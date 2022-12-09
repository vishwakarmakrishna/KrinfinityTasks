import 'dart:developer';

import 'package:app/editer/rich_text_editer.dart';
import 'package:app/login.dart';
import 'package:app/signup.dart';
import 'package:app/splash.dart';
import 'package:app/todo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'package:go_router/go_router.dart';

class MyPath {
  static String loginPath = "/login";
  static String signupPath = "/signup";
  static String splashPath = "/splash";
  static String todoPath = "/todo/:id";
  static String editerPath = "editer/:title";
  static String todo = "todo";
  static String signup = "signup";
  static String login = "login";
  static String splash = "splash";
  static String editer = "editer";
}

GoRouter getRoute(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: MyPath.todoPath,
        name: MyPath.todo,
        builder: (context, state) {
          final id = state.params['id'].toString();
          return Todo(userid: id);
        },
        routes: [
          GoRoute(
            path: MyPath.editerPath,
            name: MyPath.editer,
            builder: (context, state) {
              final initText = state.extra.toString();
              final title = state.params['title'].toString();
              final isDone = state.queryParams['done'] == true;
              return Editer(
                title: title,
                isDone: isDone,
                initText: initText,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: MyPath.signupPath,
        name: MyPath.signup,
        builder: (context, state) => Signup(),
      ),
      GoRoute(
        path: MyPath.loginPath,
        name: MyPath.login,
        builder: (context, state) => Login(),
      ),
      GoRoute(
        path: MyPath.splashPath,
        name: MyPath.splash,
        builder: (context, state) => MySplash(),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(body: Center(child: Text('error')));
    },
    observers: [
      if (kDebugMode) MyLoggerRouteObserver(),
    ],
  );
}

class MyLoggerRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    log('didPush ${route.settings.name} previousRoute ${previousRoute?.settings.name}',
        name: 'MyLoggerRouteObserver');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    log('didPop ${route.settings.name} previousRoute ${previousRoute?.settings.name}',
        name: 'MyLoggerRouteObserver');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    log('didRemove ${route.settings.name} previousRoute ${previousRoute?.settings.name}',
        name: 'MyLoggerRouteObserver');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    log('didReplace ${newRoute?.settings.name} previousRoute ${oldRoute?.settings.name}');
  }
}
