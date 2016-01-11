//
//  DebateCell.h
//  PolyApp
//
//  Created by Rick Medved on 12/31/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
#import "DebateObj.h"

@interface DebateCell : UITableViewCell

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) CustomLabel *user1Label;
@property (nonatomic, retain) UIButton *user1Button;

@property (nonatomic, retain) CustomLabel *user2Label;
@property (nonatomic, retain) UIButton *user2Button;

@property (nonatomic, retain) UILabel *topicLabel;
@property (nonatomic, retain) UILabel *statusLabel;

@property (nonatomic, retain) UILabel *likesLabel;
@property (nonatomic, retain) UILabel *likesCountLabel;
@property (nonatomic, retain) UILabel *favoritesLabel;
@property (nonatomic, retain) UILabel *favoritesCountLabel;

+(void)populateCell:(DebateCell *)cell withObj:(DebateObj*)obj selectorLeft:(SEL)selectorLeft selectorRight:(SEL)selectorRight target:(id)target;

@end
