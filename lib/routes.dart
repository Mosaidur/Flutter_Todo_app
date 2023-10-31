import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:todo_app/screens/home/home%20_screen.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/signup_screen.dart';

class GetRoutes{
  static const String login= "/login";
  static const String signup= "/signup";
  static const String home= "/home";
  static List<GetPage> routes = [
    GetPage(
        name: GetRoutes.login,
        page: () => Login_screen()
    ),
    GetPage(
        name: GetRoutes.signup,
        page: ()=> SignupScreen()
    ),
    GetPage(
        name: GetRoutes.home,
        page: ()=> HomeScreen()
    ),

  ] ;
}