import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutter/core/bloc/postBloc/post_bloc.dart';
import 'package:tp_flutter/core/bloc/postListBloc/post_list_bloc.dart';
import 'package:tp_flutter/core/enums/AuthStatus.dart';
import 'package:tp_flutter/core/models/post.dart';
import 'package:tp_flutter/core/repositories/auth/auth_data_source_impl.dart';
import 'package:tp_flutter/core/repositories/auth/auth_repository.dart';
import 'package:tp_flutter/core/repositories/post/post_data_source_impl.dart';
import 'package:tp_flutter/core/repositories/post/post_repository.dart';
import 'package:tp_flutter/page_not_found/page_not_found.dart';
import 'package:tp_flutter/post/create_post/create_post.dart';
import 'package:tp_flutter/post/post_detail/post_detail.dart';
import 'package:tp_flutter/post/post_list/post_list.dart';

import 'core/bloc/userBloc/user_bloc.dart';
import 'core/bloc/userBloc/user_state.dart';
import 'login_and_sign_up/login_and_sign_up.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            authDataSource: AuthDataSourceImpl(),
          ),
        ),
        RepositoryProvider(
          create: (context) => PostRepository(
            postDataSource: PostDatasSourceImpl(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PostListBLoc(
              postRepository: context.read<PostRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            ),
          ),
        ], // Add initial event if needed
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state.authStatus == AuthStatus.connected) {
                    return const PostList();
                  } else {
                    return const LoginAndSignUp();
                  }
                },
              );
            },
          ),
          routes: {
            '/createPost': (context) => CreatePost(),
          },
          onGenerateRoute: (settings) {
            Widget page = const PageNotFound();

            switch (settings.name) {
              case PostDetail.routeName:
                final arguments = settings.arguments;
                if (arguments is Post) {
                  page = PostDetail(post: arguments);
                }
              default:
                break;
            }
            return MaterialPageRoute(
              builder: (context) => page,
              settings: settings,
            );
          },
        ),
      ),
    );
  }
}
