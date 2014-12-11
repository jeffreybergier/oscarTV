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
    
    //prepare the view
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.movieListTableView.delegate = self;
    self.movieListTableView.dataSource = self;
    self.title = @"Top Movies";
    
    //generate the URL request
    NSString *url = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=%@", self.appDelegate.apiKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.moviesArray = object[@"movies"];
        self.movieListtableViewTopLayoutConstraint.constant = 1 - self.movieListTableView.contentInset.top;
        [self.movieListTableView reloadData];
        [self.movieListTableView flashScrollIndicators];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
