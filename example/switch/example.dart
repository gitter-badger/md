// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:md/md.dart';

@Component(
    selector: 'my-app',
    directives: const [MATERIAL_DIRECTIVES],
    templateUrl: 'example.html')
class AppComponent {
  bool cb1 = true;
  bool cb2 = true;
  bool cb4 = true;
  bool cb5 = false;
  bool cb6 = true;
  bool disabledModel = false;

  dynamic message = 'false';

  onChange(cbState) {
    message = cbState;
  }
}
