import 'package:get/get.dart';
import 'package:lblmanagert/routes/app_pages.dart';

class NavigationController extends GetxController {
  var currentRoute = Routes.HOME.obs;

  void changePage(String route) {
    currentRoute.value = route;
    Get.toNamed(route);
  }

  void replacePage(String route) {
    currentRoute.value = route;
    Get.offNamed(route);
  }
}
