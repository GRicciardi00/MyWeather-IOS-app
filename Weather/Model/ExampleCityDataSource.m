//
//  ExampleCityDataSource.m
//  Weather
//
//  Created by Giuseppe Ricciardi on 23/08/22.
//

#import "ExampleCityDataSource.h"
#import "CityList.h"

@interface ExampleCityDataSource()

@property (strong, nonatomic) CityList *list;

@end

@implementation ExampleCityDataSource

-(CityList *)getCities {
    return self.list;
}

-(instancetype)init {
    if(self = [super init]) {
        _list = [[CityList alloc] init];
    }
    return self;
}

@end
