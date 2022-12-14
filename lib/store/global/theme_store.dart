import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:notie/data/shared_pref/shared_pref.dart';
import 'package:notie/global/debug.dart';
import 'package:notie/global/vars.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  @observable
  ThemeMode activeTheme = ThemeMode.system;

  @action
  Future<void> getActiveTheme() async =>
      activeTheme = await SharedPref.getTheme();

  @action
  Future<void> setActiveTheme(ThemeMode theme) async {
    if (await SharedPref.setTheme(theme)) {
      activeTheme = theme;
    } else {
      Debug.log(Vars.context, 'Failed to set theme');
    }
  }
}