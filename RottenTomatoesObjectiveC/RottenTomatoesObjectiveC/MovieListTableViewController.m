//
//  MovieListTableViewController.m
//  RottenTomatoesObjectiveC
//
//  Created by Jeffrey Bergier on 4/14/15.
//  Copyright (c) 2015 MobileBridge. All rights reserved.
//

#import "MovieListTableViewController.h"
#import "MovieTableViewCell.h"

@interface MovieListTableViewController()

@property (strong, nonatomic) NSArray *moviesArray;

@end

@implementation MovieListTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Download rotten tomatoes file
    NSString *apiKey = @"qe43pmsb84evcmyj43gbe7j8";
    NSString *urlString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=%@", apiKey];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = ((NSHTTPURLResponse*) response);
            switch (httpResponse.statusCode) {
                case 200: {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: nil];
                    NSArray *moviesArray = json[@"movies"];
                    if (moviesArray) {
                        // Grab the main queue because NSURLSession can callback on any
                        // queue and we're touching non-atomic properties and the UI
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.moviesArray = moviesArray;
                            [self.tableView reloadData];
                        });
                    }
                    break;
                }
                default: {
                    NSLog(@"Error downloading file: Response code %ld", (long)httpResponse.statusCode); // Handle Errors here
                    break;
                }
            }
        }
    }];
    [task resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moviesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.moviesArray[indexPath.row];
    NSString *movieTitle = movie[@"title"];
    NSString *movieDescription = movie[@"synopsis"];
    
    cell.moviePosterImageView.image = nil; // Need to clear the image before we start downloading a new one.
    cell.movieTitleLabel.text = movieTitle;
    cell.movieDescriptionLabel.text = movieDescription;
    
    NSDictionary *posterDictionary = movie[@"posters"];
    NSString *posterURLString = posterDictionary[@"thumbnail"];
    NSURL *posterURL = [[NSURL alloc] initWithString:posterURLString];
    
    cell.posterURL = posterURL;
    [self downloadImageURL:posterURL ForCell:cell];
    
    return cell;
}

-(void)downloadImageURL:(NSURL *)downloadURL ForCell:(MovieTableViewCell *)cell {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:downloadURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *downloadedData, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = ((NSHTTPURLResponse*) response);
            switch (httpResponse.statusCode) {
                case 200: {
                    // Grab the main queue because NSURLSession can callback on any
                    // queue and we're touching non-atomic properties and the UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([httpResponse.URL isEqual:cell.posterURL]) {
                            UIImage *image = [[UIImage alloc] initWithData: downloadedData];
                            cell.moviePosterImageView.image = image;
                        } else {
                            // The URL's don't match. That means that the cell has been "Reused" since starting this download
                            // We can discard this download and do nothing
                            // Hopefully, the appropriate downloaded for this cell has already started
                            // If we were serious about error handling, we would have a way to verify that.
                            NSLog(@"URL's Don't match: Download %@. Cell %@", httpResponse.URL, cell.posterURL);
                        }
                    });
                    break;
                }
                default: {
                    break; // Handle HTTP Errors here
                }
            }
        }
    }];
    [task resume];
}


@end
