import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeviceHelper {
  static bool isTablet() {
    // Kiểm tra xem thiết bị có phải là tablet hay không (ví dụ > 600px)
    return ScreenUtil().screenWidth > 600;
  }

  static double getFontSize(double sp) {
    // Giảm font chữ đi 2 sp nếu là tablet
    if (isTablet()) {
      return sp - 2;
    }
    return sp.sp;
  }
}
