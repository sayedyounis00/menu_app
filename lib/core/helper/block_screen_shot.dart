import 'package:no_screenshot/no_screenshot.dart';

class NoScreenShot{final _noScreenshot = NoScreenshot.instance;

void disableScreenshot() async {
 await _noScreenshot.screenshotOff();
}

void enableScreenShot() async {
 await _noScreenshot.screenshotOn();
}

}