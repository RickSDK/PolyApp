//
//  UserCell.m
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "UserCell.h"
#import "UIColor+ATTColor.h"
#import "ObjectiveCScripts.h"

@implementation UserCell

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
		
		self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 35, 38)];
		self.avatar.image = [UIImage imageNamed:@"unknown.jpg"];
		[self.contentView addSubview:self.avatar];
	
		self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 250, 25)];
		self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
		self.nameLabel.text = @"name";
		self.nameLabel.textAlignment = NSTextAlignmentLeft;
		self.nameLabel.textColor = [UIColor blackColor];
		[self.contentView addSubview:self.nameLabel];
		

		self.ideologyLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 250, 15)];
		self.ideologyLabel.font = [UIFont systemFontOfSize:12];
		self.ideologyLabel.text = @"ideology";
		self.ideologyLabel.textAlignment = NSTextAlignmentLeft;
		self.ideologyLabel.textColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.ideologyLabel];
		
		self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 5, 70, 15)];
		self.stateLabel.font = [UIFont systemFontOfSize:12];
		self.stateLabel.text = @"state";
		self.stateLabel.textAlignment = NSTextAlignmentRight;
		self.stateLabel.textColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.stateLabel];
		
		self.countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 25, 70, 15)];
		self.countryLabel.font = [UIFont systemFontOfSize:12];
		self.countryLabel.text = @"location";
		self.countryLabel.textAlignment = NSTextAlignmentRight;
		self.countryLabel.textColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.countryLabel];
		

	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	self.stateLabel.frame = CGRectMake(width-160, 5, 120, 15);
	self.countryLabel.frame = CGRectMake(width-160, 25, 120, 15);
}


+(void)populateCell:(UserCell *)cell withObj:(UserObj *)obj {
	cell.nameLabel.text=obj.userName;
	cell.ideologyLabel.text=obj.ideology;
	cell.stateLabel.text=obj.state;
	cell.countryLabel.text=obj.country;
	cell.avatar.image=[ObjectiveCScripts cachedImageForRowId:obj.imgNum type:1 dir:obj.imgDir forceRecache:NO];
}

@end
