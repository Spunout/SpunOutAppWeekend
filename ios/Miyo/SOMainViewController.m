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
#import "SOTutorialViewController.h"
#import "SOAppDelegate.h"

#import "UIColor+Miyo.h"

static NSString *const kButtonCollectionViewCellIdentifier = @"ButtonCollectionViewCellIdentifier";

@interface SOMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic, strong) SOPointMeterView *pointMeterView;

@property (nonatomic, strong) UILabel *moodLabel;
@property (nonatomic, strong) UILabel *logLabel;

@property (nonatomic, strong) UISlider *activitySlider;
@property (nonatomic, strong) UIView *logActivitiesButton;

@property (nonatomic, strong) UICollectionView *buttonCollectionView;

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation SOMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor miyoBlue];

    UIButton *tutorialButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    tutorialButton.frame = CGRectMake(10.0, 30.0, 20.0, 20.0);
    tutorialButton.tintColor = [UIColor whiteColor];
    [tutorialButton setTitle:@"Help" forState:UIControlStateNormal];
    [tutorialButton addTarget:self action:@selector(didTapTutorialButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tutorialButton];

    self.pointMeterView = [[SOPointMeterView alloc] init];
    self.pointMeterView.maximumValue = 500;
    self.pointMeterView.minimumValue = 0;
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"score"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"score"];
    }
    self.pointMeterView.currentValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
    self.pointMeterView.translatesAutoresizingMaskIntoConstraints = NO;

    self.activitySlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 290, 270,30)];
    [self.view addSubview: self.activitySlider];
    [self.activitySlider setHidden:YES];
    
    self.logActivitiesButton = [[UIView alloc] initWithFrame:CGRectMake(20, 330, 270, 100)];
    self.logActivitiesButton.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *logActivitiesButtonTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logActivitiesButtonTapped:)];
    [self.logActivitiesButton addGestureRecognizer:logActivitiesButtonTapped];
    
    [self.view addSubview:self.logActivitiesButton];
    [self.logActivitiesButton setHidden:YES];
    
    self.logLabel = [[UILabel alloc] init];
    
    self.logLabel.text = @"Log";
    self.logLabel.textColor =  [UIColor miyoBlue];
    self.logLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.logLabel.frame = CGRectMake(140, 355, 100, 50);
    [self.view addSubview:self.logLabel];
    [self.logLabel setHidden:YES];
    
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

    SOActivityButton *sleepActivityButton = [[SOActivityButton alloc] initWithTitle:@"Sleep Well" image:[UIImage imageNamed:@"sleep"]];
    sleepActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    sleepActivityButton.tag = 1;
    [self.buttons addObject:sleepActivityButton];

    [sleepActivityButton addTarget:self
                            action:@selector(didTapActivityButton:)
                  forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *exerciseActivityButton = [[SOActivityButton alloc] initWithTitle:@"Move" image:[UIImage imageNamed:@"exercise"]];
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

    SOActivityButton *connectActivityButton = [[SOActivityButton alloc] initWithTitle:@"Connect" image:[UIImage imageNamed:@"talk"]];
    connectActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    connectActivityButton.tag = 4;
    [self.buttons addObject:connectActivityButton];

    [connectActivityButton addTarget:self
                              action:@selector(didTapActivityButton:)
                    forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *playActivityButton = [[SOActivityButton alloc] initWithTitle:@"Play" image:[UIImage imageNamed:@"play"]];
    playActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    playActivityButton.tag = 5;
    [self.buttons addObject:playActivityButton];
    
    [playActivityButton addTarget:self
                           action:@selector(didTapActivityButton:)
                 forControlEvents:UIControlEventTouchUpInside];

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

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_buttonCollectionView]-(20)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    BOOL tutorialDate = [[NSUserDefaults standardUserDefaults] boolForKey:@"shown_tutorial"];
    if (!tutorialDate) {
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:@"shown_tutorial"];

        [self.tabBarController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[SOTutorialViewController alloc] init]]
                                            animated:YES
                                          completion:nil];
    }

    NSArray *selectedActivites = [[SOMiyoDatabase sharedInstance] getLastSelectedActivites];

    if (selectedActivites) {
        for (NSInteger i = 0; i < self.buttons.count; i++) {
            SOActivityButton *button = self.buttons[i];
            button.selected = [(NSNumber *)selectedActivites[i] boolValue];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didTapTutorialButton
{
    [self.tabBarController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[SOTutorialViewController alloc] init]]
                                        animated:YES
                                      completion:nil];
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
    [[NSUserDefaults standardUserDefaults] setInteger:button.tag forKey:@"currentButtonTag"];
    [[NSUserDefaults standardUserDefaults] setBool:button.isSelected forKey:@"currentButtonSelected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.buttonCollectionView setHidden:YES];
    [self.activitySlider setHidden:NO];
    [self.logActivitiesButton setHidden:NO];
    [self.logLabel setHidden:NO];
    self.moodLabel.text = [[NSString stringWithFormat:@"How well did you %@?", [button.titleLabel.text stringByReplacingOccurrencesOfString: @" WELL" withString:@""]] lowercaseString];
}

- (IBAction)logActivitiesButtonTapped:(UITapGestureRecognizer *)recognizer {
    
    NSInteger buttonTag = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentButtonTag"];
    BOOL buttonSelected = [[NSUserDefaults standardUserDefaults] boolForKey:@"currentButtonSelected"];
    NSInteger points;

    switch (buttonTag) {
        case 0:
        case 1:
        case 4:
        case 7:
            points = 7.0f * self.activitySlider.value;
            break;
        default:
            points = 5.0f * self.activitySlider.value;
            break;
    }

    if (buttonSelected) {
        self.pointMeterView.currentValue += points;
    }
    else {
        self.pointMeterView.currentValue -= points;
    }

    [[NSUserDefaults standardUserDefaults] setFloat:self.pointMeterView.currentValue forKey:@"score"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SOActivityButton *button = self.buttons[buttonTag];

    [[SOMiyoDatabase sharedInstance] insertOrUpdateMood:button.titleLabel.text earnedPoints:[[NSNumber alloc] initWithInteger:points] tag:buttonTag];
    
    
    [self.buttonCollectionView setHidden:NO];
    [self.activitySlider setHidden:YES];
    [self.logActivitiesButton setHidden:YES];
    [self.logLabel setHidden:YES];
    self.moodLabel.text = @"WHAT HAVE YOU DONE TODAY?";
}



@end
