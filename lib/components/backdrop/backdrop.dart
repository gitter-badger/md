import "dart:async";
import "../../core/util/animate.dart" as animate;
import 'dart:html';
import "package:angular2/core.dart";
import "package:angular2/src/platform/dom/dom_adapter.dart" show DOM;

/**
 * An overlay for content on the page.
 * Can optionally dismiss when clicked on.
 * Has outputs for show/showing and hide/hiding.
 */
@Component(
    selector: "md-backdrop",
    template: "",
    encapsulation: ViewEncapsulation.None,
    host: const {"class": "md-backdrop", "(click)": "onClick()"})
class MdBackdrop {
  ElementRef element;

  /**
   * When true, clicking on the backdrop will close it
   */
  @Input()
  bool clickClose = false;
  /**
   * When true, disable the parent container scroll while the backdrop is active.
   */
  @Input()
  bool hideScroll = true;
  /**
   * Emits when the backdrop begins to hide.
   */
  @Output()
  EventEmitter<MdBackdrop> onHiding = new EventEmitter<MdBackdrop>(false);
  /**
   * Emits when the backdrop has finished being hidden.
   */
  @Output()
  EventEmitter<MdBackdrop> onHidden = new EventEmitter<MdBackdrop>(false);
  /**
   * Emits when the backdrop begins to be shown.
   */
  @Output()
  EventEmitter<MdBackdrop> onShowing = new EventEmitter<MdBackdrop>();
  /**
   * Emits when the backdrop has finished being shown.
   */
  @Output()
  EventEmitter<MdBackdrop> onShown = new EventEmitter<MdBackdrop>();

  MdBackdrop(this.element) {
    this._body = DOM.querySelector(window.document, "body");
  }

  /**
   * The CSS class name to transition on/off when the backdrop is hidden/shown.
   */
  @Input()
  String transitionClass = "md-active";
  /**
   * Whether to add the {@see transitionClass} or remove it when the backdrop is shown. The
   * opposite will happen when the backdrop is hidden.
   */
  @Input()
  var transitionAddClass = true;
  /**
   * Whether the backdrop is visible.
   */
  bool get visible {
    return this._visible;
  }

  @Input()
  set visible(bool value) {
    this.toggle(value);
  }

  bool _visible = false;
  bool _transitioning = false;
  String _previousOverflow = null;
  HtmlElement _body = null;
  onClick() {
    if (this.clickClose && !this._transitioning && this.visible) {
      this.hide();
    }
  }

  /**
   * Hide the backdrop and return a promise that is resolved when the hide animations are
   * complete.
   */
  Future hide() {
    return this.toggle(false);
  }

  /**
   * Show the backdrop and return a promise that is resolved when the show animations are
   * complete.
   */
  Future show() {
    return toggle(true);
  }

  /**
   * Toggle the visibility of the backdrop.
   * 
   * 
   */
  Future toggle([bool visible]) async {
    visible = visible ?? !this.visible;

    if (identical(visible, this._visible)) {
      return null;
    }

    var beginEvent = visible ? this.onShowing : this.onHiding;
    var endEvent = visible ? this.onShown : this.onHidden;
    this._visible = visible;
    this._transitioning = true;

    beginEvent.emit(this);

    var action = visible
        ? (transitionAddClass ? animate.enter : animate.leave)
        : (transitionAddClass ? animate.leave : animate.enter);

    // Page scroll
    if (visible && this.hideScroll && this.element != null && this._previousOverflow != null) {
      var style = DOM.getStyle(this._body, "overflow");
      if (!identical(style, "hidden")) {
        this._previousOverflow = style;
        DOM.setStyle(this._body, "overflow", "hidden");
      }
    } else if (!visible &&
        this.hideScroll &&
        this.element != null &&
        !identical(this._previousOverflow, null)) {
      DOM.setStyle(this._body, "overflow", this._previousOverflow);
      this._previousOverflow = null;
    }

    // Animate transition class in/out and then finally emit the completed event.
    return action(this.element.nativeElement, this.transitionClass).then(() {
      this._transitioning = false;
      endEvent.emit(this);
    });
  }
}
