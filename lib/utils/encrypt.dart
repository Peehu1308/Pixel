import 'package:encrypt/encrypt.dart';

import 'package:encrypt/encrypt.dart';

class CryptoHelper {
  final key = Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 chars
  final iv = IV.fromUtf8('16charconstantiv'); // 16 chars

  late final Encrypter encrypter;

  CryptoHelper() {
    encrypter = Encrypter(AES(key));
  }

  String encryptText(String text) {
    return encrypter.encrypt(text, iv: iv).base64;
  }

  String decryptText(String encryptedText) {
    return encrypter.decrypt64(encryptedText, iv: iv);
  }

  /// Safe decrypt → works if text is Base64, otherwise returns original
  String safeDecrypt(String? text) {
    if (text == null || text.isEmpty) return ""; // handle null safely
    try {
      return decryptText(text);
    } catch (_) {
      return text; // not valid encrypted string
    }
  }
}
