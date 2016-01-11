//
//  ForumCatCell.h
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumCatCell : UITableViewCell

@property (nonatomic, retain) UIImageView *updatesPic;

@property (nonatomic, retain) UILabel *categoryLabel;
@property (nonatomic, retain) UILabel *postsLabel;
@property (nonatomic, retain) UILabel *repliesLabel;
@property (nonatomic, retain) UILabel *mostRecentLabel;

@property (nonatomic, retain) UILabel *posts2Label;
@property (nonatomic, retain) UILabel *replies2Label;
@property (nonatomic, retain) UILabel *mostRecent2Label;

@end
