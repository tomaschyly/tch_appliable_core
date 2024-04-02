## [0.32.2] - 2.4.2024

* Get first day of week for 1-7 range

## [0.32.1] - 29.3.2024

* Translator improvements and tweaks

## [0.32.0] - 20.3.2024

* Replace deprecated use of global window for numbers

## [0.31.0] - 15.3.2024

* Upgrade UUID package

## [0.30.2] - 14.3.2024

* Add missing return type

## [0.30.1] - 13.3.2024

* Improve setStateNotDisposed

## [0.30.0] - 26.2.2024

* Improve compatibility with latest Flutter

## [0.29.1] - 14.2.2024

* Fix concurrent list access issue

## [0.29.0] - 13.2.2024

* Add onGenerateInitialRoute callback to customize initial Route

## [0.28.0] - 23.1.2024

* Dependecies update 

## [0.27.2] - 10.12.2023

* Fix missing export for ResponsiveWidget

## [0.27.1] - 1.12.2023

* SembastApiClient improvements

## [0.27.0] - 30.11.2023

* Newly improved and dedicated SembastApiClient/Provider, it is replacement for using general MainDataProvider

## [0.26.0] - 25.10.2023

* **Warning:** Replaced deprecated use of Theme.of(context).backgroundColor

## [0.25.0] - 29.9.2023

* **Warning:** Code refactor to support better current Flutter
* ResponsiveWidget as alternative to ResponsiveScreenState

## [0.24.4] - 10.9.2023

* Useful date utils as extension for DateTime

## [0.24.3] - 3.9.2023

* Generic Debouncer utility

## [0.24.2] - 23.8.2023

* Additional typedefs

## [0.24.1] - 31.7..2023

* Improve truncateText util

## [0.24.0] - 16.6.2023

* Change routes generation for V1

## [0.23.2] - 16.6.2023

* RouterV1 tweaks

## [0.23.1] - 16.6.2023

* RouterV1 tweaks

## [0.23.0] - 16.6.2023

* **Warning:** Dependecies upgrade, some may have breaking changes

## [0.22.0] - 2.5.2023

* Update Translator to support country code

## [0.21.1] - 27.4.2023

* Change intl to any to avoid issues with Flutter sdk

## [0.21.0] - 15.4.2023

* Change CoreApp initialization

## [0.20.1] - 10.4.2023

* List mapUnique util

## [0.20.0] - 7.4.2023

* **Warning:** AbstractHooksWidget removed firstBuildOnly to avoid breaking code patterns

## [0.19.1] - 13.3.2023

* Set custom backgroundColor for each screen

## [0.19.0] - 20.3.2023

* Upgrade dependencies with some **breaking changes**

## [0.18.3] - 13.3.2023

* Increase SDK versions

## [0.18.2] - 13.3.2023

* Utils for typedefs

## [0.18.1] - 22.2.2023

* AbstractScreenOptions added canPop var for use with AppBar

## [0.18.0] - 14.2.2023

* **Warning:** AbstractScreen safeArea option changed

## [0.17.1] - 28.1.2023

* Tweaks

## [0.17.0] - 28.1.2023

* Listen to AppLifecycleState changes

## [0.16.0] - 20.1.2023

* Improvements to screen state options

## [0.15.1] - 19.1.2023

* Fix wrong addScreenMessage typedef

## [0.15.0] - 18.1.2023

* **Warning:** ScreenMessagner changed to object from string

## [0.14.1] - 7.1.2023

* Form & Widget utils

## [0.14.0] - 5.1.2023

* AbstractScreenState improvements
* ScreenMessenger refactor for better logic/usage

## [0.13.1] - 29.12.2022

* Hotfix

## [0.13.0] - 29.12.2022

* Support for flutter_hooks, AbstractHooksWidget as Stateless widget with hooks
* **Warning:** AbstractScreenStateOptions are now called AbstractScreenOptions

## [0.12.3] - 18.12.2022

* Improvements to screen options

## [0.12.2] - 15.12.2022

* Improvements to Preferences

## [0.12.1] - 14.12.2022

* Improvements to Translator and AppBarOption

## [0.12.0] - 6.12.2022

* Update all able dependencies

## [0.11.2] - 19.6.2022

* Fix wrong DataRequests identification when pagination in use

## [0.11.1] - 17.6.2022

* Fix bad pagination behaviour under certain conditions

## [0.11.0] - 13.6.2022

* **Warning:** pagination is enabled by default
* SQLite and HTTP sources support pagination
* Automatic pagination is integrated with ListDataWidget

## [0.10.3] - 22.5.2022

* Update packages

## [0.10.2] - 4.2.2022

* Updates, make sure working with Flutter 2.10

## [0.10.1] - 3.2.2022

* Fix post Dio requests not sending data

## [0.10.0] - 19.12.2021

* Update dependencies
* Http communication prefers Dio instead of Http client

## [0.9.10] - 15.12.2021

* Update ListDataWidget to include error state and flow

## [0.9.9] - 15.10.2021

* Update packages to latest versions

## [0.9.8] - 4.10.2021

* ListDataWidget expose optional controller

## [0.9.7] - 13.9.2021

* CoreApp add banner for debug

## [0.9.6] - 27.8.2021

* Fix wrong theme use when DarkMode and no DarkTheme

## [0.9.5] - 16.8.2021

* Improve usage of Translator by providing String extensions

## [0.9.4] - 13.8.2021

