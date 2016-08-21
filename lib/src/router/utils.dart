import "package:angular2/core.dart" show ComponentFactory;
import "package:angular2/src/core/reflection/reflection.dart" show reflector;
import "package:angular2/src/facade/lang.dart" show isPresent, isBlank;

import "lifecycle/lifecycle_annotations_impl.dart" show CanActivate;

class TouchMap {
  Map<String, String> map = {};
  Map<String, bool> keys = {};
  TouchMap(Map<String, dynamic> map) {
    if (map != null) {
      map.forEach((key, value) {
        this.map[key] = isPresent(value) ? value.toString() : null;
        this.keys[key] = true;
      });
    }
  }
  String get(String key) {
    keys.remove(key);
    return this.map[key];
  }

  Map<String, dynamic> getUnused() {
    Map<String, dynamic> unused = {};
    keys.keys.forEach((key) => unused[key] = map[key]);
    return unused;
  }
}

String normalizeString(dynamic obj) {
  if (isBlank(obj)) {
    return null;
  } else {
    return obj.toString();
  }
}

List<dynamic> getComponentAnnotations(
    dynamic /* Type | ComponentFactory */ comp) {
  if (comp is ComponentFactory) {
    return comp.metadata;
  } else {
    return reflector.annotations(comp);
  }
}

Type getComponentType(dynamic /* Type | ComponentFactory */ comp) {
  return comp is ComponentFactory ? comp.componentType : comp;
}

Function getCanActivateHook(component) {
  var annotations = getComponentAnnotations(component);
  for (var i = 0; i < annotations.length; i += 1) {
    var annotation = annotations[i];
    if (annotation is CanActivate) {
      return annotation.fn;
    }
  }
  return null;
}
