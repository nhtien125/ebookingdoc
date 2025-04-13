import 'package:get/get.dart';

class CategoryController extends GetxController {
  // Trạng thái
  final RxBool isLoading = false.obs;
  final RxInt topTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  
  // Dữ liệu
  final RxList<Map<String, dynamic>> displayedCategories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> newsItems = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> servicePackages = <Map<String, dynamic>>[].obs;
  late final List<Map<String, dynamic>> _allCategories;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _filterCategories(); // Lọc dữ liệu ngay khi khởi tạo
    _loadNewsAndServices(); // Tải dữ liệu tin tức và dịch vụ
  }

  void _initializeData() {
    _allCategories = [
      {'id': 1, 'name': 'Khám tổng quát', 'type': 'all', 'image': ''},
      {'id': 2, 'name': 'Khám nội tổng quát', 'type': 'clinic', 'image': ''},
      {'id': 3, 'name': 'Khám tại nhà', 'type': 'home', 'image': ''},
      {'id': 4, 'name': 'Nha khoa', 'type': 'specialty', 'image': ''},
      {'id': 5, 'name': 'Da liễu', 'type': 'specialty', 'image': ''},
    ];
  }

  void _loadNewsAndServices() {
    // Dữ liệu mẫu cho tin tức
    newsItems.assignAll([
      {
        'id': 1,
        'title': 'Cách phòng bệnh mùa nắng nóng',
        'image': '',
        'date': '10/04/2025',
        'summary': 'Những biện pháp phòng tránh các bệnh thường gặp trong mùa nắng nóng...'
      },
      {
        'id': 2, 
        'title': 'Dinh dưỡng cho người cao tuổi',
        'image': '',
        'date': '08/04/2025',
        'summary': 'Chế độ dinh dưỡng phù hợp giúp người cao tuổi duy trì sức khỏe...'
      },
      {
        'id': 3,
        'title': 'Tiêm chủng vắc-xin mới',
        'image': '',
        'date': '05/04/2025',
        'summary': 'Thông tin về chương trình tiêm chủng vắc-xin mới cho trẻ em...'
      },
    ]);

    // Dữ liệu mẫu cho gói dịch vụ khám
    servicePackages.assignAll([
      {
        'id': 1,
        'name': 'Gói khám sức khỏe cơ bản',
        'price': '500.000đ',
        'image': '',
        'description': 'Kiểm tra các chỉ số cơ bản, xét nghiệm máu, nước tiểu'
      },
      {
        'id': 2,
        'name': 'Gói khám tổng quát nâng cao',
        'price': '1.200.000đ',
        'image': '',
        'description': 'Kiểm tra toàn diện với 20+ hạng mục, siêu âm, X-quang'
      },
      {
        'id': 3,
        'name': 'Gói khám tim mạch chuyên sâu',
        'price': '2.500.000đ',
        'image': '',
        'description': 'Điện tâm đồ, siêu âm tim, đo huyết áp 24h'
      },
    ]);
  }

  void changeTab(int index) {
    if (topTabIndex.value == index) return;
    topTabIndex.value = index;
    _filterCategories();
  }

  void updateSearchQuery(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    _filterCategories();
  }

  void _filterCategories() {
    isLoading.value = true;
    
    // Tạm dừng 50ms để tránh rebuild liên tục khi nhập liệu
    Future.delayed(const Duration(milliseconds: 50), () {
      try {
        // Lọc theo tab
        Iterable<Map<String, dynamic>> filtered = _allCategories;
        
        if (topTabIndex.value != 0) {
          final type = _getCategoryType(topTabIndex.value);
          filtered = filtered.where((cat) => cat['type'] == type);
        }
        
        // Lọc theo từ khóa
        if (searchQuery.value.isNotEmpty) {
          filtered = filtered.where((cat) => 
            cat['name'].toLowerCase().contains(searchQuery.value.toLowerCase())
          );
        }
        
        displayedCategories.assignAll(filtered.toList());
      } catch (e) {
        displayedCategories.clear();
      } finally {
        isLoading.value = false;
      }
    });
  }

  String _getCategoryType(int tabIndex) {
    switch (tabIndex) {
      case 1: return 'home';
      case 2: return 'clinic';
      case 3: return 'specialty';
      default: return 'all';
    }
  }

  // Thêm hàm tiện ích
  List<Map<String, dynamic>> get categoriesByCurrentTab {
    return _allCategories.where((cat) {
      if (topTabIndex.value == 0) return true;
      return cat['type'] == _getCategoryType(topTabIndex.value);
    }).toList();
  }
}