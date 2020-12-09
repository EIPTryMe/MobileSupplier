import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class DecodeLink {
  static Future<Uint8List> decodeLinkBytes(String link) async {
    Uint8List bytes;

    if (link.contains('base64,'))
      bytes = base64.decode(link.split('base64,').last);
    else {
      await http.get(link).then((value) {
        bytes = value.bodyBytes;
      });
    }
    return (bytes);
  }
}
