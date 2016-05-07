import "package:angular2/core.dart" show Component, ViewEncapsulation;
import "package:md/md.dart" show MdCheckbox;

// TODO(): add gesture support
// TODO(): clean up CSS.
@Component(
    selector: "md-switch",
    inputs: const ["checked", "disabled"],
    host: const {
      "role": "checkbox",
      "[attr.aria-checked]": "checked",
      "[attr.aria-disabled]": "disabled",
      "(keydown)": "onKeydown(\$event)",
      "(click)": "toggle(\$event)"
    },
    template: '''
    <div class="md-switch-container">
      <div class="md-switch-bar"></div>
      <div class="md-switch-thumb-container">
        <div class="md-switch-thumb"></div>
      </div>
    </div>
    <div class="md-switch-label">
      <ng-content></ng-content>
    </div>''',
    directives: const [],
    encapsulation: ViewEncapsulation.None)
class MdSwitch extends MdCheckbox {}
