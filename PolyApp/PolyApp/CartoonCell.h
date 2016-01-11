//
//  CartoonCell.h
//  PolyApp
//
//  Created by Rick Medved on 12/28/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface CartoonCell : UITableViewCell

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UIImageView *pic;
@property (nonatomic, retain) UIButton *likeButton;
@property (nonatomic, retain) UIButton *favoriteButton;
@property (nonatomic, retain) UILabel *likesLabel;
@property (nonatomic, retain) UILabel *favoritesLabel;
@property (nonatomic, retain) UILabel *createdLabel;
@property (nonatomic, retain) CustomLabel *likesCountLabel;
@property (nonatomic, retain) CustomLabel *favoritesCountLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end
