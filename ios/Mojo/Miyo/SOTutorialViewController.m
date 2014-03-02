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

    self.title = @"How to Play";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                          target:self
                                                                                          action:@selector(done)];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *topText = [[UILabel alloc] init];
    topText.textColor = [UIColor whiteColor];
    topText.font = [UIFont systemFontOfSize:15.0];
    topText.text = @"Complete real life activites and log them in Miyo to gain Health Points. Your Health Points reset every week so keep coming back to enter your activities!";
    topText.lineBreakMode = NSLineBreakByWordWrapping;
    topText.numberOfLines = 0;

    topText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *eatText = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 80.0, 290.0, 380.0)];
    eatText.textColor = [UIColor whiteColor];
    eatText.text = @"Eat Well - Eat a healthy meal or drink some water.";
    eatText.font = [UIFont systemFontOfSize:15.0];
    eatText.lineBreakMode = NSLineBreakByWordWrapping;
    eatText.numberOfLines = 0;
    eatText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *sleepText = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 80.0, 290.0, 380.0)];
    sleepText.textColor = [UIColor whiteColor];
    sleepText.text = @"Sleep Well - Have a good nights sleep or get a power nap";
    sleepText.font = [UIFont systemFontOfSize:15.0];
    sleepText.lineBreakMode = NSLineBreakByWordWrapping;
    sleepText.numberOfLines = 0;
    sleepText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *moveText = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 80.0, 290.0, 380.0)];
    moveText.textColor = [UIColor whiteColor];
    moveText.text = @"Move - Do anything that involves moving around (outside if possible).";
    moveText.font = [UIFont systemFontOfSize:15.0];
    moveText.lineBreakMode = NSLineBreakByWordWrapping;
    moveText.numberOfLines = 0;
    moveText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *learnText = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 80.0, 290.0, 380.0)];
    learnText.textColor = [UIColor whiteColor];
    learnText.text = @"Learn - Complete a work or study task that gets you closer to your goals.";
    learnText.font = [UIFont systemFontOfSize:15.0];
    learnText.lineBreakMode = NSLineBreakByWordWrapping;
    learnText.numberOfLines = 0;
    learnText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *talkText = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 80.0, 290.0, 380.0)];
    talkText.textColor = [UIColor whiteColor];
    talkText.text = @"Talk - Talk honestly with friends or family";
    talkText.font = [UIFont systemFontOfSize:15.0];
    talkText.lineBreakMode = NSLineBreakByWordWrapping;
    talkText.numberOfLines = 0;
    talkText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *makeText = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 80.0, 290.0, 380.0)];
    makeText.textColor = [UIColor whiteColor];
    makeText.text = @"Make - Go wild! Do something artistic or creative";
    makeText.font = [UIFont systemFontOfSize:15.0];
    makeText.lineBreakMode = NSLineBreakByWordWrapping;
    makeText.numberOfLines = 0;
    makeText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *connectText = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 80.0, 290.0, 380.0)];
    connectText.textColor = [UIColor whiteColor];
    connectText.text = @"Connect - Do one thing that makes you feel more social";
    connectText.font = [UIFont systemFontOfSize:15.0];
    connectText.lineBreakMode = NSLineBreakByWordWrapping;
    connectText.numberOfLines = 0;
    connectText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *playText = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 80.0, 290.0, 380.0)];
    playText.textColor = [UIColor whiteColor];
    playText.text = @"Play - Have fun! Do an activity that you enjoy";
    playText.font = [UIFont systemFontOfSize:15.0];
    playText.lineBreakMode = NSLineBreakByWordWrapping;
    playText.numberOfLines = 0;
    playText.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *eatImageView = [[UIImageView alloc] init];
    eatImageView.image = [UIImage imageNamed:@"Eat-Gold"];
    eatImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *sleepImageView = [[UIImageView alloc] init];
    sleepImageView.image = [UIImage imageNamed:@"Sleep-Gold"];
    sleepImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *moveImageView = [[UIImageView alloc] init];
    moveImageView.image = [UIImage imageNamed:@"Exercise-Gold"];
    moveImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *learnImageView = [[UIImageView alloc] init];
    learnImageView.image = [UIImage imageNamed:@"Learn-Gold"];
    learnImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *talkImageView = [[UIImageView alloc] init];
    talkImageView.image = [UIImage imageNamed:@"Talk-Gold"];
    talkImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *makeImageView = [[UIImageView alloc] init];
    makeImageView.image = [UIImage imageNamed:@"Make-Gold"];
    makeImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *connectImageView = [[UIImageView alloc] init];
    connectImageView.image = [UIImage imageNamed:@"Connect-Gold"];
    connectImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *playImageView = [[UIImageView alloc] init];
    playImageView.image = [UIImage imageNamed:@"Play-Gold"];
    playImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:scrollView];
    [scrollView addSubview:contentView];
    [contentView addSubview:topText];
    [contentView addSubview:eatText];
    [contentView addSubview:sleepText];
    [contentView addSubview:moveText];
    [contentView addSubview:learnText];
    [contentView addSubview:talkText];
    [contentView addSubview:makeText];
    [contentView addSubview:connectText];
    [contentView addSubview:playText];
    [contentView addSubview:eatImageView];
    [contentView addSubview:sleepImageView];
    [contentView addSubview:moveImageView];
    [contentView addSubview:learnImageView];
    [contentView addSubview:talkImageView];
    [contentView addSubview:makeImageView];
    [contentView addSubview:connectImageView];
    [contentView addSubview:playImageView];

    NSDictionary *views = @{@"scrollView": scrollView,
                            @"contentView": contentView,
                            @"topText": topText,
                            @"eatText": eatText,
                            @"eatImageView": eatImageView,
                            @"sleepText": sleepText,
                            @"sleepImageView": sleepImageView,
                            @"moveText": moveText,
                            @"moveImageView": moveImageView,
                            @"learnText": learnText,
                            @"learnImageView": learnImageView,
                            @"talkText": talkText,
                            @"talkImageView": talkImageView,
                            @"makeText": makeText,
                            @"makeImageView": makeImageView,
                            @"connectText": connectText,
                            @"connectImageView": connectImageView,
                            @"playText": playText,
                            @"playImageView": playImageView};

    NSDictionary *metrics = @{@"padding": @10,
                              @"textSpacing": @20,
                              @"imageSize": @30};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:self.view.bounds.size.width]];

    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];

    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:self.view.bounds.size.width]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[topText]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topText]-(textSpacing)-[eatText]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[eatText]-(textSpacing)-[sleepText]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sleepText]-(textSpacing)-[moveText]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[moveText]-(textSpacing)-[learnText]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[learnText]-(textSpacing)-[talkText]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[talkText]-(textSpacing)-[makeText]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[makeText]-(textSpacing)-[connectText]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[connectText]-(textSpacing)-[playText]-(40)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topText]-(textSpacing)-[eatImageView(imageSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[eatText]-(textSpacing)-[sleepImageView(imageSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sleepText]-(textSpacing)-[moveImageView(imageSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[moveText]-(textSpacing)-[learnImageView(imageSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[learnText]-(textSpacing)-[talkImageView(imageSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[talkText]-(textSpacing)-[makeImageView(imageSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[makeText]-(textSpacing)-[connectImageView(imageSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[connectText]-(textSpacing)-[playImageView(imageSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[topText]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[eatImageView(imageSize)]-(padding)-[eatText]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[sleepImageView(imageSize)]-(padding)-[sleepText]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[moveImageView(imageSize)]-(padding)-[moveText]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[learnImageView(imageSize)]-(padding)-[learnText]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[talkImageView(imageSize)]-(padding)-[talkText]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[makeImageView(imageSize)]-(padding)-[makeText]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[connectImageView(imageSize)]-(padding)-[connectText]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[playImageView(imageSize)]-(padding)-[playText]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
}

- (void)done
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
