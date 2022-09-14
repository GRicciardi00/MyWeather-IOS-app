//
//  CityList.m
//  Weather
//
//  Created by Giuseppe Ricciardi on 21/08/22.
//

#import "CityList.h"
@interface CityList()

@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) NSMutableArray *cities_names;
@property (strong, nonatomic) NSMutableArray *cities_latitudes;
@property (strong, nonatomic) NSMutableArray *cities_longitudes;
@end

@implementation CityList

-(instancetype)init {
    if(self = [super init])
        _list = [[NSMutableArray alloc] init];
    _cities_names = [[NSMutableArray alloc] init];
    _cities_latitudes = [[NSMutableArray alloc] init];
    _cities_longitudes = [[NSMutableArray alloc] init];
    return self;
}

-(long)size {
    return self.list.count;
}

-(void)add:(City *)city {
    if(![self.list containsObject:city]){
        [self.list addObject:city];
        [self.cities_names addObject:city.name];
        [self.cities_latitudes addObject:[NSString stringWithFormat:@"%f",city.lat]];
        [self.cities_longitudes addObject:[NSString stringWithFormat:@"%f",city.lon]];
    }
}

-(void)remove:(City *)city {
    [self.list removeObject:city];
    [self.cities_names removeObject:city.name];
    [self.cities_latitudes removeObject:[NSString stringWithFormat:@"%f",city.lat]];
    [self.cities_longitudes removeObject:[NSString stringWithFormat:@"%f",city.lon]];
}

-(NSArray *)getAll {
    return self.list;
}

-(City *)getAtIndex:(NSInteger)index {
    return (City *) [self.list objectAtIndex:index];
}

-(NSArray *)get_citiesnames{
    return self.cities_names;
}
-(NSArray *)get_citieslatitudes{
    return self.cities_latitudes;
}
-(NSArray *)get_citieslongitudes{
    return self.cities_longitudes;
}

@end
