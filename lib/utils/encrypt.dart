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
}
