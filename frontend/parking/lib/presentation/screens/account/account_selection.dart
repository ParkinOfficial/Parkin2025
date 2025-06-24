import 'package:flutter/material.dart';
import 'package:parking/presentation/screens/home/user_home.dart';

class AccountSelection extends StatefulWidget {
  final List<String> roles;

  const AccountSelection({Key? key, required this.roles}) : super(key: key);

  @override
  State<AccountSelection> createState() => _AccountSelectionState();
}

class _AccountSelectionState extends State<AccountSelection> {
  void navigateToRolePage(BuildContext context, String role) {
    if (role == 'user') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => UserHomePage()),
      );
    } else if (role == 'owner') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => UserHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Role")),
      body: ListView.builder(
        itemCount: widget.roles.length,
        itemBuilder: (context, index) {
          final role = widget.roles[index];
          return ListTile(
            title: Text(role.toUpperCase()),
            onTap: () => navigateToRolePage(context, role),
          );
        },
      ),
    );
  }
}
