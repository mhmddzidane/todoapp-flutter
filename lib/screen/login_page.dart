import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:todoapp/screen/todo_list.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LocalAuthentication auth;
  bool _suppportState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _suppportState = isSupported;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_suppportState)
            const Text('This device is supported')
          else
            const Text('This device is not supported'),
          const Divider(
            height: 100,
          ),
          ElevatedButton(
              onPressed: _getAvailableBiometrics,
              child: Text('Get Available Biometrics')),
          const Divider(
            height: 100,
          ),
          ElevatedButton(
              onPressed: _authenticate,
              child: Text('Authenticate with fingerprint')),
          const Divider(
            height: 100,
          ),
          ElevatedButton(
              onPressed: _authenticateFace,
              child: Text('Authenticate with face'))
        ],
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Fingerprint to Login',
          options:
              AuthenticationOptions(stickyAuth: true, biometricOnly: true));

      final route = MaterialPageRoute(
        builder: (context) => TodoList(),
      );
      if (authenticated) {
        Navigator.pushReplacement(context, route);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _authenticateFace() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Fingerprint to Login',
          options:
              AuthenticationOptions(stickyAuth: true, biometricOnly: true));

      final route = MaterialPageRoute(
        builder: (context) => TodoList(),
      );
      if (authenticated) {
        Navigator.pushReplacement(context, route);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print('List of availableBiometrics: $availableBiometrics');

    if (!mounted) {
      return;
    }
  }
}
