import 'dart:async';
import 'dart:html';
import 'package:angular2/src/platform/dom/dom_adapter.dart' show DOM;
import 'package:angular2/src/facade/async.dart' show TimerWrapper;

final String TRANSITION_EVENT = whichTransitionEvent();

Future enter(HtmlElement el, String cssClass) {
  Completer completer = new Completer();
  DOM.removeClass(el, cssClass);

  DOM.addClass(el, cssClass + '-add');
  TimerWrapper.setInterval((){
    var duration = getTransitionDuration(el, true);
    var removeListener;
    var callTimeout;
    var done;

    done = (timeout) {
      if (!removeListener) {
        return;
      }

      DOM.removeClass(el, cssClass + '-add-active');
      DOM.removeClass(el, cssClass + '-add');

      if (!timeout) {
        TimerWrapper.clearTimeout(callTimeout);
      }

      removeListener();
      removeListener = null;
      completer.complete();
    };

    callTimeout = TimerWrapper.setTimeout(() => done(true), duration);
    removeListener = DOM.onAndCancel(el, TRANSITION_EVENT, done);
    DOM.addClass(el, cssClass + '-add-active');
    DOM.removeClass(el, cssClass);

  }, 1);

  return completer.future;
}

Future leave(HtmlElement el, String cssClass) {
  Completer completer = new Completer();
  DOM.removeClass(el, cssClass);

  DOM.addClass(el, cssClass + '-remove');
  TimerWrapper.setInterval((){
    var duration = getTransitionDuration(el, true);
    var removeListener;
    var callTimeout;
    var done;

    done = (timeout) {
      if (!removeListener) {
        return;
      }

      DOM.removeClass(el, cssClass + '-remove-active');
      DOM.removeClass(el, cssClass + '-remove');

      if (!timeout) {
        TimerWrapper.clearTimeout(callTimeout);
      }

      removeListener();
      removeListener = null;
      completer.complete();
    };

    callTimeout = TimerWrapper.setTimeout(() => done(true), duration);
    removeListener = DOM.onAndCancel(el, TRANSITION_EVENT, done);
    DOM.addClass(el, cssClass + '-remove-active');
    DOM.removeClass(el, cssClass);

  }, 1);

  return completer.future;
}

/// refactor
handleDuration(String duration) {
  var index = duration.indexOf(new RegExp(r'(ms|s)'));
  var value = double.parse(duration.substring(0, index));
  return duration.indexOf('ms') > -1 ? value : value * 1000;
}

getTransitionDuration(HtmlElement element, [bool includeDelay = false]) {
  CssStyleDeclaration style = DOM.getComputedStyle(element);
  var duration = handleDuration(style.transitionDuration);
  if(includeDelay){
    var delay = handleDuration(style.transitionDelay);
    duration = duration + delay;
  }
  return duration;
}

void setTransitionDuration(HtmlElement element, num delayMs) {
  DOM.setStyle(element, 'transition-duration', '${delayMs}ms');
}

/// todo(): this is incomplete
String whichTransitionEvent() => 'transitionend';
