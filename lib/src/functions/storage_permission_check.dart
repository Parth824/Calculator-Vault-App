import 'package:permission_handler/permission_handler.dart';
var st=0;
Future<void> storagePermissionCheck({
  required Function onPermissionGranted,
  required Function onPermissionDenied,
}) async {
  final status = await Permission.manageExternalStorage.request();
  final status1 = await Permission.storage.request();
  if (status.isGranted || status1.isGranted) {
    if(status1.isGranted){
      st=1;
    }
    onPermissionGranted();
  } else {
    onPermissionDenied();
  }
}