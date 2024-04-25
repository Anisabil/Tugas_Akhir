class FVFirebaseException implements Exception {
  final String code;

  FVFirebaseException(this.code);

  String get message {
    switch (code) {
      case 'unknown':
        return 'Terjadi kesalahan Firebase yang tidak diketahui. Silahkan coba lagi';
      case 'invalid-custom-token':
        return 'Format toker khusus salah. Silahkan periksa token khusus Anda';
      case 'custom-token-mismatch':
        return 'Token khusus sesuai dengan audiens yang berbeda';
      case 'user-disabled':
        return 'Akun pengguna telah dinonaktifkan';
      case 'user-not-found':
        return 'Tidak ada pengguna yang ditemukan untuk email atau ID yang diberikan';
      case 'invalid-email':
        return 'Alamat email yang diberikan tidak valid. Tolong masukkan email yang benar';
      case 'email-already-in-use':
        return 'Alamat email sudah terdaftar. Silahkan gunakan email lain';
      case 'wrong-password':
        return 'Kata sandi salah. Silahkan periksa kata sandi Anda dan coba lagi';
      case 'weak-password':
        return 'Kata sandi terlalu lemah. Silahkan pilih kata sandi yang lebih kuat';
      case 'provider-already-linked':
        return 'Akun sudah terhubung dengan pengguna lain';
      case 'operation-not-allowed':
        return 'Operasi ini tidak diperbolehkan. Hubungin dukungan untuk bantuan';
      case 'invalid-credential':
        return 'Kredensial yang diberikan salah format atau telah kedaluarsa';
      case 'invalid-verification-code':
        return 'Kode verifikasi salah. Silahkan masukkan kode yang valid';
      case 'invalid-verification-id':
        return 'ID verifikasi tidak valid. Silahkan minta kode verifikasi baru';
      case 'captcha-check-failed':
        return 'Respon captcha ulang tidak valid. Silahkan coba lagi';
      case 'app-not-authorized':
        return 'Aplikasi tidak diizinkan menggunakan autentikasi Firebase dengan kunci API yang disediakan';
      case 'keychain-error':
        return 'Terjadi kesalahan kunci. Silahkan periksa kunci dan coba lagi';
      case 'internet-error':
        return 'Terjadi kesalahan autentikasi internet. Silahkan coba lagi nanti';
      case 'invalid-app-credential':
        return 'Kredensial aplikasi tidak valid. Harap berikan kredensial aplikasi yang valid';
      case 'user-mismatch':
        return 'Kredensial yang diberikan tidak sesuai dengan pengguna yang masuk sebelumnya';
      case 'requires-recent-login':
        return 'Operasi ini sensitif dan memerlukan autentikasi terkini. Silahkan masuk lagi';
      case 'quota-exceeded':
        return 'Kuota melebihi batas. Silahkan coba lagi nanti';
      case 'account-exists-with-different-credential':
        return 'Akun sudah ada dengan email yang sama tetapi kredensial masuknya berbeda';
      case 'missing-iframe-start':
        return 'Template email tidak memiliki tag awal iframe';
      case 'missing-iframe-end':
        return 'Template email tidak memiliki tag akhir iframe';
      case 'missing-iframe-src':
        return 'Template email tidak memiliki atribut src iframe';
      case 'auth-domain-config-required':
        return 'Konfigurasi domain autentikasi diperlukan untuk tautan verifikasi kode tindakan';
      case 'missing-app-credential':
        return 'Kredensial aplikasi hilang. Harap berikan kredensial aplikasi yang valid';
      case 'session-cookie-expired':
        return 'Cookie sesi firebase telah kedaluarsa. Silahkan masuk lagi';
      case 'uid-already-exists':
        return 'ID pengguna yang diberikan sudah digunakan oleh pengguna lain';
      case 'web-storage-unsupported':
        return 'Penyimpanan web tidak didukung atau dinonaktifkan';
      case 'app-deleted':
        return 'Instansi aplikasi firebase ini telah dihapus';
      case 'user-token-mismatch':
        return 'Token pengguna yang diberikan tidak cocok dengan ID pengguna yang di autentikasi';
      case 'invalid-message-payload':
        return 'Pesan verifikasi email tidak valid';
      case 'invalid-sender':
        return 'Pengiriman email tidak valid. Harap verifikasi email pengirimnya';
      case 'invalid-recipient-email':
        return 'Alamat email penerima tidak valid. Harap berikan email penerima yang valid';
      case 'missing-action-code':
        return 'Kode tindakan tidak ada. Harap berikan kode tindakan yang tidak valid';
      case 'user-token-expired':
        return 'Token pengguna telah kedaluarsa, dan autentikasi diperlukan. Silahkan masuk lagi';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Kredensial login tidak valid';
      case 'expired-action-code':
        return 'Kode tindakan telah kedaluarsa. Silahkan minta kode tindakan baru';
      case 'invalid-action-code':
        return 'Kode tindakan tidak valid. Silahkan periksa kodenya dan coba lagi';
      case 'credential-already-in-use':
        return 'Kredensial ini sudah dikaitkan dengan akun pengguna lain';
      default:
        return 'Terjadi kesalahan Firebase yang tidak terduga. Silahkan coba lagi';
    }
  }
}
