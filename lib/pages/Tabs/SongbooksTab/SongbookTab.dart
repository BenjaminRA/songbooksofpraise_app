import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/components/AppBarWithProvider.dart';
import 'package:songbooksofpraise_app/db/DB.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/RootPage.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/components/SongbookSearchBar.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/components/SongbooksMenu.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/components/TabNavigator.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/helpers/updateSongbookHandler.dart';
import 'package:toastification/toastification.dart';

class SongbookCallbacks {
  Future<void> Function() refresh;
  Future<void> Function(Songbook songbook) downloadSongbook;
  Future<void> Function(Songbook songbook) updateSongbook;
  Future<void> Function(Songbook songbook) deleteSongbook;

  SongbookCallbacks({
    required this.refresh,
    required this.downloadSongbook,
    required this.updateSongbook,
    required this.deleteSongbook,
  });
}

class SongbookTab extends StatefulWidget {
  const SongbookTab({super.key});

  @override
  State<SongbookTab> createState() => _SongbookTabState();
}

class _SongbookTabState extends State<SongbookTab> {
  List<Songbook> installed = [];
  List<Songbook> available = [];

  @override
  void initState() {
    super.initState();

    onRefresh();
  }

  Future<void> onDownloadSongbook(Songbook songbook) async {
    setState(() {
      available[available.indexWhere((sb) => sb.id == songbook.id)].isDownloading = true;
    });

    try {
      final response = await API.get('songbooks/${songbook.id}/export');

      await DB.updateDatabase(response.toString());

      if (mounted) {
        toastification.show(
          context: context,
          alignment: Alignment.bottomCenter,
          title: Text(AppLocalizations.of(context)!.downloadedSuccessfully(songbook.title)),
          type: ToastificationType.success,
          // primaryColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.save),
          dragToClose: true,
          applyBlurEffect: true,
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      print('Error fetching export data: $e');
    } finally {
      await onRefresh();
    }
  }

  Future<void> onUpdateSongbook(Songbook songbook) async {
    setState(() {
      installed[installed.indexWhere((sb) => sb.id == songbook.id)].isDownloading = true;
      available[available.indexWhere((sb) => sb.id == songbook.id)].isDownloading = true;
    });

    try {
      final response = await API.get('songbooks/${songbook.id}/export');

      await songbook.delete();

      await DB.updateDatabase(response.toString());

      if (context.mounted) {
        toastification.show(
          context: context,
          alignment: Alignment.bottomCenter,
          title: Text(AppLocalizations.of(context)!.updatedSuccessfully(songbook.title)),
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
    } finally {
      await onRefresh();
    }
  }

  Future<void> onDeleteSongbook(Songbook songbook) async {
    try {
      await songbook.delete();

      toastification.show(
        context: context,
        alignment: Alignment.bottomCenter,
        title: Text(AppLocalizations.of(context)!.deletedSuccessfully(songbook.title)),
        type: ToastificationType.error,
        // primaryColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.delete),
        dragToClose: true,
        applyBlurEffect: true,
        autoCloseDuration: const Duration(seconds: 5),
      );
    } catch (e) {
      print('Error deleting songbook: $e');
    } finally {
      await onRefresh();
    }
  }

  Future<void> onRefresh() async {
    // Simulate a network call or data refresh
    // await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      final response = await API.get('songbooks');
      final available = await Songbook.fromJson(response['songbooks']);

      Map<int, bool> updateAvailable = {};

      for (Songbook available in available) {
        if (available.updateAvailable) {
          updateAvailable[available.id] = true;
        }
      }

      final installed = await Songbook.getInstalled();

      for (Songbook songbook in installed) {
        if (updateAvailable.containsKey(songbook.id)) {
          songbook.updateAvailable = true;
        }
      }

      setState(() {
        this.available = available;
        this.installed = installed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithProvider(songbookTabKey),
      body: TabNavigator(
        navigatorKey: songbookTabKey,
        child: Column(
          children: [
            const SongbookSearchBar(),
            Expanded(
              child: SongbooksMenu(
                callbacks: SongbookCallbacks(
                  refresh: onRefresh,
                  downloadSongbook: onDownloadSongbook,
                  updateSongbook: onUpdateSongbook,
                  deleteSongbook: onDeleteSongbook,
                ),
                installed: installed,
                available: available,
              ),
            ),
          ],
        ),
      ),
    );
    // return ListView(
    //   children: [
    //     AppBar(
    //       title: Row(
    //         mainAxisSize: MainAxisSize.max,
    //         children: [
    //           Icon(
    //             Icons.library_books,
    //             color: Theme.of(context).primaryColor,
    //           ),
    //           const SizedBox(width: 10),
    //           Flexible(
    //             child: Text(
    //               'Songbooks',
    //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //               maxLines: 2,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     ActiveSongbookSection(),
    //     CategoriesSection(),
    //   ],
    // );
  }
}
