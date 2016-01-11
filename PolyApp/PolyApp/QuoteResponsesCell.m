//
//  QuoteResponsesCell.m
//  PolyApp
//
//  Created by Rick Medved on 1/9/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "QuoteResponsesCell.h"

@implementation QuoteResponsesCell

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
	
		self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
		self.pic.image = [UIImage imageNamed:@"unknown.jpg"];
		[self.contentView addSubview:self.pic];
		
		self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 270, 44)];
		self.quoteLabel.font = [UIFont systemFontOfSize:12];
		self.quoteLabel.numberOfLines=2;
		self.quoteLabel.text = @"messageLabel";
		self.quoteLabel.textAlignment = NSTextAlignmentLeft;
		self.quoteLabel.textColor = [UIColor blackColor];
		self.quoteLabel.adjustsFontSizeToFitWidth = NO;
		self.quoteLabel.backgroundColor = [UIColor whiteColor];
		[self.contentView addSubview:self.quoteLabel];
		
	
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	self.quoteLabel.frame = CGRectMake(50, 0, width-50, 44);
	
}


@end
