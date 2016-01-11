//
//  CandidateIssueCell.h
//  PolyApp
//
//  Created by Rick Medved on 12/21/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueObj.h"

@interface CandidateIssueCell : UITableViewCell

@property (nonatomic, retain) UIImageView *pic;
@property (nonatomic, retain) UIImageView *option1;
@property (nonatomic, retain) UIImageView *option2;
@property (nonatomic, retain) UIImageView *option3;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *positionLabel;
@property (nonatomic, retain) UILabel *quoteCountLabel;
@property (nonatomic, retain) UILabel *popCountLabel;
@property (nonatomic, retain) UILabel *popularityLabel;

+(void)updateCell:(CandidateIssueCell*)cell issueObj:(IssueObj*)issueObj option:(int)option otherOption:(int)otherOption;

@end
