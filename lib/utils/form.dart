import 'package:tch_appliable_core/tch_appliable_core.dart';

/// Shorhand to clear any current focus
void clearFocus(BuildContext context) => FocusScope.of(context).unfocus();

/// Shorthand to properly focus input, should work in all situations
void requestFocus(BuildContext context, FocusNode focus) => FocusScope.of(context).requestFocus(focus);
