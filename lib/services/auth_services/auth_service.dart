import 'package:conset/models/login_model.dart';
import '../common_services/api_service/api_service.dart';

class AuthService {
  // Future<LoginModel?> loginService(String email, String password) async {
  //   try {
  //     if(email != 'zayahan@gmail.com' && password != '123456'){

  //     }
  //     var body = {"email": email, "password": password};

  //     var response = await APIService.login(api: URL.loginUrl, body: body);
  //     if (response != null) {
  //       return loginModelFromJson(response);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }

  Future<LoginModel?> loginService(String email, String password) async {
    try {
      // Simulated delay to mimic a real network call
      await Future.delayed(Duration(seconds: 1));

      // Dummy login check
      if (email == 'zayahan@gmail.com' && password == '123456') {
        // Return a dummy LoginModel object
        return LoginModel(
          accessToken: 'dummy_token_abc123',
          
          email: email,
          password: password,
        );
      } else {
        // Invalid credentials
        print('Invalid credentials');
        return null;
      }
    } catch (e) {
      print('Error in dummy login: $e');
      return null;
    }
  }

  
}
