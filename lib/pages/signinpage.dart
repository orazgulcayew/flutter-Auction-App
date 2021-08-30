import 'package:auction/navigate.dart';
import 'package:auction/provider/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auction/pages/homepage.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => SignIn(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<SignIn>(context);

              if (provider.isSigningIn) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
                //is signin
              } else if (snapshot.hasData) {
                return Navigate();
              } else {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            //width: 175,
                            child: Text(
                              'Auction',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(4),
                          child: SignInButton(
                            Buttons.GoogleDark,
                            text: "Sign up with Google",
                            onPressed: () {
                              final provider =
                                  Provider.of<SignIn>(context, listen: false);
                              provider.login();
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Login to continue',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
