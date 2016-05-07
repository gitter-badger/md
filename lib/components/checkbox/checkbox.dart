import "dart:html";
import "package:angular2/core.dart"
    show Component, ViewEncapsulation, Input, Output, EventEmitter;
import "package:angular2/src/facade/lang.dart" show isPresent;
import "package:md/core/key_codes.dart" show KeyCodes;
import "package:md/core/util/util.dart" show parseTabIndexAttribute;

// TODO(jd): ng-true-value, ng-false-value
@Component(
    selector: "md-checkbox",
    inputs: const ["checked", "disabled"],
    template: '''
    <div class="md-checkbox-container">
      <div class="md-checkbox-icon"></div>
    </div>
    <div class="md-checkbox-label"><ng-content></ng-content></div>''',
    directives: const [],
    encapsulation: ViewEncapsulation.None,
    host: const {
      "role": "checkbox",
      "[attr.aria-checked]": "checked",
      "[attr.aria-disabled]": "disabled",
      "[tabindex]": "tabindex",
      "(keydown)": "onKeydown(\$event)",
      "(click)": "toggle(\$event)"
    })
class MdCheckbox {
  @Output()
  EventEmitter<bool> checkedChange = new EventEmitter<bool>(false);

  /// Whether this checkbox is checked.
  @Input()
  bool checked = false;

  /// Whether this checkbox is disabled.
  bool _disabled = false;

  /// Setter for tabindex
  @Input("tabindex")
  num _tabindex;

  set tabindex(num value) {
    _tabindex = parseTabIndexAttribute(value);
  }

  num get tabindex {
    return _tabindex;
  }

  get disabled => _disabled;

  @Input("disabled")
  set disabled(value) {
    _disabled = isPresent(value) && !identical(value, false);
  }

  onKeydown(KeyboardEvent event) {
    if (identical(event.keyCode, KeyCodes.SPACE)) {
      event.preventDefault();
      toggle(event);
    }
  }

  toggle(event) {
    if (disabled) {
      event.stopPropagation();
      return;
    }

    checked = !checked;
    checkedChange.emit(checked);
  }
}
