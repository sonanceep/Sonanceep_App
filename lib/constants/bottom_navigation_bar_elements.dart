// flutter
import 'package:flutter/material.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';


final List<BottomNavigationBarItem> bottomNavigationBarElements = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: homeText,
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.search),
    label: searchText,
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.add),
    label: createText,
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.message),
    label: messageText,
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: profileText,
  ),
];