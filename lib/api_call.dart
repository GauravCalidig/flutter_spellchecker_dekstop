import 'package:get/get.dart';

class Translate extends GetConnect {
  Future<dynamic> getTranslation(String word) async {
    final response =
        await get('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    }
  }
}
