import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutterui/blocs/cart/cart_bloc.dart';
import 'package:flutterui/blocs/item/item_bloc.dart';
import 'package:flutterui/blocs/login/login_bloc.dart';
import 'package:flutterui/components/circularLoader.dart';
import 'package:flutterui/screens/cart_screen.dart';
import 'package:flutterui/screens/login_page.dart';
import 'package:flutterui/screens/signup_page.dart';
import 'package:flutterui/screens/home.dart';
import 'package:flutterui/screens/splash_screen.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/products/products_bloc.dart';
import 'blocs/signup/signup_bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    print(error);
    super.onError(bloc, error, stacktrace);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  //this Phoenix widget will restart the entire app or rebuild from stratch
  //but it may not do this at OS level
  runApp(Phoenix(
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => SignupBloc(),
        ),
        BlocProvider(
          create: (context) => ProductsBloc()
            ..add(Fetch(brandName: "Addidas", isNewBrand: true)),
        ),
        BlocProvider(
          create: (context) => ItemBloc(),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        )
      ],
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Initial(),
        '/loginPage': (context) => LogInPage(),
        '/homePage': (context) => Homepage(),
        '/signupPage': (context) => SignUpPage(),
        '/cartPage': (context) => CartPage(),
      },
    );
  }
}

class Initial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return SplashScreen();
        } else if (state is Authenticated) {
          return Homepage();
        } else if (state is Unauthenticated) {       
          return LogInPage();
        } else {
          return CircularLoader();
        }
      },
    );
  }
}
