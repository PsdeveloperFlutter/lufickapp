import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _SupportState { unknown, supported, unsupported }

void main() {
  runApp(BioMetricClass());
}

class BioMetricClass extends StatefulWidget {
  @override
  State<BioMetricClass> createState() => _BioMetricClassState();
}

class _BioMetricClassState extends State<BioMetricClass> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;

  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  // PIN authentication
  String? _storedPin;

  @override
  void initState() {
    super.initState();
    // Check if the device supports biometrics
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() =>
      _supportState = isSupported ? _SupportState.supported : _SupportState.unsupported),
    );
    _loadPin();
  }

  // Load stored PIN from SharedPreferences
  Future<void> _loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedPin = prefs.getString('pin');
    });
  }

  // Save PIN to SharedPreferences
  Future<void> _savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);
    setState(() {
      _storedPin = pin;
    });
  }

  // Check if Biometrics is available
  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  // Get available biometrics (Face, Fingerprint, etc.)
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = [];
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  // General Authentication (OS decides method)
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });

      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );

      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
    }

    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });
  }

  // Authenticate using Face Recognition ONLY
  Future<void> _authenticateWithFace() async {
    bool authenticated = false;
    if (_availableBiometrics != null &&
        _availableBiometrics!.contains(BiometricType.face)) {
      try {
        setState(() {
          _isAuthenticating = true;
          _authorized = 'Authenticating with Face Recognition';
        });

        authenticated = await auth.authenticate(
          localizedReason: 'Scan your face to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        setState(() {
          _isAuthenticating = false;
        });
      } on PlatformException catch (e) {
        setState(() {
          _isAuthenticating = false;
          _authorized = 'Error - ${e.message}';
        });
        print(e);
        return;
      }
    } else {
      setState(() {
        _authorized = 'Face Recognition not available on this device.';
      });
    }

    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });
  }

  // Authenticate using Fingerprint ONLY
  Future<void> _authenticateWithFingerprint() async {
    bool authenticated = false;
    if (_availableBiometrics != null &&
        _availableBiometrics!.contains(BiometricType.fingerprint)) {
      try {
        setState(() {
          _isAuthenticating = true;
          _authorized = 'Authenticating with Fingerprint';
        });

        authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        setState(() {
          _isAuthenticating = false;
        });
      } on PlatformException catch (e) {
        setState(() {
          _isAuthenticating = false;
          _authorized = 'Error - ${e.message}';
        });
        print(e);
        return;
      }
    } else {
      setState(() {
        _authorized = 'Fingerprint not available on this device.';
      });
    }

    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });
  }

  // Authenticate using PIN
  Future<void> _authenticateWithPin() async {
    final pinController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter PIN'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your PIN';
                } else if (value != _storedPin) {
                  return 'Incorrect PIN';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'PIN'),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  setState(() {
                    _authorized = 'Authorized with PIN';
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() {
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Biometric Authentication'),
        ),
        body: ListView(
          children: <Widget>[
            if (_supportState == _SupportState.unknown)
              const CircularProgressIndicator()
            else if (_supportState == _SupportState.supported)
              const Text('Device supports biometrics.')
            else
              const Text('Device does not support biometric authentication.'),

            if (_canCheckBiometrics != null)
              Text('Can check biometrics: $_canCheckBiometrics.'),

            if (_availableBiometrics != null && _availableBiometrics!.isNotEmpty)
              Text('Available biometrics: ${_availableBiometrics!.join(', ')}'),

            ElevatedButton(
              onPressed: _getAvailableBiometrics,
              child: const Text('Get Available Biometrics'),
            ),

            ElevatedButton(
              onPressed: _checkBiometrics,
              child: const Text('Check Biometrics Support'),
            ),

            ElevatedButton(
              onPressed: _authenticate,
              child: Text(_isAuthenticating ? 'Authenticating' : 'Authenticate (Any)'),
            ),

            ElevatedButton(
              onPressed: _authenticateWithFace,
              child: Text(_isAuthenticating ? 'Authenticating' : 'Authenticate with Face ID'),
            ),

            ElevatedButton(
              onPressed: _authenticateWithFingerprint,
              child: Text(_isAuthenticating ? 'Authenticating' : 'Authenticate with Fingerprint'),
            ),

            ElevatedButton(
              onPressed: _authenticateWithPin,
              child: const Text('Authenticate with PIN'),
            ),

            Text('Authorized: $_authorized'),

            ElevatedButton(
              onPressed: _cancelAuthentication,
              child: const Text('Cancel Authentication'),
            ),

            // Option to set a new PIN
            if (_storedPin == null)
              ElevatedButton(
                onPressed: () async {
                  final pinController = TextEditingController();
                  final formKey = GlobalKey<FormState>();

                  final newPin = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Set a PIN'),
                        content: Form(
                          key: formKey,
                          child: TextFormField(
                            controller: pinController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a PIN';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'PIN'),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                _savePin(pinController.text);
                                Navigator.of(context).pop(pinController.text);
                              }
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Set a New PIN'),
              ),
          ],
        ),
      ),
    );
  }
}
