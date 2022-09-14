//
//  CityDataSource.h
//  Weather
//
//  Created by Giuseppe Ricciardi on 23/08/22.
//

#import <Foundation/Foundation.h>

#import "CityList.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CityDataSource <NSObject>

- (CityList *) getCities;

@end

NS_ASSUME_NONNULL_END
