from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import easyocr
import cv2
import numpy as np
from io import BytesIO
from PIL import Image
from anrp.main import analyze_license_plate
import threading
from ultralytics import YOLO
from anrp.sort.sort import *
from anrp.util import get_car, read_license_plate
import numpy as np

app = FastAPI()

# Allow Flutter to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # for production, restrict to your domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

detection_active = False
capture_thread = None
current_capture = None
results = {}
plate_texts = []

def analyze_license_plate():
    global detection_active, results, plate_texts, current_capture
    
    try:
        

        mot_tracker = Sort()
        coco_model = YOLO('./anrp/yolov8n.pt')
        license_plate_detector = YOLO('./anrp/models/license_plate_detector.pt')
        vehicles = [2, 3, 5, 7]
        
        current_capture = cv2.VideoCapture(0)
        if not current_capture.isOpened():
            raise HTTPException(status_code=500, detail="Could not open camera")

        frame_nmr = -1
        detection_active = True
        
        while detection_active and current_capture.isOpened():
            frame_nmr += 1
            ret, frame = current_capture.read()
            if not ret:
                break

            results[str(frame_nmr)] = {}
            
            # Vehicle detection and processing
            detections = coco_model(frame)[0]
            detections_ = [det[:5] for det in detections.boxes.data.tolist() 
                          if int(det[5]) in vehicles]
            
            track_ids = mot_tracker.update(np.asarray(detections_))
            
            # License plate detection
            license_plates = license_plate_detector(frame)[0]
            for license_plate in license_plates.boxes.data.tolist():
                x1, y1, x2, y2, score, class_id = license_plate
                car_info = get_car(license_plate, track_ids)
                
                if car_info[-1] != -1:  # if valid car_id
                    license_plate_crop = frame[int(y1):int(y2), int(x1):int(x2)]
                    license_plate_crop_gray = cv2.cvtColor(license_plate_crop, cv2.COLOR_BGR2GRAY)
                    _, license_plate_crop_thresh = cv2.threshold(license_plate_crop_gray, 64, 255, cv2.THRESH_BINARY_INV)
                    
                    plate_text, plate_score = read_license_plate(license_plate_crop_thresh)
                    if plate_text:
                        results[str(frame_nmr)][str(car_info[-1])] = {
                            'car': {'bbox': car_info[:4]},
                            'license_plate': {
                                'bbox': [x1, y1, x2, y2],
                                'text': plate_text,
                                'bbox_score': float(score),
                                'text_score': float(plate_score) if plate_score else None
                            }
                        }
                        plate_texts.append(plate_text)
                        detection_active = False  # Stop after first detection
                        break

    except Exception as e:
        raise e
    finally:
        if current_capture:
            current_capture.release()
        cv2.destroyAllWindows()

@app.post("/start-detection")
async def start_detection():
    global detection_active, capture_thread, results, plate_texts
    
    if detection_active:
        return JSONResponse(content={
            "status": "error",
            "message": "Detection is already running"
        }, status_code=400)
    
    # Reset previous results
    results = {}
    plate_texts = []
    
    try:
        capture_thread = threading.Thread(target=analyze_license_plate)
        capture_thread.start()
        
        return JSONResponse(content={
            "status": "success",
            "message": "License plate detection started"
        })
    except Exception as e:
        return JSONResponse(content={
            "status": "error",
            "message": str(e)
        }, status_code=500)

@app.post("/stop-detection")
async def stop_detection():
    global detection_active, capture_thread
    
    if not detection_active:
        return JSONResponse(content={
            "status": "error",
            "message": "No active detection to stop"
        }, status_code=400)
    
    detection_active = False
    
    if capture_thread:
        capture_thread.join(timeout=5)  # Wait for thread to finish
    print(results)
    return JSONResponse(content={
        "status": "success",
        "message": "Detection stopped",
        "results": {
            "detailed": results,
            "plate_numbers": plate_texts
        }
    })

@app.get("/detection-status")
async def get_status():
    return JSONResponse(content={
        "status": "success",
        "detection_active": detection_active,
        "plates_detected": len(plate_texts) > 0,
        "plate_numbers": plate_texts
    })
