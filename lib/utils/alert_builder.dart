import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AlertBuilder {
  bool _isLoaderDialogShowed = false;
  bool _isErrorDialogShowed = false;

  showLoaderDialog(BuildContext context) {
    if(!_isLoaderDialogShowed) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _isLoaderDialogShowed = true;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              AlertDialog(
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
    if(_isLoaderDialogShowed) {
      _isLoaderDialogShowed = false;

      Navigator.of(context).pop();
    }
  }

  showErrorDialog(BuildContext context, String errorMessage) {
    if(!_isErrorDialogShowed) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _isErrorDialogShowed = true;

        showDialog(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
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
        ).then((value) => _isErrorDialogShowed = false);
      });
    }
  }

  stopErrorDialog(BuildContext context) {
    if(_isErrorDialogShowed) {
      _isErrorDialogShowed = false;

      Navigator.of(context).pop();
    }
  }
}
