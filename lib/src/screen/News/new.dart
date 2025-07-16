import 'dart:developer' as dev; // Thêm để log
import 'package:flutter/material.dart';
import 'package:ebookingdoc/src/data/model/article_model.dart';
import 'package:ebookingdoc/src/constants/services/ArticleService.dart';
import 'article_detail.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];
  bool _isSearching = false;
  bool _isLoading = true; 
  bool _isLoadingMore = false;
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _limit = 2; 
  bool _hasMoreData = true; 

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles({bool isRefresh = false}) async {
    if (isRefresh || _allArticles.isEmpty) {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
        _allArticles.clear();
        _filteredArticles.clear();
      });

      try {
        final articles = await ArticleService().getAllArticles();
        dev.log('Số lượng bài viết từ API: ${articles.length}'); // Log tổng số
        setState(() {
          _allArticles = articles;
          _hasMoreData = articles.length > _limit; // Kiểm tra nếu còn đủ để phân trang
          _filteredArticles = _allArticles.sublist(0, _limit < articles.length ? _limit : articles.length);
          _isLoading = false;
        });
      } catch (e) {
        dev.log('Lỗi tải bài viết: $e');
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải bài viết: $e')),
        );
      }
    } else if (_isLoadingMore) {
      return; // Ngăn chặn gọi đồng thời
    }

    if (!_isLoading && _hasMoreData) {
      setState(() => _isLoadingMore = true);
      final start = (_currentPage - 1) * _limit;
      final end = start + _limit;
      dev.log('Tải thêm: start=$start, end=$end, total=${_allArticles.length}');
      if (end <= _allArticles.length) {
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
        setState(() {
          _filteredArticles.addAll(_allArticles.sublist(start, end));
          _currentPage++;
          _hasMoreData = end < _allArticles.length;
          _isLoadingMore = false;
        });
      } else {
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
        setState(() {
          _filteredArticles.addAll(_allArticles.sublist(start));
          _hasMoreData = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  void _searchArticles(String query) {
    setState(() {
      _filteredArticles = _allArticles.where((article) {
        final title = (article.title ?? '').toLowerCase();
        final content = (article.content ?? '').toLowerCase();
        final searchLower = query.toLowerCase();
        return title.contains(searchLower) || content.contains(searchLower);
      }).toList();
      _currentPage = 1; // Reset page khi tìm kiếm
      _hasMoreData = _filteredArticles.length > _limit;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredArticles = _allArticles.sublist(0, _limit < _allArticles.length ? _limit : _allArticles.length);
        _currentPage = 1;
        _hasMoreData = _allArticles.length > _limit;
      }
    });
  }

  Future<void> _refreshArticles() async {
    await _fetchArticles(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm bài viết...',
                  border: InputBorder.none,
                ),
                onChanged: _searchArticles,
              )
            : const Text('Tin tức'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshArticles,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredArticles.isEmpty
                  ? const Center(child: Text('Không tìm thấy bài viết phù hợp'))
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification &&
                            notification.metrics.pixels >=
                                notification.metrics.maxScrollExtent - 200 &&
                            _hasMoreData &&
                            !_isLoadingMore) {
                          _fetchArticles();
                        }
                        return false;
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _filteredArticles.length + (_hasMoreData ? 1 : 0),
                              itemExtent: 350, // Đặt chiều cao cố định để tối ưu
                              itemBuilder: (context, index) {
                                if (index == _filteredArticles.length) {
                                  return _buildLoadMore();
                                }
                                final article = _filteredArticles[index];
                                return _buildArticleCard(article, context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildLoadMore() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _isLoadingMore
            ? const CircularProgressIndicator()
            : _hasMoreData
                ? OutlinedButton(
                    onPressed: _fetchArticles,
                    child: const Text('Tải thêm'),
                  )
                : const Text('Đã tải hết'),
      ),
    );
  }

  Widget _buildArticleCard(Article article, BuildContext context) {
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
            child: article.image != null && article.image!.isNotEmpty
                ? Image.network(
                    article.image!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    ),
                  )
                : Container(
                    height: 180,
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 40),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.content ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.createdAt ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetail(article: article),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}