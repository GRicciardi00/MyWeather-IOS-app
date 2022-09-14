//
//  MyWeatherTableViewController.m
//  Weather
//
//  Created by Giuseppe Ricciardi on 17/08/22.
//

#define BACKGROUND_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define KEY_UPDATED_FORECAST                @"UpdatedForecast"
#define KEY_DISPLAY_WAITING                 @"DisplayWaitingScreen"

#import <CoreLocation/CoreLocation.h>
#import "MyWeatherTableViewController.h"
#import "ExampleCityDataSource.h"
#import "CityList.h"

@interface MyWeatherTableViewController()

@property (strong, nonatomic) NSMutableArray<CLLocation *> *locations;
@property (strong, nonatomic) CLLocationManager *locationManager;

//today UI
@property (weak, nonatomic) IBOutlet UITableViewCell *weather_iconCell;
@property (weak, nonatomic) IBOutlet UIImageView *weatherInfo;
@property (weak, nonatomic) IBOutlet UILabel *weatherinfoLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *City_nameCell;
@property (weak, nonatomic) IBOutlet UILabel *city_nameLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *current_TempCell;
@property (weak, nonatomic) IBOutlet UILabel *current_TempLabel;

//next days UI
@property (weak, nonatomic) IBOutlet UIView *nextDaysView;

//tomorrow
@property (weak, nonatomic) IBOutlet UILabel *next_dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tomorrowInfo;
@property (weak, nonatomic) IBOutlet UILabel *next_dayTempLabel;

//day after tomorrow
@property (weak, nonatomic) IBOutlet UILabel *second_dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *second_dayInfo;
@property (weak, nonatomic) IBOutlet UILabel *second_dayTempLabel;

//third day.
@property (weak, nonatomic) IBOutlet UILabel *third_dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *third_dayInfo;
@property (weak, nonatomic) IBOutlet UILabel *third_dayTempLabel;


//loading animation
@property (strong, nonatomic) UIImageView *imgConnection;
@property (strong, nonatomic) UIView *viewWaitingScreen;

//favourites cities
@property (weak,nonatomic) IBOutlet UIButton *favourite_button;

@property (strong, nonatomic) ExampleCityDataSource *dataSource;
@property (strong, nonatomic) CityList *citylist;

//implementing fav cities file writing
@property (strong, nonatomic) NSArray *paths;
@property (strong, nonatomic) NSString *documentsDirectory;
@property (strong,nonatomic) NSString *favlistname_file;
@property (strong,nonatomic) NSString *favlistlon_file;
@property (strong,nonatomic) NSString *favlistlat_file;
@property (strong,nonatomic) NSMutableArray *favlist_array;
@property (strong,nonatomic) NSMutableArray *favlon_array;
@property (strong,nonatomic) NSMutableArray *favlat_array;
@end

