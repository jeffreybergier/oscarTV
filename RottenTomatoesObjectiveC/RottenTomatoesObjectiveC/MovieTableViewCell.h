//
//  MovieTableViewCell.h
//  RottenTomatoesObjectiveC
//
//  Created by Jeffrey Bergier on 4/15/15.
//  Copyright (c) 2015 MobileBridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieDescriptionLabel;

@property (strong, nonatomic) NSURL *posterURL;

@end
