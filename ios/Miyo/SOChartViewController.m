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


@interface SOChartViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *buttonCollectionView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic) NSInteger chartToDay;
@property (nonatomic) NSInteger chartFromDay;
@property (nonatomic, strong) NSArray* activityCounts;
@property (nonatomic) NSInteger selectedButtonTag;
@property (nonatomic, strong) SOChartFooter *footerView;

@end

@implementation SOChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedButtonTag = -1;
    self.title = @"Activity Chart";
    
    self.view.backgroundColor = [UIColor miyoBlue];

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake(10.0, 5.0, self.view.bounds.size.width - 20.0, 170.0);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;

    self.footerView = [[SOChartFooter alloc] initWithFrame:CGRectMake(10.0, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (5.0 * 2), kJBLineChartViewControllerChartFooterHeight)];
    self.footerView.backgroundColor = [UIColor clearColor];
    self.footerView.leftLabel.text = @"4 Weeks Ago";
    self.footerView.leftLabel.textColor = [UIColor whiteColor];
    self.footerView.leftLabel.font = [UIFont systemFontOfSize:15.0f];
    self.footerView.rightLabel.text = @"This Week";
    self.footerView.rightLabel.textColor = [UIColor whiteColor];
    self.footerView.rightLabel.font = [UIFont systemFontOfSize:15.0f];
    self.footerView.sectionCount = kJBLineChartViewControllerNumChartPoints;
    self.lineChartView.footerView = self.footerView;


    NSInteger currentExp = [[SOMiyoDatabase sharedInstance] getCurrentLifetimePoints];
    float nextLevelExp = [[NSUserDefaults standardUserDefaults] floatForKey:@"next_level_exp"];
    float currentLevel = [[NSUserDefaults standardUserDefaults] floatForKey:@"current_level"];

    UIProgressView *levelProgress = [[UIProgressView alloc] init];
    levelProgress.progressTintColor = [UIColor greenColor];
    [levelProgress setProgress:currentExp / nextLevelExp];
    [levelProgress setTransform:CGAffineTransformMakeScale(1.0,6.0)];
    levelProgress.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *currentLevelLabel = [[UILabel alloc] init];
    currentLevelLabel.text = [NSString stringWithFormat:@"%ld", (long)currentLevel];
    currentLevelLabel.textColor = [UIColor whiteColor];
    currentLevelLabel.textAlignment = NSTextAlignmentCenter;
    currentLevelLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    currentLevelLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *nextLevelLabel = [[UILabel alloc] init];
    nextLevelLabel.text = [NSString stringWithFormat:@"%ld", (long)currentLevel+1];
    nextLevelLabel.textColor = [UIColor whiteColor];
    nextLevelLabel.textAlignment = NSTextAlignmentCenter;
    nextLevelLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    nextLevelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UISegmentedControl *chartRangeSwitcher = [[UISegmentedControl alloc] initWithItems:@[@"Past Week", @"Prev. Week", @"Last Month", @"All Time"]];
    chartRangeSwitcher.translatesAutoresizingMaskIntoConstraints = NO;
    [chartRangeSwitcher addTarget:self action:@selector(didChangeDateRange:) forControlEvents:UIControlEventValueChanged];
    
    
    
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

    NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, _lineChartView, _buttonCollectionView, levelProgress, currentLevelLabel, nextLevelLabel, chartRangeSwitcher);

    [self.view addSubview:scrollView];
    [scrollView addSubview:self.lineChartView];
    [scrollView addSubview:self.buttonCollectionView];
    [scrollView addSubview:levelProgress];
    [scrollView addSubview:nextLevelLabel];
    [scrollView addSubview:currentLevelLabel];
    [scrollView addSubview:chartRangeSwitcher];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[_lineChartView(250)]-(20)-[chartRangeSwitcher]-(20)-[_buttonCollectionView(140)]-(10)-[levelProgress]-(-16)-[currentLevelLabel]-(-22)-[nextLevelLabel]-(40)-|"
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

    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[chartRangeSwitcher]-(15)-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[currentLevelLabel]-(10)-[levelProgress]-(10)-[nextLevelLabel]-(20)-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
    
  

    [self.lineChartView reloadData];
}

- (void)didChangeDateRange:(UISegmentedControl*)dateRangeSelector
{
    NSInteger selectedIndex = dateRangeSelector.selectedSegmentIndex;

    switch(selectedIndex)
    {
        case 0:
            self.chartFromDay = 0;
            self.chartToDay = 7;
            self.footerView.leftLabel.text = @"7 Days Ago";
            self.footerView.rightLabel.text = @"Today";
            break;
        case 1:
            self.chartFromDay = 7;
            self.chartToDay = 7;
            self.footerView.leftLabel.text = @"14 Days Ago";
            self.footerView.rightLabel.text = @"7 Days Ago";
            break;
        case 2:
            self.chartFromDay = 0;
            self.chartToDay = 30;
            self.footerView.leftLabel.text = @"30 Days Ago";
            self.footerView.rightLabel.text = @"Today";
            break;
        case 3:
            self.chartFromDay = 0;
            self.chartToDay = 50;

            
            break;
        default:
            self.chartFromDay = 0;
            self.chartToDay = 7;
            break;
    }
    
    [self updateData];
}

- (void)legendButtonTapped:(UIButton *)sender
{
    self.selectedButtonTag = sender.tag;
    
    for (NSInteger i = 0; i < self.buttons.count; i++)
    {
        [self.buttons[i] setSelected:NO];
    }
    
    [self.buttons[sender.tag] setSelected:YES];
    
    [self updateData];
}

- (void)updateData
{
    
    if (self.selectedButtonTag != -1)
    {
        self.activityCounts = [[SOMiyoDatabase sharedInstance] getDaysData:self.activities[self.selectedButtonTag] fromDay:self.chartFromDay toDay:self.chartToDay];
    } else {
        self.activityCounts = [[SOMiyoDatabase sharedInstance] getDaysData:@"" fromDay:self.chartFromDay toDay:self.chartToDay];
    }
    
    self.activityCounts = [[self.activityCounts reverseObjectEnumerator] allObjects];
    
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
    return self.chartToDay - self.chartFromDay;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView heightForIndex:(NSInteger)index
{
    float height;
    
    if (index > ([self.activityCounts count]-1))
    {
        height = 0;
    } else {
        height = [[self.activityCounts objectAtIndex:index] floatValue];
    }
    
    return height;
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
