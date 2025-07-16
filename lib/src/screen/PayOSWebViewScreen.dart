import 'package:ebookingdoc/src/constants/app_page.dart';
import 'package:ebookingdoc/src/constants/services/PayOSService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayOSWebViewScreen extends StatefulWidget {
  final String url;
  final String paymentId;
  final PayOSService payOSService; // Truyền service vào hoặc tạo mới

  const PayOSWebViewScreen({
    required this.url,
    required this.paymentId,
    required this.payOSService,
    super.key,
  });

  @override
  State<PayOSWebViewScreen> createState() => _PayOSWebViewScreenState();
}

class _PayOSWebViewScreenState extends State<PayOSWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            if (url.contains('/payment/success')) {
              _onPaymentResult('success');
              return NavigationDecision.prevent;
            } else if (url.contains('/payment/cancel')) {
              _onPaymentResult('cancel');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lỗi Thanh toán')),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _onPaymentResult(String status) async {
    // Map status string to int
    int statusCode = 1; // default: pending
    if (status == 'success') {
      statusCode = 0; // thành công
    } else if (status == 'cancel') {
      statusCode = 2; // hủy
    }
    // Gọi PayOSService cập nhật trạng thái thanh toán
    final result = await widget.payOSService
        .updatePaymentStatus(widget.paymentId, statusCode);
    if (result && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            statusCode == 0
                ? 'Bạn đã thanh toán thành công'
                : 'Đã hủy thanh toán.',
          ),
        ),
      );
       Future.delayed(const Duration(seconds: 1), () {
        if (Navigator.canPop(context)) {
    
          Get.offAllNamed(Routes.dashboard);
        }
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi cập nhật trạng thái!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán PayOS')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
