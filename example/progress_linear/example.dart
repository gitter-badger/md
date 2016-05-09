// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:md/md.dart';

@Component(
    selector: 'my-app',
    directives: const [MATERIAL_DIRECTIVES],
    templateUrl: 'example.html',
    styleUrls: const ['example.css'])
class AppComponent {
  num determinateValue = 30;
  num determinateValue2 = 30;

  AppComponent() {
    // Iterate every 100ms, non-stop
    new Timer.periodic(new Duration(milliseconds: 1000),(_){
      determinateValue += 1;
      determinateValue2 += 1.5;
      if (determinateValue > 100) {
        determinateValue = 30;
      }
      if (determinateValue2 > 100) {
        determinateValue2 = 30;
      }
    });
  }
}
