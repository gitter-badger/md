import "package:angular2/core.dart";
import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "../progress_linear/progress_linear.dart" show MdProgressLinear;
import "package:angular2/src/facade/math.dart" show Math;

class _ProgressMode {
  static const DETERMINATE = "determinate";
  static const INDETERMINATE = "indeterminate";
  const _ProgressMode();
}

class Defaults {
  static const DEFAULT_PROGRESS_SIZE = 100;
  static const DEFAULT_SCALING = 0.5;
  static const DEFAULT_HALF_TRANSITION = "transform 0.1s linear";
  const Defaults();
}

@Component(
    selector: "md-progress-circular",
    inputs: const ["value", "diameter"],
    host: const {
      "role": "progressbar",
      "aria-valuemin": "0",
      "aria-valuemax": "100",
      "[attr.aria-valuenow]": "value",
      "[style.width]": "outerSize",
      "[style.height]": "outerSize"
    },
    template: '''
    <div class="md-scale-wrapper"
     [style.-webkit-transform]="diameterTransformation"
     [style.transform]="diameterTransformation">
      <div class="md-spinner-wrapper">
        <div class="md-inner">
          <div class="md-gap"
          [style.-webkit-transition]="gapTransition"
          [style.transition]="gapTransition"></div>
          <div class="md-left">
            <div class="md-half-circle"
              [style.-webkit-transform]="leftHalfTransform"
              [style.transform]="leftHalfTransform"
              [style.-webkit-transition]="defaultHalfTransition"
              [style.transition]="defaultHalfTransition"></div>
          </div>
          <div class="md-right">
            <div class="md-half-circle"
              [style.-webkit-transform]="rightHalfTransform"
              [style.transform]="rightHalfTransform"
              [style.-webkit-transition]="defaultHalfTransition"
              [style.transition]="defaultHalfTransition"></div>
          </div>
        </div>
      </div>
    </div>''',
    directives: const [],
    encapsulation: ViewEncapsulation.None)
class MdProgressCircular extends MdProgressLinear implements OnChanges, OnInit {
  /// Value for the circle diameter.
  String _diameter;
  @Input()
  String mode;

  /// CSS `transform` property applied to the circle diameter.
  String diameterTransformation;

  /// CSS property length of circle preloader side.
  String outerSize;

  /// CSS `transform` property applied to the circle gap.
  String gapTransition;

  /// CSS `transition` property applied to circle.
  String defaultHalfTransition = Defaults.DEFAULT_HALF_TRANSITION;

  /// CSS `transform` property applied to the left half of circle.
  String leftHalfTransform;

  /// CSS `transform` property applied to the right half of circle.
  String rightHalfTransform;

  String get diameter => _diameter;

  @Input("diameter")
  set diameter(v) {
    if (isPresent(v)) {
      _diameter = v;
    }
  }

  ngOnInit() {
    updateScale();
  }

  ngOnChanges(_) {
    if (identical(mode, _ProgressMode.INDETERMINATE) || isBlank(value)) {
      return;
    }
    gapTransition = (value <= 50) ? "" : "borderBottomColor 0.1s linear";
    transformLeftHalf(value);
    transformRightHalf(value);
  }

  transformLeftHalf(value) {
    var rotation = (value <= 50) ? 135 : (((value - 50) / 50 * 180) + 135);
    leftHalfTransform = '''rotate(${ rotation}deg)''';
  }

  transformRightHalf(value) {
    var rotation = (value >= 50) ? 45 : (value / 50 * 180 - 135);
    rightHalfTransform = '''rotate(${ rotation}deg)''';
  }

  updateScale() {
    outerSize = "${100 * getDiameterRatio()}px";
    diameterTransformation =
        'translate(-50%, -50%) scale(${getDiameterRatio ()})';
  }

  num getDiameterRatio() {
    if (diameter == null || diameter.toString().isEmpty)
      return Defaults.DEFAULT_SCALING;

    var match = new RegExp(r'([0-9]*)%').firstMatch(diameter.toString());
    var value;

    try {
      value = Math.max(
          0,
          (match != null)
              ? double.parse(match[1]) / 100
              : double.parse(diameter.toString()));

    } on FormatException {
      return Defaults.DEFAULT_SCALING;
    }

    return (value > 1) ? value / Defaults.DEFAULT_PROGRESS_SIZE : value;
  }

  webkit(String style) {
    return '''-webkit-${ style}''';
  }
}
