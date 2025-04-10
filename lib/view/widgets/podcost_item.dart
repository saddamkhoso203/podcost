import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:podcost/Model/podcast_Model.dart';
import '../../api/podcast_api.dart';

class PodcostItem extends StatefulWidget {
  final Podcast podcast;
  const PodcostItem({super.key, required this.podcast});

  @override
  State<PodcostItem> createState() => _PodcostItemState();
}

class _PodcostItemState extends State<PodcostItem> {
  double progress = 0.0;
  bool isDownloading = false;
  bool isDownloaded = false;
  final podcastApi = PodcastApi();

  @override
  void initState() {
    super.initState();
    checkIfDownloaded();
  }

  Future<void> checkIfDownloaded() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('path_${widget.podcast.id}');
    if (saved != null) {
      setState(() {
        isDownloaded = true;
      });
    }
  }

  Future<void> downloadAudio() async {
    setState(() {
      isDownloading = true;
      progress = 0.0;
    });

    final path = '${widget.podcast.title}/${widget.podcast.id}.mp3';

    await podcastApi.downloadAudio(
      widget.podcast.audio,
      path,
      onReceiveProgress: (count, total) {
        setState(() {
          progress = count / total;
        });
        debugPrint('Progress: $progress');
      },
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('path_${widget.podcast.id}', path);

    setState(() {
      isDownloading = false;
      isDownloaded = true;
      progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.podcast.title),
      trailing: isDownloading
          ? SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator.adaptive(value: progress),
      )
          : IconButton(
        icon: isDownloaded
            ? const Icon(Icons.play_arrow)
            : const Icon(Icons.download),
        onPressed: () {
          if (!isDownloaded) {
            downloadAudio();
          } else {
            // TODO: play audio
            debugPrint('Play audio');
          }
        },
      ),
      leading: CachedNetworkImage(
        imageUrl: widget.podcast.image,
        width: 100,
        fit: BoxFit.cover,
        placeholder: (context, _) =>
        const ColoredBox(color: Colors.black26),
        errorWidget: (context, _, __) =>
        const Icon(Icons.error, size: 100, color: Colors.red),
      ),
    );
  }
}
