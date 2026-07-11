# 🔐 Desain & Implementasi Kriptografi CBDC Offline (Ed25519)

Berdasarkan desain di `diagram.md`, sistem Anda menggunakan mekanisme **Dual Signature** (Ed25519) untuk mencegah pemalsuan dan membuktikan validitas uang tanpa koneksi internet. 

Berikut adalah panduan lengkap dan *source code* untuk mengimplementasikannya di Flutter.

## 1. Tambahkan Dependency `cryptography`
Tambahkan *package* standar untuk Kriptografi Dart di file `pubspec.yaml` Anda:

```yaml
dependencies:
  # ... (dependencies lainnya)
  cryptography: ^2.7.0
```

*Lalu jalankan `flutter pub get` di terminal.*

## 2. Model Payload Transaksi
Sebelum membuat fungsi verifikasi, kita butuh sebuah representasi dari "Paket Transaksi" yang dikirim via NFC.

Buat file: `lib/features/transaction/domain/entities/cbdc_payload.dart`

```dart
import 'dart:convert';

class CbdcPayload {
  final String transactionId;
  final int amount;
  final String currency;
  final String senderId; // Public Key Pengirim (Base64)
  final String bankSignature; // Signature dari Bank (Base64)
  final String txSignature; // Signature dari Pengirim (Base64)
  final DateTime timestamp;
  final int hopCount;

  CbdcPayload({
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.senderId,
    required this.bankSignature,
    required this.txSignature,
    required this.timestamp,
    required this.hopCount,
  });

  // Fungsi untuk mendapatkan data mentah saldo (tanpa txSignature) 
  // yang digunakan untuk Verifikasi Bank.
  List<int> get balanceRawData {
    final payloadMap = {
      'amount': amount,
      'currency': currency,
    };
    return utf8.encode(jsonEncode(payloadMap));
  }

  // Fungsi untuk mendapatkan data mentah keseluruhan (tanpa txSignature)
  // yang digunakan untuk Verifikasi Pengirim.
  List<int> get txRawData {
    final payloadMap = {
      'transactionId': transactionId,
      'amount': amount,
      'currency': currency,
      'senderId': senderId,
      'bankSignature': bankSignature,
      'timestamp': timestamp.toIso8601String(),
      'hopCount': hopCount,
    };
    return utf8.encode(jsonEncode(payloadMap));
  }
}
```

## 3. Implementasi `CryptoService`
Service ini bertugas menangani verifikasi 1 (Bank) dan verifikasi 2 (Pengirim).

Buat file: `lib/core/services/crypto_service.dart`

```dart
import 'dart:convert';
import 'package:cryptography/cryptography.dart';

class CryptoService {
  final Ed25519 _ed25519 = Ed25519();
  
  // Hardcoded atau diambil dari local storage. 
  // Ini adalah Public Key milik Bank Pusat (CBDC Issuer)
  final String _bankPublicKeyBase64; 

  CryptoService(this._bankPublicKeyBase64);

  /// --- VERIFIKASI 1: Verifikasi Signature Bank ---
  /// Memastikan bahwa "jumlah uang" (saldo) benar-benar diterbitkan oleh Bank yang sah.
  Future<bool> verifyBankSignature(List<int> balanceRawData, String base64Signature) async {
    try {
      final signatureBytes = base64Decode(base64Signature);
      final publicKeyBytes = base64Decode(_bankPublicKeyBase64);

      final signature = Signature(
        signatureBytes,
        publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
      );

      final isValid = await _ed25519.verify(
        balanceRawData,
        signature: signature,
      );
      
      return isValid;
    } catch (e) {
      return false; // Tolak (Saldo Palsu)
    }
  }

  /// --- VERIFIKASI 2: Verifikasi Signature Pengirim ---
  /// Memastikan bahwa transaksi ini benar-benar ditandatangani oleh pemegang wallet.
  Future<bool> verifySenderSignature(List<int> txRawData, String base64Signature, String base64SenderPublicKey) async {
    try {
      final signatureBytes = base64Decode(base64Signature);
      final publicKeyBytes = base64Decode(base64SenderPublicKey);

      final signature = Signature(
        signatureBytes,
        publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
      );

      final isValid = await _ed25519.verify(
        txRawData,
        signature: signature,
      );

      return isValid;
    } catch (e) {
      return false; // Tolak (Tx Dipalsukan)
    }
  }

  /// (Opsional) Helper untuk menandatangani data saat kita menjadi PENGIRIM
  Future<String> signData(List<int> rawData, SimpleKeyPair senderKeyPair) async {
    final signature = await _ed25519.sign(
      rawData,
      keyPair: senderKeyPair,
    );
    return base64Encode(signature.bytes);
  }
}
```

## 4. Cara Penggunaan di Penerima (Receiver Logic)

Ketika payload diterima via NFC, ini adalah alur logikanya (berdasarkan `diagram.md`):

```dart
Future<void> processIncomingNfcPayload(CbdcPayload incomingPayload) async {
  // Anggap kita punya public key bank
  final cryptoService = CryptoService("base64_bank_public_key_here");

  // 1. Verifikasi 1 (Bank)
  final isBankValid = await cryptoService.verifyBankSignature(
    incomingPayload.balanceRawData,
    incomingPayload.bankSignature,
  );

  if (!isBankValid) {
    throw Exception("Tolak: Saldo Palsu (Invalid Bank Signature)");
  }

  // 2. Verifikasi 2 (Pengirim)
  final isSenderValid = await cryptoService.verifySenderSignature(
    incomingPayload.txRawData,
    incomingPayload.txSignature,
    incomingPayload.senderId,
  );

  if (!isSenderValid) {
    throw Exception("Tolak: Transaksi Dipalsukan (Invalid Sender Signature)");
  }

  // 3. Pengecekan Tambahan Lokal
  final isNotDoubleSpend = await checkLocalDatabaseForDoubleSpend(incomingPayload.transactionId);
  final isHopCountValid = incomingPayload.hopCount < 3;
  final isTimestampValid = DateTime.now().difference(incomingPayload.timestamp).inHours < 72;

  if (isNotDoubleSpend && isHopCountValid && isTimestampValid) {
    // SEMUA LOLOS: TERIMA SALDO LOKAL
    await saveToDatabase(incomingPayload);
    print("Transaksi Offline Berhasil Diterima!");
  } else {
    throw Exception("Tolak: Gagal pada pengecekan tambahan");
  }
}
```

## Penjelasan Sistem:
1. **Balance Raw Data**: Data yang di-sign oleh bank (contoh: *User A punya Rp 50.000*). Bank me-sign data ini dan menyimpannya di HP user.
2. **TX Raw Data**: Saat User A memberikan Rp 50.000 ke User B. User A menggunakan *Private Key*-nya sendiri untuk menandatangani data tersebut secara keseluruhan, membuktikan ia rela memberikannya.
3. **Penerima (Receiver)**: Mencek kedua *signature* tersebut di HP-nya sendiri (tanpa internet). Menggunakan `CryptoService` ini, penerima bisa yakin 100% uang tersebut bukan uang buatan sendiri, dan benar-benar dikirimkan oleh pemegang uang yang sah.

---
**Tugas Anda:** 
Jika kode ini sudah sesuai dengan keinginan Anda, saya bisa bantu meng-inject langsung ke dalam `lib/core/services/` dan mengatur Riverpod Provider-nya.
