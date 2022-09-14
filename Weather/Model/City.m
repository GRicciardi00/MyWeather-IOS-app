//
//  City.m
//  Weather
//
//  Created by Giuseppe Ricciardi on 21/08/22.
//
#import "City.h"
@implementation City

-(instancetype) initWithName:(NSString *)name
                    lat:(double)lat
                   lon:(double)lon{
    if(self = [super init]) {
        _name = [name copy];
        _lat = lat;
        _lon = lon;
    }
    return self;
}

@end
