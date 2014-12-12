//
//  MovieListViewController.m
//  TopTomatoes
//
//  Created by Jeffrey Bergier on 12/10/14.
//  Copyright (c) 2014 Jeffrey Bergier. All rights reserved.
//

#import "MovieListViewController.h"
#import "MovieDetailViewController.h"
#import "MovieTableViewCell.h"
#import "AppDelegate.h"

@interface MovieListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movieListtableViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UITableView *movieListTableView;

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSArray *moviesArray;

@end

@implementation MovieListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //prepare the title and make sure we have a reference to the app delegate for the AppID
    self.title = @"Top Movies"; //the title is displayed in the UINavigationController
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    //prepare the tableview delegate and datasource
    self.movieListTableView.delegate = self;
    self.movieListTableView.dataSource = self;
    
    //hide the table view so we can see the loading spinner
    self.movieListTableView.alpha = 0.0;
    
    //generate the URL request
    NSString *url = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=%@", self.appDelegate.apiKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // This Block should be executed on the main thread. However, I had one crash that looked like it was thread related.
        // The next block forces the code to wait for the main thread to be available and then executes.
        // No crashes since using this.
        dispatch_async(dispatch_get_main_queue(), ^{
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.moviesArray = object[@"movies"];
            // This moves the tableview up so it is below the navigation controller.
            // This is important in iOS7 and later for the blur
            // The tableview is smart enough to adjust its content inset so the top row stays below the navigation controller.
            // We'll take advantage of this to adjust the top constraint of the tableview
            // If using a UITableViewcontroller this is done for you
            self.movieListtableViewTopLayoutConstraint.constant = 1 - self.movieListTableView.contentInset.top;
            [self.movieListTableView reloadData];
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:0
                             animations:^{
                                 self.movieListTableView.alpha = 1.0;
                             } completion:^(BOOL finished) {
                                 // This causes the nice touch that iOS users normally experience when going to a new view
                                 // This is done automatically if using a UITableViewController.
                                 [self.movieListTableView flashScrollIndicators];
                             }];
        });
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // This causes the selected row to be deselected when we come back to this view
    // Normally, this is done for you if you use UITableViewController
    // However, we're using UIViewController with a tableview placed into it. So we have to do it manually
    NSIndexPath *selectedIndexPath = [self.movieListTableView indexPathForSelectedRow];
    [self.movieListTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"ShowMovieDetailSegue"]) {
        MovieDetailViewController *movieDetailViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.movieListTableView indexPathForSelectedRow];
        movieDetailViewController.movieDictionary = self.moviesArray[indexPath.row];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell"];
    
    cell.movieDictionary = self.moviesArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 162;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moviesArray.count;
}



@end
