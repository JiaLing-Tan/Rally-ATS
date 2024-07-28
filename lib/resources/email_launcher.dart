import 'package:url_launcher/url_launcher.dart';

class EmailLauncher {
  // MapUtils._();

  static Future<void> openMail(String email) async{
    Uri mailUrl = Uri.parse("https://mail.google.com/mail/?view=cm&fs=1&to=" + email);

    if (await canLaunchUrl(mailUrl)){
      await launchUrl(mailUrl);
    }
    else{
      throw 'Could not open the link';
    }

  }
}