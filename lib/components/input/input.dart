import "package:angular2/core.dart";
import "package:angular2/common.dart" show NgModel, NgControl, FORM_PROVIDERS;
import "package:angular2/src/facade/async.dart"
    show ObservableWrapper, EventEmitter, TimerWrapper;
import "package:angular2/src/facade/lang.dart" show isBlank;
import "package:angular2/src/platform/dom/dom_adapter.dart" show DOM;

// TODO(jd): <select> hasFocus/hasValue classes

// TODO(jd): input container validation styles.

// TODO(jelbourn): textarea resizing

// TODO(jelbourn): max-length counter
@Directive(
    selector:
        "input[md-input],input.md-input,textarea[md-input],textarea.md-input",
    host: const {
      "class": "md-input",
      "[value]": "value",
      "(input)": "value=\$event.target.value",
      "(focus)": "setHasFocus(true)",
      "(blur)": "setHasFocus(false)"
    },
    providers: const [
      FORM_PROVIDERS
    ])
class MdInput {
  NgModel model;
  NgControl control;
  String _value;

  MdInput(@Optional() this.model, @Optional() this.control);

  @Input("value")
  set value(String value) {
    this._value = value;
    TimerWrapper.setTimeout(() => mdChange.emit(value), 1);
  }

  String get value {
    var val = model != null
        ? model.value
        : control != null ? control.value : _value;
    return !isBlank(val) ? val : "";
  }

  @Input()
  String placeholder;

  @Output("valueChange")
  EventEmitter<dynamic> mdChange = new EventEmitter();

  @Output()
  EventEmitter<dynamic> mdFocusChange = new EventEmitter(false);

  setHasFocus(bool hasFocus) {
    ObservableWrapper.callEmit(mdFocusChange, hasFocus);
  }
}

@Component(
    selector: "md-input-container",
    template:
        '''
          <ng-content></ng-content>
          <div class="md-errors-spacer"></div>''')
class MdInputContainer implements AfterContentInit, OnChanges {
  ElementRef _element;

  @ContentChild(MdInput)
  MdInput input = null;

  MdInputContainer(this._element);

  // Whether the input inside of this container has a non-empty value.
  @HostBinding("class.md-input-has-value")
  bool inputHasValue = false;

  // Whether the input inside of this container has focus.
  @HostBinding("class.md-input-focused")
  bool inputHasFocus = false;

  // Whether the input inside of this container has a placeholder
  @HostBinding("class.md-input-has-placeholder")
  bool inputHasPlaceholder = false;

  ngOnChanges(_) {
    inputHasValue = input.value !=  "";

    // TODO(jd): Is there something like @ContentChild that accepts a selector? I would prefer not to

    // use a directive for label elements because I cannot use a parent->child selector to make them

    // specific to md-input
    inputHasPlaceholder =
        !!DOM.querySelector(this._element.nativeElement, "label") &&
            input.placeholder != null;
  }

  ngAfterContentInit() {
    // If there is no text input, just bail and do nothing.
    if (input == null) {
      return;
    }

    // TODO(jd): :sob: what is the correct way to update these variables after the component initializes?

    //  any time I do it directly here, debug mode complains about values changing after being checked. I

    //  need to wait until the content has been initialized so that `_input` is there

    // For now, just wrap it in a setTimeout to let the change detection finish up, and then set the values...
    TimerWrapper.setTimeout(() => this.ngOnChanges({}), 0);
    // Listen to input changes and focus events so that we can apply the appropriate CSS

    // classes based on the input state.
    input.mdChange.listen((String value) {
      inputHasValue = !identical(value, "");
    });

    input.mdFocusChange.listen((bool hasFocus) {
      inputHasFocus = hasFocus;
    });
  }
}