@implementation MyWeatherTableViewController
#pragma mark - Tableview cycle life-
- (void)viewWillAppear:(BOOL)animated
{
    [self registerForCitySelected];
    //startForecast and register to the notification center
    if (self.city.name != nil){
        [self hideWaitingScreen];
    }
    else{
        [self.navigationController setNavigationBarHidden:YES];
        [self initForecast];
        
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //setting background image for the table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    [self.navigationController.navigationBar setTitleTextAttributes:
       @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //initialize datasource
    
    self.dataSource = [[ExampleCityDataSource alloc] init];
    if(self.dataSource != nil)
        self.citylist = [self.dataSource getCities];
    //current position management
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    if(self.city.name == nil)
    {
        [self.locationManager startUpdatingLocation];
    }
    
    //Search for the app's documents directory
    self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentsDirectory = [self.paths objectAtIndex:0];
    //Create the full file path by appending the file name
    self.favlistname_file = [self.documentsDirectory stringByAppendingPathComponent:@"favname_list.dat"];
    self.favlistlat_file = [self.documentsDirectory stringByAppendingPathComponent:@"favlat_list.dat"];
    self.favlistlon_file = [self.documentsDirectory stringByAppendingPathComponent:@"favlon_list.dat"];
    self.favlist_array = [[NSMutableArray alloc] initWithContentsOfFile: self.favlistname_file];
    self.favlat_array = [[NSMutableArray alloc] initWithContentsOfFile: self.favlistlat_file];
    self.favlon_array = [[NSMutableArray alloc] initWithContentsOfFile: self.favlistlon_file];
     if(self.favlist_array == nil)
    {
        //Array file didn't exist... create a new one
        self.favlist_array = [[NSMutableArray alloc] initWithCapacity:100];
        self.favlon_array = [[NSMutableArray alloc] initWithCapacity:100];
        self.favlat_array = [[NSMutableArray alloc] initWithCapacity:100];
        self.favlist_array = self.citylist.get_citiesnames;
        self.favlon_array = self.citylist.get_citieslongitudes;
        self.favlat_array = self.citylist.get_citieslatitudes;
        [self.favlist_array writeToFile:self.favlistname_file atomically:YES];
        [self.favlon_array writeToFile:self.favlistlon_file atomically:YES];
        [self.favlat_array writeToFile:self.favlistlat_file atomically:YES];
    }
    
    [self registerForDisplayWaitingScreen];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//start location manager
-(CLLocationManager *)locationManager {
    if(!_locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
}

//start forecast
- (void)initForecast {
    self.forecast = [[Forecast alloc] init];
    self.forecast.city = self.city;
    //NSLog(@"forecast city: %@",self.forecast.city.name);
    [self.forecast updateForecastData];
    
}

//UI UPDATE
- (void)updateForecastView{
    if (self.forecast.city.name) //if forecast received data
    {
        self.forecast.hasDisplayedForecastData = YES;
        //MAIN THREAD
        dispatch_async(dispatch_get_main_queue(), ^{
            //display current day forecast info
            self.city_nameLabel.text = self.city.name;
            self.current_TempLabel.text = [NSString stringWithFormat:@"%d °C", self.forecast.currentTemp.intValue];
            
            //current day forecast image management
            self.weatherInfo.image = [self viewForCode:self.forecast.currentWeatherSummary.intValue];
            
            if(self.forecast.currentWeatherSummary.intValue == 0){
                self.weatherinfoLabel.text = @"Clear sky";}
            if(self.forecast.currentWeatherSummary.intValue == 1 || self.forecast.currentWeatherSummary.intValue == 2 || self.forecast.currentWeatherSummary.intValue == 3)
                self.weatherinfoLabel.text = @"Partly cloudy";
            if(self.forecast.currentWeatherSummary.intValue == 45 || self.forecast.currentWeatherSummary.intValue == 48)
                self.weatherinfoLabel.text = @"Fog";
            if(self.forecast.currentWeatherSummary.intValue == 51 || self.forecast.currentWeatherSummary.intValue == 53 || self.forecast.currentWeatherSummary.intValue == 55)
                self.weatherinfoLabel.text = @"Drizzle";
            if(self.forecast.currentWeatherSummary.intValue == 56 ||
               self.forecast.currentWeatherSummary.intValue == 57 ||
               self.forecast.currentWeatherSummary.intValue == 71 || self.forecast.currentWeatherSummary.intValue == 73 || self.forecast.currentWeatherSummary.intValue == 75 || self.forecast.currentWeatherSummary.intValue == 77 || self.forecast.currentWeatherSummary.intValue == 85 || self.forecast.currentWeatherSummary.intValue == 86)
                self.weatherinfoLabel.text = @"Snow";
            if(self.forecast.currentWeatherSummary.intValue == 61 || self.forecast.currentWeatherSummary.intValue == 63 || self.forecast.currentWeatherSummary.intValue ==  65 ||  self.forecast.currentWeatherSummary.intValue == 80 || self.forecast.currentWeatherSummary.intValue == 81 || self.forecast.currentWeatherSummary.intValue == 82)
                self.weatherinfoLabel.text = @"Rain";
            if(self.forecast.currentWeatherSummary.intValue== 66 ||  self.forecast.currentWeatherSummary.intValue== 67)
                self.weatherinfoLabel.text = @"Sleet";
            if(self.forecast.currentWeatherSummary.intValue == 95 || self.forecast.currentWeatherSummary.intValue == 96 || self.forecast.currentWeatherSummary.intValue == 99)
                self.weatherinfoLabel.text = @"Storm";
            
            //netx days forecast UI
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM"];
            NSDate *now = [NSDate date];
            for (int i=0; i<3; i++) {
                NSDate *newDate = [now dateByAddingTimeInterval:60*60*24*(i+1)];
                NSString *datetext =  [formatter stringFromDate:newDate];
                NSNumber *weathercode = [self.forecast.weathersummary objectAtIndex:i];
                double max_temp = [[self.forecast.temp_max objectAtIndex:i] doubleValue];
                double min_temp = [[self.forecast.temp_min objectAtIndex:i] doubleValue];
                NSString *minmax_temp = [NSString stringWithFormat:@"%.1f°|%.1f°", max_temp, min_temp];;
                NSString *weatherstatus = @"";
                if(weathercode.intValue == 0)
                    weatherstatus = @"clear-day";
                if(weathercode.intValue == 1 || weathercode.intValue == 2 || weathercode.intValue == 3)
                    weatherstatus = @"cloudy-day";
                if(weathercode.intValue == 45 || weathercode.intValue == 48)
                    weatherstatus = @"fog";
                if(weathercode.intValue == 51 || weathercode.intValue == 53 || weathercode.intValue == 55)
                    weatherstatus = @"drizzle";
                if(weathercode.intValue == 56 || weathercode.intValue == 57 || weathercode.intValue == 71 || weathercode.intValue == 73 || weathercode.intValue == 75 || weathercode.intValue == 77 || weathercode.intValue == 85 || weathercode.intValue == 86 )
                    weatherstatus = @"snow";
                if(weathercode.intValue == 61 || weathercode.intValue == 63 || weathercode.intValue == 65 || weathercode.intValue == 80 || weathercode.intValue == 81 || weathercode.intValue == 82)
                    weatherstatus = @"rain";
                if(weathercode.intValue == 66 || weathercode.intValue == 67)
                    weatherstatus = @"sleet";
                if(weathercode.intValue == 95 || weathercode.intValue == 96 || weathercode.intValue == 99)
                    weatherstatus = @"storm";
                if (i == 0)
                {
                    self.next_dayLabel.text = datetext;
                    self.tomorrowInfo.image = [UIImage imageNamed: weatherstatus];
                    self.next_dayTempLabel.text = minmax_temp;
                }
                if (i == 1){ //day after tomorrow UI
                    self.second_dayLabel.text = (NSString *) datetext;
                    self.second_dayInfo.image = [UIImage imageNamed: weatherstatus];
                    self.second_dayTempLabel.text = minmax_temp;
                }
                if (i==2){ //etc.
                    self.third_dayLabel.text = (NSString *) datetext;
                    self.third_dayInfo.image = [UIImage imageNamed: weatherstatus];
                    self.third_dayTempLabel.text = minmax_temp;
                }
            
            }
            // Render favourite_button
                if(self.favlist_array != nil)
                {
                    if([self.favlist_array containsObject:self.city.name]){
                        [self.favourite_button setImage: [UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
                    }
                    else {
                        [self.favourite_button setImage: [UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
                    }
                }
        });
        [self hideWaitingScreen];
        [NSNotificationCenter.defaultCenter postNotificationName:@"ForecastViewUpdated" object:nil];
    }
    else
    {
        self.forecast.hasDisplayedForecastData = NO;
    }
    
}

//when device's location update -> set new current city name,lat,lon
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks lastObject];
        self.city = [[City alloc] initWithName:placemark.locality lat:placemark.location.coordinate.latitude lon: placemark.location.coordinate.longitude];
        if(self.city.name != nil) {
            //NSLog(@"Location mangare UPDATE ! "); Debug OK!
            [self.locationManager stopUpdatingLocation];
            [self initForecast];
            [self registerForUpdatedForecast];
            
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error %@", error.domain);
}

//fav button click

- (IBAction)AddFavouritecity:(id)sender {
    //if city isn't in fav list -> add city to the list
    if(![self.favlist_array containsObject:self.city.name]){
        [self.citylist add: self.city];
        [self.favlist_array addObject:self.city.name];
        [self.favlat_array addObject:[NSString stringWithFormat:@"%f",self.city.lat]];
        [self.favlon_array addObject:[NSString stringWithFormat:@"%f",self.city.lon]];
        [self.favourite_button setImage: [UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.favlist_array writeToFile:self.favlistname_file atomically:YES];
        [self.favlon_array writeToFile:self.favlistlon_file atomically:YES];
        [self.favlat_array writeToFile:self.favlistlat_file atomically:YES];
    //else remove it
    }
    else {
        [self.citylist remove:self.city];
        [self.favlist_array removeObject:self.city.name];
        [self.favlat_array removeObject:[NSString stringWithFormat:@"%f",self.city.lat]];
        [self.favlon_array removeObject:[NSString stringWithFormat:@"%f",self.city.lon]];
        [self.favourite_button setImage: [UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
        [self.favlist_array writeToFile:self.favlistname_file atomically:YES];
        [self.favlon_array writeToFile:self.favlistlon_file atomically:YES];
        [self.favlat_array writeToFile:self.favlistlat_file atomically:YES];
    }

}

//rendering forecast images
-(UIImage *)viewForCode:(int) code {
    if(code == 0)
        return [UIImage imageNamed:@"clear-day"];
    if(code == 1 || code == 2 || code == 3)
        return [UIImage imageNamed:@"cloudy-day"];
    if(code == 45 || code == 48)
        return [UIImage imageNamed:@"fog"];
    if(code == 51 || code == 53 || code == 55)
        return [UIImage imageNamed:@"drizzle"];
    if(code == 56 || code == 57 || code == 71 || code == 73 || code == 75 || code == 77 || code == 85 || code == 86 )
        return [UIImage imageNamed:@"snow"];
    if(code == 61 || code == 63 || code == 65 || code == 80 || code == 81 || code == 82)
        return [UIImage imageNamed:@"rain"];
    if(code == 66 || code == 67)
        return [UIImage imageNamed:@"sleet"];
    if(code == 95 || code == 96 || code == 99)
        return [UIImage imageNamed:@"storm"];
    else
        return nil;
}
 
- (void)cityselected:(NSNotification *)notification{
    if ([notification.object isKindOfClass:[City class]])
    {
        self.city = [City alloc] ;
        self.city = notification.object;
        //NSLog(@"notification received, self city: %@", self.city.name);
        [self initForecast];
        [self registerForUpdatedForecast];
        
        
    }
}




/* #pragma mark - Delegate management - ALTERNATIVE APPROACH TO NOTIFICATIONS
- (void)searchCityViewControllerDelegate:(SearchCityViewController*)viewController
                           didChooseCity:(City*)city{
    self.searched_city = [[City alloc] initWithName:city.name lat:city.lat lon:city.lon];
    NSLog(@"searche city: %@",self.searched_city.name);
    
} */

#pragma mark Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     
     if([segue.identifier isEqualToString:@"fav_list"]){
         if([segue.destinationViewController isKindOfClass:[FavouritesCitiesTableViewController class]]){
             FavouritesCitiesTableViewController *viewcontroller =( FavouritesCitiesTableViewController*)segue.destinationViewController;
                viewcontroller.dataSource = self.dataSource;
                viewcontroller.names_Source = self.favlist_array;
                viewcontroller.lat_Source = self.favlat_array;
                viewcontroller.lon_Source = self.favlon_array;
            }
     }
     if([segue.identifier isEqualToString:@"MapView"]){
         if([segue.destinationViewController isKindOfClass:[FavouritesMapViewController class]]){
             FavouritesMapViewController *viewcontroller = (FavouritesMapViewController *)segue.destinationViewController;
             viewcontroller.currentLocation = self.city;
             viewcontroller.list = self.citylist.getAll;
             viewcontroller.favlist_array = self.favlist_array;
             viewcontroller.favlon_array = self.favlon_array;
             viewcontroller.favlat_array = self.favlat_array;
         }
     }
}


#pragma mark - Loading animation -
//------------------------------------------------------------------------------
//creating subview for loading screen
- (void)createWaitingScreen
{
    if (!self.displayingWaitingScreen)
    {
        self.viewWaitingScreen = [[UIView alloc] initWithFrame: self.view.frame];
        self.viewWaitingScreen.backgroundColor = [UIColor blackColor];
        self.imgConnection = [[UIImageView alloc] initWithFrame: CGRectMake (self.viewWaitingScreen.frame.origin.x,self.viewWaitingScreen.frame.origin.y,
                                                                            80,
                                                                             80)];
        self.imgConnection.center = self.viewWaitingScreen.center;
        
        [self initConnectionImages];
        
        [self startConnectionAnimation];
        
        self.imgConnection.backgroundColor = [UIColor whiteColor];
        
        [self.viewWaitingScreen addSubview:self.imgConnection];
        
        [self.view addSubview: self.viewWaitingScreen];
        
        self.displayingWaitingScreen = YES;
    }
}
//adding animation to exit waitingscreen
- (void)hideWaitingScreen
{
    [UIView transitionWithView: self.view
                      duration: 0.5f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^{
                        
                        [self.viewWaitingScreen removeFromSuperview];
                        [self stopConnectionAnimation];
                        self.displayingWaitingScreen = NO;
                        
                    } completion:nil];
    [self.navigationController setNavigationBarHidden:NO];
}

//making image animation
- (void)initConnectionImages
{
    NSMutableArray *animationImages;
    animationImages = [[NSMutableArray alloc] initWithObjects:
                        [UIImage imageNamed:@"rain"],
                        [UIImage imageNamed:@"snow"],
                        [UIImage imageNamed:@"fog"],
                        [UIImage imageNamed:@"clear-day"],
                        nil];
    self.imgConnection.animationImages = animationImages;
    self.imgConnection.animationDuration = 1;
}

- (void)startConnectionAnimation
{
    [self.imgConnection startAnimating];
}

- (void)stopConnectionAnimation
{
    [self.imgConnection stopAnimating];
}


#pragma mark - Notification management -
//------------------------------------------------------------------------------

- (void)registerForUpdatedForecast
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateForecastView)
                                                 name: KEY_UPDATED_FORECAST
                                               object: nil];
}

- (void)registerForDisplayWaitingScreen
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(createWaitingScreen)
                                                 name: KEY_DISPLAY_WAITING
                                               object: nil];
}
- (void)registerForCitySelected{
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(cityselected:)
                                                 name: @"cityselected"
                                               object: nil];
}
    


@end
