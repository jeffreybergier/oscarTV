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

@end

@implementation MovieListTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    cell.movieTitleLabel.text = [NSString stringWithFormat:@"This is Cell Number %d", indexPath.row];
    return cell;
}

@end
