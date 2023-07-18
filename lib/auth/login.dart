import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/authController.dart';
import 'package:todo_app/models/userModel.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final controllers = Get.put(AuthController());
  bool signUp = false;
  bool _isEmpty = true;
  @override
  void initState() {
    controllers.email.addListener((isEmpty));
    controllers.password.addListener((isEmpty));
    controllers.username.addListener((isEmpty));
    super.initState();
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  isEmpty() {
    if (controllers.email.isBlank!) {
      setState(() {
        _isEmpty = true;
      });
    } else if (controllers.password.isBlank!) {
      setState(() {
        _isEmpty = true;
      });
    } else if (controllers.username.isBlank!) {
      setState(() {
        _isEmpty = true;
      });
    } else {
      setState(() {
        _isEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F3C1),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/ToDoGo-Logo.png',
              width: 150,
              height: 150,
            ),
            const Text(
              'ToDoGo',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 36,
                color: Color(0xff270564),
              ),
            ),
            const Text(
              'Stay on track get it done.',
              style: TextStyle(
                  fontFamily: 'Aylafs', fontSize: 24, color: Color(0xBE270564)),
            ),
            AnimatedPadding(
              padding: signUp
                  ? const EdgeInsets.only(top: 75, bottom: 0)
                  : const EdgeInsets.only(top: 100, bottom: 16),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Text(
                signUp ? 'Create an account:' : 'Continue with your account:',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff270564)),
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedScale(
                  scale: signUp ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 64,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xff270564), width: 4),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.name,
                            controller: controllers.username,
                            maxLength: 7,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                            ),
                            cursorColor: const Color(0xff27E1C1),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 12),
                                hintText: 'what do you want us to call you?',
                                hintStyle: TextStyle(
                                  color: Color(0x7E270564),
                                )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          color: const Color(0xffF5F3C1),
                          child: const Text(
                            "Username",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xff270564),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                AnimatedSlide(
                  offset: signUp ? const Offset(0, 0) : const Offset(0, -1.4),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 64,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xff270564), width: 4),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: controllers.email,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                            ),
                            cursorColor: const Color(0xff27E1C1),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 12),
                                hintText: 'juandelacruz@email.com',
                                hintStyle: TextStyle(
                                  color: Color(0x7E270564),
                                )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          color: const Color(0xffF5F3C1),
                          child: const Text(
                            "Email",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xff270564),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                AnimatedSlide(
                  offset: signUp ? const Offset(0, 0) : const Offset(0, -1.4),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 64,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xff270564), width: 4),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            controller: controllers.password,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                            ),
                            cursorColor: const Color(0xff27E1C1),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 12),
                                hintText: 'your password...',
                                hintStyle: TextStyle(
                                  color: Color(0x7E270564),
                                )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          color: const Color(0xffF5F3C1),
                          child: const Text(
                            "Password",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xff270564),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  margin: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PassReset();
                          }));
                        },
                        child: Text(
                          signUp ? "" : "Forgot Password?",
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xff0EA293)),
                        ),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_isEmpty) {
                        Get.snackbar('Cant ${signUp ? 'sign in' : 'login'}',
                            'Please fill up the necessary fields.',
                            snackPosition: SnackPosition.TOP,
                            icon: Image.asset(
                              'assets/images/loginError.gif',
                              height: 50,
                              width: 50,
                            ),
                            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                            duration: Duration(seconds: 5),
                            borderRadius: 10,
                            colorText: Color(0xffF5F3C1),
                            backgroundColor: Color(0x830EA293));
                      } else {
                        signUp ? signup() : login();
                        Get.snackbar(signUp ? 'Signing in' : 'Logging in',
                            'Please wait.',
                            snackPosition: SnackPosition.TOP,
                            icon: Image.asset(
                              'assets/images/login.gif',
                              height: 50,
                              width: 50,
                            ),
                            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                            duration: Duration(seconds: 5),
                            borderRadius: 10,
                            colorText: Color(0xffF5F3C1),
                            backgroundColor: Color(0x830EA293));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff27E1C1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 64),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      signUp ? "Sign up" : "Login",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xff270564),
                      ),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        signUp
                            ? "Already have an account?"
                            : "Don’t have an account?",
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Color(0xff270564)),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            signUp = !signUp;
                          });
                          print(signUp);
                        },
                        child: Text(
                          signUp ? "Log in" : "Sign up",
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xff0EA293)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  signup() async {
    final user = UserModel(
        username: controllers.username.text.trim(),
        email: controllers.email.text.trim(),
        password: controllers.password.text.trim());
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (_isEmpty) {
      Get.snackbar('Cant ${signUp ? 'sign in' : 'login'}',
          'Please fill up the necessary fields.',
          snackPosition: SnackPosition.TOP,
          icon: Image.asset(
            'assets/images/loginError.gif',
            height: 50,
            width: 50,
          ),
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
          duration: Duration(seconds: 5),
          borderRadius: 10,
          colorText: Color(0xffF5F3C1),
          backgroundColor: Color(0x830EA293));
    } else {
      if (connectivityResult == ConnectivityResult.mobile) {
        await AuthController.instance
            .createUser(user, controllers.username.text.trim());
      } else if (connectivityResult == ConnectivityResult.wifi) {
        await AuthController.instance
            .createUser(user, controllers.username.text.trim());
      } else {
        return Get.snackbar(
            'You are offline.', 'Please connect to an internet and try again.',
            snackPosition: SnackPosition.TOP,
            icon: Image.asset(
              'assets/images/noInternet.gif',
              height: 50,
              width: 50,
            ),
            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
            duration: Duration(seconds: 5),
            borderRadius: 10,
            colorText: Color(0xffF5F3C1),
            backgroundColor: Color(0x830EA293));
      }
    }
  }

  login() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return AuthController.instance.loginUser(
          controllers.email.text.trim(), controllers.password.text.trim());
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return AuthController.instance.loginUser(
          controllers.email.text.trim(), controllers.password.text.trim());
    } else {
      return Get.snackbar(
          'You are offline.', 'Please connect to an internet and try again.',
          snackPosition: SnackPosition.TOP,
          icon: Image.asset(
            'assets/images/noInternet.gif',
            height: 50,
            width: 50,
          ),
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
          duration: Duration(seconds: 5),
          borderRadius: 10,
          colorText: Color(0xffF5F3C1),
          backgroundColor: Color(0x830EA293));
    }
  }
}

