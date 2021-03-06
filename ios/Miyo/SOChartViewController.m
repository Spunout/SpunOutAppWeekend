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
#import "SOTutorialViewController.h"
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
@property (nonatomic, strong) UILabel *explainLabel;
@property (nonatomic, strong) UILabel *currentLevelLabel;
@property (nonatomic, strong) UILabel *nextLevelLabel;
@property (nonatomic, strong) UIProgressView *levelProgress;

@end

@implementation SOChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedButtonTag = -1;
    self.title = @"Activity";
    
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
    
    self.explainLabel = [[UILabel alloc] init];
    self.explainLabel.text = @"The Graph plots your health points over time. Select an activity to filter to just health points for that activity. The level indicator shows how close you are to progressing to the next level. It is based on how well you do in your activities.";
    self.explainLabel.textColor = [UIColor whiteColor];
    self.explainLabel.textAlignment = NSTextAlignmentCenter;
    self.explainLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.explainLabel.numberOfLines = 0;
    self.explainLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.explainLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSInteger currentExp = [[SOMiyoDatabase sharedInstance] getCurrentLifetimePoints];
    float nextLevelExp = [[NSUserDefaults standardUserDefaults] floatForKey:@"next_level_exp"];
    float currentLevel = [[NSUserDefaults standardUserDefaults] floatForKey:@"current_level"];
    
    self.levelProgress = [[UIProgressView alloc] init];
    self.levelProgress.progressTintColor = [UIColor greenColor];
    [self.levelProgress setProgress:currentExp / nextLevelExp];
    [self.levelProgress setTransform:CGAffineTransformMakeScale(1.0,6.0)];
    self.levelProgress.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.currentLevelLabel = [[UILabel alloc] init];
    self.currentLevelLabel.text = [NSString stringWithFormat:@"%ld", (long)currentLevel];
    self.currentLevelLabel.textColor = [UIColor whiteColor];
    self.currentLevelLabel.textAlignment = NSTextAlignmentCenter;
    self.currentLevelLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.currentLevelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.nextLevelLabel = [[UILabel alloc] init];
    self.nextLevelLabel.text = [NSString stringWithFormat:@"%ld", (long)currentLevel+1];
    self.nextLevelLabel.textColor = [UIColor whiteColor];
    self.nextLevelLabel.textAlignment = NSTextAlignmentCenter;
    self.nextLevelLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.nextLevelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
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
    self.activities = @[@"eat", @"sleep", @"exercise", @"learn", @"connect", @"play"];
    
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
    
    
    SOActivityButton *connectActivityButton = [[SOActivityButton alloc] initWithTitle:@"Connect" image:[UIImage imageNamed:@"talk"]];
    connectActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    connectActivityButton.tag = 4;
    [self.buttons addObject:connectActivityButton];
    
    [connectActivityButton addTarget:self
                              action:@selector(legendButtonTapped:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    SOActivityButton *playActivityButton = [[SOActivityButton alloc] initWithTitle:@"Play" image:[UIImage imageNamed:@"play"]];
    playActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    playActivityButton.tag = 5;
    [self.buttons addObject:playActivityButton];
    
    [playActivityButton addTarget:self
                           action:@selector(legendButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, _lineChartView, _buttonCollectionView, _levelProgress, _currentLevelLabel, _nextLevelLabel, chartRangeSwitcher, _explainLabel);
    
    [self.view addSubview:scrollView];
    [scrollView addSubview:self.lineChartView];
    [scrollView addSubview:self.buttonCollectionView];
    [scrollView addSubview:self.levelProgress];
    [scrollView addSubview:self.nextLevelLabel];
    [scrollView addSubview:self.currentLevelLabel];
    [scrollView addSubview:chartRangeSwitcher];
    [scrollView addSubview:self.explainLabel];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[_lineChartView(250)]-(20)-[chartRangeSwitcher]-(20)-[_buttonCollectionView(140)]-(10)-[_levelProgress]-(-16)-[_currentLevelLabel]-(-22)-[_nextLevelLabel]-(20)-[_explainLabel]-(40)-|"
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
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_explainLabel]-(20)-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[chartRangeSwitcher]-(13)-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_currentLevelLabel]-(10)-[_levelProgress]-(10)-[_nextLevelLabel]-(20)-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
    
    
    
    chartRangeSwitcher.selectedSegmentIndex = 0;
    self.chartFromDay = 0;
    self.chartToDay = 7;
    self.footerView.leftLabel.text = @"7 Days Ago";
    self.footerView.rightLabel.text = @"Today";
    [self updateData];
    [self.lineChartView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSInteger currentExp = [[SOMiyoDatabase sharedInstance] getCurrentLifetimePoints];
    float nextLevelExp = [[NSUserDefaults standardUserDefaults] floatForKey:@"next_level_exp"];
    float currentLevel = [[NSUserDefaults standardUserDefaults] floatForKey:@"current_level"];
    
    
    [self.levelProgress setProgress:currentExp / nextLevelExp];
    
    self.currentLevelLabel.text = [NSString stringWithFormat:@"%ld", (long)currentLevel];
    
    self.nextLevelLabel.text = [NSString stringWithFormat:@"%ld", (long)currentLevel+1];
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
            self.chartToDay = 14;
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
            self.chartToDay = 100;
            self.footerView.leftLabel.text = @"";
            self.footerView.rightLabel.text = @"Today";
            
            
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

- (void)didTapTutorialButton
{
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[SOTutorialViewController alloc] init]]
                       animated:YES
                     completion:nil];
}

#pragma mark - line chart methods


- (NSInteger)numberOfPointsInLineChartView:(JBLineChartView *)lineChartView
{
    return ([self.activityCounts count] > 0) ? self.chartToDay - self.chartFromDay : 0;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView heightForIndex:(NSInteger)index
{
    float height;
    
    if (index > ([self.activityCounts count]-1))
    {
        height = 0;
    } else {
        height = [[self.activityCounts objectAtIndex:([self.activityCounts count]-1-index)] floatValue];
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
