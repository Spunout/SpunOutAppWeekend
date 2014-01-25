//
//  SOMainViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOMainViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface SOMainViewController ()

@end

@implementation SOMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    topView.backgroundColor = [UIColor colorWithRed:0 green:0.624 blue:0.89 alpha:1.0];
    [self.view addSubview:topView];
    
    UILabel *moodSelectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 380.0, 280.0, 50.0)];
    moodSelectorLabel.text = @"How are you feeling today?";
    moodSelectorLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:moodSelectorLabel];
    
//    UISlider *moodSelectorSlider = [[UISlider alloc] initWithFrame:CGRectMake(55.0, 350.0, 200.0, 60.0)];
//    moodSelectorSlider.tintColor = [UIColor whiteColor];
//    [self.view addSubview:moodSelectorSlider];
    
//    [moodSelectorSlider addTarget:self action:@selector(moodChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *button = [[UIView alloc] initWithFrame:CGRectMake(35.0, 380.0, 250.0, 50.0)];
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1.0f;
    button.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:button];
    
}

-(void)buttonTapped:(UITapGestureRecognizer *)gr
{
    NSLog(@"hi!");
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
