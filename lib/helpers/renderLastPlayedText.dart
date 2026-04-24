import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';

String renderLastPlayedText(BuildContext context, DateTime? lastPlayed) {
  AppLocalizations localizations = AppLocalizations.of(context)!;

  if (lastPlayed == null) {
    return localizations.neverPlayed;
  }

  final now = DateTime.now();
  final difference = now.difference(lastPlayed);

  if (difference.inDays > 30) {
    return localizations.playedOnDate(lastPlayed.year, lastPlayed.month, lastPlayed.day);
  }

  if (difference.inDays > 0) {
    if (difference.inDays == 1) {
      return localizations.playedYesterday;
    } else {
      return localizations.playedDaysAgo(difference.inDays);
    }
  } else if (difference.inHours > 0) {
    if (difference.inHours == 1) {
      return localizations.playedOneHourAgo;
    } else {
      return localizations.playedHoursAgo(difference.inHours);
    }
  } else if (difference.inMinutes > 0) {
    if (difference.inMinutes == 1) {
      return localizations.playedOneMinuteAgo;
    } else {
      return localizations.playedMinutesAgo(difference.inMinutes);
    }
  } else {
    return localizations.playedJustNow;
  }
}
