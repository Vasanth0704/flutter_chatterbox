import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'HomeScreen.dart';
import 'RegisterScreen.dart';


final supabase = Supabase.instance.client;

class LoginScreen extends StatefulWidget {
  final String title;

  const LoginScreen({super.key, required this.title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final storage = FlutterSecureStorage();

  bool _isPasswordVisible = false;

  @override
  void initState(){
    super.initState();
    emailController.text = "admin@gmail.com";
    passwordController.text = "admin@123";

  }

  Future<void> signIn() async{
    try{
      final response = await supabase.auth.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );

      if(response.session != null){

        await storage.write(key: 'session',
            value: response.session!.accessToken
        );

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Successful!')),
        );

        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
            HomeScreen(title:'Home')),
        );
      }

    } catch (error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $error')),
      );
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'password',
                  suffixIcon: IconButton(
                       icon: Icon(
                         _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                       ),
                    onPressed: (){
                         setState(() {
                           _isPasswordVisible = !_isPasswordVisible;
                         });
                    },
                  )
                ),
                obscureText: !_isPasswordVisible,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: signIn,
                  child: Text('Login'),
              ),
              SizedBox(height: 20),
              TextButton(onPressed: (){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => RegisterScreen(title:'Register'),
                  ),
                );
              },
                  child: Text("Don't have an account? Register"),
              ),
            ],
          ),
      ),
    );
  }
}
