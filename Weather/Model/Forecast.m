//
//  Forecast.m
//  Weather
//
//  Created by Giuseppe Ricciardi on 22/08/22.
//
#define BACKGROUND_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define KEY_UPDATED_FORECAST                @"UpdatedForecast"
#define KEY_DISPLAY_WAITING                 @"DisplayWaitingScreen"

#import "Forecast.h"

@implementation Forecast

- (void)createForecast
{
    NSString *urlString = [NSString stringWithFormat: @"https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current_weather=true&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=UTC", self.city.lat, self.city.lon];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    id value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *weather_response = (NSDictionary *)value;
    self.current_weatherINFO = [weather_response valueForKey:@"current_weather"];
    self.daily_weatherINFO = [weather_response valueForKey:@"daily"];
}

- (void)getForecastData
{
    //currentday
    self.currentTemp = [self.current_weatherINFO valueForKey:@"temperature"];
    self.currentWeatherSummary = [self.current_weatherINFO valueForKey:@"weathercode"];
    
    //NSLog(@"I'm getForecastData, current temperature:  %@", self.currentTemp); DEBUGGING
    
    //next days
    self.temp_min = [self.daily_weatherINFO valueForKey:@"temperature_2m_min"];
    self.temp_max = [self.daily_weatherINFO valueForKey:@"temperature_2m_max"];
    self.weathersummary = [self.daily_weatherINFO valueForKey:@"weathercode"];
}

- (void)updateForecastData
{
    [self postWaitingScreen];
    
    dispatch_async(BACKGROUND_QUEUE, ^{
        //Networking operation NOT on the main thread
        [self createForecast];
        
        [self getForecastData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self postUpdatedForecast];
            
        });
        
    });
    
}


//------------------------------------------------------------------------------
#pragma mark - Notifications -
//------------------------------------------------------------------------------

- (void)postWaitingScreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName: KEY_DISPLAY_WAITING
                                                        object: nil
                                                      userInfo: nil];
}

- (void)postUpdatedForecast
{
    [[NSNotificationCenter defaultCenter] postNotificationName: KEY_UPDATED_FORECAST
                                                        object: nil
                                                      userInfo: nil];
}

@end
