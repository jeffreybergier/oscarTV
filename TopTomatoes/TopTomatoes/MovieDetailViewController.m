//
//  MovieDetailViewController.m
//  TopTomatoes
//
//  Created by Jeffrey Bergier on 12/10/14.
//  Copyright (c) 2014 Jeffrey Bergier. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieDetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *openCloseDetailsButton;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsViewBottomLayoutConstraint;

@property (strong, nonatomic) NSArray *movieArray;
@property (strong, nonatomic) NSURL *posterThumbnailURL;
@property (strong, nonatomic) NSURL *posterOriginalURL;
@property BOOL detailsAreOpen;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //prepare the details view
    self.detailsAreOpen = YES;
    [self.openCloseDetailsButton setTitle:@"–––––––––– Close ––––––––––" forState: UIControlStateNormal];
    self.detailsTableView.dataSource = self;
    self.detailsTableView.delegate = self;
    self.detailsTableView.backgroundColor = [UIColor clearColor];
    self.posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //
    // if the movieDictionary is set at this point, then we know we can update all the labels and images with the necessary values
    //
    if (self.movieDictionary) {
        //set the title of the view controller. this shows in the navigation bar
        self.title = self.movieArray[0];
        //tell the table to reload the data with the array.
        [self.detailsTableView reloadData];
        //the poster images can sometimes be quite large (several MB). This line of code sets the image to the small thumbnail view. Then when success or failure is called, we start downloading the big one. Once the big one comes in, the image is set.
        [self.posterImageView setImageWithURLRequest:[NSURLRequest requestWithURL:self.posterThumbnailURL]
                                    placeholderImage:nil
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 [self.posterImageView setImage:image];
                                                 [self.posterImageView setImageWithURL:self.posterOriginalURL];
                                             }
                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                 [self.posterImageView setImageWithURL:self.posterOriginalURL];
                                             }];
    } else {
        NSLog(@"Error Loading Movie Details");
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //for some reason this tintcolor code doesn't work until viewDidAppear.
    self.openCloseDetailsButton.titleLabel.textColor = self.openCloseDetailsButton.tintColor;
}

- (void)setMovieDictionary:(NSDictionary *)movieDictionary {
    if ([movieDictionary isKindOfClass:[NSDictionary class]]) {
        
        //Start extracting the key components out of the dictionary
        NSString *movieTitle = movieDictionary[@"title"];
        NSString *movieReleaseYear = ((NSNumber *)movieDictionary[@"year"]).stringValue;
        NSString *movieDescription = movieDictionary[@"synopsis"];
        
        //The list of cast members is an array of dictionarys
        //We'll loop through the array to get out the name and create a string with it
        NSMutableString *castMutString = [[NSMutableString alloc] initWithFormat:@""];
        NSArray *castArray = movieDictionary[@"abridged_cast"];
        for (NSDictionary *item in castArray) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [castMutString appendFormat:@"%@, ", item[@"name"]];
            }
        }
        NSString *castString = [[NSString alloc] initWithString:castMutString];
        
        //once we get all the items we need out the dictionary. We put them in the array that will be the data source of our tableview.
        self.movieArray = @[movieTitle, movieReleaseYear, castString, movieDescription];
        
        //lastly, we get the posters we need and build the NSURL's with them so we can set the image with them in ViewDidLoad
        NSDictionary *posters = movieDictionary[@"posters"];
        NSString *thumbString = posters[@"thumbnail"];
        NSString *originalString = posters[@"original"];
        self.posterThumbnailURL = [[NSURL alloc] initWithString:thumbString];
        self.posterOriginalURL = [[NSURL alloc] initWithString:originalString];
        
        //lastly, in a custom setter, you have to actually set the property
        _movieDictionary = movieDictionary;
    }
}

- (IBAction)didTapToShowPoster:(UITapGestureRecognizer *)sender {
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    if (self.detailsAreOpen) {
        [self didTapOpenCloseDetailsButton: sender];
    }
}

- (IBAction)didTapOpenCloseDetailsButton:(id) sender {
    if (![sender isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
    self.openCloseDetailsButton.titleLabel.textColor = [UIColor blackColor];
    if (self.detailsAreOpen) {
        [self.openCloseDetailsButton setTitle:@"–––––––––– Open ––––––––––" forState: UIControlStateNormal];
        self.detailsAreOpen = NO;
        [UIView animateWithDuration:0.3
                              delay:0.0
                 usingSpringWithDamping:1.0
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.detailsViewBottomLayoutConstraint.constant = 1 - self.detailsView.frame.size.height + self.openCloseDetailsButton.frame.size.height;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             self.openCloseDetailsButton.titleLabel.textColor = self.openCloseDetailsButton.tintColor;
                         }];
    } else {
        [self.openCloseDetailsButton setTitle:@"–––––––––– Close ––––––––––" forState: UIControlStateNormal];
        self.detailsAreOpen = YES;
        [UIView animateWithDuration:0.3
                              delay:0.0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.detailsViewBottomLayoutConstraint.constant = 0;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             self.openCloseDetailsButton.titleLabel.textColor = self.openCloseDetailsButton.tintColor;
                         }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieDetailCell"];
    
    switch (indexPath.row) {
        case 0:
            cell.subheadTextLabel.text = @"Title";
            break;
        case 1:
            cell.subheadTextLabel.text = @"Release Year";
            break;
        case 2:
            cell.subheadTextLabel.text = @"Cast";
            break;
        case 3:
            cell.subheadTextLabel.text = @"Synopsis";
            break;
        default:
            break;
    }
    cell.bodytypeTextLabel.text = self.movieArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieArray.count;
}

@end
