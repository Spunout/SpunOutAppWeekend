//
//  SOMainViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOMainViewController.h"
#import <Parse/Parse.h>

@interface SOMainViewController ()

@end

@implementation SOMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 300.0)];
    topView.backgroundColor = [UIColor colorWithRed:1 green:0.212 blue:0.212 alpha:1.0];
    [self.view addSubview:topView];
    
    UILabel *moodSelectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 300.0, 280.0, 50.0)];
    moodSelectorLabel.text = @"How are you feeling today?";
    moodSelectorLabel.textColor = [UIColor colorWithRed:1 green:0.212 blue:0.212 alpha:1.0];
    [self.view addSubview:moodSelectorLabel];
    
    UISlider *moodSelectorSlider = [[UISlider alloc] initWithFrame:CGRectMake(55.0, 350.0, 200.0, 60.0)];
    moodSelectorSlider.tintColor = [UIColor colorWithRed:1 green:0.212 blue:0.212 alpha:1.0];
    [self.view addSubview:moodSelectorSlider];
    
    [moodSelectorSlider addTarget:self action:@selector(moodChanged:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)moodChanged:(UISlider *)sender {
    NSNumber *moodValue = [[NSNumber alloc] initWithFloat:(sender.value * 100.0)];
    PFObject *mood = [PFObject objectWithClassName:@"Mood"];
    mood[@"value"] = moodValue;

    
    [mood saveInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
