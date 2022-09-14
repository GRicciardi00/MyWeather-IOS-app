//
//  FavouriteMapViewController.h
//  Weather
//
//  Created by Giuseppe Ricciardi on 29/08/22.
//

#import <UIKit/UIKit.h>
#import "CityList.h"
#import "Forecast.h"
NS_ASSUME_NONNULL_BEGIN

@interface FavouritesMapViewController : UIViewController

@property (strong, nonatomic) NSArray *list;

// used to center the map
@property (strong, nonatomic) City *currentLocation;
//used for displaying cities on map
@property (strong,nonatomic) NSMutableArray *favlist_array;
@property (strong,nonatomic) NSMutableArray *favlon_array;
@property (strong,nonatomic) NSMutableArray *favlat_array;

@end

NS_ASSUME_NONNULL_END
