//
//  FavouritesCitiesViewController.m
//  Weather
//
//  Created by Giuseppe Ricciardi on 28/08/22.
//

#import "FavouritesCitiesViewController.h"
#import "CityList.h"

@interface FavouritesCitiesTableViewController ()

@property (strong, nonatomic) CityList *fav_list;
@property (strong, nonatomic) City *favcity_selected;
@end

@implementation FavouritesCitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForForecastViewupdated];
    //display background image
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background2.png"]];
    [self.navigationController.navigationBar setTitleTextAttributes:
       @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    UINavigationBar *bar =[self.navigationController navigationBar];
    [bar setTintColor: [UIColor blackColor]];
    //get data
    self.fav_list = [self.dataSource getCities];
    
}

#pragma mark - TableView settings

//1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//rows = number of favourites cities

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.names_Source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fav_city" forIndexPath:indexPath];
    double row_latitude = [[self.lat_Source objectAtIndex:indexPath.row] doubleValue];
    double row_longitude = [[self.lon_Source objectAtIndex:indexPath.row] doubleValue];
    City *city = [[City alloc] initWithName: [self.names_Source objectAtIndex:indexPath.row] lat:row_latitude lon:row_longitude];
    cell.textLabel.text = city.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    double row_latitude = [[self.lat_Source objectAtIndex:indexPath.row] doubleValue];
    double row_longitude = [[self.lon_Source objectAtIndex:indexPath.row] doubleValue];
    City *new = [[City alloc] initWithName: [self.names_Source objectAtIndex:indexPath.row] lat:row_latitude lon:row_longitude];
    self.favcity_selected = new;
    [NSNotificationCenter.defaultCenter postNotificationName:@"cityselected" object:self.favcity_selected];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateView:(NSNotification *)notification{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Notification
- (void)registerForForecastViewupdated{
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateView:)
                                                 name: @"ForecastViewUpdated"
                                               object: nil];
}
@end

