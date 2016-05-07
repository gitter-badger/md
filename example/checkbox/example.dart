// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:md/md.dart';

@Component(
    selector: 'my-app',
    directives: const [MATERIAL_DIRECTIVES],
    templateUrl: 'example.html',
    styleUrls: const ['example.css'])
class AppComponent {
  bool cb1 = true;
  bool cb2 = false;
  bool cb3 = false;
  bool cb4 = true;
  bool cb5 = false;
}
