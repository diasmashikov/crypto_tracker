import 'package:crypto_tracker/blocs/crypto/crypto_bloc.dart';
import 'package:crypto_tracker/repositories/crypto_repository.dart';
import 'package:crypto_tracker/screens/home_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // kDebugMode when app is in production sets to false
  EquatableConfig.stringify = kDebugMode;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CryptoRepository(),
      child: MaterialApp(
        title: 'Flutter Crypto Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.black, accentColor: Colors.tealAccent),
        home: BlocProvider(
          create: (context) =>
              CryptoBloc(cryptoRepository: context.read<CryptoRepository>())
                ..add(AppStarted()),
          child: HomeScreen(),
        ),
      ),
    );
  }
}
