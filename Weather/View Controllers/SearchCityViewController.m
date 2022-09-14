//
//  search_cityviewcontroller.m
//  Weather
//
//  Created by Giuseppe Ricciardi on 27/08/22.
//
//
//  SearchViewController.m
//  MyWeather
//
//  Created by Simone Leoni on 21/07/22.
//
#import <MapKit/MapKit.h>
#import "SearchCityViewController.h"
#import "City.h"

@interface SearchCityViewController ()

@property (weak, nonatomic) IBOutlet UITableView *ResultsTableView;

@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;



@property (strong,nonatomic) NSMutableArray *search_results;
@property (strong,nonatomic) City *city_selected;

@end

@implementation SearchCityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForForecastViewupdated];
    //display background image
    self.ResultsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background2.png"]];
    [self.navigationController.navigationBar setTitleTextAttributes:
       @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    UINavigationBar *bar =[self.navigationController navigationBar];
    self.ResultsTableView.backgroundColor = [UIColor clearColor];
    [bar setTintColor: [UIColor blackColor] ];
    
    _search_results = [[NSMutableArray alloc] init];
    self.ResultsTableView.delegate = self;
    self.ResultsTableView.dataSource = self;
    self.SearchBar.delegate = self;
    
}

#pragma mark - Table view settings
//one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//number rows = number places founded
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.search_results.count;
}

//result cell UI settings:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"City_found" forIndexPath:indexPath];
    MKMapItem *cityData = [self.search_results objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",[cityData name], [[cityData placemark] title]];
    
    
    return cell;
}
//when select a row pop back to myweathertableview
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    MKMapItem *data = [self.search_results objectAtIndex:indexPath.row];
    NSString *cityName = [NSString stringWithFormat:@"%@",[data name]];
    NSString *latitude = [NSString stringWithFormat:@"%f",[[data placemark] coordinate].latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",[[data placemark] coordinate].longitude];
    self.city_selected = [[City alloc] initWithName:cityName lat:[f numberFromString:latitude].doubleValue lon:[f numberFromString:longitude].doubleValue];
    //NSLog(@"%@",new.name); Ok
    //Do a segue and pass the city selected
    [NSNotificationCenter.defaultCenter postNotificationName:@"cityselected" object:self.city_selected];
    
    
}

//when user click on search call search function
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self search_City];
}

//search a city with MKLocalSearchRequest.
-(void) search_City {
    // Create a search request with a string
    NSString *search_request = self.SearchBar.text;
    //empty search results array before start
    [self.search_results removeAllObjects];
    dispatch_queue_t queue = dispatch_queue_create("search_data", NULL);
    dispatch_async(queue, ^{
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    [searchRequest setNaturalLanguageQuery: search_request ];
    // Create the local search to perform the search
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            for (MKMapItem *mapItem in [response mapItems]) {
                [self.search_results addObject: mapItem];
                
            }
        } else {
            NSLog(@"Search Request Error: %@", [error localizedDescription]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.ResultsTableView reloadData];
        });
    }];
    });
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

