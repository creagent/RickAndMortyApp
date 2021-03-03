Rick and Morty IOS app
=====================

MVC IOS app for getting Rick and Morty characters' main info from [Rick and Morty API](https://rickandmortyapi.com/documentation) 

_Made by_ ***Anton Alekseyev*** _(hoping to become ios junior developer)_

## Project structure:
### Model
* **Client.swift**
  * `Client` struct provides common access to structs representing API sections (`Character`, `Episode` and `Location`)
* **JSONHandler.swift**
  * `JSONHandler` struct handles JSON coding/decoding
* **NetworkManager.swift**
  * `NetworkManager` struct for managing network requests 
  * `Info` struct represents API response info section
  * `NetworkManagerError` struct for categorizing network errors
  * `URLSession extension` adds _dataTask_ method that allows to get network request result in _Result<(URLResponse, Data), Error>_ format
* **FileSystemManager.swift**
  * `FileSystemManager` struct for managing JSON read/write file operations
* **Character.swift**
  * `Character` struct contains methods to request character information from API and loading/saving it from/to file
  * `CharacterInfoModel` struct represents all characters list response
  * `CharacterData struct` for decoding character's JSON representation
  * `CharacterModel` struct for character's data appropriate form interpretation
  * `CharacterListModel` struct for storing character list in file
  * `CharacterOriginModel` struct for decoding character's origin JSON info
  * `CharacterLocationModel` struct for decoding character's location JSON info
* **Location.swift**
  * `Location` struct contains methods to request location information 
  * `LocationModel` struct for decoding character location's JSON representation
  * `LocationInfoModel` struct for representing location list response
* **Episode.swift**
  * `Episode` struct contains methods to request episode information
  * `EpisodeModel` struct for decoding JSON representation of character's first appearance episode
  * `EpisodeInfoModel` struct for representing episode list response


### Views
* **Main.storyboard** contains two scenes: _character list screen_ and _single character detail info_ 

### Controllers
* **ListTableViewController.swift** - main character list table view controller, contains character and episode collections, search, 
    refresh and detail screen segue logic
* **ListTableViewCell.swift** represents single character's cell in table view
* **DetailViewController.swift** contains logic of character's detail info representation

## Functionality:
* Main screen represents a list of Rick and Morty characters with some basic info (name, status, 
  last known location and name of the episode where the character appered for the first time). 
* By tapping on character's cell one can jump to the second (detail info) screen which contains single character's basic info + character's image. 
* By pressing "back" button one can go back to the main screen.
* Characters' info can be refreshed by "pull to refresh gesture".
* App backups characters' info (JSON data is stored in file). If device is offline it loads info from stored file (if exists). 
* App contains searchbar for searching characters by name. 
* App's interface adapts to different screen sizes and device orientation (scrolling is enabled when UI elements dimensions are too big).

## Screenshots:
<img src="https://sun9-27.userapi.com/impf/hB6J63OpbGVVMnr4NB2R0rauPSXHKjgFBQYU8Q/DpRN_dvfat0.jpg?size=607x1080&quality=96&sign=c64531a2edcfdc021a262ba864d8f672&type=album" 
alt="alt text" width="304" height="540">    <img src="https://sun9-47.userapi.com/impf/Mn60RDxYKQ5hVDHk1fBJZPP2f1OPCp8FKZGkig/72Wf4-DKlws.jpg?size=607x1080&quality=96&sign=b166b357c1109a140e23adc1b79c4172&type=album" 
alt="alt text" width="304" height="540">

<img src="https://sun9-71.userapi.com/impf/fu7897Sww7q_EyoXKHG07YG5ffuFujWiB0ynrQ/Xx3hNO2ImC4.jpg?size=607x1080&quality=96&sign=e22fc9151ce01ac77e8431d3a307195b&type=album" alt="alt text" width="304" height="540">  <img src="https://sun9-11.userapi.com/impf/DilWTYzZvHIe_hzTz3GBr-WP6XAnD6Vx73kYDg/MhLKNOVnMMU.jpg?size=607x1080&quality=96&sign=97724853f9bafa702e1149036125e03f&type=album" 
alt="alt text" width="304" height="540">
