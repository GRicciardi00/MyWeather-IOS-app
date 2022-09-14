//
//  FavouritesCitiesViewController.h
//  Weather
//
//  Created by Giuseppe Ricciardi on 28/08/22.
//

#import "ExampleCityDataSource.h"
#import "MyWeatherTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavouritesCitiesTableViewController : UITableViewController

@property (strong, nonatomic) ExampleCityDataSource *dataSource;
@property (strong, nonatomic) NSArray *names_Source;
@property (strong, nonatomic) NSArray *lat_Source;
@property (strong, nonatomic) NSArray *lon_Source;


@end

NS_ASSUME_NONNULL_END
