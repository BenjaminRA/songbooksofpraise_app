import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/pages/SongPage/SongPage.dart';

Future<void> navigateToSong(BuildContext context, int songID) async {
  Song? fullSong = await Song.getSongByID(songID);

  if (fullSong == null) {
    final response = await API.get('songs/${songID}');
    fullSong = Song.fromJson(response['song']);
  }

  Provider.of<AppBarProvider>(context, listen: false).setTitle(
    AppBarState(
      title: fullSong.title,
      subtitle: fullSong.number?.toString(),
      icon: Icons.music_note,
      backgroundColor: Theme.of(context).primaryColor,
      titleColor: Theme.of(context).scaffoldBackgroundColor,
      subtitleColor: Theme.of(context).scaffoldBackgroundColor,
      iconColor: Theme.of(context).scaffoldBackgroundColor,
    ),
  );

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SongPage(song: fullSong!),
    ),
  );
}
