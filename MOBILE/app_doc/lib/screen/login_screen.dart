// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, non_constant_identifier_names, avoid_print, avoid_unnecessary_containers, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_local_variable, avoid_function_literals_in_foreach_calls, prefer_collection_literals, deprecated_member_use, prefer_const_declarations, avoid_init_to_null, missing_return, unused_label, use_build_context_synchronously, avoid_returning_null_for_void, unused_import, unnecessary_this, await_only_futures

import 'dart:convert';
import 'package:app_doc/provider/user_provider.dart';
import 'package:flutter/material.dart';
import '../component/circular_progress.dart';
import '../component/info_app.dart';
import '../model/user.dart';
import '../util/app_routes.dart';
import '../util/utility.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final loading = ValueNotifier<bool>(false);
  final userProvider = UserProvider();
  Color colorWifi = Colors.white;
  int contadorMsgNet = 0;
  User user = User();

  @override
  initState() {
    super.initState();
    getUserApi(context);
  }

  void _getStatusNet(BuildContext context) async {
    await Utility.getStatusNet(context);
    if (!Utility.isNet) {
      setState(() {
        colorWifi = Colors.red[800];
      });
      if (this.contadorMsgNet == 0) {
        Utility.snackbar(context, 'SEM CONEXAO COM A INTERNET!');
      }
    } else {
      setState(() {
        colorWifi = Colors.white;
      });
    }
    setState(() {
      this.contadorMsgNet++;
    });
  }

  Future<void> getUsuario(String login, String senha) async {
    if (user.id != null) {
      user = User();
    }
    try {
      await userProvider.getUsuario(login, senha).then((result) => {
            if (result.isNotEmpty)
              {
                user = user.toObject(user, result[0]),
              },
            setState(() {
              user;
            }),
          });
    } catch (Exc) {
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO BUSCAR USUARIO!');
    }
  }

  Future<void> _autenticar(BuildContext context) async {
    if (_loginController.text.isEmpty || _loginController.text.trim() == '' || _senhaController.text.isEmpty || _senhaController.text.trim() == '') {
      return;
    }
    await getUsuario(_loginController.text, _senhaController.text);
    if (user.id != null) {
      _loginController.text = '';
      _senhaController.text = '';
      Utility.setAppRouter(context, AppRoutes.HOME, user);
    } else {
      Utility.snackbar(context, 'LOGIN OU SENHA INCORRETOS!');
    }
    setState(() {
      loading.value = false;
    });
  }

  Future<int> convertToInt(String value) async {
    int newValue = int.tryParse(value);
    return newValue;
  }

  Future<void> getUserApi(BuildContext context) async {
    await Utility.getStatusNet(context);
    if (Utility.isNet) {
      try {
        await userProvider.deleteAll('usuario');
        loading.value = true;
        User userApi;
        final future = userProvider.getUser();
        future.then(
          (response) => {
            jsonDecode(response.body).forEach(
              (element) async => {
                element['id'] = await convertToInt(element['id'].toString()),
                userApi = User(),
                userApi = userApi.toObject(userApi, element),
                userProvider.insert(userApi.toMap()),
              },
            ),
            loading.value = false,
          },
        );
      } catch (Exc) {
        print('$Exc');
        Utility.snackbar(context, 'ERRO DE DOWNLOAD DE USUARIO: $Exc');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _getStatusNet(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.wifi,
              size: 40,
              color: colorWifi,
            ),
            padding: const EdgeInsets.fromLTRB(1, 1, 25, 1),
            onPressed: () => getUserApi(context),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: loading,
        builder: (context, value, child) {
          if (value) {
            return CircularProgressComponent();
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 80.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: _loginController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        labelText: 'Login',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                        hintText: "Informe o Login",
                      ),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: _senhaController,
                      // obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        labelText: 'Senha',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                        hintText: "Informe a Senha",
                      ),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text('Entrar'),
                        onPressed: () => _autenticar(context),
                        style: TextButton.styleFrom(
                          elevation: 10,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      child: Image.asset(
                        // 'assets/images/logo_felltech.png',
                        'assets/images/logo_floripark.png',
                        height: 100,
                      ),
                    ),
                  ),
                  InfoApp(User()),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
