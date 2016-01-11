//
//  CandidateCell.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "CandidateCell.h"


@implementation CandidateCell

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
		UIColor *bgLabelColor = [UIColor clearColor];
		self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
		self.bgView.backgroundColor=[UIColor whiteColor];
		self.bgView.layer.cornerRadius = 7.0;
		self.bgView.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.bgView.layer.borderColor = [UIColor blackColor].CGColor;
		self.bgView.layer.borderWidth = 1.;
		[self.contentView addSubview:self.bgView];
		
		self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 54)];
		self.pic.image = [UIImage imageNamed:@"unknown.jpg"];
		[self.bgView addSubview:self.pic];

		self.outImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 44)];
		self.outImg.image = [UIImage imageNamed:@"out.png"];
		self.outImg.hidden=YES;
		[self.contentView addSubview:self.outImg];

		self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 4, 159, 21)];
		self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
		self.nameLabel.adjustsFontSizeToFitWidth = YES;
		self.nameLabel.minimumScaleFactor = .7;
		self.nameLabel.text = @"Name";
		self.nameLabel.textAlignment = NSTextAlignmentLeft;
		self.nameLabel.textColor = [UIColor blackColor];
		self.nameLabel.backgroundColor = bgLabelColor;
		[self.contentView addSubview:self.nameLabel];

		self.partyLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 23, 159, 15)];
		self.partyLabel.font = [UIFont systemFontOfSize:12];
		self.partyLabel.adjustsFontSizeToFitWidth = YES;
		self.partyLabel.minimumScaleFactor = .7;
		self.partyLabel.text = @"Party";
		self.partyLabel.textAlignment = NSTextAlignmentLeft;
		self.partyLabel.textColor = [UIColor grayColor];
		self.partyLabel.backgroundColor = bgLabelColor;
		[self.contentView addSubview:self.partyLabel];
		
		self.percentMatchLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 23, 80, 15)];
		self.percentMatchLabel.font = [UIFont systemFontOfSize:12];
		self.percentMatchLabel.adjustsFontSizeToFitWidth = YES;
		self.percentMatchLabel.minimumScaleFactor = .7;
		self.percentMatchLabel.text = @"";
		self.percentMatchLabel.textAlignment = NSTextAlignmentLeft;
		self.percentMatchLabel.textColor = [UIColor purpleColor];
		self.percentMatchLabel.backgroundColor = bgLabelColor;
		[self.contentView addSubview:self.percentMatchLabel];
		
		self.quoteCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.quoteCountLabel.font = [UIFont systemFontOfSize:11];
		self.quoteCountLabel.adjustsFontSizeToFitWidth = YES;
		self.quoteCountLabel.minimumScaleFactor = .7;
		self.quoteCountLabel.text = @"0";
		self.quoteCountLabel.textAlignment = NSTextAlignmentCenter;
		self.quoteCountLabel.textColor = [UIColor whiteColor];
		self.quoteCountLabel.backgroundColor = [UIColor orangeColor];
		[self.bgView addSubview:self.quoteCountLabel];
		
		self.conservativeMeterView = [[UIView alloc] initWithFrame:CGRectZero];
		self.conservativeMeterView.backgroundColor=[UIColor colorWithRed:1 green:.7 blue:.7 alpha:1];
		self.conservativeMeterView.layer.cornerRadius = 4.0;
		self.conservativeMeterView.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.conservativeMeterView.layer.borderColor = [UIColor blackColor].CGColor;
		self.conservativeMeterView.layer.borderWidth = 1.;
		
		self.liberalView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 300, 11)];
		self.liberalView.backgroundColor=[UIColor colorWithRed:.7 green:.7 blue:1 alpha:1];
		[self.conservativeMeterView addSubview:self.liberalView];
		[self.contentView addSubview:self.conservativeMeterView];

		self.ideologyLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 39, 100, 11)];
		self.ideologyLabel.font = [UIFont systemFontOfSize:10];
		self.ideologyLabel.text = @"Liberal";
		self.ideologyLabel.textAlignment = NSTextAlignmentCenter;
		self.ideologyLabel.textColor = [UIColor whiteColor];
		[self.contentView addSubview:self.ideologyLabel];
		
		self.popularityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.popularityLabel.font = [UIFont systemFontOfSize:11];
		self.popularityLabel.adjustsFontSizeToFitWidth = YES;
		self.popularityLabel.minimumScaleFactor = .7;
		self.popularityLabel.text = @"0";
		self.popularityLabel.textAlignment = NSTextAlignmentCenter;
		self.popularityLabel.textColor = [UIColor whiteColor];
		self.popularityLabel.backgroundColor = [UIColor colorWithRed:(6/255.0) green:(122/255.0) blue:(180/255.0) alpha:1.0];
		[self.bgView addSubview:self.popularityLabel];

		self.yellowCircle = [[UIImageView alloc] initWithFrame:CGRectMake(100, 20, 16, 16)];
		self.yellowCircle.image = [UIImage imageNamed:@"yellowCircle.png"];
		[self.contentView addSubview:self.yellowCircle];

		self.backgroundColor = [UIColor redColor];

	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	self.bgView.frame = CGRectMake(2, 2, width-4, 50);
	self.percentMatchLabel.frame = CGRectMake(width-110, 23, 80, 15);
	self.quoteCountLabel.frame = CGRectMake(width-27, 38, 25, 11);
	self.popularityLabel.frame = CGRectMake(width-27, 0, 25, 11);
	self.conservativeMeterView.frame = CGRectMake(50, 39, width-kConservativeMeterGap, 11);
	
}

@end
