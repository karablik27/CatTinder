import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../viewmodels/auth_session_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthSessionViewModel>();

    return Container(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Text(
                  'CatTinder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Вход или регистрация',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Вход'),
                      Tab(text: 'Регистрация'),
                    ],
                  ),
                ),
                if (vm.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      vm.error!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [_LoginForm(), _SignUpForm()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final vm = context.read<AuthSessionViewModel>();
    vm.clearError();

    await vm.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthSessionViewModel>();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _AuthTextField(
              fieldKey: const Key('login_email_field'),
              controller: _emailController,
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 12),
            _AuthTextField(
              fieldKey: const Key('login_password_field'),
              controller: _passwordController,
              hint: 'Пароль',
              obscureText: true,
              validator: _validatePassword,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: vm.isBusy ? null : _submit,
                child: vm.isBusy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Войти'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final vm = context.read<AuthSessionViewModel>();
    vm.clearError();

    await vm.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthSessionViewModel>();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _AuthTextField(
              fieldKey: const Key('signup_email_field'),
              controller: _emailController,
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 12),
            _AuthTextField(
              fieldKey: const Key('signup_password_field'),
              controller: _passwordController,
              hint: 'Пароль',
              obscureText: true,
              validator: _validatePassword,
            ),
            const SizedBox(height: 12),
            _AuthTextField(
              fieldKey: const Key('signup_confirm_field'),
              controller: _confirmController,
              hint: 'Повторите пароль',
              obscureText: true,
              validator: (value) {
                final base = _validatePassword(value);
                if (base != null) {
                  return base;
                }
                if (value != _passwordController.text) {
                  return 'Пароли не совпадают';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: vm.isBusy ? null : _submit,
                child: vm.isBusy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Зарегистрироваться'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final Key? fieldKey;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?) validator;

  const _AuthTextField({
    this.fieldKey,
    required this.controller,
    required this.hint,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

String? _validateEmail(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) {
    return 'Введите email';
  }

  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRegex.hasMatch(text)) {
    return 'Некорректный email';
  }

  return null;
}

String? _validatePassword(String? value) {
  final text = value ?? '';
  if (text.isEmpty) {
    return 'Введите пароль';
  }
  if (text.length < 6) {
    return 'Минимум 6 символов';
  }
  return null;
}
