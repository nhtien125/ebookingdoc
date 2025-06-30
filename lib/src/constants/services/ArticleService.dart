import 'package:ebookingdoc/src/data/model/article_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';

class ArticleService {
  Future<List<Article>> getAllArticles() async {
    try {
      final response = await APICaller.getInstance().get('api/article/getAll');

      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Article.fromJson(e)).toList();
      } else {
        if (response != null && response['message'] != null) {
          print('Lý do: ${response['message']}');
        }
      }
    } catch (e) {
      print('Lỗi khi gọi API: $e');
    }
    return [];
  }
}
