import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/l10n.dart' as location_picker;
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  MyRouter.setupRouter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GraphQLProvider(
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'landing',
          onGenerateRoute: MyRouter.router.generator,
          supportedLocales: [
            Locale('en'),
            Locale('it'),
            Locale('fr'),
            Locale('es'),
          ],
          localizationsDelegates: [
            location_picker.S.delegate,
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
      client: client,
    );
  }
}
