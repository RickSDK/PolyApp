//
//  QuoteTestCell.m
//  PolyApp
//
//  Created by Rick Medved on 1/9/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "QuoteTestCell.h"
#import "ObjectiveCScripts.h"

@implementation QuoteTestCell

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
		
		self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 66)];
		self.pic.image = [UIImage imageNamed:@"unknown.jpg"];
		[self.bgView addSubview:self.pic];
		
		self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 240, 22)];
		self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
		self.nameLabel.adjustsFontSizeToFitWidth = YES;
		self.nameLabel.minimumScaleFactor = .7;
		self.nameLabel.text = @"Name";
		self.nameLabel.textAlignment = NSTextAlignmentLeft;
		self.nameLabel.textColor = [UIColor blackColor];
		self.nameLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.nameLabel];
		
		self.resultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 240, 22)];
		self.resultsLabel.font = [UIFont boldSystemFontOfSize:18];
		self.resultsLabel.adjustsFontSizeToFitWidth = YES;
		self.resultsLabel.minimumScaleFactor = .7;
		self.resultsLabel.text = @"% agreement";
		self.resultsLabel.textAlignment = NSTextAlignmentLeft;
		self.resultsLabel.textColor = [UIColor purpleColor];
		self.resultsLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.resultsLabel];
		
		
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	self.bgView.frame = CGRectMake(2, 2, width-4, 66);
	
}


+(void)updateCell:(QuoteTestCell*)cell obj:(QuoteTestObj *)obj {
	cell.pic.image = [ObjectiveCScripts cachedCandidateImageForRowId:obj.candidate_id thumbFlg:NO];
	cell.nameLabel.text = obj.name;
	cell.resultsLabel.text = [NSString stringWithFormat:@"%d%% agreement on quotes.", obj.agreePercent];
}


@end
