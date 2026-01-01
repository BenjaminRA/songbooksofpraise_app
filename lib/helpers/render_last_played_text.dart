String renderLastPlayedText(DateTime? lastPlayed) {
  if (lastPlayed == null) {
    return 'Never played';
  }

  final now = DateTime.now();
  final difference = now.difference(lastPlayed);

  if (difference.inDays > 30) {
    return 'Played ${lastPlayed.year}/${lastPlayed.month}/${lastPlayed.day}';
  }

  if (difference.inDays > 0) {
    if (difference.inDays == 1) {
      return 'Played yesterday';
    } else {
      return 'Played ${difference.inDays} days ago';
    }
  } else if (difference.inHours > 0) {
    if (difference.inHours == 1) {
      return 'Played 1 hour ago';
    } else {
      return 'Played ${difference.inHours} hours ago';
    }
  } else if (difference.inMinutes > 0) {
    if (difference.inMinutes == 1) {
      return 'Played 1 minute ago';
    } else {
      return 'Played ${difference.inMinutes} minutes ago';
    }
  } else {
    return 'Played just now';
  }
}
