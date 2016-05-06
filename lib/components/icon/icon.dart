import "package:angular2/core.dart" show Directive;

@Directive(
    selector: "[md-icon], .md-icon",
    host: const {"[class.material-icons]": "true"})
class MdIcon {}
