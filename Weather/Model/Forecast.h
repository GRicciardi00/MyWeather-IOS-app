//
//  Forecast.h
//  Weather
//
//  Created by Giuseppe Ricciardi on 22/08/22.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface Forecast : NSObject

- (void)updateForecastData;
- (void)createForecast;
- (void)getForecastData;
@property (strong, nonatomic) City *city;

//control for waiting screen
@property (nonatomic) BOOL hasDisplayedForecastData;

//today forecast
@property (strong, nonatomic) NSDictionary *current_weatherINFO;
@property (strong, nonatomic) NSDictionary *daily_weatherINFO;
@property (strong, nonatomic) NSNumber *currentTemp;
@property (strong, nonatomic) NSNumber *currentWeatherSummary;

//next days forecast
@property (strong, nonatomic) NSArray *weathersummary;
@property (strong, nonatomic) NSArray *temp_max;
@property (strong, nonatomic) NSArray *temp_min;

@end

NS_ASSUME_NONNULL_END
