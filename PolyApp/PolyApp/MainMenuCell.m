//
//  MainMenuCell.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "MainMenuCell.h"

@implementation MainMenuCell

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
		self.bgView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 316, 40)];
		self.bgView.backgroundColor=[UIColor whiteColor];
		self.bgView.layer.cornerRadius = 7.0;
		self.bgView.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.bgView.layer.borderColor = [UIColor blackColor].CGColor;
		self.bgView.layer.borderWidth = 1.;
		[self.contentView addSubview:self.bgView];
		
		self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
		self.pic.image = [UIImage imageNamed:@"marco.jpg"];
		[self.bgView addSubview:self.pic];
		
		self.yellowBlob = [[UIImageView alloc] initWithFrame:CGRectMake(210, 5, 40, 30)];
		self.yellowBlob.image = [UIImage imageNamed:@"new.png"];
		[self.bgView addSubview:self.yellowBlob];
		
		self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 11, 240, 22)];
		self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
		self.nameLabel.adjustsFontSizeToFitWidth = YES;
		self.nameLabel.minimumScaleFactor = .7;
		self.nameLabel.text = @"Name";
		self.nameLabel.textAlignment = NSTextAlignmentLeft;
		self.nameLabel.textColor = [UIColor blackColor];
		self.nameLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.nameLabel];
		
		self.backgroundColor = [UIColor redColor];
		
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
//	CGSize screenSize = [[UIScreen mainScreen] bounds].size;
	self.bgView.frame = CGRectMake(2, 2, width-4, 40);
	
}

@end
