import 'package:another_flushbar/flushbar.dart';
import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AlertBuilder {
  bool _isLoaderDialogShowed = false;
  bool _isErrorDialogShowed = false;
  bool _isSnackBarShowed = false;

  showLoaderDialog(BuildContext context) {
    if (!_isLoaderDialogShowed) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _isLoaderDialogShowed = true;

        showDialog(
          context: context,
          useRootNavigator: false,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Text("Loading..."),
                ),
              ],
            ),
          ),
        );
      });
    }
  }

  stopLoaderDialog(BuildContext context) {
    if (_isLoaderDialogShowed) {
      _isLoaderDialogShowed = false;

      Navigator.of(context).pop();
    }
  }

  showErrorDialog(BuildContext context, String errorMessage) {
    if (!_isErrorDialogShowed) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _isErrorDialogShowed = true;

        showDialog(
          context: context,
          useRootNavigator: false,
          builder: (BuildContext context) => AlertDialog(
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Error!"),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Text(errorMessage),
                ),
              ],
            ),
          ),
        ).then((value) {
          print("showDialog then");

          _isErrorDialogShowed = false;
        });
      });
    }
  }

  stopErrorDialog(BuildContext context) {
    if (_isErrorDialogShowed) {
      _isErrorDialogShowed = false;

      Navigator.of(context).pop();
    }
  }

  showErrorSnackBar(BuildContext context, String errorText) {
    if (!_isSnackBarShowed) {
      _isSnackBarShowed = true;
      Flushbar(
        maxWidth: 224,
        padding: const EdgeInsets.all(15),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        messageText: Text(errorText,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center),
        backgroundColor: errorRed.withAlpha(80),
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 3),
      ).show(context).then((value) {
        Future.delayed(
            Duration(milliseconds: 500), () => _isSnackBarShowed = false);
      });
    }
  }

// void _showAlertDialog(String message, bool popToFirstPage) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       content: Text(message),
//       actions: [
//         TextButton(
//           onPressed: () {
//             if (popToFirstPage) {
//               Navigator.of(context).popUntil((route) => route.isFirst);
//             } else {
//               Navigator.of(context).pop();
//             }
//           },
//           child: const Text(
//             'Ok :(',
//             textAlign: TextAlign.end,
//           ),
//         )
//       ],
//     ),
//   );
// }

}
