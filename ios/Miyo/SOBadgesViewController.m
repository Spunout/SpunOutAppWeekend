//
//  SOBadgesViewController.m
//  Miyo
//
//  Created by Matt Donnelly on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOBadgesViewController.h"
#import "SOMiyoDatabase.h"
#import "SOBadgeTableViewCell.h"
#import "SOTutorialViewController.h"

#import "UIColor+Miyo.h"

static NSString *kSOBadgeCellIdentifier = @"SOBadgeCellIdentifier";

@interface SOBadgesViewController ()

@property (nonatomic, strong) UILabel *explainLabel;

@end

@implementation SOBadgesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Badges";


    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = [UIColor miyoBlue];
    self.tableView.separatorColor = [UIColor colorWithRed:0.15 green:0.64 blue:0.82 alpha:1];
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    [self.tableView registerClass:[SOBadgeTableViewCell class] forCellReuseIdentifier:kSOBadgeCellIdentifier];

    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(130.0, 435.0, 60.0, 70.0);
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 3;
    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOBadgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSOBadgeCellIdentifier forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.badgeLabel.text = @"Food Nut";
        cell.defaultImage = [UIImage imageNamed:@"Eat-Blue"];
        cell.bronzeImage = [UIImage imageNamed:@"Eat-Bronze"];
        cell.silverImage = [UIImage imageNamed:@"Eat-Silver"];
        cell.goldImage = [UIImage imageNamed:@"Eat-Gold"];
        cell.showBronze = [[NSUserDefaults standardUserDefaults] boolForKey:@"eat-bronze"];
        cell.showSilver = [[NSUserDefaults standardUserDefaults] boolForKey:@"eat-silver"];
        cell.showGold = [[NSUserDefaults standardUserDefaults] boolForKey:@"eat-gold"];
    }
    else if (indexPath.row == 1) {
        cell.badgeLabel.text = @"Sleep Star";
        cell.defaultImage = [UIImage imageNamed:@"Sleep-Blue"];
        cell.bronzeImage = [UIImage imageNamed:@"Sleep-Bronze"];
        cell.silverImage = [UIImage imageNamed:@"Sleep-Silver"];
        cell.goldImage = [UIImage imageNamed:@"Sleep-Gold"];
        cell.showBronze = [[NSUserDefaults standardUserDefaults] boolForKey:@"sleep-bronze"];
        cell.showSilver = [[NSUserDefaults standardUserDefaults] boolForKey:@"sleep-silver"];
        cell.showGold = [[NSUserDefaults standardUserDefaults] boolForKey:@"sleep-gold"];
    }
    else if (indexPath.row == 2) {
        cell.badgeLabel.text = @"Active Champion";
        cell.defaultImage = [UIImage imageNamed:@"Exercise-Blue"];
        cell.bronzeImage = [UIImage imageNamed:@"Exercise-Bronze"];
        cell.silverImage = [UIImage imageNamed:@"Exercise-Silver"];
        cell.goldImage = [UIImage imageNamed:@"Exercise-Gold"];
        cell.showBronze = [[NSUserDefaults standardUserDefaults] boolForKey:@"exercise-bronze"];
        cell.showSilver = [[NSUserDefaults standardUserDefaults] boolForKey:@"exercise-silver"];
        cell.showGold = [[NSUserDefaults standardUserDefaults] boolForKey:@"exercise-gold"];
    }
    else if (indexPath.row == 3) {
        cell.badgeLabel.text = @"Wise Owl";
        cell.defaultImage = [UIImage imageNamed:@"Learn-Blue"];
        cell.bronzeImage = [UIImage imageNamed:@"Learn-Bronze"];
        cell.silverImage = [UIImage imageNamed:@"Learn-Silver"];
        cell.goldImage = [UIImage imageNamed:@"Learn-Gold"];
        cell.showBronze = [[NSUserDefaults standardUserDefaults] boolForKey:@"learn-bronze"];
        cell.showSilver = [[NSUserDefaults standardUserDefaults] boolForKey:@"learn-silver"];
        cell.showGold = [[NSUserDefaults standardUserDefaults] boolForKey:@"learn-gold"];
    }
    else if (indexPath.row == 4) {
        cell.badgeLabel.text = @"Play Maker";
        cell.defaultImage = [UIImage imageNamed:@"Play-Blue"];
        cell.bronzeImage = [UIImage imageNamed:@"Play-Bronze"];
        cell.silverImage = [UIImage imageNamed:@"Play-Silver"];
        cell.goldImage = [UIImage imageNamed:@"Play-Gold"];
        cell.showBronze = [[NSUserDefaults standardUserDefaults] boolForKey:@"play-bronze"];
        cell.showSilver = [[NSUserDefaults standardUserDefaults] boolForKey:@"play-silver"];
        cell.showGold = [[NSUserDefaults standardUserDefaults] boolForKey:@"play-gold"];
    }
    else if (indexPath.row == 5) {
        cell.badgeLabel.text = @"Social Butterfly";
        cell.defaultImage = [UIImage imageNamed:@"Connect-Blue"];
        cell.bronzeImage = [UIImage imageNamed:@"Connect-Bronze"];
        cell.silverImage = [UIImage imageNamed:@"Connect-Silver"];
        cell.goldImage = [UIImage imageNamed:@"Connect-Gold"];
        cell.showBronze = [[NSUserDefaults standardUserDefaults] boolForKey:@"connect-bronze"];
        cell.showSilver = [[NSUserDefaults standardUserDefaults] boolForKey:@"connect-silver"];
        cell.showGold = [[NSUserDefaults standardUserDefaults] boolForKey:@"connect-gold"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
