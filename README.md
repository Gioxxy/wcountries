# wcountries
wcountries lists all countries of the world and lets the user to view their details.
Also allows users to filter the various countries by continent and/or language.

The app is written using Swift 5.3, iOS 14.4 as development target and MVVM + Coordinators patterns.
UI is created without the use of Storyboard and Xib.

wcountries uses the [restcountries.eu](http://restcountries.eu) API for countries data and [flagcdn.com](https://flagcdn.com) API for flag images.
## Screenshots
<p>
<img src="./screenshots/screen1.png?raw=true" width="200">
<img src="./screenshots/screen2.png?raw=true" width="200">
</p>
<p>
<img src="./screenshots/screen3.png?raw=true" width="200">
<img src="./screenshots/screen4.png?raw=true" width="200">
</p>
<p>
<img src="./screenshots/screen5.png?raw=true" width="200">
<img src="./screenshots/screen6.png?raw=true" width="200">
<img src="./screenshots/screen7.png?raw=true" width="200">
</p>

## APP Mockup
In the project root you can find the Adobe XD [mockup](./wcountries.xd) project, created before developing the app to have a guideline.
## APP Flow
wcountries starts by showing all countries. When the user taps on a country the app shows its details (name, alpha3Code, continent, currency symbol, call number, native name, capital, population, latitude and longitude, area, language, timezone and neighboring countries) and if he taps on a neighboring country the detail of it will be opened.
User can also filter countries by continent and/or language.
## Caching
API requests and images are cached using [URLCache](https://developer.apple.com/documentation/foundation/urlcache), so the app works even offline with cached data.
## External libraries
No external library were used, this because I decided to take it as a challenge to improve my skills and better explore some aspects such as caching requests and images.
## Unit Tests
I wrote some tests for ViewModels.
