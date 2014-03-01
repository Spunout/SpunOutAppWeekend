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
#include <stdlib.h>

static NSString *const kButtonCollectionViewCellIdentifier = @"ButtonCollectionViewCellIdentifier";

// Numerics
CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
CGFloat const kJBLineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
NSInteger const kJBLineChartViewControllerNumChartPoints = 27;


@interface SOChartViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

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

@implementation SOChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Activity Chart";
    
    self.view.backgroundColor = [UIColor miyoBlue];
    
    JBLineChartView *lineChartView = [[JBLineChartView alloc] initWithFrame:CGRectMake(5.0, 20.0, 310.0, 280.0)];
    lineChartView.delegate = self;
    lineChartView.dataSource = self;
    
    SOChartFooter *footerView = [[SOChartFooter alloc] initWithFrame:CGRectMake(5.0, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (5.0 * 2), kJBLineChartViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = @"Earliest";
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = @"Latest";
    footerView.rightLabel.textColor = [UIColor whiteColor];
    footerView.sectionCount = kJBLineChartViewControllerNumChartPoints;
    lineChartView.footerView = footerView;
    
    [self.view addSubview: lineChartView];
    [lineChartView reloadData];
    
    UIProgressView *levelProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(20.0,410.0,280.0,40.0)];
    levelProgress.progressTintColor = [UIColor greenColor];
    [levelProgress setProgress:0.5];
    [self.view addSubview:levelProgress];
    
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 370.0, 270.0, 50.0)];
    levelLabel.text = @"YOUR LEVEL PROGRESS";
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self.view addSubview:levelLabel];

    
    // buttons
    
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
    self.eatActivityButton.tag = 0;
    [self.buttons addObject:self.eatActivityButton];
    
    [self.eatActivityButton addTarget:self
                               action:@selector(didTapActivityButton:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    self.sleepActivityButton = [[SOActivityButton alloc] initWithTitle:@"Slept Well" image:[UIImage imageNamed:@"sleep"]];
    self.sleepActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.sleepActivityButton.tag = 1;
    [self.buttons addObject:self.sleepActivityButton];
    
    [self.sleepActivityButton addTarget:self
                                 action:@selector(didTapActivityButton:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    self.exerciseActivityButton = [[SOActivityButton alloc] initWithTitle:@"Exercise" image:[UIImage imageNamed:@"exercise"]];
    self.exerciseActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.exerciseActivityButton.tag = 2;
    [self.buttons addObject:self.exerciseActivityButton];
    
    [self.exerciseActivityButton addTarget:self
                                    action:@selector(didTapActivityButton:)
                          forControlEvents:UIControlEventTouchUpInside];
    
    self.learnActivityButton = [[SOActivityButton alloc] initWithTitle:@"Learn" image:[UIImage imageNamed:@"learn"]];
    self.learnActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.learnActivityButton.tag = 3;
    [self.buttons addObject:self.learnActivityButton];
    
    [self.learnActivityButton addTarget:self
                                 action:@selector(didTapActivityButton:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    self.talkActivityButton = [[SOActivityButton alloc] initWithTitle:@"Talk" image:[UIImage imageNamed:@"talk"]];
    self.talkActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.talkActivityButton.tag = 4;
    [self.buttons addObject:self.talkActivityButton];
    
    [self.talkActivityButton addTarget:self
                                action:@selector(didTapActivityButton:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    self.makeActivityButton = [[SOActivityButton alloc] initWithTitle:@"Make" image:[UIImage imageNamed:@"make"]];
    self.makeActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.makeActivityButton.tag = 5;
    [self.buttons addObject:self.makeActivityButton];
    
    [self.makeActivityButton addTarget:self
                                action:@selector(didTapActivityButton:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    self.connectActivityButton = [[SOActivityButton alloc] initWithTitle:@"Connect" image:[UIImage imageNamed:@"connect"]];
    self.connectActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.connectActivityButton.tag = 6;
    [self.buttons addObject:self.connectActivityButton];
    
    [self.connectActivityButton addTarget:self
                                   action:@selector(didTapActivityButton:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    self.playActivityButton = [[SOActivityButton alloc] initWithTitle:@"Play" image:[UIImage imageNamed:@"play"]];
    self.playActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.playActivityButton.tag = 7;
    [self.buttons addObject:self.playActivityButton];
    
    [self.playActivityButton addTarget:self
                                action:@selector(didTapActivityButton:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    
    NSDictionary *views = @{ @"buttonCollectionView": self.buttonCollectionView };

    [self.view addSubview:self.buttonCollectionView];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonCollectionView]|" options:0 metrics:nil views:views]];
    
    
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - line chart methods


- (NSInteger)numberOfPointsInLineChartView:(JBLineChartView *)lineChartView
{
    return 12;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView heightForIndex:(NSInteger)index
{
    return arc4random() % 74;
}

- (UIColor *)lineColorForLineChartView:(JBLineChartView *)lineChartView
{
    return [UIColor whiteColor];
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

- (void)didTapActivityButton:(UIButton *)button
{
  
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
