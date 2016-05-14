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

  final user = {
    'title': 'Developer',
    'email': 'ipsum@lorem.com',
    'firstName': '',
    'lastName': '',
    'company': 'Google',
    'address': '1600 Amphitheatre Pkwy',
    'address2': '',
    'city': 'Mountain View',
    'state': 'CA',
    'biography': 'Loves kittens, snowboarding, and can type at 130 WPM.\n\nAnd rumor has it she bouldered up Castle Craig!',
    'postalCode': '94043'
  };

  final _states = [
  'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME',
  'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA',
  'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
  ];

  get states => _states.map((state) => {'abbrev': state});

}
