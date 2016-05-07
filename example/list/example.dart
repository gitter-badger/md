// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:md/md.dart';

const String imagePath = '/images/avatars/avatar11.svg';

@Component(
    selector: 'my-app',
    directives: const [MATERIAL_DIRECTIVES],
    templateUrl: 'example.html',
    styleUrls: const ['example.css'])
class AppComponent {

  List phones = [
    {'type': 'Home', 'number': '(555) 251-1234'},
    {'type': 'Cell', 'number': '(555) 786-9841'},
    {'type': 'Office', 'number': '(555) 314-1592'}
  ];

  List todos = [
    {
      'face': imagePath,
      'what': 'Brunch this weekend?',
      'who': 'Min Li Chan',
      'when': '3:08PM',
      'notes': " I'll be in your neighborhood doing errands"
    },
    {
      'face': imagePath,
      'what': 'Brunch this weekend?',
      'who': 'Min Li Chan',
      'when': '3:08PM',
      'notes': " I'll be in your neighborhood doing errands"
    },
    {
      'face': imagePath,
      'what': 'Brunch this weekend?',
      'who': 'Min Li Chan',
      'when': '3:08PM',
      'notes': " I'll be in your neighborhood doing errands"
    },
    {
      'face': imagePath,
      'what': 'Brunch this weekend?',
      'who': 'Min Li Chan',
      'when': '3:08PM',
      'notes': " I'll be in your neighborhood doing errands"
    },
    {
      'face': imagePath,
      'what': 'Brunch this weekend?',
      'who': 'Min Li Chan',
      'when': '3:08PM',
      'notes': " I'll be in your neighborhood doing errands"
    }
  ];

  String getSrc(item, index) => "${item['face']}?$index";
}
