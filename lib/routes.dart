import 'package:messages/create/create.dart';
import 'package:messages/home/home.dart';
import 'package:messages/profile/profile.dart';
import 'package:messages/login/login.dart';

var appRoutes = {
  '/': (context) => const Home(),
  '/login': (context) => const Login(),
  '/profile': (context) => const Profile(),
  '/create': (context) => const Create(),
};
