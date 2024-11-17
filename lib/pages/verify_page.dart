import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'display_id_card_page.dart';
import 'package:id_quick/utils/helper_functions.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    checkBiometrics();
  }

  Future<void> checkBiometrics() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    setState(() {
      _supportState = canCheckBiometrics;
    });
  }

  Future<void> authenticate(BuildContext context) async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to access ID Quick',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      _showSnackBar("Error: $e");
    }

    if (authenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DisplayIDHomePage()),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red.shade100,
        body: Center(
          child: _supportState
          ? Builder(
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        "assets/images/sus4.gif",
                        height: screenHeight(context) * 0.3,
                        // width: screenWidth(context),z
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(height: screenHeight(context) * 0.25,),
                  ElevatedButton(
                    onPressed: () => authenticate(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          side: const BorderSide(color: Colors.black, width: 1.0), // Add border here
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(2.0),
                    ),
                    child: Icon(
                      Icons.lock,
                      color: Colors.red.shade50,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: screenHeight(context) * 0.04,)
                ],
              );
            },
          )
          : const Text('Fingerprint authentication not supported or failed'),
        ),
      );
  }
}
