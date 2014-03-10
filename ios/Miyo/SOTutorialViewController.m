//
//  SOTutorialViewController.m
//  Miyo
//
//  Created by James Eggers on 01/03/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOTutorialViewController.h"
#import "UIColor+Miyo.h"

#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface SOTutorialViewController () <TTTAttributedLabelDelegate>

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
    topText.font = [UIFont systemFontOfSize:16.0];
    topText.text = @"Complete real life activites and log them in MiYo to gain Health Points.\n\nYour Health Points reset every week so keep coming back to enter your activities!";
    topText.textAlignment = NSTextAlignmentCenter;
    topText.lineBreakMode = NSLineBreakByWordWrapping;
    topText.numberOfLines = 0;

    topText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *eatText = [[UILabel alloc] init];
    eatText.textColor = [UIColor whiteColor];
    eatText.text = @"Eat Well - Eat a healthy meal or drink some water.";
    eatText.font = [UIFont systemFontOfSize:16.0];
    eatText.lineBreakMode = NSLineBreakByWordWrapping;
    eatText.numberOfLines = 0;
    eatText.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *eatImageView = [[UIImageView alloc] init];
    eatImageView.image = [UIImage imageNamed:@"Eat-Gold"];
    eatImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *sleepText = [[UILabel alloc] init];
    sleepText.textColor = [UIColor whiteColor];
    sleepText.text = @"Sleep Well - Have a good nights sleep or get a power nap";
    sleepText.font = [UIFont systemFontOfSize:16.0];
    sleepText.lineBreakMode = NSLineBreakByWordWrapping;
    sleepText.numberOfLines = 0;
    sleepText.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *sleepImageView = [[UIImageView alloc] init];
    sleepImageView.image = [UIImage imageNamed:@"Sleep-Gold"];
    sleepImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *moveText = [[UILabel alloc] init];
    moveText.textColor = [UIColor whiteColor];
    moveText.text = @"Move - Do anything that involves moving around (outside if possible).";
    moveText.font = [UIFont systemFontOfSize:16.0];
    moveText.lineBreakMode = NSLineBreakByWordWrapping;
    moveText.numberOfLines = 0;
    moveText.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *moveImageView = [[UIImageView alloc] init];
    moveImageView.image = [UIImage imageNamed:@"Exercise-Gold"];
    moveImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *learnText = [[UILabel alloc] init];
    learnText.textColor = [UIColor whiteColor];
    learnText.text = @"Learn - Complete a work or study task that gets you closer to your goals.";
    learnText.font = [UIFont systemFontOfSize:16.0];
    learnText.lineBreakMode = NSLineBreakByWordWrapping;
    learnText.numberOfLines = 0;
    learnText.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *learnImageView = [[UIImageView alloc] init];
    learnImageView.image = [UIImage imageNamed:@"Learn-Gold"];
    learnImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *talkText = [[UILabel alloc] init];
    talkText.textColor = [UIColor whiteColor];
    talkText.text = @"Talk - Talk & connect with friends or family and get something off your chest if you need to";
    talkText.font = [UIFont systemFontOfSize:16.0];
    talkText.lineBreakMode = NSLineBreakByWordWrapping;
    talkText.numberOfLines = 0;
    talkText.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *talkImageView = [[UIImageView alloc] init];
    talkImageView.image = [UIImage imageNamed:@"Talk-Gold"];
    talkImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *makeText = [[UILabel alloc] init];
    makeText.textColor = [UIColor whiteColor];
    makeText.text = @"Make - Go wild! Do something artistic or creative";
    makeText.font = [UIFont systemFontOfSize:16.0];
    makeText.lineBreakMode = NSLineBreakByWordWrapping;
    makeText.numberOfLines = 0;
    makeText.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *makeImageView = [[UIImageView alloc] init];
    makeImageView.image = [UIImage imageNamed:@"Make-Gold"];
    makeImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *connectText = [[UILabel alloc] init];
    connectText.textColor = [UIColor whiteColor];
    connectText.text = @"Connect - Make a plan to meet up with a friend in the next day or two";
    connectText.font = [UIFont systemFontOfSize:16.0];
    connectText.lineBreakMode = NSLineBreakByWordWrapping;
    connectText.numberOfLines = 0;
    connectText.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *connectImageView = [[UIImageView alloc] init];
    connectImageView.image = [UIImage imageNamed:@"Connect-Gold"];
    connectImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *playText = [[UILabel alloc] init];
    playText.textColor = [UIColor whiteColor];
    playText.text = @"Play - Have fun! Do an activity that you enjoy";
    playText.font = [UIFont systemFontOfSize:16.0];
    playText.lineBreakMode = NSLineBreakByWordWrapping;
    playText.numberOfLines = 0;
    playText.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *playImageView = [[UIImageView alloc] init];
    playImageView.image = [UIImage imageNamed:@"Play-Gold"];
    playImageView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *bronzeBadgeText = [[UILabel alloc] init];
    bronzeBadgeText.textColor = [UIColor whiteColor];
    bronzeBadgeText.text = @"Achieve a Bronze badge by completing an activity for 6 days in 1 week";
    bronzeBadgeText.font = [UIFont systemFontOfSize:16.0];
    bronzeBadgeText.textAlignment = NSTextAlignmentCenter;
    bronzeBadgeText.lineBreakMode = NSLineBreakByWordWrapping;
    bronzeBadgeText.numberOfLines = 0;
    bronzeBadgeText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *silverBadgeText = [[UILabel alloc] init];
    silverBadgeText.textColor = [UIColor whiteColor];
    silverBadgeText.text = @"Achieve any Silver Badge by completing any acitivity for 12 days in 2 weeks";
    silverBadgeText.font = [UIFont systemFontOfSize:16.0];
    silverBadgeText.textAlignment = NSTextAlignmentCenter;
    silverBadgeText.lineBreakMode = NSLineBreakByWordWrapping;
    silverBadgeText.numberOfLines = 0;
    silverBadgeText.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *goldBadgeText = [[UILabel alloc] init];
    goldBadgeText.textColor = [UIColor whiteColor];
    goldBadgeText.text = @"Achieve any Gold Badge by completing any activity for 18 days in 3 weeks";
    goldBadgeText.font = [UIFont systemFontOfSize:16.0];
    goldBadgeText.textAlignment = NSTextAlignmentCenter;
    goldBadgeText.lineBreakMode = NSLineBreakByWordWrapping;
    goldBadgeText.numberOfLines = 0;
    goldBadgeText.translatesAutoresizingMaskIntoConstraints = NO;

    TTTAttributedLabel *moreInfoLabel = [[TTTAttributedLabel alloc] init];
    moreInfoLabel.delegate = self;
    moreInfoLabel.textColor = [UIColor whiteColor];
    moreInfoLabel.font = [UIFont systemFontOfSize:16.0];
    moreInfoLabel.textAlignment = NSTextAlignmentLeft;
    moreInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    moreInfoLabel.numberOfLines = 0;
    moreInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    moreInfoLabel.linkAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0],
                                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    moreInfoLabel.activeLinkAttributes = moreInfoLabel.linkAttributes;
    moreInfoLabel.inactiveLinkAttributes = moreInfoLabel.linkAttributes;
    moreInfoLabel.text = @"Find out more about how MiYo works by going to http://SpunOut.ie/MiYo";
    [moreInfoLabel addLinkToURL:[NSURL URLWithString:@"http://SpunOut.ie/MiYo"] withRange:[moreInfoLabel.text rangeOfString:@"http://SpunOut.ie/MiYo"]];

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
    [contentView addSubview:bronzeBadgeText];
    [contentView addSubview:silverBadgeText];
    [contentView addSubview:goldBadgeText];
    [contentView addSubview:moreInfoLabel];

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
                            @"playImageView": playImageView,
                            @"bronzeBadgeText": bronzeBadgeText,
                            @"silverBadgeText": silverBadgeText,
                            @"goldBadgeText": goldBadgeText,
                            @"moreInfoLabel": moreInfoLabel};

    NSDictionary *metrics = @{@"padding": @10,
                              @"textSpacing": @25,
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

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[connectText]-(textSpacing)-[playText]"
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

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[playText]-(textSpacing)-[bronzeBadgeText]-(textSpacing)-[silverBadgeText]-(textSpacing)-[goldBadgeText]"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[goldBadgeText]-(textSpacing)-[moreInfoLabel]-(40)-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[bronzeBadgeText]-(padding)-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[silverBadgeText]-(padding)-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[goldBadgeText]-(padding)-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[moreInfoLabel]-(padding)-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];
}

- (void)done
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];

}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
