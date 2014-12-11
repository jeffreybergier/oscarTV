//
//  MovieDetailViewController.m
//  TopTomatoes
//
//  Created by Jeffrey Bergier on 12/10/14.
//  Copyright (c) 2014 Jeffrey Bergier. All rights reserved.
//

#import "MovieDetailViewController.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setMovieDictionary:(NSDictionary *)movieDictionary {
    if ([movieDictionary isKindOfClass:[NSDictionary class]]) {
        _movieDictionary = movieDictionary;
        NSLog(@"%@", movieDictionary);
    }
}

@end
