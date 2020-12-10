import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:tryme/Globals.dart' as global;
import 'package:tryme/GraphQLConfiguration.dart';
import 'package:tryme/Request.dart';

enum SocialAuth_e { FACEBOOK, GOOGLE }

class Auth0API {
  static String domain = 'dev-2o6a8byc.eu.auth0.com';
  static String clientId = 'YIfBoxMsxuVG6iTGNlxX3g7lvecyzrVQ';

  static Auth0 auth0 = Auth0(baseUrl: 'https://$domain/', clientId: clientId);

  static Future<bool> resetPassword() async {
    auth0.webAuth.authorize({
      'connection': 'Username-Password-Authentication',
      //'scope': 'openid profile email offline_access',
      //'prompt': 'reset-password',
    });
    return (true);
  }

  //https://dev-2o6a8byc.eu.auth0.com/u/login?state=g6Fo2SBZMldSeGkxSXd2YjQ4NTRUSEw2UXdlUlJoZzY1NG84b6N0aWTZIHF4UFZFdkd6aUYxZ01hUEd3VkFyMHA0QkNMQnZHWjl6o2NpZNkgWUlmQm94TXN4dVZHNmlUR05seFgzZzdsdmVjeXpyVlE
  //https://dev-2o6a8byc.eu.auth0.com/u/reset-password/request/Username-Password-Authentication?state=g6Fo2SA4TFd2bldzQ2tOYVI4YnVFUDNObGxiOWtqaEVoci1nN6N0aWTZIEFhZ1dmRXkwMlhRamhiV214S1hJak90WWwyaFZHLW9lo2NpZNkgWUlmQm94TXN4dVZHNmlUR05seFgzZzdsdmVjeXpyVlE
  static Future<bool> register(String email, String password) async {
    try {
      var response = await auth0.auth.createUser({
        'email': email,
        'password': password,
        'connection': 'Username-Password-Authentication',
      });

      print('''
    \nid: ${response['_id']}
    \nusername/email: ${response['email']}
    ''');
      return (await login(email, password));
    } catch (e) {
      print(e);
      return (false);
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      auth0.auth.getUserInfo();
      var response = await auth0.auth.passwordRealm({
        'username': email,
        'password': password,
        'realm': 'Username-Password-Authentication',
      });

      print('''
    \nAccess Token: ${response['access_token']}
    ''');

      return (await userInfo(response['access_token']));
    } catch (e) {
      print(e);
      return (false);
    }
  }

  static Future<bool> webAuth(SocialAuth_e socialAuth) async {
    try {
      String connection = '';
      if (socialAuth == SocialAuth_e.FACEBOOK)
        connection = 'facebook';
      else if (socialAuth == SocialAuth_e.GOOGLE) connection = 'google-oauth2';
      var response = await auth0.webAuth.authorize({
        'connection': connection,
        'scope': 'openid profile email offline_access',
        'prompt': 'login',
      });
      DateTime now = DateTime.now();
      print('''
    \ntoken_type: ${response['token_type']}
    \nexpires_in: ${DateTime.fromMillisecondsSinceEpoch(response['expires_in'] + now.millisecondsSinceEpoch)}
    \nrefreshToken: ${response['refresh_token']}
    \naccess_token: ${response['access_token']}
    ''');
      return (await userInfo(response['access_token']));
    } catch (e) {
      print('Error: $e');
      return (false);
    }
  }

  static Future saveUser(String token) async {
    final storage = FlutterSecureStorage();

    await storage.deleteAll();
    await storage.write(key: 'jwt', value: token);
  }

  static Future<bool> getLastUser() async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    if (token == null) return (false);
    return (await userInfo(token));
  }

  static Future<bool> userInfo(String bearer) async {
    await saveUser(bearer);
    try {
      var authClient = Auth0Auth(auth0.auth.clientId, auth0.auth.client.baseUrl,
          bearer: bearer);
      var info = await authClient.getUserInfo();

      global.auth0User = global.Auth0User();
      if (info['sub'] != null) global.auth0User.uid = info['sub'];
      if (info['picture'] != null) global.auth0User.picture = info['picture'];
      if (info['email_verified'] != null)
        global.auth0User.isEmailVerified = info['email_verified'];

      global.client = getGraphQLClient(uid: global.auth0User.uid);

      print(info);
      return (await initData());
    } catch (e) {
      print(e);
      return (false);
    }
  }

  static Future<bool> initData() async {
    await Request.getUser().then((hasException) {
      if (hasException) return (false);
    });
    global.isLoggedIn = true;
    return (true);
  }

  static Future disconnect() async {
    final storage = FlutterSecureStorage();

    await storage.deleteAll();
  }
}
