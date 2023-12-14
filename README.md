# MY WEATHER
Project for the IOS part of the MobDev course, consists of a weather application in *objective c* made with *Xcode*.

## Key features and application examples

With the **MyWeather** app you can:

- See the weather information for today's current location and the next 3 days <br />

![]( https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/gif%20main%20scene.gif)

- Search for a city and see its weather forecast <br />

![]( https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/gif%20search%20city.gif)

- Save a city to a list of favourites <br />

![]( https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/gif%20add%20favourite.gif)

- Select a city from the list of favourites <br />

![]( https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/gif%20fav%20list.gif)

- View your favourite cities on a map and see the weather for the day via an annotation <br />

![]( https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/gif%20map%20view%20.gif)

## A close look on it

The application is based on the **MVC** model: **M**odel, **V**iew, **C**ontroller.

### Model

>The *model* is responsible for defining the application data. <br />

The *City*,*CityList* and *Forecast* classes are the application model. I decided to use a Forecast class to **asynchronous** manage the capture of weather information via the *open.meteo* API and ensure smooth application use for the user. <br />

The API is used via **JSON serialisation**.

### ViewController

> The *views* display the data contained in the model and 'capture' the user's interaction with the application, the *controllers* are the brain of the application: they provide the link between view and model, manage the user inputs sent by the view and send any updates to the model. <br />

The use of a **UInavigation controller** allows you to quickly and intuitively manage the use of multiple views using the stack structure (LIFO Logic). <br />

<img src=https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/Screenshots/Storyboard.png width="30%" height="30%">

There are 4 view controllers:

- **MyWeatherTableViewController**: It is a *UITableViewController static*, the first controller in the stack, which is responsible for showing the current weather and forecasts of the city's future days (which may have been selected or derived from the current location).<br />

This view implements the *LocationManager* recording to derive the current location of the user and records the controller to listen to notifications sent by the *Forecast* class once the request for weather information via API has been completed to update the view. <br />

When starting the view (method '*viewDidLoaded*') the controller retrieves via file the list of favourite cities (3 arrays that handle names, latitude and longitude), to be sent via follows to the controllers (if files do not exist they are created).<br />

The buttons on the *navigation bar* allow you to start the segues for the respective view controllers. <br />
 
 <img src=https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/Screenshots/mainVC.png width="20%" height="20%">
 
 - **SearchCityViewController**, is called via modal segues by the MyweatherTableViewController. It is a *UIView* that allows the search of the city on a **operation queue** that creates a *MKLocalSearchRequest* that takes care of executing a *NaturalLanguageQuery* with the city entered in the appropriate searchbar.<br />

The results are displayed on a dynamic *UITableView* with a section and number of rows equal to the number of search results. There is a listener that captures the click on a TableView cell that allows you to send a notification to the MyWeatherTableViewController that allocates a request to the Forecast to show the weather. <br />

Once the operation is complete, the SearchCityViewController in turn receives a notification to pop itself from the NavigationController stack. <br />

**N.B**: This notification exchange operation could be replaced by implementing a delegate (by defining a protocol) of the viewcontroller that signalled the selection of a city.
 
 <img src=https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/Screenshots/FavCitiesVC.png width="20%" height="20%">
 
 - **FavouritesCitiesTableViewController**: It is the View Controller that shows the user the list of favourite cities, it is a dynamic *TableView* with a section and number of rows equal to the number of cities in the arrays sent by MyWeatherTableViewController during the following.<br />

When a user selects a table view cell, the same procedure explained above is applied to notify MyWeatherTableViewController to initialise the Forecast object and make the transition to show the view.

<br />

 <img src=https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/Screenshots/SearchVC.png width="20%" height="20%">
 
 - **FavouritesMapViewController**: Used to show the map to the user with annotations placed in cities saved in favourites. This is a *UIViewController* with a *MapView* inside. <br />

To create annotations, the ViewController receives the arrays of favourite cities saved in files and draws an annotation for each pair of coordinates of the favourite city. <br />

There is a Listener on the touch of an annotation that proceeds with the generation of a current day weather request in the selected city and shows it to the user. <br />

<img src=https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/Screenshots/mapVC.png width="20%" height="20%">
