//
//  MovieDetailViewController.h
//  TopTomatoes
//
//  Created by Jeffrey Bergier on 12/10/14.
//  Copyright (c) 2014 Jeffrey Bergier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController

@property (copy, nonatomic) NSDictionary *movieDictionary;

- (void)setMovieDictionary:(NSDictionary *)movieDictionary;

@end
