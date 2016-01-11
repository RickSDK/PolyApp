//
//  CandidateCell.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kConservativeMeterGap	78

@interface CandidateCell : UITableViewCell

@property (nonatomic, retain) UIImageView *pic;
@property (nonatomic, retain) UIImageView *outImg;
@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *partyLabel;
@property (nonatomic, retain) UILabel *percentMatchLabel;
@property (nonatomic, retain) UILabel *ideologyLabel;
@property (nonatomic, retain) UILabel *popularityLabel;
@property (nonatomic, retain) UILabel *quoteCountLabel;

@property (nonatomic, retain) UIView *conservativeMeterView;
@property (nonatomic, retain) UIView *liberalView;
@property (nonatomic, retain) UIImageView *yellowCircle;

@end
