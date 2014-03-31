//
//  SOBadgeTableViewCell.h
//  Miyo
//
//  Created by Matt Donnelly on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOBadgeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *badgeLabel;

@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) UIImage *bronzeImage;
@property (nonatomic, strong) UIImage *silverImage;
@property (nonatomic, strong) UIImage *goldImage;

@property (nonatomic, assign) BOOL showBronze;
@property (nonatomic, assign) BOOL showSilver;
@property (nonatomic, assign) BOOL showGold;

@end
