//
//  City+MapAnnotation.m
//  Weather
//
//  Created by Giuseppe Ricciardi on 29/08/22.
//

#import "City+MapAnnotation.h"

@implementation City(MapAnnotation)

-(CLLocationCoordinate2D) coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.lat;
    coordinate.longitude = self.lon;
    return coordinate;
}

- (NSString *)title {
    return self.name;
}

@end
