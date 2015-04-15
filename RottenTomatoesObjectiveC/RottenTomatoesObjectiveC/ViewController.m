//
//  ViewController.m
//  RottenTomatoesObjectiveC
//
//  Created by Jeffrey Bergier on 4/13/15.
//  Copyright (c) 2015 MobileBridge. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *upperTextField;
@property (weak, nonatomic) IBOutlet UIButton *upperUpdateButton;
@property (weak, nonatomic) IBOutlet UILabel *lowerTextLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update:(UIButton *)sender {
    NSString *textFromTextField = self.upperTextField.text;
    self.lowerTextLabel.text = textFromTextField;
}

@end
