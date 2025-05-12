import 'package:ebookingdoc/Global/app_color.dart';
import 'package:flutter/material.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final List<Map<String, dynamic>> _allArticles = [
    {
      'title': '10 Cách phòng ngừa bệnh tim mạch hiệu quả',
      'image': 'assets/images/10cpntm.jpg',
      'description': 'Bài viết cung cấp các phương pháp khoa học giúp bảo vệ sức khỏe tim mạch...',
      'date': '15/03/2024',
      'content': 'Trên thực tế cho thấy tim mạch là bệnh lý nguy hiểm và chiếm tỷ lệ tử vong cao đặc biệt tỷ lệ mắc bệnh tim mạch ngày càng trẻ hóa. Nguyên nhân do thói quen ăn uống, sinh hoạt hàng ngày thiếu lành mạnh. Do đó việc thực hiện các biện pháp phòng bệnh tim mạch là việc cấp thiết hiện nay. ',
    },
    {
      'title': 'Dấu hiệu nhận biết thiếu vitamin D',
      'image': 'assets/images/vitaminD.jpg',
      'description': 'Những triệu chứng thường gặp khi cơ thể thiếu hụt vitamin D và cách khắc phục...',
      'date': '10/03/2024',
      'content': 'Đây là nội dung chi tiết về các dấu hiệu thiếu vitamin D và phương pháp bổ sung...',
    },
    {
      'title': 'Hướng dẫn tập thể dục tại nhà mùa dịch',
      'image': 'assets/images/phongchondich.jpg',
      'description': 'Các bài tập đơn giản giúp tăng cường sức đề kháng mà không cần đến phòng gym...',
      'date': '05/03/2024',
      'content': 'Đây là nội dung chi tiết về các bài tập thể dục tại nhà giúp tăng cường sức khỏe...',
    },
  ];

  late List<Map<String, dynamic>> _filteredArticles;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _filteredArticles = _allArticles;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchArticles(String query) {
    setState(() {
      _filteredArticles = _allArticles.where((article) {
        final title = article['title'].toLowerCase();
        final description = article['description'].toLowerCase();
        final searchLower = query.toLowerCase();
        return title.contains(searchLower) || description.contains(searchLower);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredArticles = _allArticles;
      }
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bài viết...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColor.main),
              ),
              style: TextStyle(color: AppColor.main),
              onChanged: _searchArticles,
            )
          : Text(
              'Tin tức y tế',
              style: TextStyle(color: AppColor.main),
            ),
      centerTitle: true,
      backgroundColor: AppColor.fourthMain,
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: AppColor.main, 
          ),
          onPressed: _toggleSearch,
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: _filteredArticles.isEmpty
          ? Center(
              child: Text(
                'Không tìm thấy bài viết phù hợp',
                style: TextStyle(fontSize: 16, color: AppColor.xmain),
              ),
            )
          : ListView.builder(
              itemCount: _filteredArticles.length,
              itemBuilder: (context, index) {
                final article = _filteredArticles[index];
                return _buildArticleCard(article, context);
              },
            ),
    ),
  );
}


  Widget _buildArticleCard(Map<String, dynamic> article, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              article['image'],
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: AppColor.main,
                child: Center(
                  child: Icon(Icons.image_not_supported, color: AppColor.xmain, size: 40),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article['date'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    _buildReadMoreButton(article, context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadMoreButton(Map<String, dynamic> article, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetail(article: article),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Xem chi tiết',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ArticleDetail extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArticleDetail({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        article['title'],
        style: TextStyle(fontSize: 16, color: AppColor.main), 
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: AppColor.fourthMain,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColor.main), 
        onPressed: () {
          Navigator.pop(context); 
        },
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bài viết
          Image.asset(
            article['image'],
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 220,
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
              ),
            ),
          ),
          
          // Nội dung bài viết
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                Text(
                  article['title'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                // Ngày đăng
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Ngày đăng: ${article['date']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                
                const Divider(),
                
                // Nội dung chính
                const SizedBox(height: 8),
                Text(
                  article['content'] ?? article['description'],
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}