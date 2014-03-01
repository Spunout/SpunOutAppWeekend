//
//  SOMainViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "SOMainViewController.h"
#import "SOChartViewController.h"
#import "SOPointMeterView.h"
#import "SOActivityButton.h"
#import "SOMiyoDatabase.h"

#import "UIColor+Miyo.h"

static NSString *const kButtonCollectionViewCellIdentifier = @"ButtonCollectionViewCellIdentifier";

@interface SOMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic, strong) SOPointMeterView *pointMeterView;

@property (nonatomic, strong) UILabel *moodLabel;

@property (nonatomic, strong) UICollectionView *buttonCollectionView;

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation SOMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *selectedActivites = [[SOMiyoDatabase sharedInstance] getLastSelectedActivites];

    self.view.backgroundColor = [UIColor miyoBlue];

    self.pointMeterView = [[SOPointMeterView alloc] init];
    self.pointMeterView.maximumValue = 500;
    self.pointMeterView.minimumValue = 0;
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"score"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:150 forKey:@"score"];
    }
    self.pointMeterView.currentValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
    self.pointMeterView.translatesAutoresizingMaskIntoConstraints = NO;

    self.moodLabel = [[UILabel alloc] init];
    self.moodLabel.text = @"WHAT HAVE YOU DONE TODAY?";
    self.moodLabel.textColor = [UIColor whiteColor];
    self.moodLabel.textAlignment = NSTextAlignmentCenter;
    self.moodLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.moodLabel.numberOfLines = 0;
    self.moodLabel.translatesAutoresizingMaskIntoConstraints = NO;

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

    SOActivityButton *eatActivityButton = [[SOActivityButton alloc] initWithTitle:@"Eat Well" image:[UIImage imageNamed:@"eat"]];
    eatActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    eatActivityButton.tag = 0;
    [self.buttons addObject:eatActivityButton];

    [eatActivityButton addTarget:self
                          action:@selector(didTapActivityButton:)
                forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *sleepActivityButton = [[SOActivityButton alloc] initWithTitle:@"Slept Well" image:[UIImage imageNamed:@"sleep"]];
    sleepActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    sleepActivityButton.tag = 1;
    [self.buttons addObject:sleepActivityButton];

    [sleepActivityButton addTarget:self
                            action:@selector(didTapActivityButton:)
                  forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *exerciseActivityButton = [[SOActivityButton alloc] initWithTitle:@"Exercise" image:[UIImage imageNamed:@"exercise"]];
    exerciseActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    exerciseActivityButton.tag = 2;
    [self.buttons addObject:exerciseActivityButton];

    [exerciseActivityButton addTarget:self
                               action:@selector(didTapActivityButton:)
                     forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *learnActivityButton = [[SOActivityButton alloc] initWithTitle:@"Learn" image:[UIImage imageNamed:@"learn"]];
    learnActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    learnActivityButton.tag = 3;
    [self.buttons addObject:learnActivityButton];

    [learnActivityButton addTarget:self
                            action:@selector(didTapActivityButton:)
                  forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *talkActivityButton = [[SOActivityButton alloc] initWithTitle:@"Talk" image:[UIImage imageNamed:@"talk"]];
    talkActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    talkActivityButton.tag = 4;
    [self.buttons addObject:talkActivityButton];

    [talkActivityButton addTarget:self
                           action:@selector(didTapActivityButton:)
                 forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *makeActivityButton = [[SOActivityButton alloc] initWithTitle:@"Make" image:[UIImage imageNamed:@"make"]];
    makeActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    makeActivityButton.tag = 5;
    [self.buttons addObject:makeActivityButton];

    [makeActivityButton addTarget:self
                           action:@selector(didTapActivityButton:)
                 forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *connectActivityButton = [[SOActivityButton alloc] initWithTitle:@"Connect" image:[UIImage imageNamed:@"connect"]];
    connectActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    connectActivityButton.tag = 6;
    [self.buttons addObject:connectActivityButton];

    [connectActivityButton addTarget:self
                              action:@selector(didTapActivityButton:)
                    forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *playActivityButton = [[SOActivityButton alloc] initWithTitle:@"Play" image:[UIImage imageNamed:@"play"]];
    playActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    playActivityButton.tag = 7;
    [self.buttons addObject:playActivityButton];
    
    [playActivityButton addTarget:self
                           action:@selector(didTapActivityButton:)
                 forControlEvents:UIControlEventTouchUpInside];

    if (selectedActivites) {
        for (NSInteger i = 0; i < self.buttons.count; i++) {
            SOActivityButton *button = self.buttons[i];
            button.selected = [(NSNumber *)selectedActivites[i] boolValue];
        }
    }

    UIView *spacer1 = [[UIView alloc] init];
    spacer1.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *spacer2 = [[UIView alloc] init];
    spacer2.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *spacer3 = [[UIView alloc] init];
    spacer3.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.pointMeterView];
    [self.view addSubview:self.moodLabel];
    [self.view addSubview:self.buttonCollectionView];
    [self.view addSubview:spacer1];
    [self.view addSubview:spacer2];
    [self.view addSubview:spacer3];

    NSDictionary *views = NSDictionaryOfVariableBindings(_pointMeterView,
                                                         _moodLabel,
                                                         _buttonCollectionView,
                                                         spacer1,
                                                         spacer2,
                                                         spacer3);

    NSDictionary *metrics = @{@"buttonWidth": @150};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(56)-[_pointMeterView]-(56)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pointMeterView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.pointMeterView
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spacer3
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:spacer2
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:0.0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spacer1
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:spacer2
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:0.0]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[spacer1]-[_pointMeterView]-[spacer2]-[_moodLabel(17)]-[_buttonCollectionView(140)]-[spacer3]|"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_moodLabel]-(20)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonCollectionView]|"
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
        case 0:
        case 1:
        case 4:
        case 7:
            points = 7;
            break;
        default:
            points = 5;
            break;
    }

    if (button.isSelected) {
        self.pointMeterView.currentValue += points;
    }
    else {
        self.pointMeterView.currentValue -= points;
    }

    [[NSUserDefaults standardUserDefaults] setInteger:self.pointMeterView.currentValue forKey:@"score"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self logActivites];
}

- (void)logActivites
{
    NSMutableArray *selectedActivities = [NSMutableArray array];
    NSInteger points = 0;

    for (UIButton *button in self.buttons) {


        if (button.isSelected) {
            switch (button.tag) {
                case 0:
                case 1:
                case 4:
                case 7:
                    points += 7;
                    break;
                default:
                    points += 5;
                    break;
            }
        }

        [selectedActivities addObject:[NSNumber numberWithBool:button.isSelected]];
    }

    [[SOMiyoDatabase sharedInstance] insertOrUpdateMood:0
                                             activities:selectedActivities
                                           earnedPoints:points];
}


@end
