class FVPlatformException implements Exception {
  final String code;

  FVPlatformException(this.code);

  String get message {
    switch (code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Kredensial login tidak valid. Harap periksa kembali informasi Anda';
      case 'too-many-requests':
        return 'Terlalu banyak permintaan. Silahkan coba lagi nanti';
      case 'invalid-argument':
        return 'Argumen tidak valid yang diberikan ke metode autentikasi';
      case 'invalid-password':
        return 'Kata kunci salah. Silahkan coba lagi';
      case 'invalid-phone-number':
        return 'Nomor telepon yang diberikan tidak valid';
      case 'operation-not-allowed':
        return 'Penyedia masuk dinonaktifkan untuk proyek firebase Anda';
      case 'session-cookie-expired':
        return 'Cookie firebase telah kedaluarsa. Silahkan masuk lagi';
      case 'uid_already-exists':
        return 'ID pengguna yang diberikan sudah digunakan oleh pengguna lain';
      case 'sign_in_failed':
        return 'Gagal masuk. Silahkan coba lagi';
      case 'network-request-failed':
        return 'Permintaan jaringan gaga;. Silahkan periksa koneksi internet Anda';
      case 'internet-error':
        return 'Kesalahan internet. Coba lagi nanti';
      case 'invalid-verification-code':
        return 'Kode verifikasi salah. Silahkan masukkan kode yang valid';
      case '':
        return '';
      default:
        return 'Terjadi kesalahan Firebase yang tidak terduga. Silahkan coba lagi';
    }
  }
}
