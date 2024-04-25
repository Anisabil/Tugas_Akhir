class FVFirebaseAuthException implements Exception {
  final String code;

  FVFirebaseAuthException(this.code);

  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'Alamat email sudah terdaftar. Silahkan gunakan email lain';
      case 'invalid-email':
        return 'Alamat email yang diberikan tidak valid. Tolong masukkan email yang benar';
      case 'weak-password':
        return 'Kata sandi terlalu lemah. Silahkan pilih kata sandi yang lebih kuat';
      case 'user-disabled':
        return 'Akun pengguna ini telah dinonaktifkan. Silahkan hubungi dukungan untuk bantuan';
      case 'wrong-password':
        return 'Kata sandi salah. Silahkan periksa kata sandi Anda dan coba lagi';
      case 'invalid-verification-code':
        return 'Kode verifikasi salah. Silahkan masukkan kode yang valid';
      case 'invalid-verification-id':
        return 'ID verifikasi tidak valid. Silahkan minta kode verifikasi baru';
      case 'quota-exceeded':
        return 'Kuota terlampaui. Mohon coba lagi nanti';
      case 'email-already-exists':
        return 'Alamat email sudah ada. Silahkan gunakan email lain';
      case 'provider-already-linked':
        return 'Akun sudah terhubung dengan pengguna lain';
      case 'requires-recent-login':
        return 'Operasi ini sensitif dan memerlukan otentikasi terkini. Silahkan masuk lagi';
      case 'credential-already-in-use':
        return 'Kredensial ini sudah disambungkan dengan akun pengguna yang berbeda';
      case 'user-mismatch':
        return 'Kredensial yang dimasukkan tidak sesuai dengan pengguna yang masuk sebelumnya';
      case 'account-exists-with-different-credential':
        return 'Akun sudah ada dengan email yang sama tetapi kredential masuknya berbeda';
      case 'operations-not-allowed':
        return 'Operasi ini tidak diperbolehkan. Hubungin dukungan untuk bantuan';
      case 'expired-action-code':
        return 'Kode tindakan telah kedaluarsa. Silahkan minta kode tindakan baru';
      case 'invalid-action-code':
        return 'Kode tindakan tidak valid. Silahkan periksa kodenya dan coba lagi';
      case 'missing-action-code':
        return 'Kode tindakan tidak ada. Harap berikan kode tindakan yang valid';
      case 'user-token-expired':
        return 'Token pengguna telak kedaluarsa, dan autentikasi diperlukan. Silahkan masuk lagi';
      case 'user-not-found':
        return 'Tidak ada pengguna yang ditemukan untuk email atau ID yang diberikan';
      case 'invalid-credential':
        return 'Kredensial yang diberikan salah format atau telah kedaluarsa';
      case 'user-token-revoced':
        return 'Pengguna telah dicabut. Silahkan masuk lagi';
      case 'invalid-message-payload':
        return 'Payload pesan verifikasi email tidak valid';
      case 'invalid-sender':
        return 'Pengirim template email tidak valid. Harap verifikasi email pengirimnya';
      case 'invalid-recipient-email':
        return 'Alamat email penerima tidak valid. Harap berikan email penerima yang valid';
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
      case 'invalid-app-credential':
        return 'Kredensial aplikasi tidak valid. Tolong sediakan kredensial aplikasi yang valid';
      case 'session-cookie-expired':
        return 'Cookie sesi firebase telah kedaluarsa. Silahkan masuk lagi';
      case 'uid-already-exists':
        return 'ID pengguna yang diberikan sudah digunakan oleh pengguna lain';
      case 'invalid-cordova-configuration':
        return 'Konfigurasi kordova yang disediakan tidak valid';
      case 'app-deleted':
        return 'Contoh aplikasi firebase ini telah dihapus';
      case 'user-token-mismatch':
        return 'Token pengguna yang diberikan tidak cocok dengan ID pengguna yang di autentikasi';
      case 'web-storage-unsupported':
        return 'Penyimpanan web tidak didukung atau dinonaktifkan';
      case 'invalid-aredential':
        return 'Kredensial yang diberika tidak valid. Silahkan periksa kredensialnya dan coba lagi';
      case 'app-not-authorized':
        return 'Aplikasi tidak diizinkan menggunakan autentikasi Firebase dengan kunci API yang disediakan';
      case 'keychain-error':
        return 'Terjadi kesalahan kunci. Silahkan periksa kunci dan coba lagi';
      default:
        return 'Terjadi kesalahan Firebase yang tidak terduga. Silahkan coba lagi';
    }
  }
}
