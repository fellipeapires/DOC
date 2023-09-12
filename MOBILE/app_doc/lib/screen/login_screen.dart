// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, non_constant_identifier_names, avoid_print, avoid_unnecessary_containers, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_local_variable, avoid_function_literals_in_foreach_calls, prefer_collection_literals, deprecated_member_use, prefer_const_declarations, avoid_init_to_null, missing_return, unused_label, use_build_context_synchronously, avoid_returning_null_for_void, unused_import

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
  final List<User> listaUser = [];
  final indexMsg = {'value': 0};

  @override
  initState() {
    super.initState();
    deleteUsuarioAll();
    getUserApi(context);
  }

  Future<void> deleteUsuarioAll() async {
    await userProvider.deleteAll('usuario');
  }

  Future<void> getUsuario(String login, String senha) async {
    var user = null;
    if (listaUser.isNotEmpty) {
      setState(() {
        listaUser.clear();
      });
    }
    await userProvider.getUsuario(login, senha).then((result) => {
          result.forEach(
            (element) => {
              user = User(),
              user.id = element['id'],
              user.idRegional = element['idRegional'],
              user.regional = element['regional'],
              user.nome = element['nome'],
              user.login = element['login'],
              user.senha = element['senha'],
              user.matricula = element['matricula'],
              user.situacao = element['situacao'],
              listaUser.add(user),
            },
          ),
          setState(() {
            listaUser;
          }),
        });
  }

  Future<void> _autenticar(BuildContext context) async {
    if (_loginController.text.isEmpty || _loginController.text.trim() == '' || _senhaController.text.isEmpty || _senhaController.text.trim() == '') {
      return;
    }
    setState(() {
      loading.value = true;
    });
    await getUsuario(_loginController.text, _senhaController.text);
    bool isUser = false;
    User user = User();
    for (int i = 0; i < listaUser.length; i++) {
      if (_loginController.text == listaUser[i].login && _senhaController.text == listaUser[i].senha) {
        isUser = true;
        user = listaUser[i];
        break;
      }
    }
    if (isUser) {
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

  Future<void> getUserApi(BuildContext context) async {
    await Utility.getStatusNet(context);
    if (Utility.isNet) {
      try {
        loading.value = true;
        User user;
        final future = userProvider.getUser();
        future.then(
          (response) => {
            jsonDecode(response.body).forEach(
              (element) => {
                user = User(),
                user.id = int.tryParse(element['id'].toString())!,
                user.idRegional = int.tryParse(element['idRegional'].toString())!,
                user.regional = element['regional'],
                user.nome = element['nome'],
                user.login = element['login'],
                user.senha = element['matricula'],
                user.matricula = element['matricula'],
                user.situacao = int.tryParse(element['ativo'].toString())!,
                userProvider.insert(
                  {
                    'id': user.id,
                    'idRegional': user.idRegional,
                    'regional': user.regional,
                    'nome': user.nome,
                    'login': user.login,
                    'senha': user.senha,
                    'matricula': user.matricula,
                    'situacao': user.situacao,
                  },
                ),
              },
            ),
            loading.value = false,
          },
        );
      } catch (Exc) {
        print('$Exc');
        Utility.snackbar(context, 'ERRO DE DOWNLOAD DE USUARIO: $Exc');
      }
    } else {
      /*if (indexMsg['values'] == 0) {
        setState(() {
          indexMsg['value'] = 1;
        });
        Utility.snackbar(context, 'SEM CONEXAO COM A INTERNET!');
      }*/
      Utility.snackbar(context, 'SEM CONEXAO COM A INTERNET!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
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
                        'assets/images/logo_felltech.png',
                        height: 100,
                      ),
                    ),
                  ),
                  //   Divider(),
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
