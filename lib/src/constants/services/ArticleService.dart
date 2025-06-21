import 'package:ebookingdoc/src/data/model/article_model.dart';
import 'package:ebookingdoc/src/constants/services/api_caller.dart';

class ArticleService {
  Future<List<Article>> getAllArticles() async {
    try {
      print('[ArticleService] Gọi API: api/article/getAll');
      final response = await APICaller.getInstance().get('api/article/getAll');
      print('[ArticleService] Raw Response: $response');

      if (response != null && response['code'] == 200) {
        List list = response['data'];
        print('[ArticleService] Data: $list');
        return list.map((e) => Article.fromJson(e)).toList();
      } else {
        print('[ArticleService] API lỗi hoặc không trả về code 200');
        if (response != null && response['message'] != null) {
          print('[ArticleService] Lý do: ${response['message']}');
        }
      }
    } catch (e) {
      print('[ArticleService] Lỗi khi gọi API: $e');
    }
    return [];
  }
}