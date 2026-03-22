import 'package:example/ui/screens/HomeScreen.dart';
import 'package:example/ui/screens/mdpHttp/MDPHttpScreen.dart';
import 'package:example/ui/screens/mdpMockup/MDPMockupScreen.dart';
import 'package:example/ui/screens/mdpSQLite/MDPSQLiteScreen.dart';
import 'package:example/ui/screens/mdpSembast/MDPSembastScreen.dart';
import 'package:example/ui/widgets/IconButtonWidget.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class AppScreenStateOptions extends AbstractScreenOptions {
  /// AppScreenStateOptions initialization for default app state
  AppScreenStateOptions.basic({
    required super.screenName,
    required super.title,
  }) : super.basic() {
    optionsBuildPreProcessor = optionsBuildPreProcess;
  }

  /// AppScreenStateOptions initialization for state with Drawer
  AppScreenStateOptions.drawer({
    required super.screenName,
    required super.title,
  }) : super.basic() {
    optionsBuildPreProcessor = optionsBuildPreProcess;

    drawerOptions = <DrawerOption>[
      DrawerOption(
        onSelect: (BuildContext context) {
          goNamedV2(context, HomeScreen.ROUTE);
        },
        isSelected: (BuildContext context) {
          return context.routingArgumentsV2?.route == HomeScreen.ROUTE;
        },
        title: Text(
          tt('home.screen.title'),
        ),
      ),
      DrawerOption(
        onSelect: (BuildContext context) {
          goNamedV2(context, MDPSQLiteScreen.ROUTE);
        },
        isSelected: (BuildContext context) {
          return context.routingArgumentsV2?.route == MDPSQLiteScreen.ROUTE;
        },
        title: Text(
          tt('mdpsqlite.screen.title'),
        ),
      ),
      DrawerOption(
        onSelect: (BuildContext context) {
          goNamedV2(context, MDPHttpScreen.ROUTE);
        },
        isSelected: (BuildContext context) {
          return context.routingArgumentsV2?.route == MDPHttpScreen.ROUTE;
        },
        title: Text(
          tt('mdphttp.screen.title'),
        ),
      ),
      DrawerOption(
        onSelect: (BuildContext context) {
          goNamedV2(context, MDPSembastScreen.ROUTE);
        },
        isSelected: (BuildContext context) {
          return context.routingArgumentsV2?.route == MDPSembastScreen.ROUTE;
        },
        title: Text(
          tt('mdpsembast.screen.title'),
        ),
      ),
      DrawerOption(
        onSelect: (BuildContext context) {
          goNamedV2(context, MDPMockupScreen.ROUTE);
        },
        isSelected: (BuildContext context) {
          return context.routingArgumentsV2?.route == MDPMockupScreen.ROUTE;
        },
        title: Text(
          tt('mdpmockup.screen.title'),
        ),
      ),
    ];
  }

  /// Callback used to preProcess options at the start of each build
  /// May be used to change options based on some conditions
  void optionsBuildPreProcess(BuildContext context) {
    final AbstractAppDataStateSnapshot snapshot = AppDataState.of(context)!;

    final permanentlyVisibleDrawerScreens = [
      ResponsiveScreen.extraLargeDesktop,
      ResponsiveScreen.largeDesktop,
      ResponsiveScreen.smallDesktop,
    ];

    drawerIsPermanentlyVisible = permanentlyVisibleDrawerScreens.contains(snapshot.responsiveScreen);
  }
}

abstract class AbstractAppScreen extends AbstractResponsiveScreen {
  AbstractAppScreen({super.key});
}

abstract class AbstractAppScreenState<T extends AbstractAppScreen> extends AbstractResponsiveScreenState<T> {
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
                    icon: (theComplexIcon ?? theIcon) ?? const SizedBox.shrink(),
                    onPressed: () {
                      option.onTap!(context);
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
  @override
  @protected
  BottomNavigationBar? createBottomBar(BuildContext context) => null;

  /// Create default Drawer
  @override
  @protected
  Widget? createDrawer(BuildContext context) {
    final theDrawerOptions = options.drawerOptions;

    if (theDrawerOptions != null && theDrawerOptions.isNotEmpty) {
      final theme = Theme.of(context);

      final drawerList = SizedBox(
        width: options.drawerIsPermanentlyVisible ? 304 : null,
        child: ColoredBox(
          color: theme.primaryColorDark,
          child: ListView(padding: EdgeInsets.zero, children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
          ...theDrawerOptions
              .map(
                (DrawerOption option) => Material(
                  color: option.isSelected(context) ? theme.primaryColor : theme.primaryColorDark,
                  child: InkWell(
                    onTap: !option.isSelected(context)
                        ? () {
                            if (!options.drawerIsPermanentlyVisible) {
                              Navigator.pop(context);
                            }

                            option.onSelect(context);
                          }
                        : null,
                    child: SizedBox(
                      height: 48,
                      child: Padding(
                        padding: option.icon != null ? const EdgeInsets.only(right: 16) : const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (option.icon != null)
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: option.icon,
                                  ),
                                ),
                              ),
                            option.title!,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ]),
        ),
      );

      if (options.drawerIsPermanentlyVisible) {
        return drawerList;
      } else {
        return Drawer(
          child: drawerList,
        );
      }
    }

    return null;
  }
}
