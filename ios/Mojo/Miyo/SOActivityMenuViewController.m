//
//  SOActivityMenuViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOActivityMenuViewController.h"
#import "SOActivityButton.h"

#import <QuartzCore/QuartzCore.h>

static const CGFloat kMenuHeight = 320.0f;
static NSString *const kButtonCollectionViewCellIdentifier = @"ButtonCollectionViewCellIdentifier";

@interface SOActivityMenuViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *dimView;

@property (nonatomic, strong) UIToolbar *menuView;
@property (nonatomic, strong) NSLayoutConstraint *menuViewTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *dimViewHeightConstraint;

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

@property (nonatomic, assign) NSUInteger points;

@end

@implementation SOActivityMenuViewController

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.view.backgroundColor = [UIColor clearColor];

        self.points = 0;

        self.dimView = [[UIButton alloc] init];
        self.dimView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.dimView.alpha = 0.0;
        self.dimView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.dimView addTarget:self action:@selector(dismissMenu) forControlEvents:UIControlEventTouchUpInside];

        self.menuView = [[UIToolbar alloc] init];
        self.menuView.userInteractionEnabled = YES;
        self.menuView.translatesAutoresizingMaskIntoConstraints = NO;

        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handlePanGesture:)];

        [self.menuView addGestureRecognizer:panGestureRecognizer];

        UIImageView *dragImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drag-tab"]];
        dragImageView.contentMode = UIViewContentModeScaleAspectFit;
        dragImageView.translatesAutoresizingMaskIntoConstraints = NO;

        UIView *divder1 = [[UIView alloc] init];
        divder1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        divder1.translatesAutoresizingMaskIntoConstraints = NO;

        UILabel *activityLabel = [[UILabel alloc] init];
        activityLabel.text = @"WHAT HAVE YOU DONE TODAY?";
        activityLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        activityLabel.translatesAutoresizingMaskIntoConstraints = NO;

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

        self.sleepActivityButton = [[SOActivityButton alloc] initWithTitle:@"Slept Well" image:[UIImage imageNamed:@"sleep"]];
        self.sleepActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.sleepActivityButton.tag = 2;
        [self.buttons addObject:self.sleepActivityButton];

        self.exerciseActivityButton = [[SOActivityButton alloc] initWithTitle:@"Exercise" image:[UIImage imageNamed:@"exercise"]];
        self.exerciseActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.exerciseActivityButton.tag = 3;
        [self.buttons addObject:self.exerciseActivityButton];

        self.learnActivityButton = [[SOActivityButton alloc] initWithTitle:@"Learn" image:[UIImage imageNamed:@"learn"]];
        self.learnActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.learnActivityButton.tag = 4;
        [self.buttons addObject:self.learnActivityButton];

        self.talkActivityButton = [[SOActivityButton alloc] initWithTitle:@"Talk" image:[UIImage imageNamed:@"talk"]];
        self.talkActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.talkActivityButton.tag = 5;
        [self.buttons addObject:self.talkActivityButton];

        self.makeActivityButton = [[SOActivityButton alloc] initWithTitle:@"Make" image:[UIImage imageNamed:@"make"]];
        self.makeActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.makeActivityButton.tag = 6;
        [self.buttons addObject:self.makeActivityButton];

        self.connectActivityButton = [[SOActivityButton alloc] initWithTitle:@"Connect" image:[UIImage imageNamed:@"connect"]];
        self.connectActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.connectActivityButton.tag = 7;
        [self.buttons addObject:self.connectActivityButton];

        self.playActivityButton = [[SOActivityButton alloc] initWithTitle:@"Play" image:[UIImage imageNamed:@"play"]];
        self.playActivityButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.playActivityButton.tag = 8;
        [self.buttons addObject:self.playActivityButton];

        UIView *divder2 = [[UIView alloc] init];
        divder2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        divder2.translatesAutoresizingMaskIntoConstraints = NO;

        UIButton *activityLogButton = [[UIButton alloc] init];
        [activityLogButton setTitle:@"LOG ACTIVITIES" forState:UIControlStateNormal];
        [activityLogButton setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0] forState:UIControlStateNormal];
        activityLogButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        activityLogButton.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1.0].CGColor;
        activityLogButton.layer.cornerRadius = 5;
        activityLogButton.layer.borderWidth = 2.0f;
        activityLogButton.layer.masksToBounds = YES;
        activityLogButton.translatesAutoresizingMaskIntoConstraints = NO;

        [activityLogButton addTarget:self action:@selector(logActivites) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:self.dimView];
        [self.view addSubview:self.menuView];
        [self.menuView addSubview:dragImageView];
        [self.menuView addSubview:divder1];
        [self.menuView addSubview:activityLabel];
        [self.menuView addSubview:self.buttonCollectionView];
        [self.menuView addSubview:divder2];
        [self.menuView addSubview:activityLogButton];

        NSDictionary *views = @{@"menuView": self.menuView,
                                @"dimView": self.dimView,
                                @"dragImageView": dragImageView,
                                @"divider1": divder1,
                                @"activityLabel": activityLabel,
                                @"buttonCollectionView": self.buttonCollectionView,
                                @"divider2": divder2,
                                @"activityLogButton": activityLogButton};

        NSDictionary *metrics = @{@"menuViewHeight": @(kMenuHeight),
                                  @"buttonSize": @60,
                                  @"buttonSpacing": @16};

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dimView]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dimView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0]];

        self.dimViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.dimView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0];

        [self.view addConstraint:self.dimViewHeightConstraint];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuView]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[menuView(menuViewHeight)]"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];

        self.menuViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.menuView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0];

        [self.view addConstraint:self.menuViewTopConstraint];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[dragImageView(57)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraint:[NSLayoutConstraint constraintWithItem:dragImageView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.menuView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0
                                                                   constant:0]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[dragImageView(10)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[divider1]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dragImageView]-(10)-[divider1(1)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraint:[NSLayoutConstraint constraintWithItem:activityLabel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.menuView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0
                                                                   constant:0]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[divider1]-(20)-[activityLabel]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonCollectionView]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[activityLabel]-(20)-[buttonCollectionView(140)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[divider2]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[buttonCollectionView]-(10)-[divider2(1)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(50)-[activityLogButton]-(50)-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraint:[NSLayoutConstraint constraintWithItem:activityLogButton
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.menuView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0
                                                                   constant:0]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[divider2]-(18)-[activityLogButton(45)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];
    }

    return self;
}

- (void)showInView:(UIView *)view;
{
    [view addSubview:self.view];

    [self.view addSubview:self.dimView];
    [self.view addSubview:self.menuView];

    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.3
                     animations:^{
                         self.menuViewTopConstraint.constant -= kMenuHeight;
                         self.dimViewHeightConstraint.constant -= kMenuHeight;
                         self.dimView.alpha = 1.0;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)dismissMenu
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.menuViewTopConstraint.constant += kMenuHeight;
                         self.dimViewHeightConstraint.constant += kMenuHeight;
                         self.dimView.alpha = 0.0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                     }];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [gestureRecognizer velocityInView:self.menuView];

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded && velocity.y > 0) {
        [self dismissMenu];
    }
}

- (void)logActivites
{
    for (SOActivityButton *button in self.buttons) {
        if (button.isSelected) {
            switch (button.tag) {
                case 1:
                case 2:
                    self.points += 7;
                    break;
                case 7:
                case 8:
                    self.points += 5;
                    break;
                default:
                    self.points += 6;
                    break;
            }
        }

        button.selected = NO;
    }

    [self dismissMenu];

    [self.delegate didSelectActivitesForPoints:self.points];

    self.points = 0;
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

@end
