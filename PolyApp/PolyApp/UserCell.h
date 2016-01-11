//
//  UserCell.h
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"

@interface UserCell : UITableViewCell

@property (nonatomic, retain) UIImageView *avatar;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *ideologyLabel;
@property (nonatomic, retain) UILabel *stateLabel;
@property (nonatomic, retain) UILabel *countryLabel;

+(void)populateCell:(UserCell *)cell withObj:(UserObj *)obj;

@end
