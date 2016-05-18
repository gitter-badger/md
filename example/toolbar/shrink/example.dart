// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:md/md.dart';
import 'dart:html';

@Component(
    selector: 'my-app',
    directives: const [MATERIAL_DIRECTIVES],
    templateUrl: 'example.html',
    styles: const ['example.css'])
class AppComponent {
  String title = 'My App Title';
  String imagePath = 'https://justindujardin.github.io/ng2-material/public/images/avatars/avatar5.svg';
  List todos = [];

  AppComponent(){
    for (var i = 0; i < 15; i++) {
      todos.add({
        'face' : imagePath,
        'what' : "Brunch this weekend?",
        'who' : "Min Li Chan",
        'notes' : "I'll be in your neighborhood doing errands."
      });
    }
  }
}
