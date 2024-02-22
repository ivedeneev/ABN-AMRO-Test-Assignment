# Igor Vedeneev test assignment for ABN AMRO

<img src="preview/abn.png" width="293.4"/> <img src="preview/manual.gif" width="140"/> <img src="preview/map.gif" width="140"/>

## Contents
- App which allows to open Wikipedia's app places tab via deeplink with coordinates
- [Modified Wikipedia app](https://github.com/ivedeneev/wikipedia-ios)
- [Changes to Wikipedia app](https://github.com/ivedeneev/wikipedia-ios/pull/1/files)

## How to use it
- Build & run Wikipedia app from the [source code](https://github.com/ivedeneev/wikipedia-ios)
- Run ABNLocation picker app (this repo)
- Enter location manually and open it or select location from the list(or map)

## Features

### List of locations 
- Displays list of predefined locations and user-entered location
- Adds location manually and open Wikipedia app with this location

### Map
- Displays current user location on first appear* (see limitations)
- Display predefined and user entered locations on the map
- Selects and opens Wikipedia app with selected location
- Map remembers its camera position and selected location when we are switching back to it from the list view
- If selected stored location: user get redirected immidiately to Wikipedia app
- If selected random location: user needs to press "Open Wikipedia button on top (see screenshots above)"

### Common
- Detect if Wikipedia app is installed or not
- Validate manually entered coordnates
- Supports english localization
- Dark mode support
- Dynamic type support
- Voice over support (partial)

## Known issues and limitations
- Current user location is hardcoded to Amsterdam (see `MockLocationManager`)
- Locations input history is not persisted between app launches (only within current launch)
- Minor visual glitch when switching between list and map when Wikipedia app is not installed
- Visual glitch when selecting exsiting location on the map (SwiftUI `Map` bug, https://developer.apple.com/forums/thread/739782, https://stackoverflow.com/questions/74675989/how-to-have-ontap-gestures-on-map-and-mapannotation-both-without-the-two-interf)

## Implementation details
- MVVM architecture is being used
- ViewModel accepts actions and modifies its state. No external modifications are allowed.
- For real app i would add swiftlint and code generation tools for licalized strings and resources (swiwtgen or r.swift)
- For real app i would implement proper design system with all fonts and colors
