import 'dart:async';
import 'dart:html' show MouseEvent;
import 'package:angular2/core.dart';

@Component(
  selector: '[md-button]:not(a), [md-fab]:not(a), [md-raised-button]:not(a)',
  template: '''
    <span class="md-button-wrapper">
      <ng-content></ng-content>
    </span>
  ''',
  encapsulation: ViewEncapsulation.None)
class MdButton {

  /// Whether a mousedown has occured on this element in the last 100ms.
  bool isMouseDown = false;

  /// Whether the button has focus from the keyboard (not the mouse). Used for class binding.
  bool isKeyboardFocused = false;

  onMousedown() {
    isMouseDown = true;
    // todo() WIP
    new Future.delayed(new Duration(milliseconds: 100))..then((_){
      isMouseDown = false;
    });
  }

  onFocus() {
    isKeyboardFocused = !isMouseDown;
  }

  onBlur() {
    isKeyboardFocused = false;
  }
}

@Component(
  selector: 'a[md-button], a[md-raised-button], a[md-fab]',
  inputs: const ['disabled'],
    template: '''
    <span class="md-button-wrapper">
      <ng-content></ng-content>
    </span>
  ''',
  encapsulation: ViewEncapsulation.None,
  host: const {
    '(click)': 'onClick(\$event)',
    '(mousedown)': 'onMousedown()',
    '(focus)': 'onFocus()',
    '(blur)': 'onBlur()',
    '[tabIndex]': 'tabIndex',
    '[disabled]': 'disabled',
    '[class.md-button-focus]': 'isKeyboardFocused',
    '[attr.aria-disabled]': 'isAriaDisabled',
  })
class MdAnchor extends MdButton implements OnChanges {
  num tabIndex;
  bool _disabled = false;

  bool get disabled => _disabled;

  set disabled(value) {
    // The presence of *any* disabled value makes the component disabled, *except* for false.
    // todo() make sure this actually works
    _disabled = value.toString().toLowerCase() != 'false';
  }

  void onClick(MouseEvent event) {
    // A disabled anchor shouldn't navigate anywhere.
    if (disabled) {
      event.preventDefault();
    }
  }

  /// Invoked when a change is detected.
  void ngOnChanges(Map<String, SimpleChange> changes) {
    // A disabled anchor should not be in the tab flow.
    tabIndex = disabled ? -1 : 0;
  }

  /// Gets the aria-disabled value for the component
  /// which must be a string for Dart.
  bool get isAriaDisabled => disabled == true ? true : false;
}