* HTTPSource have consistent endpoint usage
* HTTP DataTask for POST enable sending as json

## [0.9.3] - 11.8.2021

* BoundaryPageRoute optional action before push

## [0.9.2] - 7.8.2021

* Translator support for dynamic parameters in translations

## [0.9.1] - 7.8.2021

* Use dynamic headers instead of update of MainDataProvider options

## [0.9.0] - 6.8.2021

* CoreApp now updated MainDataProvider options & sources

## [0.8.4] - 22.7.2021

* BoundaryPageRoute improve transition smoothness & add failsafes

## [0.8.3] - 22.7.2021

* BoundaryPageRoute improve transition layout structure

## [0.8.2] - 21.7.2021

* BoundaryPageRoute fix BorderRadius behaviour

## [0.8.1] - 21.7.2021

* BoundaryPageRoute transition support optional BorderRadius

## [0.8.0] - 21.7.2021

* BoundaryPageRoute transition & widget

## [0.7.5] - 19.7.2021

* ListDataWidget support for initial full screen loading

## [0.7.4] - 16.7.2021

* ListDataWidget support pullToRefresh

## [0.7.3] - 9.7.2021

* Fix DarkMode automatic startup

## [0.7.2] - 9.7.2021

* Improve DarkMode automatic startup

## [0.7.1] - 9.7.2021

* Improve DarkMode handling/switching

## [0.7.0] - 4.7.2021

* CoreApp Dark theme detection and support

## [0.6.3] - 18.6.2021

* Utils improvements

## [0.6.2] - 18.6.2021

* ScreenDataState supports also optional Tag/s for isLoading pairing

## [0.6.1] - 13.6.2021

* MDP SQLiteSource and SembastSource deleteWhere DataTask type for multiple records batch deletion

## [0.6.0] - 11.6.2021

* ScreenDataState with isLoading, executeAsyncTask and extensibility

## [0.5.6] - 9.6.2021

* Fix variable typo

## [0.5.5] - 9.6.2021

* Fix missing code 

## [0.5.4] - 9.6.2021

* MDP MockupSource better comform to other sources
* MDP sources now sent optionally SourceException instead of crashing

## [0.5.3] - 8.6.2021

* Mockup data by optional param in Requests & Tasks

## [0.5.2] - 7.6.2021

* Removed CoreAppState invalidateApp as it does not do what it used to

## [0.5.1] - 7.6.2021

* MockUpSource support for query Task

## [0.5.0] - 7.6.2021

* Partially implement MockUpSource, works for DataWidgets 

## [0.4.5] - 31.5.2021

* Invalidate CoreApp when init done

## [0.4.4] - 27.5.2021

* Add Color utils

## [0.4.3] - 23.5.2021

* Builder param for CoreApp

## [0.4.2] - 22.5.2021

* SembastSource options add DB migration parameters
* Update dependencies

## [0.4.1] - 22.5.2021

* CoreApp push after initialization optional arguments

## [0.4.0] - 20.5.2021

* **Warning:** changes to exports from package, may require updated imports and dependencies
* Finished HTTPSource implementation
* SembastSource implementation

## [0.3.0] - 13.5.2021

* **Warning:** changed the way ScreenState options are overriden/initialized
* ScreenState options build preProcessor
* Drawer permanently visible support
* bugfixes

## [0.2.3] - 19.3.2021

* Previous dispose of ValueNotifiers of MainDataSource caused issues, different resolution implemented

## [0.2.2+1] - 18.3.2021

* Add options for floating action button

## [0.2.2] - 18.3.2021

* Add support for floating action button of screens

## [0.2.1] - 17.3.2021

* Change AppBar, BottomBar & Drawer to be more loosely defined

## [0.2.0] - 16.3.2021

* Handle situation with RouterV1 when wrong type cast

## [0.2.0-dev.1] - 7.3.2021

* Sound null-safety achieved

## [0.1.0-dev.15] - 2.3.2021

* SQLiteSource add onUpgrade & onDowngrade to the options

## [0.1.0-dev.14] - 1.3.2021

* HTTPSource do not crash app on no network error

## [0.1.0-dev.13] - 1.3.2021

* Translator get initial language fun

## [0.1.0-dev.12] - 28.2.2021

* DataTask for HTTPSource give option to override used url

## [0.1.0-dev.11] - 18.2.2021

* Dispose of ValueNotifiers used by MainDataSources

## [0.1.0-dev.10] - 13.2.2021

* Update dependencies which were possible to update without conflicts

## [0.1.0-dev.9] - 29.1.2021

* Add useful text utils

## [0.1.0-dev.8] - 27.1.2021

* SQLiteSource allow DataTasks with raw queries

## [0.1.0-dev.7] - 25.1.2021

* ReFetch data for any initialized source from app

## [0.1.0-dev.6] - 24.1.2021

* DataTask processResult allow nullable result

## [0.1.0-dev.5] - 24.1.2021

* SQLiteSource execute DataTask supports one time queries

## [0.1.0-dev.4] - 22.1.2021

* Reorganize code into private/public for better autoImport experience

## [0.1.0-dev.3] - 21.1.2021

* DataRequest processResult allow nullable result

## [0.1.0-dev.2] - 21.1.2021

* More CoreApp initialization options

## [0.1.0-dev.1] - 20.1.2021

* Initial release
* Working CoreApp with Widgets & Screens
* Router
* Translator
* Preferences
* MainDataProvider partially working (SQLite done, HTTPClient partial, others todo)
