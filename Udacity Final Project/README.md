#  NHL Player Tracker
## Udacity iOS Nanodegree Final Project

****
## Table of Contents
- [NHL Player Tracker](#nhl-player-tracker)
* [Usage](#usage)
  + [Favourite Players Screen](#favourite-players-screen)
  + [Tab Controller](#tab-controller)
    - [Team List Screen](#team-list-screen)
    - [Team Map Screen](#team-map-screen)
  + [Team Roster Screen](#team-roster-screen)
  + [Player Detail Screen](#player-detail-screen)
  + [Favourite Players Screen](#favourite-players-screen-1)
* [Features Implemented](#features-implemented)
* [Methodolgy](#methodolgy)
* [Acknowledgements](#acknowledgements)
***

## Usage
### Favourite Players Screen
When the app is first launched, you will see the **Favourites** screen. The screen presents a table view with a list of the users favourite players. If the user has not yet added any players to their favourites list, which would be the case the first time the app is launched, the table view is hidden. Instead the user will see a label directing the user to the *add button* in the top right corner.

Click the *add button* in the top right corner to proceed.

### Tab Controller
After clicking the *add button* on the previous screen, the app segues to a tab controller with two tabs.

#### Team List Screen
The first tab presents a list of all 31 NHL teams in a table view. The background colour of each cell is set to the respective team's primary colour.

- Clicking on a cell will perform a segue to the **Roster** screen.
- Clicking on the *Favourites* button in the top right will dismiss the view. The user will go back to the root **Favourites** screen.
- Clicking on the right tab button in the bottom tab bar will present the user with the **Team Map** screen.

#### Team Map Screen
The second tab in the tab controller displays a map of North America. Each of the 31 NHL teams are represented on the map with a custom pin. The respective team's logos are used for the corresponding team. The logos are pinned to the coordinates of the team's home arena.

- Clicking on a pin will perform a segue to the **Roster** screen. 
- Clicking on the *Favourites* button in the top right will dismiss the view. The user will go back to the root **Favourites** screen.
- Clicking on the left tab button in the bottom tab bar will present the user with the **Team List** screen.

Select a team from either the **Team List** screen or the **Team Map** screen to segue to the **Roster** screen.

### Team Roster Screen
The title of the **Roster** screen is set to the team's nickname. The background colour of table's cells is set to the selected team's primary colour.

The table displays a list of the team's current players. The cells are sorted in order of jersey numbers. In the title of the cell you'll see the player's jersey number followed by the player's name. In the subtitle of the cell you'll see the player's position and their shooting hand (for skaters) or catching glove (for goalies).

- Clicking on a cell brings up the respective player's detail page.
- Clicking on the *Favourites* button in the top right will dismiss the view. The user will go back to the root **Favourites** screen.

Select a player by clicking on a cell to go the the **Player Detail** screen.

### Player Detail Screen
The **Player Detail** screen shows personal information about the selected player, along with their up to date season statistics. The title of the screen is set to the player's name.

In the *Current Season Statistics* section, you will see the player's current statistics. The statistics displayed depend on whether a goalie or skater has been selected. If a player has not yet played a game this season, then you will just see dashes, "-", in the statistics section.

Below the statistics you will see a button. If the selected player is not currently in the user's favourites list, the button's title will be *Add To Favourites List*. If the player is in the user's favourites list, then the button's title will be set to *Remove From Favourites List*.

Click the *Add To Favourites List* button to add your selected player to your favourites list.

From here you can click the back button in the top left to go back and select another player. Or you can click the *Favourites* button in the top right to go back to the root **Favourites** screen.

### Favourite Players Screen
This is the same screen you started at. But you should now see the players you added to your favourites list displayed in the table view. The image of each cell is set to the logo of the team the player plays for. Clicking on a cell will bring up the player's detail screen. This is the same **Player Detail** screen you've seen previously. But when you navigate to the **Player Detail** screen directly from the **Favourites** screen, the *Favourites* button in the top right is hidden. You can navigate back to the **Favourites** screen using the back button. 

## Features Implemented
- Navigation controllers
- Tab controller
- Table Views
- Map View
- Restful API calls to the NHL's API
- Core Data to store team and player information.
- Custom Protocol to make it easy to pass information to views in the tab controller.
- UserDefaults to store information like the ids of the user's favourite players, and when the team information was last downloaded.

## Methodolgy
The app relies on the NHL's public API to pull down information about each of the NHL's teams and players. Some information for each of the teams that is not available from the API is hardcoded in the TeamAttributes struct.

The first time the user navigates to the **Team List**, an API call is made to download information for all of the teams in the NHL. Since this data almost never changes, it is only downloaded once and is stored in Core Data in the **Team** entity. This way the app will not rely on costly networking calls every time they want to get the list of teams.

When a team is selected, and the user is presented with the **Roster** screen, the code will check if the team's roster has already been downloaded. If it has been downloaded, it checks how long it's been since the roster was downloaded. If the roster has not been downloaded within the past 24 hours, an API call is made to grab the roster information for the team. Subsequent API calls are made for each player on the roster to get detailed information for each player. Since this data rarely changes, it is only downloaded once per day. This keeps the app responsive by storing the data in Core Data.

When a player is selected, an API call is made to get their latest statistics. This data is not stored in Core Data since it changes frequently. An API call is made every time the user opens the **Player Detail** page.

## Acknowledgements
The team logos and NHL logo are the property of the NHL and the respective teams. They are used in this assignment purely for personal and educational purposes.

I found the following resources helpful:
- https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
- https://stackoverflow.com/questions/24658641/ios-delete-all-core-data-swift/38449688

