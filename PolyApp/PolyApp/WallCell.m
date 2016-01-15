//
//  WallCell.m
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "WallCell.h"
#import "UIColor+ATTColor.h"
#import "ObjectiveCScripts.h"

@implementation WallCell

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
		
		self.userButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 36, 40)];
		[self.userButton setBackgroundImage:[UIImage imageNamed:@"unknown.jpg"] forState:UIControlStateNormal];
		self.userButton.layer.cornerRadius = 4;
		self.userButton.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.userButton.layer.borderColor = [UIColor blackColor].CGColor;
		self.userButton.layer.borderWidth = 1.;
		[self.contentView addSubview:self.userButton];
		
		
		
		self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 1, 250, 12)];
		self.usernameLabel.font = [UIFont boldSystemFontOfSize:12];
		self.usernameLabel.text = @"usernameLabel";
		self.usernameLabel.textAlignment = NSTextAlignmentLeft;
		self.usernameLabel.textColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.usernameLabel];
		
		
		self.createdLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 1, 250, 12)];
		self.createdLabel.font = [UIFont systemFontOfSize:12];
		self.createdLabel.text = @"createdLabel";
		self.createdLabel.textAlignment = NSTextAlignmentLeft;
		self.createdLabel.textColor = [UIColor purpleColor];
		[self.contentView addSubview:self.createdLabel];
		
		self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 15, 273, 28)];
		self.messageLabel.font = [UIFont systemFontOfSize:12];
		self.messageLabel.numberOfLines=5;
		self.messageLabel.text = @"messageLabel";
		self.messageLabel.textAlignment = NSTextAlignmentLeft;
		self.messageLabel.textColor = [UIColor blackColor];
		self.messageLabel.adjustsFontSizeToFitWidth = YES;
		self.messageLabel.minimumScaleFactor = .7;
		self.messageLabel.backgroundColor = [UIColor whiteColor];
		[self.contentView addSubview:self.messageLabel];
		
		self.checkButton = [[CustomButton alloc] initWithFrame:CGRectMake(280, 5, 35, 35)];
		self.checkButton.layer.cornerRadius = 4;
		self.checkButton.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.checkButton.layer.borderColor = [UIColor blackColor].CGColor;
		self.checkButton.layer.borderWidth = 1.;
		self.checkButton.hidden=YES;
		[self.contentView addSubview:self.checkButton];
		
		self.backgroundColor=[UIColor colorWithWhite:.8 alpha:1];
		self.layer.cornerRadius = 5;
		self.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.layer.borderColor = [UIColor blackColor].CGColor;
		self.layer.borderWidth = 1.;
		
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	float height=self.frame.size.height;
	self.createdLabel.frame = CGRectMake(width-120, 1, 250, 12);
	self.messageLabel.frame = CGRectMake(42, 15, width-47, height-16);
	self.checkButton.frame = CGRectMake(width-40, 5, 35, 35);
}


+(void)populateCell:(WallCell *)cell withObj:(WallObj *)obj {
	cell.messageLabel.text=obj.message;
	if(obj.recipName.length>0 && obj.redirectedFlg)
		cell.messageLabel.text = [NSString stringWithFormat:@"@%@: %@", obj.recipName, obj.message];
	cell.usernameLabel.text=obj.username;
	cell.createdLabel.text=obj.created;
	[cell.userButton setBackgroundImage:[ObjectiveCScripts cachedImageForRowId:obj.imgNum type:1 dir:obj.imgDir forceRecache:NO] forState:UIControlStateNormal];
}

+(int)heightForCellWithText:(NSString *)text {
	float lines = ceil((float)text.length/60);
	int height = 15+lines*15;
	if(height<44)
		height=44;
	return height;
}


@end
