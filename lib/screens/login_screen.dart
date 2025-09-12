import 'package:flutter/material.dart';
import 'package:my_portfolio_app/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final InputDecoration fieldDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.black,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
      ),
    );

    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome aboard 👋🏼',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Dive into my projects!'),
                const SizedBox(height: 24),

                // EMAIL INPUT
                TextFormField(
                  controller: _emailController,
                  decoration: fieldDecoration.copyWith(
                    prefixIcon: const Icon(Icons.email),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                  ),
                  validator: (value) =>
                      (value!.isEmpty) ? "Email is required" : null,
                ),
                const SizedBox(height: 15),

                // PASSWORD INPUT
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: fieldDecoration.copyWith(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                  ),
                  validator: (value) =>
                      value!.length < 6 ? "Password must be 6+ chars" : null,
                ),
                const SizedBox(height: 20),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);

                        try {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          final success = await authProvider.signInWithEmail(
                            email,
                            password,
                            profileProvider,
                          );

                          if (!mounted) return;

                          if (success && profileProvider.profile != null) {
                            if (profileProvider.profile!.role == "admin") {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.adminDashboard,
                              );
                            } else {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.home,
                              );
                            }
                          } else {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  authProvider.errorMessage ?? "Login failed",
                                  style: TextStyle(
                                    color: theme.colorScheme.onError,
                                  ),
                                ),
                                backgroundColor: theme.colorScheme.error,
                              ),
                            );
                          }
                        } catch (e) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                "Sign in failed: $e",
                                style: TextStyle(
                                  color: theme.colorScheme.onError,
                                ),
                              ),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Sign in"),
                  ),
                ),
                const SizedBox(height: 8),

                // GOOGLE SIGN IN BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Image.asset(
                      "assets/img/google_logo.png", // logo google
                      height: 20,
                    ),
                    label: const Text("Sign in with Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerLow,
                      foregroundColor: theme.colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      final success = await authProvider.signInWithGoogle(
                        profileProvider,
                      );

                      if (success && mounted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      } else {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              authProvider.errorMessage ??
                                  "Google Sign-In failed",
                              style: TextStyle(
                                color: theme.colorScheme.onError,
                              ),
                            ),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );

                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
