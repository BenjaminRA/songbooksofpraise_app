import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/db/DB.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:toastification/toastification.dart';

Future<void> updateSongbookHandler(BuildContext context, Songbook item) async {
  try {
    final response = await API.get('songbooks/${item.id}/export');

    await item.delete();

    await DB.updateDatabase(response.toString());

    if (context.mounted) {
      toastification.show(
        context: context,
        alignment: Alignment.bottomCenter,
        title: Text(AppLocalizations.of(context)!.updatedSuccessfully(item.title)),
        type: ToastificationType.success,
        // primaryColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.update),
        dragToClose: true,
        applyBlurEffect: true,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  } catch (e) {
    print('Error fetching export data: $e');
  }
}
