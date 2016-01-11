//
//  QuoteTestCell.h
//  PolyApp
//
//  Created by Rick Medved on 1/9/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuoteTestObj.h"

@interface QuoteTestCell : UITableViewCell

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UIImageView *pic;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *resultsLabel;

+(void)updateCell:(QuoteTestCell*)cell obj:(QuoteTestObj *)obj;

@end
