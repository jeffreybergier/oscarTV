//
//  MovieTableViewCell.m
//  TopTomatoes
//
//  Created by Jeffrey Bergier on 12/10/14.
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Jeffrey Bergier
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
