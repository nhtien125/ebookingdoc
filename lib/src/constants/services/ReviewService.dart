import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/data/model/review_model.dart';

class ReviewService {
  /// Lấy danh sách review theo doctor_id
  Future<List<Review>> getReviewsByDoctorId(String doctorId) async {
    try {
      final response = await APICaller.getInstance()
          .get('api/review/getByDoctorId/$doctorId');
      if (response != null && response['code'] == 200) {
        List list = response['data'];
        return list.map((e) => Review.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
