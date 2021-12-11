// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:meuapp/modules/login/repositories/login_repository_impl.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/button/button.dart';
import 'package:meuapp/shared/widgets/input_text/input_text.dart';
import 'package:validators/validators.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = LoginController(
        repository: LoginRepositoryImpl(database: AppDatabase.instance));
    controller.addListener(() {
      controller.state.when(
          success: (value) => Navigator.pushNamed(context, "/home"),
          error: (message, _) => scaffoldKey.currentState!
              .showBottomSheet((context) => BottomSheet(
                  onClosing: () {},
                  builder: (context) => Container(
                        child: Text(message),
                      ))),
          orElse: () {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.colors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 200,
              ),
              InputText(
                label: "Email",
                hint: "Digite seu email",
                validator: (value) =>
                    isEmail(value) ? null : "Digite um email válido",
                onChanged: (value) => controller.onChanged(email: value),
              ),
              SizedBox(
                height: 18,
              ),
              InputText(
                label: "Senha",
                obscure: true,
                hint: "Digite sua senha",
                validator: (value) =>
                    value.length >= 6 ? null : "Digite uma senha válida",
                onChanged: (value) => controller.onChanged(password: value),
              ),
              SizedBox(
                height: 14,
              ),
              AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) => controller.state.when(
                        loading: () => CircularProgressIndicator(),
                        orElse: () => Column(
                          children: [
                            Button(
                              label: "Entrar",
                              onTap: () {
                                controller.login();
                              },
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Button(
                              label: "Criar conta",
                              type: ButtonType.outline,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, "/login/create-account");
                              },
                            ),
                          ],
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
