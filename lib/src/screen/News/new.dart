import 'package:ebookingdoc/src/Global/app_color.dart';
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
      'description': 'Phương pháp khoa học bảo vệ sức khỏe tim mạch...',
      'date': '15/03/2024',
      'content': 'Tim mạch là bệnh lý nguy hiểm với tỷ lệ tử vong cao, ngày càng trẻ hóa do thói quen ăn uống, sinh hoạt thiếu lành mạnh. Phòng bệnh tim mạch là việc cấp thiết hiện nay.',
    },
    {
      'title': 'Dấu hiệu nhận biết thiếu vitamin D',
      'image': 'assets/images/vitaminD.jpg',
      'description': 'Triệu chứng thiếu hụt vitamin D và cách khắc phục...',
      'date': '10/03/2024',
      'content': 'Nội dung chi tiết về dấu hiệu thiếu vitamin D và phương pháp bổ sung...',
    },
    {
      'title': 'Hướng dẫn tập thể dục tại nhà mùa dịch',
      'image': 'assets/images/phongchondich.jpg',
      'description': 'Bài tập đơn giản tăng cường sức đề kháng tại nhà...',
      'date': '05/03/2024',
      'content': 'Nội dung chi tiết về bài tập thể dục tại nhà giúp tăng cường sức khỏe...',
    },
  ];

  late List<Map<String, dynamic>> _filteredArticles;
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredArticles = _allArticles;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchArticles(String query) {
    setState(() {
      _filteredArticles = _allArticles
          .where((article) =>
              article['title'].toLowerCase().contains(query.toLowerCase()) ||
              article['description'].toLowerCase().contains(query.toLowerCase()))
          .toList();
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
            : Text('Tin tức y tế', style: TextStyle(color: AppColor.main)),
        centerTitle: true,
        backgroundColor: AppColor.fourthMain,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: AppColor.main),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _filteredArticles.isEmpty
            ? Center(child: Text('Không tìm thấy bài viết', style: TextStyle(fontSize: 16, color: AppColor.xmain)))
            : ListView.builder(
                itemCount: _filteredArticles.length,
                itemBuilder: (context, index) => _buildArticleCard(_filteredArticles[index], context),
              ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              article['image'],
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 160,
                color: AppColor.main,
                child: Icon(Icons.image_not_supported, color: AppColor.xmain, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  article['description'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(article['date'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetail(article: article))),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(16)),
        child: const Text('Xem chi tiết', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              article['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[200],
                child: Icon(Icons.image_not_supported, color: AppColor.main, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text('Ngày đăng: ${article['date']}', style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic)),
                  ),
                  const Divider(),
                  const SizedBox(height: 6),
                  Text(article['content'] ?? article['description'], style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}