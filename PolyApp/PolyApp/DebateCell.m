//
//  DebateCell.m
//  PolyApp
//
//  Created by Rick Medved on 12/31/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "DebateCell.h"
#import "UIColor+ATTColor.h"
#import "ObjectiveCScripts.h"

@implementation DebateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		UIColor *bgcolor = [UIColor clearColor];

		self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
		self.bgView.backgroundColor=[UIColor whiteColor];
		self.bgView.layer.cornerRadius = 7.0;
		self.bgView.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.bgView.layer.borderColor = [UIColor blackColor].CGColor;
		self.bgView.layer.borderWidth = 1.;
		[self.contentView addSubview:self.bgView];
		
		UIView *grayStrip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
		grayStrip.backgroundColor=[UIColor colorWithWhite:.8 alpha:1];
		[self.bgView addSubview:grayStrip];

		self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, 40, 13)];
		self.likesLabel.font = [UIFont systemFontOfSize:12];
		self.likesLabel.adjustsFontSizeToFitWidth = YES;
		self.likesLabel.minimumScaleFactor = .7;
		self.likesLabel.text = @"Likes";
		self.likesLabel.textAlignment = NSTextAlignmentCenter;
		self.likesLabel.textColor = [UIColor blackColor];
		self.likesLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.likesLabel];
		
		self.likesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 3, 40, 13)];
		self.likesCountLabel.font = [UIFont systemFontOfSize:12];
		self.likesCountLabel.adjustsFontSizeToFitWidth = YES;
		self.likesCountLabel.minimumScaleFactor = .7;
		self.likesCountLabel.text = @"0";
		self.likesCountLabel.textAlignment = NSTextAlignmentCenter;
		self.likesCountLabel.textColor = [UIColor whiteColor];
		self.likesCountLabel.backgroundColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.likesCountLabel];
		
		self.favoritesLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 3, 80, 13)];
		self.favoritesLabel.font = [UIFont systemFontOfSize:12];
		self.favoritesLabel.adjustsFontSizeToFitWidth = YES;
		self.favoritesLabel.minimumScaleFactor = .7;
		self.favoritesLabel.text = @"Favorites";
		self.favoritesLabel.textAlignment = NSTextAlignmentCenter;
		self.favoritesLabel.textColor = [UIColor blackColor];
		self.favoritesLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.favoritesLabel];
		
		self.favoritesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 3, 40, 13)];
		self.favoritesCountLabel.font = [UIFont systemFontOfSize:12];
		self.favoritesCountLabel.adjustsFontSizeToFitWidth = YES;
		self.favoritesCountLabel.minimumScaleFactor = .7;
		self.favoritesCountLabel.text = @"0";
		self.favoritesCountLabel.textAlignment = NSTextAlignmentCenter;
		self.favoritesCountLabel.textColor = [UIColor whiteColor];
		self.favoritesCountLabel.backgroundColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.favoritesCountLabel];
		
		self.topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 160, 40)];
		self.topicLabel.font = [UIFont boldSystemFontOfSize:20];
		self.topicLabel.adjustsFontSizeToFitWidth = YES;
		self.topicLabel.minimumScaleFactor = .7;
		self.topicLabel.numberOfLines = 2;
		self.topicLabel.text = @"Topic";
		self.topicLabel.textAlignment = NSTextAlignmentCenter;
		self.topicLabel.textColor = [UIColor ATTBlue];
		self.topicLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.topicLabel];
		
		self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 160, 20)];
		self.statusLabel.font = [UIFont boldSystemFontOfSize:17];
		self.statusLabel.adjustsFontSizeToFitWidth = YES;
		self.statusLabel.minimumScaleFactor = .7;
		self.statusLabel.text = @"-";
		self.statusLabel.textAlignment = NSTextAlignmentCenter;
		self.statusLabel.textColor = [UIColor whiteColor];
		self.statusLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.statusLabel];
		
		self.user1Button = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 55)];
		[self.user1Button setBackgroundImage:[UIImage imageNamed:@"unknown.jpg"] forState:UIControlStateNormal];
		self.user1Button.layer.cornerRadius = 4;
		self.user1Button.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.user1Button.layer.borderColor = [UIColor blackColor].CGColor;
		self.user1Button.layer.borderWidth = 1.;
		[self.contentView addSubview:self.user1Button];
		
		self.user1Label = [[CustomLabel alloc] initWithFrame:CGRectMake(0, 53, 70, 15)];
		self.user1Label.font = [UIFont systemFontOfSize:10];
		self.user1Label.adjustsFontSizeToFitWidth = YES;
		self.user1Label.minimumScaleFactor = .7;
		self.user1Label.text = @"Username";
		self.user1Label.textAlignment = NSTextAlignmentCenter;
		self.user1Label.textColor = [UIColor whiteColor];
		self.user1Label.backgroundColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.user1Label];
		
		self.user2Button = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 55)];
		[self.user2Button setBackgroundImage:[UIImage imageNamed:@"unknown.jpg"] forState:UIControlStateNormal];
		self.user2Button.layer.cornerRadius = 4;
		self.user2Button.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.user2Button.layer.borderColor = [UIColor blackColor].CGColor;
		self.user2Button.layer.borderWidth = 1.;
		[self.contentView addSubview:self.user2Button];
		
		self.user2Label = [[CustomLabel alloc] initWithFrame:CGRectMake(0, 55, 70, 15)];
		self.user2Label.font = [UIFont systemFontOfSize:10];
		self.user2Label.adjustsFontSizeToFitWidth = YES;
		self.user2Label.minimumScaleFactor = .7;
		self.user2Label.text = @"Join!";
		self.user2Label.textAlignment = NSTextAlignmentCenter;
		self.user2Label.textColor = [UIColor whiteColor];
		self.user2Label.backgroundColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.user2Label];
		
		self.backgroundColor = [UIColor colorWithRed:0 green:.6 blue:0 alpha:1];
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	self.bgView.frame = CGRectMake(2, 2, width-4, 50);
	self.user2Button.frame = CGRectMake(width-60, 0, 50, 55);
	self.user2Label.frame = CGRectMake(width-70, 53, 70, 15);
	self.topicLabel.frame = CGRectMake(65, 15, width-130, 38);
}