class PassReset extends StatefulWidget {
  PassReset({Key? key}) : super(key: key);

  @override
  State<PassReset> createState() => _PassResetState();
}

class _PassResetState extends State<PassReset> {
  final controller = Get.put(AuthController());
  Future passwordReset() async {
    var _message;
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: controller.email.text.trim())
          .then((_) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                icon: Image.asset(
                  'assets/images/completedTask.gif',
                  width: 80,
                  height: 80,
                ),
                backgroundColor: Color(0xFF0EA293),
                content: const Text(
                    'Password reset link sent!\nPlease check your email.',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffF5F3C1))),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 30, 20),
                      child: Text(
                        'OK',
                        style: TextStyle(
                            color: Color(0xffF5F3C1),
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              );
            });
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      switch (e.message) {
        case 'Given String is empty or null':
          setState(() {
            _message = 'Please provide a valid email address.';
          });
          break;
        case 'The email address is badly formatted.':
          setState(() {
            _message = 'The email you provided is not valid.';
          });
          break;
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          setState(() {
            _message = 'The email provided is not registered user.';
          });
          break;
        default:
          _message = 'An error occured, Please try again.';
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(15),
              icon: Image.asset(
                'assets/images/authError.gif',
                width: 80,
                height: 80,
              ),
              backgroundColor: Color(0xFF0EA293),
              content: Text(
                _message.toString(),
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffF5F3C1)),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 30, 20),
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: Color(0xffF5F3C1),
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F3C1),
      appBar: AppBar(
        foregroundColor: Color(0xFF0EA293),
        elevation: 0,
        backgroundColor: const Color(0xffF5F3C1),
        title: Text('Reset Password'),
        titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0EA293)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/ToDoGo-Logo.png',
            width: 150,
            height: 150,
          ),
          const Text(
            'ToDoGo',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 36,
              color: Color(0xff270564),
            ),
          ),
          const Text(
            'Stay on track get it done.',
            style: TextStyle(
                fontFamily: 'Aylafs', fontSize: 24, color: Color(0xBE270564)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Text(
              'Enter your email address to \nreceive a link to reset your password:',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 64,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff270564), width: 4),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    controller: controller.email,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
                    cursorColor: const Color(0xff27E1C1),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 12),
                        hintText: 'youremail@email.com',
                        hintStyle: TextStyle(
                          color: Color(0x7E270564),
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  color: const Color(0xffF5F3C1),
                  child: const Text(
                    "Email",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xff270564),
                    ),
                  ),
                )
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                passwordReset();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff27E1C1),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 64),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Reset Password",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xff270564),
                ),
              ))
        ],
      ),
    );
  }
}
