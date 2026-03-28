import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: "test@example.com");
  final _passwordController = TextEditingController(text: "123456");
  String _error = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_florist, size: 100, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                "PlantPal",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const Text("Уход за растениями", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 60),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Пароль",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),

              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(_error, style: const TextStyle(color: Colors.red)),
                ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        final success = await auth.login(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                        if (success) {
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        } else {
                          setState(() => _error = "Ошибка входа. Проверьте данные.");
                        }
                      },
                child: auth.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Войти"),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        final success = await auth.register(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                        if (success) {
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        } else {
                          setState(() => _error = "Ошибка регистрации.");
                        }
                      },
                child: const Text("Регистрация"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
