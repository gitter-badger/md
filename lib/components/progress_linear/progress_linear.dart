import "package:angular2/core.dart"
    show Component, ViewEncapsulation, OnChanges, Input;
import "package:angular2/src/facade/lang.dart" show isPresent, isBlank;
import "package:angular2/src/facade/math.dart" show Math;

/// Different display / behavior modes for progress_linear.
class _ProgressMode {
  static const DETERMINATE = "determinate";
  static const INDETERMINATE = "indeterminate";
  static const BUFFER = "buffer";
  static const QUERY = "query";
  const _ProgressMode();
}

@Component(
    selector: "md-progress-linear",
    inputs: const ["value", "bufferValue", "mode"],
    host: const {
      "role": "progressbar",
      "aria-valuemin": "0",
      "aria-valuemax": "100",
      "[attr.aria-valuenow]": "value",
      "[attr.mode]": "mode"
    },
    template: '''
    <div class="md-progress-linear-container md-ready">
      <div class="md-progress-linear-dashed"></div>
      <div class="md-progress-linear-bar md-progress-linear-bar1"
          [style.-webkit-transform]="secondaryBarTransform"
          [style.transform]="secondaryBarTransform"></div>
      <div class="md-progress-linear-bar md-progress-linear-bar2"
          [style.-webkit-transform]="primaryBarTransform"
          [style.transform]="primaryBarTransform"></div>
    </div>''',
    directives: const [],
    encapsulation: ViewEncapsulation.None)
class MdProgressLinear implements OnChanges {

  /// Clamps a value to be between 0 and 100.
  static clamp(v) {
    return Math.max(0, Math.min(100, v));
  }

  /// Value for the primary bar.
  num _value;

  /// Value for the secondary bar.
  @Input()
  num bufferValue;

  /// The render mode for the progress bar.
  @Input()
  String mode = _ProgressMode.DETERMINATE;

  /// CSS `transform` property applied to the primary bar.
  String primaryBarTransform;
  /// CSS `transform` property applied to the secondary bar.
  String secondaryBarTransform;

  MdProgressLinear() {
    primaryBarTransform = "";
    secondaryBarTransform = "";
  }

  get value => _value;

  @Input("value")
  set value(v) {
    if (isPresent(v)) {
      _value = MdProgressLinear.clamp(v);
    }
  }

  ngOnChanges(_) {
    // If the mode does not use a value, or if there is no value, do nothing.
    if (identical(mode, _ProgressMode.QUERY) ||
        identical(mode, _ProgressMode.INDETERMINATE)) {
      return;
    }
    if (!isBlank(value)) {
      primaryBarTransform = transformForValue(value);
    }
    // The bufferValue is only used in buffer mode.
    if (identical(mode, _ProgressMode.BUFFER) &&
        !isBlank(bufferValue)) {
      secondaryBarTransform = transformForValue(bufferValue);
    }
  }

  /// Gets the CSS `transform` property for a progress bar based on the given value (0 - 100).
  transformForValue(value) {
    // TODO(): test perf gain of caching these, since there are only 101 values.
    var scale = value / 100;
    var translateX = (value - 100) / 2;
    return 'translateX($translateX%) scale($scale, 1)';
  }
}
