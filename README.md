# OnTheMap

## App Overview
App OnTheMap allows user to annotate their location with a link to the resource they are studying.
They can also see other students on the map and can see the resource link they have shared.
Further the app allow user to modify the list of Students which server returns based on the different sort parameters. 
The preference page allow user to control the number of results return by Server.

## Components

1. A Networking Layer which separate UI from Networking Code
2. View Controllers to manage all User interaction.
  1. ADPMapViewController: Manage user interaction on Map View.
  2. ADPStudentTableViewController: Interact with Networking Layer to fetch student data from server
  3. ADPSortViewController: Modal View Controller where user can manage his preferences for making query to Server.
3. Login using FB

## How to use the code

To checkout and use this repository follow steps as listed below:
```
$ git clone https://github.com/pritamhinger/OnTheMap.git
$ cd OnTheMap
```

Double click **OnTheMap.xcodeproj** or open the project in Xcode

## License

`OnTheMap` is released under an [MIT License] (https://opensource.org/licenses/MIT). See `License` for details
