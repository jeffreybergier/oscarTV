//
//  MovieDetailViewController.m
//  TopTomatoes
//
//  Created by Jeffrey Bergier on 12/10/14.
//  Copyright (c) 2014 Jeffrey Bergier. All rights reserved.
//

#import "MovieDetailViewController.h"
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
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //
    // I really regret adding these timers.
    // Storyboards take over the init of the view controller.
    // Its impossible to control the order that things happen.
    // Usually the MovieDictionary is set before viewDidLoad Happens
    // This means all the interface builder objects are still NIL
    // Therefore in ViewWillAppear we need to check to make sure that movie dictionary items have been set and then configure everything.
    // However, if the dictionary has not been set then the user will get a big blank white screen with missing information.
    // The timers solve that problem. They check every 0.5 seconds to make sure the data came back. If it did, the timer cancels itself.
    //
    
    if (self.posterImageView && self.movieDictionary) {
        [self setImage:nil];
    } else {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setImage:) userInfo:nil repeats:YES];
        [timer fire];
    }
    
    if (self.detailsTableView && self.movieArray) {
        [self reloadTable:nil];
    } else {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(reloadTable:) userInfo:nil repeats:YES];
        [timer fire];
    }
    
    if (self.movieArray) {
        [self setTitleTimer:nil];
    } else {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setTitleTimer:) userInfo:nil repeats:YES];
        [timer fire];
    }
}

-(void)setTitleTimer:(NSTimer *) timer {
    if (self.movieArray) {
        [timer invalidate];
        self.title = self.movieArray[0];
    }
}

-(void)setImage: (NSTimer *) timer {
    if (self.posterImageView && self.movieDictionary) {
        [timer invalidate];
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
        NSLog(@"Timer Fired and Failed");
    }
}

-(void)reloadTable: (NSTimer *) timer {
    if (self.detailsTableView && self.movieArray) {
        [timer invalidate];
        [self.detailsTableView reloadData];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //for some reason this tintcolor code doesn't work until viewWillAppear.
    self.openCloseDetailsButton.titleLabel.textColor = self.openCloseDetailsButton.tintColor;
}

- (void)setMovieDictionary:(NSDictionary *)movieDictionary {
    if ([movieDictionary isKindOfClass:[NSDictionary class]]) {
        
        NSString *movieTitle = movieDictionary[@"title"];
        NSString *movieReleaseYear = ((NSNumber *)movieDictionary[@"year"]).stringValue;
        NSString *movieDescription = movieDictionary[@"synopsis"];
        
        NSMutableString *castMutString = [[NSMutableString alloc] initWithFormat:@""];
        NSArray *castArray = movieDictionary[@"abridged_cast"];
        for (NSDictionary *item in castArray) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [castMutString appendFormat:@"%@, ", item[@"name"]];
            }
        }
        NSString *castString = [[NSString alloc] initWithString:castMutString];
        
        self.movieArray = @[movieTitle, movieReleaseYear, castString, movieDescription];
        
        NSDictionary *posters = movieDictionary[@"posters"];
        NSString *thumbString = posters[@"thumbnail"];
        NSString *originalString = posters[@"original"];
        self.posterThumbnailURL = [[NSURL alloc] initWithString:thumbString];
        self.posterOriginalURL = [[NSURL alloc] initWithString:originalString];
        
        _movieDictionary = movieDictionary;
    }
}

- (IBAction)didTapOpenCloseDetailsButton:(UIButton *)sender {
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
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTitle"];
            cell.textLabel.text = @"Title";
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MovieReleaseYear"];
            cell.textLabel.text = @"Release Year";
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCast"];
            cell.textLabel.text = @"Cast";
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MovieDescription"];
            cell.textLabel.text = @"Synopsis";
            break;
        default:
            break;
    }
    cell.detailTextLabel.text = self.movieArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieArray.count;
}

@end
