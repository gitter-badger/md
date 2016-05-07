import "package:angular2/core.dart" show Component;

@Component(
    selector: "md-subheader",
    host: const {"class": "md-subheader"},
    template: '''
    <div class="md-subheader-inner">
      <span class="md-subheader-content"><ng-content></ng-content></span>
    </div>''')
class MdSubheader {}
