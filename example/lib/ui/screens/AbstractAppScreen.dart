import 'package:example/ui/widgets/IconButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class AppScreenStateOptions extends AbstractScreenStateOptions {
  /// AppScreenStateOptions initialization for default app state
  AppScreenStateOptions.basic({
    required String screenName,
    required String title,
  }) : super.basic(
          screenName: screenName,
          title: title,
        );
}

abstract class AbstractAppScreen extends AbstractResposiveScreen {}

abstract class AbstractAppScreenState<T extends AbstractAppScreen> extends AbstractResposiveScreenState<T> {
  /// Create default AppBar
  @override
  AppBar? createAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        options.title,
      ),
      centerTitle: false,
      leading: options.drawerOptions?.isNotEmpty == true
          ? Builder(
              builder: (BuildContext context) {
                return IconButtonWidget(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            )
          : (Navigator.of(context).canPop() == true
              ? Builder(
                  builder: (BuildContext context) {
                    return IconButtonWidget(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                )
              : null),
    );
  }

  /// Create default BottomNavigationBar
  @protected
  BottomNavigationBar? createBottomBar(BuildContext context) => null;

  /// Create default Drawer
  @protected
  Drawer? createDrawer(BuildContext context) => null;
}
