import "package:angular2/core.dart"
    show Directive, ElementRef, AfterViewInit, Component;
import "package:angular2/src/platform/dom/dom_adapter.dart" show DOM;

@Directive(selector: "md-list", host: const {"role": "list"})
class MdList {}

@Component(
    selector: "md-list-item",
    host: const {"role": "listitem"},
    properties: const ["wrap"], // todo() remove this ?
    template: '''
    <div class="md-no-style md-list-item-inner">
      <ng-content></ng-content>
    </div>''')
class MdListItem implements AfterViewInit {
  ElementRef _element;

  MdListItem(this._element);

  ngAfterViewInit() {
    setupToggleAria();
  }

  setupToggleAria() {
    var toggleTypes = ["md-switch", "md-checkbox"];
    var toggle;
    var el = this._element.nativeElement;
    for (var i = 0, toggleType; toggleType = toggleTypes[i]; ++i) {
      if (toggle = DOM.querySelector(el, toggleType)) {
        if (!toggle.hasAttribute("aria-label")) {
          var p = DOM.querySelector(el, "p");
          if (!p) return;
          toggle.setAttribute("aria-label", "Toggle " + p.textContent);
        }
      }
    }
  }
}
