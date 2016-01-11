//
//  ForumTopicCell.m
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "ForumTopicCell.h"
#import "UIColor+ATTColor.h"

@implementation ForumTopicCell

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

		self.updatesPic = [[UIImageView alloc] initWithFrame:CGRectMake(60, 18, 40, 44)];
		self.updatesPic.image = [UIImage imageNamed:@"new.png"];
		[self.contentView addSubview:self.updatesPic];

		self.userButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 50, 55)];
		[self.userButton setBackgroundImage:[UIImage imageNamed:@"unknown.jpg"] forState:UIControlStateNormal];
		self.userButton.layer.cornerRadius = 4;
		self.userButton.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.userButton.layer.borderColor = [UIColor blackColor].CGColor;
		self.userButton.layer.borderWidth = 1.;
		[self.contentView addSubview:self.userButton];

		self.userNameLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0, 45, 55, 15)];
		self.userNameLabel.font = [UIFont boldSystemFontOfSize:10];
		self.userNameLabel.adjustsFontSizeToFitWidth = YES;
		self.userNameLabel.minimumScaleFactor = .7;
		self.userNameLabel.text = @"Username";
		self.userNameLabel.textAlignment = NSTextAlignmentCenter;
		self.userNameLabel.textColor = [UIColor whiteColor];
		self.userNameLabel.backgroundColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.userNameLabel];

		self.topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 320, 30)];
		self.topicLabel.font = [UIFont boldSystemFontOfSize:20];
		self.topicLabel.adjustsFontSizeToFitWidth = YES;
		self.topicLabel.minimumScaleFactor = .7;
		self.topicLabel.numberOfLines=2;
		self.topicLabel.text = @"Topic";
		self.topicLabel.textAlignment = NSTextAlignmentLeft;
		self.topicLabel.textColor = [UIColor blackColor];
		self.topicLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.topicLabel];
		
		self.repliesLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 78, 20)];
		self.repliesLabel.font = [UIFont systemFontOfSize:18];
		self.repliesLabel.adjustsFontSizeToFitWidth = YES;
		self.repliesLabel.minimumScaleFactor = .7;
		self.repliesLabel.text = @"0";
		self.repliesLabel.textAlignment = NSTextAlignmentCenter;
		self.repliesLabel.textColor = [UIColor ATTBlue];
		self.repliesLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.repliesLabel];
		
		UILabel *replies2Label = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 78, 15)];
		replies2Label.font = [UIFont systemFontOfSize:11];
		replies2Label.adjustsFontSizeToFitWidth = YES;
		replies2Label.minimumScaleFactor = .7;
		replies2Label.text = @"Replies";
		replies2Label.textAlignment = NSTextAlignmentCenter;
		replies2Label.textColor = [UIColor blackColor];
		replies2Label.backgroundColor = bgcolor;
		[self.contentView addSubview:replies2Label];

		self.mostRecentLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 25, 78, 20)];
		self.mostRecentLabel.font = [UIFont systemFontOfSize:11];
		self.mostRecentLabel.adjustsFontSizeToFitWidth = YES;
		self.mostRecentLabel.minimumScaleFactor = .7;
		self.mostRecentLabel.text = @"Date";
		self.mostRecentLabel.textAlignment = NSTextAlignmentCenter;
		self.mostRecentLabel.textColor = [UIColor ATTBlue];
		self.mostRecentLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.mostRecentLabel];
		
		
		UILabel *mostRecent2Label = [[UILabel alloc] initWithFrame:CGRectMake(160, 45, 78, 15)];
		mostRecent2Label.font = [UIFont systemFontOfSize:12];
		mostRecent2Label.adjustsFontSizeToFitWidth = YES;
		mostRecent2Label.minimumScaleFactor = .7;
		mostRecent2Label.text = @"Most Recent";
		mostRecent2Label.textAlignment = NSTextAlignmentCenter;
		mostRecent2Label.textColor = [UIColor blackColor];
		mostRecent2Label.backgroundColor = bgcolor;
		[self.contentView addSubview:mostRecent2Label];
		
		self.replyByLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 25, 78, 20)];
		self.replyByLabel.font = [UIFont systemFontOfSize:11];
		self.replyByLabel.adjustsFontSizeToFitWidth = YES;
		self.replyByLabel.minimumScaleFactor = .7;
		self.replyByLabel.text = @"replyByLabel";
		self.replyByLabel.textAlignment = NSTextAlignmentCenter;
		self.replyByLabel.textColor = [UIColor ATTBlue];
		self.replyByLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.replyByLabel];
		
		
		UILabel *replyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 45, 78, 15)];
		replyNameLabel.font = [UIFont systemFontOfSize:12];
		replyNameLabel.adjustsFontSizeToFitWidth = YES;
		replyNameLabel.minimumScaleFactor = .7;
		replyNameLabel.text = @"Reply By";
		replyNameLabel.textAlignment = NSTextAlignmentCenter;
		replyNameLabel.textColor = [UIColor blackColor];
		replyNameLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:replyNameLabel];
		
		
		
		
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	self.topicLabel.frame = CGRectMake(60, 0, width-120, 30);

}


@end
