
import 'dart:io';

class AdHelper {

  static String homePageBanner() {
    if(Platform.isAndroid) {
      return "ca-app-pub-4370132603795922/9019944276";
    }
    else {
      return "";
    }
  }


  static String fullPageAd() {
    if(Platform.isAndroid) {
      return "ca-app-pub-4370132603795922/2479592247";
    }
    else {
      return "";
    }
  }

}