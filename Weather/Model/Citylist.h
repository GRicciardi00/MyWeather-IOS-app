//
//  CityList.h
//  Weather
//
//  Created by Giuseppe Ricciardi on 21/08/22.
//

#import <Foundation/Foundation.h>
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface CityList : NSObject

-(NSMutableArray *)getAll;

-(long)size;

-(void)add:(City *)city;

-(void)remove:(City *)city;

-(City *)getAtIndex:(NSInteger)index;

-(NSMutableArray *)get_citiesnames;
-(NSMutableArray *)get_citieslatitudes;
-(NSMutableArray *)get_citieslongitudes;
@end


NS_ASSUME_NONNULL_END
