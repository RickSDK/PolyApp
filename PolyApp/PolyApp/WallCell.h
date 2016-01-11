//
//  WallCell.h
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallObj.h"
#import "CustomButton.h"

@interface WallCell : UITableViewCell

@property (nonatomic, retain) UIButton *userButton;
@property (nonatomic, retain) UILabel *usernameLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UILabel *createdLabel;
@property (nonatomic, retain) CustomButton *checkButton;

+(void)populateCell:(WallCell *)cell withObj:(WallObj *)obj;
+(int)heightForCellWithText:(NSString *)text;

@end
