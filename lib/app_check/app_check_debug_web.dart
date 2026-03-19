import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('self')
external JSObject get _self;

void setAppCheckDebugToken(String token) {
  _self.setProperty('FIREBASE_APPCHECK_DEBUG_TOKEN'.toJS, token.toJS);
}
