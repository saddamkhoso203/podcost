import 'package:flutter/material.dart';
import 'package:podcost/Model/podcast_Model.dart';

import '../../api/podcast_api.dart';

class PodcostItem extends StatefulWidget {
  final Podcast podcast;
  const PodcostItem({super.key, required this.podcast });

  @override
  State<PodcostItem> createState() => _PodcostItemState();
}

class _PodcostItemState extends State<PodcostItem> {
  final podcastApi = PodcastApi();
  @override
  Widget build(BuildContext context) => ListTile(
    title:  Text(widget.podcast.title),
    trailing: IconButton(onPressed: () async {
      final path = '${widget.podcast.title}/${ widget.podcast.id}.mp3';
      await podcastApi.downloadAudio(
        widget.podcast.audio,
        path,
          onReceiveProgress:(count, total){
          debugPrint('${count/total}');
          }
      );
    }, icon: Icon(Icons.download)),
    leading: Image.network(
   widget.podcast.image ,
      height: 100,
      width: 100     ,
      fit: BoxFit.cover,
    ),
  );
}
