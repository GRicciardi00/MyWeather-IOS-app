//
//  MyWeatherTabeViewControllerDelegate.h
//  Weather
//
//  Created by Giuseppe Ricciardi on 12/09/22.
//

#import <UIKit/UIKit.h>
#import "MyWeatherTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MyWeatherTableViewController;
@protocol MyWeatherTableViewControllerDelegate <NSObject>
@optional
- (void)myWeatherTableViewController:(MyWeatherTableViewController *)viewController startForecast:(City *)city;
@end

NS_ASSUME_NONNULL_END

