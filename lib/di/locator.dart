import 'package:ouakr/app/app_base_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async{
  locator.registerLazySingleton(() => AppBaseViewModel());
}