+(void)populateCell:(DebateCell *)cell withObj:(DebateObj*)obj selectorLeft:(SEL)selectorLeft selectorRight:(SEL)selectorRight target:(id)target {
	cell.topicLabel.text=obj.topic;
	cell.user1Label.text = obj.username1;
	
	cell.likesCountLabel.text = [NSString stringWithFormat:@"%d", obj.likes];
	cell.favoritesCountLabel.text = [NSString stringWithFormat:@"%d", obj.favorites];
	
	if(obj.step == 0)
		cell.statusLabel.text = @"Click to Join!";
	
	if([@"Active" isEqualToString:obj.status]) {
		if([ObjectiveCScripts myUserId]==obj.currentUser)
			cell.statusLabel.text = @"Click to Update!";
		else
			cell.statusLabel.text = @"Awaiting Updates";
	}
	if([@"Complete" isEqualToString:obj.status])
		cell.statusLabel.text = @"Debate Completed";
	
	[ObjectiveCScripts showUserButton:cell.user1Button selector:selectorLeft dir:obj.imgDir1 number:obj.imgNum1 name:obj.username1 label:cell.user1Label tarrget:target];
	NSLog(@"+++obj.user2: %d", obj.user2);
	if(obj.user2>0) {
		[ObjectiveCScripts showUserButton:cell.user2Button selector:selectorRight dir:obj.imgDir2 number:obj.imgNum2 name:obj.username2 label:cell.user2Label tarrget:target];
	}
}


@end
