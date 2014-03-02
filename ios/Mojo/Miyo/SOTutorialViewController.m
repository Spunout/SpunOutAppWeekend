//
//  SOTutorialViewController.m
//  Miyo
//
//  Created by James Eggers on 01/03/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOTutorialViewController.h"
#import "UIColor+Miyo.h"

@interface SOTutorialViewController ()

@end

@implementation SOTutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor miyoBlue];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(115.0, 20.0, 150.0, 30.0)];
    title.textColor = [UIColor whiteColor];
    title.text = @"How to Play";
    title.font = [UIFont systemFontOfSize:20.0];
    
    
    [self.view addSubview:title];
    
    UILabel *topText = [[UILabel alloc] initWithFrame:CGRectMake(2.0,40.0, 310.0, 40.0)];
    topText.textColor = [UIColor whiteColor];
    topText.font = [UIFont systemFontOfSize:12];
    topText.text = @"Complete real life activites and log them in Miyo to gain Health Points.";
    topText.lineBreakMode = NSLineBreakByWordWrapping;
    topText.numberOfLines = 0;
    
    [self.view addSubview:topText];
   
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 80.0, 290.0, 460.0)];
    text.textColor = [UIColor whiteColor];
    text.text = @"\n\n\nEat Well - Eat a healthy meal or drink some water. \n\n\nSleep Well - Have a good nights sleep or get a power nap. \n\n\nMove - Do anything that involves moving around (outside if possible). \n\n\nLearn - Complete a work or study task that gets you closer to your goals. \n\n\nTalk - Talk honestly with friends or family. \n\n\nMake - Go wild! Do something artistic or creative. \n\n\nPlay - Have fun! Do an activity that you enjoy. \n\n\nConnect - Do one thing that makes you feel more social \n\nYour points are rest every week, and added to your lifetime points.";
    text.font = [UIFont systemFontOfSize:12.0];
    text.lineBreakMode = NSLineBreakByWordWrapping;
    text.numberOfLines = 0;

    [self.view addSubview:text];

    UIImageView *eat= [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 117.0, 30.0,30.0)];
    eat.image = [UIImage imageNamed:@"Eat-Gold"];
    [self.view addSubview:eat];
    UIImageView *sleep = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 170.0, 30.0,30.0)];
    sleep.image = [UIImage imageNamed:@"Sleep-Gold"];
    [self.view addSubview:sleep];
    UIImageView *move = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 223.0, 30.0,30.0)];
    move.image = [UIImage imageNamed:@"Exercise-Gold"];
    [self.view addSubview:move];
    UIImageView *learn = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 283.0, 30.0,30.0)];
    learn.image = [UIImage imageNamed:@"Learn-Gold"];
    [self.view addSubview:learn];
    UIImageView *talk = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 333.0, 30.0,30.0)];
    talk.image = [UIImage imageNamed:@"Talk-Gold"];
    [self.view addSubview:talk];
    UIImageView *make = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 378.0, 30.0,30.0)];
    make.image = [UIImage imageNamed:@"Make-Gold"];
    [self.view addSubview:make];
    UIImageView *play = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 418.0, 30.0,30.0)];
    play.image = [UIImage imageNamed:@"Play-Gold"];
    [self.view addSubview:play];
    UIImageView *connect = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 467.0, 30.0,30.0)];
    connect.image = [UIImage imageNamed:@"Connect-Gold"];
    [self.view addSubview:connect];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
