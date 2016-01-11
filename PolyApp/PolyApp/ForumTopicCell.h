//
//  ForumTopicCell.h
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface ForumTopicCell : UITableViewCell

@property (nonatomic, retain) UIImageView *updatesPic;

@property (nonatomic, retain) UILabel *topicLabel;
@property (nonatomic, retain) UILabel *bodyLabel;
@property (nonatomic, retain) UILabel *repliesLabel;
@property (nonatomic, retain) UILabel *mostRecentLabel;
@property (nonatomic, retain) UILabel *replyByLabel;

@property (nonatomic, retain) UIButton *userButton;
@property (nonatomic, retain) CustomLabel *userNameLabel;

@end
