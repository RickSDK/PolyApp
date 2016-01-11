//
//  CandidateIssueCell.m
//  PolyApp
//
//  Created by Rick Medved on 12/21/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "CandidateIssueCell.h"
#import "UIColor+ATTColor.h"

@implementation CandidateIssueCell

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
		
		self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 35, 38)];
		self.pic.image = [UIImage imageNamed:@"unknown.jpg"];
		[self.contentView addSubview:self.pic];
		
		self.option1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 3, 12, 12)];
		self.option1.image = [UIImage imageNamed:@"checkbox0.png"];
		[self.contentView addSubview:self.option1];
		
		self.option2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 14, 12, 12)];
		self.option2.image = [UIImage imageNamed:@"checkbox0.png"];
		[self.contentView addSubview:self.option2];
		
		self.option3 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 25, 12, 12)];
		self.option3.image = [UIImage imageNamed:@"checkbox0.png"];
		[self.contentView addSubview:self.option3];
		
		self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 3, 200, 22)];
		self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
		self.nameLabel.adjustsFontSizeToFitWidth = YES;
		self.nameLabel.minimumScaleFactor = .7;
		self.nameLabel.text = @"Name";
		self.nameLabel.textAlignment = NSTextAlignmentLeft;
		self.nameLabel.textColor = [UIColor blackColor];
		self.nameLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.nameLabel];
		
		
		self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 22, 200, 22)];
		self.positionLabel.font = [UIFont systemFontOfSize:14];
		self.positionLabel.adjustsFontSizeToFitWidth = NO;
		self.positionLabel.text = @"Position";
		self.positionLabel.numberOfLines=2;
		self.positionLabel.textAlignment = NSTextAlignmentLeft;
		self.positionLabel.textColor = [UIColor grayColor];
		self.positionLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.positionLabel];
		
		self.popCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 60, 14)];
		self.popCountLabel.font = [UIFont systemFontOfSize:12];
		self.popCountLabel.adjustsFontSizeToFitWidth = YES;
		self.popCountLabel.minimumScaleFactor = .7;
		self.popCountLabel.text = @"0";
		self.popCountLabel.textAlignment = NSTextAlignmentCenter;
		self.popCountLabel.textColor = [UIColor whiteColor];
		self.popCountLabel.backgroundColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.popCountLabel];
		
		self.popularityLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 12, 60, 14)];
		self.popularityLabel.font = [UIFont systemFontOfSize:10];
		self.popularityLabel.adjustsFontSizeToFitWidth = YES;
		self.popularityLabel.minimumScaleFactor = .7;
		self.popularityLabel.text = @"Popularity";
		self.popularityLabel.textAlignment = NSTextAlignmentCenter;
		self.popularityLabel.textColor = [UIColor blackColor];
		self.popularityLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.popularityLabel];
		
		self.quoteCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 30, 60, 14)];
		self.quoteCountLabel.font = [UIFont boldSystemFontOfSize:12];
		self.quoteCountLabel.adjustsFontSizeToFitWidth = YES;
		self.quoteCountLabel.minimumScaleFactor = .7;
		self.quoteCountLabel.text = @"";
		self.quoteCountLabel.textAlignment = NSTextAlignmentCenter;
		self.quoteCountLabel.textColor = [UIColor whiteColor];
		self.quoteCountLabel.backgroundColor = [UIColor orangeColor];
		[self.contentView addSubview:self.quoteCountLabel];
		
		
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	float height=self.frame.size.height;
	self.popCountLabel.frame = CGRectMake(width-60, 0, 60, 14);
	self.popularityLabel.frame = CGRectMake(width-60, 12, 60, 14);
	self.quoteCountLabel.frame = CGRectMake(width-60, height-14, 60, 14);
	self.positionLabel.frame = CGRectMake(53, 22, width-120, height-22);
	
}


+(void)updateCell:(CandidateIssueCell*)cell issueObj:(IssueObj*)issueObj option:(int)option otherOption:(int)otherOption {
	cell.nameLabel.text=issueObj.name;
	
	if(option==0)
		cell.positionLabel.text = @"Position: Unknown";
	if(option==1)
		cell.positionLabel.text = issueObj.option1;
	if(option==2)
		cell.positionLabel.text = issueObj.option2;
	if(option==3)
		cell.positionLabel.text = issueObj.option3;
	
	cell.option1.image = (option==1)?[UIImage imageNamed:@"checkbox1.png"]:[UIImage imageNamed:@"checkbox0.png"];
	cell.option2.image = (option==2)?[UIImage imageNamed:@"checkbox1.png"]:[UIImage imageNamed:@"checkbox0.png"];
	cell.option3.image = (option==3)?[UIImage imageNamed:@"checkbox1.png"]:[UIImage imageNamed:@"checkbox0.png"];
	
	cell.pic.image = (option==otherOption)?[UIImage imageNamed:@"checkbox1.png"]:nil;
	if(abs(option-otherOption)==2)
		cell.pic.image =[UIImage imageNamed:@"redX.png"];
	
	cell.backgroundColor = (option==0)?[UIColor colorWithWhite:.9 alpha:1]:[UIColor whiteColor];
}





@end
