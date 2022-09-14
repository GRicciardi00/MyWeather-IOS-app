//
//  MyWeatherTableViewController.h
//  Weather
//
//  Created by Giuseppe Ricciardi on 17/08/22.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "City.h"
#import "Forecast.h"
#import "SearchCityViewController.h"
#import "FavouritesCitiesViewController.h"
#import "FavouritesMapViewController.h"
NS_ASSUME_NONNULL_BEGIN


@interface MyWeatherTableViewController : UITableViewController

@property (strong, nonatomic) City *city;
@property (strong, nonatomic) Forecast *forecast;
@property (nonatomic) BOOL displayingWaitingScreen;

@end

NS_ASSUME_NONNULL_END
