//
//  City.h
//  Weather
//
//  Created by Giuseppe Ricciardi on 21/08/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface City : NSObject


@property (strong, nonatomic) NSString *name;
@property double lat;
@property double lon;


-(instancetype) initWithName:(NSString *)name
                    lat:(double) lat
                   lon:(double) lon;

@end

NS_ASSUME_NONNULL_END

