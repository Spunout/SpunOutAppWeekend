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
CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
NSInteger const kJBLineChartViewControllerNumChartPoints = 27;
NSInteger activityCounts[4];

@interface SOChartViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, strong) JBLineChartView *lineChartView;

@end

@implementation SOChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.pageIndex = 1;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(130.0, 435.0, 60.0, 70.0);
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 2;
    [self.view addSubview:pageControl];
    
    self.view.backgroundColor = [UIColor miyoBlue];
    
    self.lineChartView = [[JBLineChartView alloc] initWithFrame:CGRectMake(5.0, 20.0, 310.0, 280.0)];
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    
    
    SOChartHeader *headerView = [[SOChartHeader alloc] initWithFrame:CGRectMake(5.0, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (5.0 * 2), kJBLineChartViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = @"Your Activity Chart";
    headerView.titleLabel.textColor = [UIColor whiteColor];
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.subtitleLabel.text = @"Volume vs. Time";
    headerView.subtitleLabel.textColor = [UIColor whiteColor];
    headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.separatorColor = [UIColor whiteColor];
    self.lineChartView.headerView = headerView;
    
    SOChartFooter *footerView = [[SOChartFooter alloc] initWithFrame:CGRectMake(5.0, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (5.0 * 2), kJBLineChartViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = @"Earliest";
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = @"Latest";
    footerView.rightLabel.textColor = [UIColor whiteColor];
    footerView.sectionCount = kJBLineChartViewControllerNumChartPoints;
    self.lineChartView.footerView = footerView;
    
    [self.view addSubview: self.lineChartView];
    [self.lineChartView reloadData];
    
    UIProgressView *levelProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(20.0,460.0,280.0,40.0)];
    levelProgress.progressTintColor = [UIColor greenColor];
    [levelProgress setProgress:0.5];
    [self.view addSubview:levelProgress];
    
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 420.0, 270.0, 50.0)];
    levelLabel.text = @"YOUR LEVEL PROGRESS";
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self.view addSubview:levelLabel];


    // graph selector buttons
    
    self.activities = @[@"eat", @"sleep", @"exercise", @"learn", @"talk", @"make", @"connect", @"play"];
    SOActivityButton *activityButton;
    double xOffset, yOffset = 0.0;
    
    for (int i = 0; i < [self.activities count]; i++)
    {
        activityButton = [[SOActivityButton alloc] initWithTitle:[self.activities[i] capitalizedString] image:[UIImage imageNamed:self.activities[i]]];
        activityButton.translatesAutoresizingMaskIntoConstraints = NO;
        activityButton.tag = i;
        if (i>3) { yOffset = 65.0; xOffset = (([self.activities count]-1) - i)*70; } else { xOffset = i*70; }
        activityButton.frame = CGRectMake(20.0+xOffset, 305.0+yOffset, 70.0, 50.0);
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(legendButtonTapped:)];
        [activityButton addGestureRecognizer:tapped];
        [self.view addSubview:activityButton];
    }

    
    
}

- (void)legendButtonTapped:(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    int fromDay, toDay;
    
    for (int i = 0; i < 5; i++)
    {
        fromDay = i * 7;
        toDay = (i+1) * 7;
        activityCounts[i] = [[SOMiyoDatabase sharedInstance] getCountForActivity:self.activities[gesture.view.tag] fromDay:fromDay toDay:toDay];
    }
    
    [self.lineChartView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - line chart methods


- (NSInteger)numberOfPointsInLineChartView:(JBLineChartView *)lineChartView
{
    return sizeof(activityCounts);
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
