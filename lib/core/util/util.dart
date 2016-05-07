import "package:angular2/src/facade/lang.dart" show isPresent ;
import "package:angular2/src/facade/lang.dart" show NumberWrapper ;

num parseTabIndexAttribute(attr) {
 return isPresent(attr) ? NumberWrapper.parseInt(attr, 10) : 0;
}
