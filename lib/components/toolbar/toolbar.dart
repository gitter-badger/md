import "package:angular2/core.dart";
import "package:angular2/src/platform/dom/dom_adapter.dart" show DOM;
import 'dart:math' as math;
import 'dart:html';
import "package:angular2/src/facade/lang.dart"
    show isPresent, isString, NumberWrapper;

@Directive(
    selector: "md-toolbar", inputs: const ["mdShrinkSpeed", "mdScrollShrink"])
class MdToolbar implements AfterContentInit, OnChanges, OnDestroy {
  ElementRef el;

  @Input()
  set mdShrinkSpeed(value) {
    _mdShrinkSpeed = value is String ? double.parse(value) : value;
  }

  num get mdShrinkSpeed => _mdShrinkSpeed;

  @Input()
  set mdScrollShrink(bool value) {
    this._mdScrollShrink = !!isPresent(value);
  }

  bool get mdScrollShrink => _mdScrollShrink;

  num _mdShrinkSpeed = 0.5;
  var _debouncedContentScroll = null;
  var _debouncedUpdateHeight = null;
  var _content = null;
  num _toolbarHeight = 0;
  var _cancelScrollShrink = null;
  num _previousScrollTop = 0;
  num _currentY = 0;
  bool _mdScrollShrink = false;

  MdToolbar(this.el) {
    ///_debouncedContentScroll = throttle(this.onContentScroll, 10, this);
    ///_debouncedUpdateHeight = debounce(this.updateToolbarHeight, 5 * 1000, this);
  }

  ngAfterContentInit() {

    this.disableScrollShrink();
    if (!this.mdScrollShrink) {
      return;
    }

    // TODO(jd): better way to find siblings?
    _content = DOM.querySelector(DOM.parentElement(el.nativeElement), "md-content");

    if(this._content == null) return;

    _cancelScrollShrink = DOM.onAndCancel(this._content, "scroll", this._debouncedContentScroll);

    DOM.setAttribute(this._content, "scroll-shrink", "true");
    window.requestAnimationFrame((_) => updateToolbarHeight());
  }

  ngOnChanges(dynamic changes) {
    updateToolbarHeight();
  }

  ngOnDestroy() {
    disableScrollShrink();
  }

  disableScrollShrink() {
    if (_cancelScrollShrink) {
      this._cancelScrollShrink();
      this._cancelScrollShrink = null;
    }
  }

  updateToolbarHeight() {
    _toolbarHeight = DOM.getProperty(el.nativeElement, "offsetHeight");

    if (this._content) {
      var margin = "${(-this._toolbarHeight * this.mdShrinkSpeed)} px";
      DOM.setStyle(this._content, "margin-top", margin);
      DOM.setStyle(this._content, "margin-bottom", margin);
      this.onContentScroll();
    }
  }

  onContentScroll([e]) {
    var scrollTop = e ? e.target.scrollTop : this._previousScrollTop;
    this._debouncedUpdateHeight();
    this._currentY = math.min(this._toolbarHeight / this.mdShrinkSpeed,
        math.max(0, this._currentY + scrollTop - this._previousScrollTop));

    var toolbarXform =
        '''translate3d(0,${ - this . _currentY * this . mdShrinkSpeed}px,0)''';
    var contentXform =
        '''translate3d(0,${ ( this . _toolbarHeight - this . _currentY ) * this . mdShrinkSpeed}px,0)''';
    DOM.setStyle(this._content, "-webkit-transform", contentXform);
    DOM.setStyle(this._content, "transform", contentXform);
    DOM.setStyle(this.el.nativeElement, "-webkit-transform", toolbarXform);
    DOM.setStyle(this.el.nativeElement, "transform", toolbarXform);
    this._previousScrollTop = scrollTop;

    window.requestAnimationFrame((_){
      var hasWhiteFrame = DOM.hasClass(this.el.nativeElement, "md-whiteframe-z1");

      if (hasWhiteFrame && this._currentY == null) {
        DOM.removeClass(this.el.nativeElement, "md-whiteframe-z1");
      }
      else if (!hasWhiteFrame && _currentY != null) {
        DOM.addClass(this.el.nativeElement, "md-whiteframe-z1");
      }
    });
  }
}
