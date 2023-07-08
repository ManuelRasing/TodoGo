import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/authController.dart';
import 'package:todo_app/models/userModel.dart';

class loginPage extends StatefulWidget {
  loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

    final controllers = Get.put(AuthController());
    bool signUp = false;

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F3C1),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/ToDoGo-Logo.png',
            width: 150,
            height: 150,),
            const Text('ToDoGo',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 36,
              color: Color(0xff270564),
            ),),
            const Text('Stay on track get it done.',
            style: TextStyle(
              fontFamily: 'Aylafs',
              fontSize: 24,
              color: Color(0xBE270564)
            ),),
             AnimatedPadding(
              padding: signUp ? EdgeInsets.only(top:25, bottom: 0) : EdgeInsets.only(top: 50, bottom: 16),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            child: Text(signUp ? 'Create an account:' : 'Continue with your account:',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xff270564)
            ),),),
            
            AnimatedScale(
              scale: signUp ? 1.0:0.0,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Container(
                margin: EdgeInsets.only(top: 16, bottom: 8),
                child: Stack(
                  children: 
                    [
                      Container(
                      margin: EdgeInsets.only(top: 8),
                      height: 64,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff270564),
                        width: 4),
                        borderRadius: BorderRadius.circular(8)
                
                      ),
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
                        cursorColor: Color(0xff27E1C1),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 12),
                          hintText: 'what do you want us to call you?',
                          hintStyle: TextStyle(
                            color: Color(0x7E270564),
                          )
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      padding: EdgeInsets.only(left: 5, right: 5),
                      color: Color(0xffF5F3C1),
                      child: const Text("Username",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xff270564),
                      ),),
                    )
                  ],
                ),
              ),
              ),

            AnimatedSlide(
              offset: signUp ? Offset(0, 0): Offset(0, -1), 
              duration: Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              child: Container(
                margin: EdgeInsets.only(top: 16, bottom: 8),
                child: Stack(
                  children: 
                    [
                      Container(
                      margin: EdgeInsets.only(top: 8),
                      height: 64,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff270564),
                        width: 4),
                        borderRadius: BorderRadius.circular(8)
                
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: controllers.email,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                        ),
                        cursorColor: Color(0xff27E1C1),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 12),
                          hintText: 'juandelacruz@email.com',
                          hintStyle: TextStyle(
                            color: Color(0x7E270564),
                          )
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      padding: EdgeInsets.only(left: 5, right: 5),
                      color: Color(0xffF5F3C1),
                      child: const Text("Email",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xff270564),
                      ),),
                    )
                  ],
                ),
              ),
              ),



            AnimatedSlide(
              offset: signUp ? Offset(0, 0): Offset(0, -1), 
              duration: Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              child: Container(
                margin: EdgeInsets.only(top: 16, bottom: 8),
                child: Stack(
                  children: 
                    [
                      Container(
                      margin: EdgeInsets.only(top: 8),
                      height: 64,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff270564),
                        width: 4),
                        borderRadius: BorderRadius.circular(8)
                
                      ),
                      child: TextField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: controllers.password,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                        ),
                        cursorColor: Color(0xff27E1C1),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 12),
                          hintText: 'your password...',
                          hintStyle: TextStyle(
                            color: Color(0x7E270564),
                          )
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      padding: EdgeInsets.only(left: 5, right: 5),
                      color: Color(0xffF5F3C1),
                      child: const Text("Password",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xff270564),
                      ),),
                    )
                  ],
                ),
              ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 32),
                margin: EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      signUp ? "Already have an account?": "Don’t have an account?" ,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Color(0xff270564)
                    ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          signUp = !signUp;
                        });
                        print(signUp);
                      },
                      child: Text(signUp ? "Log in":  "Sign up" ,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xff0EA293)
                      ),),
                    )
                  ],
                ),
              ),

            ElevatedButton(
              onPressed: () {
                signUp ? signup() : login();
              }, 
              style: ElevatedButton.styleFrom(
                
                backgroundColor: Color(0xff27E1C1),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
              ),
              child: Text( signUp ? "Sign up" : "Login",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Color(0xff270564),
              ),))

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
    await AuthController.instance.createUser(user);
  }
  login(){
    AuthController.instance.loginUser(
                  controllers.email.text.trim(), 
                  controllers.password.text.trim()
                  );
  }
}
