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
