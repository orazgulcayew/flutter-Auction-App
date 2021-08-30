import 'package:auction/provider/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('Dashboard'),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {
                  final provider = Provider.of<SignIn>(context, listen: false);
                  provider.logout();
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
          body: Center(
            child: Text('Dashboard'),
          )),
    );
  }
}
