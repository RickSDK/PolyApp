//
//  ForumCatCell.m
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "ForumCatCell.h"
#import "UIColor+ATTColor.h"

@implementation ForumCatCell

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

		self.updatesPic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 40, 44)];
		self.updatesPic.image = [UIImage imageNamed:@"new.png"];
		[self.contentView addSubview:self.updatesPic];

		self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
		self.categoryLabel.font = [UIFont boldSystemFontOfSize:20];
		self.categoryLabel.adjustsFontSizeToFitWidth = YES;
		self.categoryLabel.minimumScaleFactor = .7;
		self.categoryLabel.numberOfLines=2;
		self.categoryLabel.text = @"Category";
		self.categoryLabel.textAlignment = NSTextAlignmentLeft;
		self.categoryLabel.textColor = [UIColor whiteColor];
		self.categoryLabel.backgroundColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.categoryLabel];
		
		self.postsLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 45, 18)];
		self.postsLabel.font = [UIFont systemFontOfSize:18];
		self.postsLabel.adjustsFontSizeToFitWidth = YES;
		self.postsLabel.minimumScaleFactor = .7;
		self.postsLabel.text = @"0";
		self.postsLabel.textAlignment = NSTextAlignmentCenter;
		self.postsLabel.textColor = [UIColor orangeColor];
		self.postsLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.postsLabel];
		
		self.repliesLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 40, 45, 18)];
		self.repliesLabel.font = [UIFont systemFontOfSize:18];
		self.repliesLabel.adjustsFontSizeToFitWidth = YES;
		self.repliesLabel.minimumScaleFactor = .7;
		self.repliesLabel.text = @"0";
		self.repliesLabel.textAlignment = NSTextAlignmentCenter;
		self.repliesLabel.textColor = [UIColor ATTBlue];
		self.repliesLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.repliesLabel];
		
		self.mostRecentLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 40, 120, 18)];
		self.mostRecentLabel.font = [UIFont systemFontOfSize:14];
		self.mostRecentLabel.adjustsFontSizeToFitWidth = YES;
		self.mostRecentLabel.minimumScaleFactor = .7;
		self.mostRecentLabel.text = @"Date";
		self.mostRecentLabel.textAlignment = NSTextAlignmentCenter;
		self.mostRecentLabel.textColor = [UIColor ATTBlue];
		self.mostRecentLabel.backgroundColor = bgcolor;
		[self.contentView addSubview:self.mostRecentLabel];
		
		self.posts2Label = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, 45, 14)];
		self.posts2Label.font = [UIFont systemFontOfSize:12];
		self.posts2Label.adjustsFontSizeToFitWidth = YES;
		self.posts2Label.minimumScaleFactor = .7;
		self.posts2Label.text = @"Posts";
		self.posts2Label.textAlignment = NSTextAlignmentCenter;
		self.posts2Label.textColor = [UIColor blackColor];
		self.posts2Label.backgroundColor = bgcolor;
		[self.contentView addSubview:self.posts2Label];
		
		self.replies2Label = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, 45, 14)];
		self.replies2Label.font = [UIFont systemFontOfSize:12];
		self.replies2Label.adjustsFontSizeToFitWidth = YES;
		self.replies2Label.minimumScaleFactor = .7;
		self.replies2Label.text = @"Replies";
		self.replies2Label.textAlignment = NSTextAlignmentCenter;
		self.replies2Label.textColor = [UIColor blackColor];
		self.replies2Label.backgroundColor = bgcolor;
		[self.contentView addSubview:self.replies2Label];
		
		self.mostRecent2Label = [[UILabel alloc] initWithFrame:CGRectMake(180, 60, 120, 14)];
		self.mostRecent2Label.font = [UIFont systemFontOfSize:12];
		self.mostRecent2Label.adjustsFontSizeToFitWidth = YES;
		self.mostRecent2Label.minimumScaleFactor = .7;
		self.mostRecent2Label.text = @"Most Recent";
		self.mostRecent2Label.textAlignment = NSTextAlignmentCenter;
		self.mostRecent2Label.textColor = [UIColor blackColor];
		self.mostRecent2Label.backgroundColor = bgcolor;
		[self.contentView addSubview:self.mostRecent2Label];
		
		
		
		
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	self.categoryLabel.frame = CGRectMake(0, 0, width, 30);
}

@end
