import 'package:example/ui/screens/HomeScreen.dart';
import 'package:example/ui/screens/mdpSQLite/MDPSQLiteScreen.dart';
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
        ) {
    optionsBuildPreProcessor = optionsBuildPreProcess;
  }

  /// AppScreenStateOptions initialization for state with Drawer
  AppScreenStateOptions.drawer({
    required String screenName,
    required String title,
  }) : super.basic(
          screenName: screenName,
          title: title,
        ) {
    optionsBuildPreProcessor = optionsBuildPreProcess;

    drawerOptions = <DrawerOption>[
      DrawerOption(
        onSelect: (BuildContext context) {
          pushNamedNewStack(context, HomeScreen.ROUTE, arguments: <String, String>{'router-fade-animation': '1'});
        },
        isSelected: (BuildContext context) {
          final RoutingArguments? arguments = RoutingArguments.of(context);

          return arguments?.route == HomeScreen.ROUTE;
        },
        title: Text(
          tt('home.screen.title'),
        ),
      ),
      DrawerOption(
        onSelect: (BuildContext context) {
          pushNamedNewStack(context, MDPSQLiteScreen.ROUTE, arguments: <String, String>{'router-fade-animation': '1'});
        },
        isSelected: (BuildContext context) {
          final RoutingArguments? arguments = RoutingArguments.of(context);

          return arguments?.route == MDPSQLiteScreen.ROUTE;
        },
        title: Text(
          tt('mdpsqlite.screen.title'),
        ),
      ),
    ];
  }

  /// Callback used to preProcess options at the start of each build
  /// May be used to change options based on some conditions
  void optionsBuildPreProcess(BuildContext context) {
    final AbstractAppDataStateSnapshot snapshot = AppDataState.of(context)!;

    final permanentlyVisibleDrawerScreens = [
      ResponsiveScreen.ExtraLargeDesktop,
      ResponsiveScreen.LargeDesktop,
      ResponsiveScreen.SmallDesktop,
    ];
    print('TCH_d ${snapshot.responsiveScreen} ${permanentlyVisibleDrawerScreens.contains(snapshot.responsiveScreen)}'); //TODO remove
    drawerIsPermanentlyVisible = permanentlyVisibleDrawerScreens.contains(snapshot.responsiveScreen);
  }
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
      leading: options.drawerOptions?.isNotEmpty == true && !options.drawerIsPermanentlyVisible
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
      actions: options.appBarOptions
          ?.map((AppBarOption option) => Builder(
                builder: (BuildContext context) {
                  final theIcon = option.icon;
                  final theComplexIcon = option.complexIcon;

                  return IconButtonWidget(
                    icon: (theComplexIcon != null ? theComplexIcon : theIcon) ?? Container(),
                    onPressed: () {
                      option.onTap(context);
                    },
                    iconWidth: option.complexIcon != null ? 48 : 24,
                    iconHeight: option.complexIcon != null ? 48 : 24,
                  );
                },
              ))
          .toList(),
    );
  }

  /// Create default BottomNavigationBar
  @protected
  BottomNavigationBar? createBottomBar(BuildContext context) => null;

  /// Create default Drawer
  @protected
  Widget? createDrawer(BuildContext context) {
    final theDrawerOptions = options.drawerOptions;

    if (theDrawerOptions != null && theDrawerOptions.isNotEmpty) {
      final theme = Theme.of(context);

      final drawerList = Container(
        width: options.drawerIsPermanentlyVisible ? 304 : null,
        color: theme.primaryColorDark,
        child: ListView(padding: EdgeInsets.zero, children: [
          Container(height: MediaQuery.of(context).padding.top),
          ...theDrawerOptions
              .map(
                (DrawerOption option) => Material(
                  color: option.isSelected(context) ? theme.primaryColor : theme.primaryColorDark,
                  child: InkWell(
                    child: Container(
                      height: 48,
                      padding: option.icon != null ? const EdgeInsets.only(right: 16) : const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (option.icon != null)
                            Container(
                              width: 48,
                              height: 48,
                              child: Center(
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  child: option.icon,
                                ),
                              ),
                            ),
                          option.title,
                        ],
                      ),
                    ),
                    onTap: !option.isSelected(context)
                        ? () {
                            if (!options.drawerIsPermanentlyVisible) {
                              Navigator.pop(context);
                            }

                            option.onSelect(context);
                          }
                        : null,
                  ),
                ),
              )
              .toList(),
        ]),
      );

      if (options.drawerIsPermanentlyVisible) {
        return drawerList;
      } else {
        return Drawer(
          child: drawerList,
        );
      }
    }
  }
}
