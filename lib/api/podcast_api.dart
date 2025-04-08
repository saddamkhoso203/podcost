import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcost/Model/podcast_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastApi {
  final dio = Dio();

  Future<List<Podcast>> fetchPodcast() async {
    const url = 'https://listen-api.listennotes.com/api/v2/search?q=star';
    const apikey = 'e0c7e9e08ba14517a53ac6f041407d4d';

    final headers = {
      'X-ListenAPI-Key': apikey,
      'Accept': 'application/json',
    };

    try {
      if (await InternetConnectionChecker().hasConnection) {
        final response = await dio.get(url, options: Options(headers: headers));

        if (response.statusCode == 200) {
          final data = response.data;

          final results = data['results'];
          if (results is List) {
            return results.map((json) => Podcast.fromJson(json)).toList();
          } else {
            print('Unexpected response format: results is not a List');
            return [];
          }
        } else {
          print('API call failed with status code: ${response.statusCode}');
          return [];
        }
      } else {
        print('No internet connection');
        return [];
      }
    } catch (e) {
      print('Error fetching podcast data: $e');
      return [];
    }
  }

  Future<void>downloadAudio(
      String url,
      String filname,{
        ProgressCallback? onReceiveProgress,
  }
      ) async{
    final appStorage = await getApplicationDocumentsDirectory();
      final sharedPreferences = await SharedPreferences.getInstance();
      final   path = '${appStorage.path}/$filname';
      if(await InternetConnectionChecker().hasConnection){
        await dio.download(
          url,
          path,
          onReceiveProgress: onReceiveProgress,
        );
        await sharedPreferences.setString('path', path);
      }
  }
}
