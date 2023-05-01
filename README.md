# Fuze CSTV App

Features:
* LaunchScreen
* MatchesList with pull to refresh and pagination
* MatchDetail

## App developed in SwiftUI using TCA (The Composable Architecture) for UI.

* To run the project open CSTV.xcworkspace where will have CSTV target and Modules Package with modularized dependencies.

The app has 4 distinc modules:
* Networking to deal with requests.
* CSTVMatchesService, the interface module to call networking
* CSTVMatchesServiceLIve, concrete implementation of CSTVMatchesService
* MatchesListFeature, feature that has 2 views, matches list and match detail 

The app has unit tests for the logic controllers (reducers) MatchesList and MatchDetail
And also has snapshot tests for all ui cases in both views.
