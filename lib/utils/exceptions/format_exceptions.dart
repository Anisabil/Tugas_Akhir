class FVFormatException implements Exception {
  final String message;

  const FVFormatException(
      [this.message =
          'Terjadi kesalahan format yang tidak terduga. Silahkan periksa masukan Anda']);

  factory FVFormatException.fromMessage(String message) {
    return FVFormatException(message);
  }

  String get formattedMessage => message;

  factory FVFormatException.fromCode(String code) {
    switch (code) {
      case 'invalid-email-format':
        return const FVFormatException(
            'Format alamat email tidak valid. Tolong masukkan email yang benar');
      case 'invalid-phone-number-format':
        return const FVFormatException(
            'Format nomor telepon yang diberikan tidak valid. Silahkan masukkan nomor yang valid');
      case 'invalid-date-format':
        return const FVFormatException(
            'Format tanggal tidak valid. Silahkan masukkan tanggal yang valid');
      case 'invalid-url-format':
        return const FVFormatException(
            'Format URL tidak valid. Silahkan masukkan URL yang valid');
      case 'invalid-credit-card-format':
        return const FVFormatException('Format kartu kredit tidak valid. Silahkan masukkan nomor kartu kredit yang benar');
      case 'invalid-numeric-format':
        return const FVFormatException('Input harus dalam format numerik yang valid');
      default:
        return const FVFormatException();
    }
  }
}
