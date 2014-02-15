//
//  SOMainViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#import "SOMainViewController.h"
#import "SOPointMeterView.h"
#import "SOActivityButton.h"

#import "UIColor+Miyo.h"

static NSString *const kButtonCollectionViewCellIdentifier = @"ButtonCollectionViewCellIdentifier";

@interface SOMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SOPointMeterView *pointMeterView;

@property (nonatomic, strong) UILabel *moodLabel;
@property (nonatomic, strong) UISlider *moodSlider;

@property (nonatomic, strong) UICollectionView *buttonCollectionView;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) SOActivityButton *eatActivityButton;
@property (nonatomic, strong) SOActivityButton *sleepActivityButton;
@property (nonatomic, strong) SOActivityButton *exerciseActivityButton;
@property (nonatomic, strong) SOActivityButton *learnActivityButton;
@property (nonatomic, strong) SOActivityButton *talkActivityButton;
@property (nonatomic, strong) SOActivityButton *makeActivityButton;
@property (nonatomic, strong) SOActivityButton *playActivityButton;
@property (nonatomic, strong) SOActivityButton *connectActivityButton;

@end

@implementation SOMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    BOOL hasLoggedActivities = YES;

    NSDate *lastScoreUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_score_update"];
    if (lastScoreUpdate) {
        NSDate *now = [NSDate date];

        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *comp1 = [[NSCalendar currentCalendar] components:unitFlags fromDate:lastScoreUpdate];
        NSDateComponents *comp2 = [[NSCalendar currentCalendar] components:unitFlags fromDate:now];

        hasLoggedActivities = [comp1 day] != [comp2 day];
    }

    self.view.backgroundColor = [UIColor miyoBlue];

    UIView *pointMeterContainer = [[UIView alloc] init];
    pointMeterContainer.translatesAutoresizingMaskIntoConstraints = NO;

    self.pointMeterView = [[SOPointMeterView alloc] init];
    self.pointMeterView.maximumValue = 500;
    self.pointMeterView.minimumValue = 0;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"score"]) {
        self.pointMeterView.currentValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
    }
    else {
        self.pointMeterView.currentValue = 150;
    }
    self.pointMeterView.translatesAutoresizingMaskIntoConstraints = NO;

    self.moodLabel = [[UILabel alloc] init];
    if (hasLoggedActivities) {
        self.moodLabel.text = @"HOW ARE YOU FEELING?";
    }
    else {
        self.moodLabel.text = @"WHAT ELSE HAVE YOU DONE TODAY?";
    }
    self.moodLabel.textColor = [UIColor whiteColor];
    self.moodLabel.textAlignment = NSTextAlignmentCenter;
    self.moodLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.moodLabel.numberOfLines = 0;
    self.moodLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.moodSlider = [[UISlider alloc] init];
    self.moodSlider.value = 0.5;
    self.moodSlider.minimumTrackTintColor = [UIColor whiteColor];
    self.moodSlider.maximumTrackTintColor = [UIColor miyoLightBlue];
    self.moodSlider.minimumValueImage = [UIImage imageNamed:@"smiley-sad"];
    self.moodSlider.maximumValueImage = [UIImage imageNamed:@"smiley-happy"];
    self.moodSlider.translatesAutoresizingMaskIntoConstraints = NO;

    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.itemSize = CGSizeMake(60.0f, 60.0f);
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0.0, 16.0, 0, 16.0);
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.buttonCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:collectionViewLayout];
    self.buttonCollectionView.delegate = self;
    self.buttonCollectionView.dataSource = self;
    self.buttonCollectionView.backgroundColor = [UIColor clearColor];
    self.buttonCollectionView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.buttonCollectionView registerClass:[UICollectionViewCell class]
                  forCellWithReuseIdentifier:kButtonCollectionViewCellIdentifier];

    self.buttons = [[NSMutableArray alloc] init];

    self.eatActivityButton = [[SOActivityButton alloc] initWithTitle:@"Eat Well" image:[UIImage imageNamed:@"eat"]];
    self.eatActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.eatActivityButton.tag = 1;
    [self.buttons addObject:self.eatActivityButton];

    [self.eatActivityButton addTarget:self
                               action:@selector(didTapActivityButton:)
                     forControlEvents:UIControlEventTouchUpInside];

    self.sleepActivityButton = [[SOActivityButton alloc] initWithTitle:@"Slept Well" image:[UIImage imageNamed:@"sleep"]];
    self.sleepActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.sleepActivityButton.tag = 2;
    [self.buttons addObject:self.sleepActivityButton];

    [self.sleepActivityButton addTarget:self
                                 action:@selector(didTapActivityButton:)
                       forControlEvents:UIControlEventTouchUpInside];

    self.exerciseActivityButton = [[SOActivityButton alloc] initWithTitle:@"Exercise" image:[UIImage imageNamed:@"exercise"]];
    self.exerciseActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.exerciseActivityButton.tag = 3;
    [self.buttons addObject:self.exerciseActivityButton];

    [self.exerciseActivityButton addTarget:self
                                    action:@selector(didTapActivityButton:)
                          forControlEvents:UIControlEventTouchUpInside];

    self.learnActivityButton = [[SOActivityButton alloc] initWithTitle:@"Learn" image:[UIImage imageNamed:@"learn"]];
    self.learnActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.learnActivityButton.tag = 4;
    [self.buttons addObject:self.learnActivityButton];

    [self.learnActivityButton addTarget:self
                                 action:@selector(didTapActivityButton:)
                       forControlEvents:UIControlEventTouchUpInside];

    self.talkActivityButton = [[SOActivityButton alloc] initWithTitle:@"Talk" image:[UIImage imageNamed:@"talk"]];
    self.talkActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.talkActivityButton.tag = 5;
    [self.buttons addObject:self.talkActivityButton];

    [self.talkActivityButton addTarget:self
                                action:@selector(didTapActivityButton:)
                      forControlEvents:UIControlEventTouchUpInside];

    self.makeActivityButton = [[SOActivityButton alloc] initWithTitle:@"Make" image:[UIImage imageNamed:@"make"]];
    self.makeActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.makeActivityButton.tag = 6;
    [self.buttons addObject:self.makeActivityButton];

    [self.makeActivityButton addTarget:self
                                action:@selector(didTapActivityButton:)
                      forControlEvents:UIControlEventTouchUpInside];

    self.connectActivityButton = [[SOActivityButton alloc] initWithTitle:@"Connect" image:[UIImage imageNamed:@"connect"]];
    self.connectActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.connectActivityButton.tag = 7;
    [self.buttons addObject:self.connectActivityButton];

    [self.connectActivityButton addTarget:self
                                   action:@selector(didTapActivityButton:)
                         forControlEvents:UIControlEventTouchUpInside];

    self.playActivityButton = [[SOActivityButton alloc] initWithTitle:@"Play" image:[UIImage imageNamed:@"play"]];
    self.playActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.playActivityButton.tag = 8;
    [self.buttons addObject:self.playActivityButton];

    [self.playActivityButton addTarget:self
                                action:@selector(didTapActivityButton:)
                      forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:pointMeterContainer];
    [pointMeterContainer addSubview:self.pointMeterView];
    [self.view addSubview:self.moodLabel];
    [self.view addSubview:self.moodSlider];
    [self.view addSubview:self.buttonCollectionView];

    NSDictionary *views = @{@"pointMeterContainer": pointMeterContainer,
                            @"pointMeterView": self.pointMeterView,
                            @"moodLabel": self.moodLabel,
                            @"moodSlider": self.moodSlider,
                            @"buttonCollectionView": self.buttonCollectionView};

    NSDictionary *metrics = @{@"buttonWidth": @150};

    [pointMeterContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(50)-[pointMeterView]-(50)-|"
                                                                                options:0
                                                                                metrics:metrics
                                                                                  views:views]];

    [pointMeterContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.pointMeterView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.pointMeterView
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0
                                                                     constant:0.0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pointMeterView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:pointMeterContainer
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[pointMeterContainer]-[moodLabel(17)]-(20)-[moodSlider(20)]-(20)-[buttonCollectionView(140)]-(>=10)-|"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pointMeterContainer]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[moodLabel]-(20)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[moodSlider]-(20)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonCollectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.buttons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kButtonCollectionViewCellIdentifier forIndexPath:indexPath];

    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }

    SOActivityButton *button = self.buttons[indexPath.row];
    button.frame = cell.contentView.frame;
    [cell.contentView addSubview:button];

    return cell;
}

#pragma mark - Activity Logging

- (void)didTapActivityButton:(UIButton *)button
{
    NSInteger points;

    switch (button.tag) {
        case 1:
        case 2:
            points = 7;
            break;
        case 7:
        case 8:
            points = 5;
            break;
        default:
            points = 6;
            break;
    }

    if (button.isSelected) {
        self.pointMeterView.currentValue += points;
    }
    else {
        self.pointMeterView.currentValue -= points;
    }

    NSMutableArray *selectedIndexes = [NSMutableArray array];

    for (UIButton *button in self.buttons) {
        [selectedIndexes addObject:[NSNumber numberWithBool:button.isSelected]];
    }
}

@end
