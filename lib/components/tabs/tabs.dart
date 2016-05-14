import "package:angular2/core.dart";
import "package:angular2/common.dart" show NgFor;
// TODO: behaviors to test

//  - Tabs will become paginated if there isn't enough room for them

//  - You can swipe left and right on a mobile device to change tabs

//  - You can bind the selected tab via the selected attribute on the md-tabs element

//  - If you set the selected tab binding to -1, it will leave no tab selected

//  - If you remove a tab, it will try to select a new one

//  - There's an ink bar that follows the selected tab, you can turn it off if you want

//  - If you set the disabled attribute on a tab, it becomes unselectable

//  - If you set md-theme=\"green\" on the md-tabs element, you'll get green tabs
@Directive(selector: "[md-tab]")
class MdTab {
  ViewContainerRef viewContainer;
  TemplateRef templateRef;
  @Input()
  String label;
  @Input()
  bool disabled = false;
  bool _active = false;
  MdTab(this.viewContainer, this.templateRef) {}
  @Input()
  set active(bool active) {
    if (active == this._active) {
      return;
    }
    this._active = active;
    if (active) {
      this.viewContainer.createEmbeddedView(this.templateRef);
    } else {
      this.viewContainer.remove(0);
    }
  }

  bool get active {
    return this._active;
  }
}

@Component(
    selector: "md-tabs",
    templateUrl: "tabs.html",
    directives: const [NgFor],
    encapsulation: ViewEncapsulation.None)
class MdTabs {

  QueryList<MdTab> panes;

  @Input()
  bool mdNoScroll = false;

  MdTabs(@ContentChildren(MdTab) this.panes) {
    panes.changes.listen((_) {
      panes.toList().asMap().forEach((index , MdTab tab){
        tab.active = index == this._selected;
      });
    });
  }

  num _selected = 0;

  num get selected {
    return this._selected;
  }

  @Input('selected')
  set selected(num index) {
    var panes = this.panes.toList();
    var pane = null;
    if (index >= 0 && index < panes.length) {
      pane = panes[index];
    }
    selectedTab = pane;
    _selected = index;
  }

  MdTab get selectedTab {
    var result = null;
    panes.toList().forEach((MdTab tab) {
      if (tab.active) {
        result = tab;
      }
    });
    return result;
  }

  set selectedTab(MdTab value) {
    panes.toList().asMap().forEach((index, MdTab tab) {
      tab.active = tab == value;
      if (tab.active) {
        _selected = index;
      }
    });
  }

  onTabClick(MdTab pane, [event]) {
    selectedTab = pane;
  }
}
