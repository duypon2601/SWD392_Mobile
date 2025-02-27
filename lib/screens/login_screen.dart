import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHidePassword = true;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMail = '';
  String errorPassword = '';

  bool isValidEmail() {
    String emailString = emailController.text;
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (emailString.isEmpty) {
      setState(() {
        errorMail = 'Email không được để trống';
      });
      return false;
    } else if (!emailRegex.hasMatch(emailString)) {
      setState(() {
        errorMail = 'Email không hợp lệ';
      });
      return false;
    }

    setState(() {
      errorMail = '';
    });
    return true;
  }

  bool isValidPassword() {
    String passwordString = passwordController.text;

    if (passwordString.isEmpty) {
      setState(() {
        errorPassword = 'Mật khẩu không được để trống';
      });
      return false;
    } else if (passwordString.length < 6) {
      setState(() {
        errorPassword = 'Mật khẩu tối thiểu 6 ký tự';
      });
      return false;
    }

    setState(() {
      errorPassword = '';
    });
    return true;
  }

  bool validateForm() {
    bool validEmail = isValidEmail();
    bool validPassword = isValidPassword();
    return validEmail && validPassword;
  }

  void login() {
    bool isValid = validateForm();
    if (isValid) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2)).then((_) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng nhập thành công!')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Xóa AppBar để hình ảnh nền phủ toàn bộ màn hình
      body: Stack(
        children: [
          // Background Image (phủ đầy màn hình)
          Positioned.fill(
            child: Image.network(
              'https://anhcute.net/wp-content/uploads/2024/11/hinh-anh-con-gai-cute-che-mat-1.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Nút back ở góc trên trái
          Positioned(
            top: 40,
            left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Nội dung login
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Login Now',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please login to continue using our app',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),

                    // Email Field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.grey),
                        errorText: errorMail.isNotEmpty ? errorMail : null,
                        errorStyle: const TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) {
                        if (errorMail.isNotEmpty) {
                          setState(() {
                            errorMail = '';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextField(
                      controller: passwordController,
                      obscureText: isHidePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.grey),
                        errorText:
                            errorPassword.isNotEmpty ? errorPassword : null,
                        errorStyle: const TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isHidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isHidePassword = !isHidePassword;
                            });
                          },
                        ),
                      ),
                      onChanged: (_) {
                        if (errorPassword.isNotEmpty) {
                          setState(() {
                            errorPassword = '';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 40),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF62B0F6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(double.infinity, 55),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? const CupertinoActivityIndicator(
                                color: Colors.white)
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),

                    // Forgot Password
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Xử lý quên mật khẩu
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
