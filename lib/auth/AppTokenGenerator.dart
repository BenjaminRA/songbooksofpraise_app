import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart' as crypto;

class AppTokenGenerator {
  static Uint8List _createKey(String secret) {
    var bytes = utf8.encode(secret);
    var digest = crypto.sha256.convert(bytes);
    return Uint8List.fromList(digest.bytes);
  }

  static String encryptAppToken({required String appId, required String appKey, required String encryptionSecret, int? expirationHours}) {
    // Create the token payload exactly matching Go struct
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expiresAt = now + (expirationHours ?? 24) * 3600;

    final token = {'app_id': appId, 'app_key': appKey, 'expires_at': expiresAt};

    // Convert to JSON bytes - ensure no extra whitespace
    final jsonString = jsonEncode(token);

    // Create AES key from secret (same as Go code)
    final key = Key(_createKey(encryptionSecret));

    // Create encrypter with AES-GCM
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

    // Generate random IV (12 bytes for GCM - same as Go's NonceSize)
    final iv = IV.fromSecureRandom(12);

    // Encrypt
    final encrypted = encrypter.encrypt(jsonString, iv: iv);

    // Combine IV + ciphertext (same format your Go code expects)
    final combined = Uint8List(iv.bytes.length + encrypted.bytes.length);
    combined.setRange(0, iv.bytes.length, iv.bytes);
    combined.setRange(iv.bytes.length, combined.length, encrypted.bytes);

    // Encode to base64 URL safe
    return base64Url.encode(combined);
  }
}
