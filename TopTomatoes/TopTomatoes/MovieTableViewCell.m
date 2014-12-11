//
//  MovieTableViewCell.m
//  TopTomatoes
//
//  Created by Jeffrey Bergier on 12/10/14.
//  Copyright (c) 2014 Jeffrey Bergier. All rights reserved.
//

#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieDescriptionLabel;

@end

@implementation MovieTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self prepareLabelsAndImageView];
}

- (void)prepareLabelsAndImageView {
    self.movieTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.movieDescriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.movieDescriptionLabel.text = @"The Matrix";
    self.movieDescriptionLabel.text = @"What if virtual reality wasn't just for fun, but was being used to imprison you? That's the dilemma that faces mild-mannered computer jockey Thomas Anderson (Keanu Reeves) in The Matrix.";
    
    self.moviePosterImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setMovieDictionary:(NSDictionary *)movieDictionary {
    if ([movieDictionary isKindOfClass:[NSDictionary class]]) {
        //set the property to the new variable
        _movieDictionary = movieDictionary;
        
        //start populating labels and poster
        NSString *title = movieDictionary[@"title"];
        NSString *description = movieDictionary[@"synopsis"];
        NSDictionary *allPosters = movieDictionary[@"posters"];
        NSString *thumbnailPosterURLString = allPosters[@"thumbnail"];
        NSURL *thumbnailPosterURL = [NSURL URLWithString:thumbnailPosterURLString];
        
        self.movieTitleLabel.text = title;
        self.movieDescriptionLabel.text = description;
        [self.moviePosterImageView setImageWithURL:thumbnailPosterURL];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
