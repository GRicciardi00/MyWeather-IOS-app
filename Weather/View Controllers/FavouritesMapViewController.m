#import "FavouritesMapViewController.h"
#import <MapKit/MapKit.h>
#import "City+MapAnnotation.h"
#import "Forecast.h"
@interface FavouritesMapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *MapView;
- (void) centerMapToLocation:(CLLocationCoordinate2D)location
                        zoom:(double)zoom;
@end

@implementation FavouritesMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup map view
    self.MapView.delegate = self;
    [self centerMapToLocation:CLLocationCoordinate2DMake(self.currentLocation.lat, self.currentLocation.lon)
                         zoom:0.1];

    [self.favlist_array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSString class]]) {
            City *city = [[City alloc]initWithName:obj lat:[self.favlat_array[idx] doubleValue] lon:[self.favlon_array[idx] doubleValue]];
            //NSLog(@"Cityname: %@, Latitude: %@, Longitude: %@",obj, self.favlat_array[idx],self.favlon_array[idx]); OK
            [self.MapView addAnnotation:city];
        }
    }];
    
}


// setup the annotation that are associated with each map's pin
- (MKAnnotationView *) mapView:(MKMapView *)mapView
             viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *AnnotationIdentifer = @"CityAnnotation";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifer];
    if(!view){
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:AnnotationIdentifer];
        view.canShowCallout = YES;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    //default view of pin annotation
    imageView.image = [UIImage imageNamed:@"unloaded"];
    view.leftCalloutAccessoryView = imageView;
    return view;
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]){
        __block UIImageView *imageView = (UIImageView *)view.leftCalloutAccessoryView;
        id<MKAnnotation> annotation = view.annotation;
        if([annotation isKindOfClass:[City class]]) {
            dispatch_queue_t queue = dispatch_queue_create("init forecast", NULL);
            City *city = (City *)annotation;
            dispatch_async(queue, ^{
                Forecast *forecast = [[Forecast alloc]init];
                forecast.city = city;
                NSString *urlString = [NSString stringWithFormat: @"https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current_weather=true&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=UTC", city.lat, city.lon];
                NSURL *url = [NSURL URLWithString:urlString];
                NSData *data = [NSData dataWithContentsOfURL:url];
                id value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *weather_response = (NSDictionary *)value;
                forecast.current_weatherINFO = [weather_response valueForKey:@"current_weather"];
                forecast.currentWeatherSummary = [forecast.current_weatherINFO valueForKey:@"weathercode"];
                dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = [self viewForCode:forecast.currentWeatherSummary.intValue];
                    });
                });
            }
}   }

-(UIImage *)viewForCode:(int) code {
    //using systemImages for better annotation view
    if(code == 0)
        return [UIImage systemImageNamed:@"sun.min"];
    if(code == 1 || code == 2 || code == 3)
        return [UIImage systemImageNamed:@"cloud.sun"];
    if(code == 45 || code == 48)
        return [UIImage systemImageNamed:@"cloud.fog"];
    if(code == 51 || code == 53 || code == 55)
        return [UIImage systemImageNamed:@"cloud.drizzle"];
    if(code == 56 || code == 57 || code == 71 || code == 73 || code == 75 || code == 77 || code == 85 || code == 86 )
        return [UIImage systemImageNamed:@"cloud.snow"];
    if(code == 61 || code == 63 || code == 65 || code == 80 || code == 81 || code == 82)
        return [UIImage systemImageNamed:@"cloud.rain"];
    if(code == 66 || code == 67)
        return [UIImage systemImageNamed:@"cloud.sleet"];
    if(code == 95 || code == 96 || code == 99)
        return [UIImage systemImageNamed:@"cloud.bolt"];
    else
        return nil;
}

- (void) centerMapToLocation:(CLLocationCoordinate2D)location
                        zoom:(double)zoom{
    MKCoordinateRegion mapRegion;
    mapRegion.center = location;
    mapRegion.span.latitudeDelta = zoom;
    mapRegion.span.longitudeDelta = zoom;
    [self.MapView setRegion:mapRegion];
}
@end
