import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/users/users_list_screen.dart';
import '../screens/clients/clients_list_screen.dart';
import '../screens/orcamentos/orcamentos_list_screen.dart';
import '../screens/categories/categories_list_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String users = '/users';
  static const String clients = '/clients';
  static const String orcamentos = '/orcamentos';
  static const String categories = '/categories';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      users: (context) => const UsersListScreen(),
      clients: (context) => const ClientsListScreen(),
      orcamentos: (context) => const OrcamentosListScreen(),
      categories: (context) => const CategoriesListScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case users:
        return MaterialPageRoute(builder: (_) => const UsersListScreen());
      case clients:
        return MaterialPageRoute(builder: (_) => const ClientsListScreen());
      case orcamentos:
        return MaterialPageRoute(builder: (_) => const OrcamentosListScreen());
      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesListScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
