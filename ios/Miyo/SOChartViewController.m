//
//  SOChartViewController.m
//  Miyo
//
//  Created by James Eggers on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOChartViewController.h"
#import "SOMainViewController.h"
#import "UIColor+Miyo.h"
#import "JBChartView.h"
#import "JBLineChartView.h"
#import "SOChartHeader.h"
#import "SOChartFooter.h"
#import "SOActivityButton.h"
#import "SOMiyoDatabase.h"
#include <stdlib.h>

static NSString *const kButtonCollectionViewCellIdentifier = @"ButtonCollectionViewCellIdentifier";

// Numerics
CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
CGFloat const kJBLineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight = 25.0f;
NSInteger const kJBLineChartViewControllerNumChartPoints = 4;
NSInteger activityCounts[4];

@interface SOChartViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *buttonCollectionView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, strong) JBLineChartView *lineChartView;

@end

@implementation SOChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Activity Chart";
    
    self.view.backgroundColor = [UIColor miyoBlue];

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake(10.0, 5.0, self.view.bounds.size.width - 20.0, 250.0);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;

    SOChartHeader *headerView = [[SOChartHeader alloc] initWithFrame:CGRectMake(10.0, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (5.0 * 2), kJBLineChartViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = @"Activities Over Time";
    headerView.titleLabel.textColor = [UIColor whiteColor];
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.separatorColor = [UIColor whiteColor];
    self.lineChartView.headerView = headerView;

    SOChartFooter *footerView = [[SOChartFooter alloc] initWithFrame:CGRectMake(10.0, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (5.0 * 2), kJBLineChartViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = @"4 Weeks Ago";
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.leftLabel.font = [UIFont systemFontOfSize:15.0f];
    footerView.rightLabel.text = @"This Week";
    footerView.rightLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.font = [UIFont systemFontOfSize:15.0f];
    footerView.sectionCount = kJBLineChartViewControllerNumChartPoints;
    self.lineChartView.footerView = footerView;

    NSInteger currentExp = [[SOMiyoDatabase sharedInstance] getCurrentLifetimePoints];
    NSInteger nextLevelExp = [[NSUserDefaults standardUserDefaults] integerForKey:@"next_level_exp"];
    NSInteger currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];

    UIProgressView *levelProgress = [[UIProgressView alloc] init];
    levelProgress.progressTintColor = [UIColor greenColor];
    [levelProgress setProgress:currentExp / nextLevelExp];
    levelProgress.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *levelLabel = [[UILabel alloc] init];
    levelLabel.text = @"YOUR LEVEL PROGRESS";
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    levelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *currentLevelLabel = [[UILabel alloc] init];
    NSString *level = @"CURRENT LEVEL: ";
    currentLevelLabel.text = [level stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)currentLevel]];
    currentLevelLabel.textColor = [UIColor whiteColor];
    currentLevelLabel.textAlignment = NSTextAlignmentCenter;
    currentLevelLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    currentLevelLabel.translatesAutoresizingMaskIntoConstraints = NO;

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
    self.activities = @[@"eat", @"sleep", @"exercise", @"learn", @"talk", @"make", @"connect", @"play"];

    SOActivityButton *eatActivityButton = [[SOActivityButton alloc] initWithTitle:@"Eat Well" image:[UIImage imageNamed:@"eat"]];
    eatActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    eatActivityButton.tag = 0;
    [self.buttons addObject:eatActivityButton];

    [eatActivityButton addTarget:self
                          action:@selector(legendButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *sleepActivityButton = [[SOActivityButton alloc] initWithTitle:@"Sleep Well" image:[UIImage imageNamed:@"sleep"]];
    sleepActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    sleepActivityButton.tag = 1;
    [self.buttons addObject:sleepActivityButton];

    [sleepActivityButton addTarget:self
                            action:@selector(legendButtonTapped:)
                  forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *exerciseActivityButton = [[SOActivityButton alloc] initWithTitle:@"Move" image:[UIImage imageNamed:@"exercise"]];
    exerciseActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    exerciseActivityButton.tag = 2;
    [self.buttons addObject:exerciseActivityButton];

    [exerciseActivityButton addTarget:self
                               action:@selector(legendButtonTapped:)
                     forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *learnActivityButton = [[SOActivityButton alloc] initWithTitle:@"Learn" image:[UIImage imageNamed:@"learn"]];
    learnActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    learnActivityButton.tag = 3;
    [self.buttons addObject:learnActivityButton];

    [learnActivityButton addTarget:self
                            action:@selector(legendButtonTapped:)
                  forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *talkActivityButton = [[SOActivityButton alloc] initWithTitle:@"Talk" image:[UIImage imageNamed:@"talk"]];
    talkActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    talkActivityButton.tag = 4;
    [self.buttons addObject:talkActivityButton];

    [talkActivityButton addTarget:self
                           action:@selector(legendButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *makeActivityButton = [[SOActivityButton alloc] initWithTitle:@"Make" image:[UIImage imageNamed:@"make"]];
    makeActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    makeActivityButton.tag = 5;
    [self.buttons addObject:makeActivityButton];

    [makeActivityButton addTarget:self
                           action:@selector(legendButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *connectActivityButton = [[SOActivityButton alloc] initWithTitle:@"Connect" image:[UIImage imageNamed:@"connect"]];
    connectActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    connectActivityButton.tag = 6;
    [self.buttons addObject:connectActivityButton];

    [connectActivityButton addTarget:self
                              action:@selector(legendButtonTapped:)
                    forControlEvents:UIControlEventTouchUpInside];

    SOActivityButton *playActivityButton = [[SOActivityButton alloc] initWithTitle:@"Play" image:[UIImage imageNamed:@"play"]];
    playActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    playActivityButton.tag = 7;
    [self.buttons addObject:playActivityButton];
    
    [playActivityButton addTarget:self
                           action:@selector(legendButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];

    NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, _lineChartView, _buttonCollectionView, levelProgress, levelLabel, currentLevelLabel);

    [self.view addSubview:scrollView];
    [scrollView addSubview:self.lineChartView];
    [scrollView addSubview:self.buttonCollectionView];
    [scrollView addSubview:levelProgress];
    [scrollView addSubview:currentLevelLabel];
    [scrollView addSubview:levelLabel];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[_lineChartView(250)]-(20)-[_buttonCollectionView(140)]-(20)-[currentLevelLabel]-(20)-[levelProgress]-[levelLabel]-(40)-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];

    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonCollectionView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:1.0
                                                            constant:0.0]];

    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonCollectionView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];

    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[levelProgress]-(20)-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[currentLevelLabel]-(20)-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];

    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[levelLabel]-(20)-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
    

    [self.lineChartView reloadData];
}

- (void)legendButtonTapped:(UIButton *)sender
{
    int fromDay, toDay;
    
    for (int i = 0; i < 5; i++)
    {
        fromDay = (i) * 7;
        toDay = (i+1) * 7;
        activityCounts[3-i] = [[SOMiyoDatabase sharedInstance] getCountForActivity:self.activities[sender.tag] fromDay:fromDay toDay:7];
    }
    
    for (NSInteger i = 0; i < self.buttons.count; i++)
    {
        [self.buttons[i] setSelected:NO];
    }
    
    [self.buttons[sender.tag] setSelected:YES];
    
    [self.lineChartView reloadData];
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

#pragma mark - line chart methods


- (NSInteger)numberOfPointsInLineChartView:(JBLineChartView *)lineChartView
{
    return 4;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView heightForIndex:(NSInteger)index
{
    return [[NSNumber numberWithInteger:activityCounts[index]] floatValue];
}

- (UIColor *)lineColorForLineChartView:(JBLineChartView *)lineChartView
{
    return [UIColor whiteColor];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end