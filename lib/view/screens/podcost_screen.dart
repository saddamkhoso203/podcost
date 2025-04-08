import 'package:flutter/material.dart';
import 'package:podcost/Model/podcast_Model.dart';
import 'package:podcost/api/podcast_api.dart';

import '../widgets/podcost_item.dart';

class PodcostScreen extends StatefulWidget {
  const PodcostScreen({super.key});

  @override
  State<PodcostScreen> createState() => _PodcostScreenState();
}

class _PodcostScreenState extends State<PodcostScreen> {
  List<Podcast>? podcast;
  final podcastApi = PodcastApi();

  @override
  void initState() {
    super.initState();
    fetchPodcast();
  }
Future<void>fetchPodcast()async{
    podcast = await podcastApi.fetchPodcast();
    setState(() {});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Podcost", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blue,
          centerTitle: true),
      body: podcast == null ? const Center(
        child:  CircularProgressIndicator(),
      ): podcast!.isEmpty?
          const Center(
            child: Text(" No podcast is found") ,
          ):

      ListView.separated(
        itemCount: podcast!.length,

        itemBuilder: (context, index){
          final item = podcast![index];
          return PodcostItem(podcast: item);
        },

        separatorBuilder: (_,_)=> SizedBox(height: 10,),


      ),
    );
  }
}
