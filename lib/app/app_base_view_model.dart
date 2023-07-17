import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AppBaseViewModel extends BaseViewModel{
  ThemeMode theme = ThemeMode.dark;
  //AppBaseViewModel baseModel = locator<AppBaseViewModel>();
  init() {}
  ChangeTheme(){
    if(theme == ThemeMode.dark){
      theme = ThemeMode.light;
    }
    else{
      theme = ThemeMode.dark;
    }
    notifyListeners();
    //baseModel.notifyListeners();
  }
}