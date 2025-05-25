import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/materi/materi_bloc.dart';
import 'package:pp_flutter/blocs/materi/materi_event.dart';
import 'package:pp_flutter/blocs/regist/regist_bloc.dart';
import 'package:pp_flutter/blocs/login/login_bloc.dart';
import 'package:pp_flutter/blocs/logout/logout_bloc.dart';
import 'package:pp_flutter/blocs/ulasan/ulasan_bloc.dart';
import 'package:pp_flutter/pages/splash_screen.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';
import 'package:pp_flutter/repositories/materi_repository.dart';
import 'package:pp_flutter/repositories/ulasan_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(authRepository: authRepository),
        ),
        BlocProvider<LogoutBloc>(
          create: (_) => LogoutBloc(authRepository: authRepository),
        ),
        BlocProvider<RegistBloc>(
          create: (_) => RegistBloc(authRepository: authRepository),
        ),
        BlocProvider<MateriBloc>(
          create: (_) => MateriBloc(repository: MateriRepository())
            ..add(FetchMateriVideos()),
        ),
        BlocProvider<UlasanBloc>(
          create: (_) => UlasanBloc(UlasanRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
