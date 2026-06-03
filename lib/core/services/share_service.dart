import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ShareService extends GetxService {
  Future<ShareResult> shareText(String text, {String? subject}) {
    return SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }
}
