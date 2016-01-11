//
//  QuoteCell.m
//  PolyApp
//
//  Created by Rick Medved on 12/22/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "QuoteCell.h"

@implementation QuoteCell

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

		self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 250, 44)];
		self.quoteLabel.font = [UIFont boldSystemFontOfSize:14];
		self.quoteLabel.adjustsFontSizeToFitWidth = YES;
		self.quoteLabel.minimumScaleFactor = .7;
		self.quoteLabel.numberOfLines=2;
		self.quoteLabel.text = @"Quote";
		self.quoteLabel.textAlignment = NSTextAlignmentLeft;
		self.quoteLabel.textColor = [UIColor blackColor];
		self.quoteLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.quoteLabel];
		
		self.favoritesLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 45, 14)];
		self.favoritesLabel.font = [UIFont systemFontOfSize:11];
		self.favoritesLabel.adjustsFontSizeToFitWidth = YES;
		self.favoritesLabel.minimumScaleFactor = .7;
		self.favoritesLabel.text = @"";
		self.favoritesLabel.textAlignment = NSTextAlignmentRight;
		self.favoritesLabel.textColor = [UIColor magentaColor];
		self.favoritesLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.favoritesLabel];

		self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 30, 45, 14)];
		self.likesLabel.font = [UIFont systemFontOfSize:11];
		self.likesLabel.adjustsFontSizeToFitWidth = YES;
		self.likesLabel.minimumScaleFactor = .7;
		self.likesLabel.text = @"";
		self.likesLabel.textAlignment = NSTextAlignmentRight;
		self.likesLabel.textColor = [UIColor colorWithRed:0 green:.5 blue:0 alpha:1];
		self.likesLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.likesLabel];
		
		
	
		
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	self.quoteLabel.frame = CGRectMake(5, 0, width-70, 44);
	
}


@end
