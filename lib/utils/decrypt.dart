// import 'package:encrypt/encrypt.dart' as encrypt;

// class CryptoHelper {
//   final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32-char key
//   final _iv = encrypt.IV.fromLength(16);

//   late final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

//   String encryptText(String text) {
//     return _encrypter.encrypt(text, iv: _iv).base64;
//   }

//   String decryptText(String encryptedText) {
//     return _encrypter.decrypt64(encryptedText, iv: _iv);
//   }
// }
