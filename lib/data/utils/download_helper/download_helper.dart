import 'package:saurav_portfolio/data/utils/download_helper/download_helper_stub.dart'
    if (dart.library.html) 'package:saurav_portfolio/data/utils/download_helper/download_helper_web.dart'
    as helper;

abstract class FileDownloader {
  static Future<void> downloadAsset(
    String assetPath, {
    String? fileName,
  }) async {
    await helper.downloadAssetFile(assetPath, fileName: fileName);
  }
}
