//
//  CartoonCell.m
//  PolyApp
//
//  Created by Rick Medved on 12/28/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "CartoonCell.h"
#import "UIColor+ATTColor.h"
#import "ObjectiveCScripts.h"

@implementation CartoonCell

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
		
		int picBottom=[ObjectiveCScripts screenWidth];
		
		self.bgView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 316, 316)];
		self.bgView.backgroundColor=[UIColor whiteColor];
		self.bgView.layer.cornerRadius = 7.0;
		self.bgView.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.bgView.layer.borderColor = [UIColor blackColor].CGColor;
		self.bgView.layer.borderWidth = 1.;
		[self.contentView addSubview:self.bgView];
		
		self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 316, picBottom)];
		self.pic.image = [UIImage imageNamed:@"unknown.jpg"];
		[self.bgView addSubview:self.pic];
		
		self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(7, picBottom, 80, 40)];
		[self.likeButton setTitle:@"Like" forState:UIControlStateNormal];
		[self.likeButton setBackgroundImage:[UIImage imageNamed:@"whiteButton.png"] forState:UIControlStateNormal];
		[self.contentView addSubview:self.likeButton];
		
		self.favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(235, picBottom, 80, 40)];
		[self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
		[self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"whiteButton.png"] forState:UIControlStateNormal];
		[self.contentView addSubview:self.favoriteButton];

		self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, picBottom+5, 65, 14)];
		self.likesLabel.font = [UIFont systemFontOfSize:11];
		self.likesLabel.adjustsFontSizeToFitWidth = YES;
		self.likesLabel.minimumScaleFactor = .7;
		self.likesLabel.text = @"Likes";
		self.likesLabel.textAlignment = NSTextAlignmentCenter;
		self.likesLabel.textColor = [UIColor colorWithRed:0 green:.5 blue:0 alpha:1];
		self.likesLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.likesLabel];
		
		self.favoritesLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, picBottom+5, 65, 14)];
		self.favoritesLabel.font = [UIFont systemFontOfSize:11];
		self.favoritesLabel.adjustsFontSizeToFitWidth = YES;
		self.favoritesLabel.minimumScaleFactor = .7;
		self.favoritesLabel.text = @"Favorites";
		self.favoritesLabel.textAlignment = NSTextAlignmentCenter;
		self.favoritesLabel.textColor = [UIColor magentaColor];
		self.favoritesLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.favoritesLabel];
		
		self.likesCountLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(95, picBottom+20, 65, 16)];
		self.likesCountLabel.font = [UIFont systemFontOfSize:14];
		self.likesCountLabel.adjustsFontSizeToFitWidth = YES;
		self.likesCountLabel.minimumScaleFactor = .7;
		self.likesCountLabel.text = @"0";
		self.likesCountLabel.textAlignment = NSTextAlignmentCenter;
		self.likesCountLabel.textColor = [UIColor whiteColor];
		self.likesCountLabel.backgroundColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.likesCountLabel];
		
		self.favoritesCountLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(165, picBottom+20, 65, 16)];
		self.favoritesCountLabel.font = [UIFont systemFontOfSize:14];
		self.favoritesCountLabel.adjustsFontSizeToFitWidth = YES;
		self.favoritesCountLabel.minimumScaleFactor = .7;
		self.favoritesCountLabel.text = @"0";
		self.favoritesCountLabel.textAlignment = NSTextAlignmentCenter;
		self.favoritesCountLabel.textColor = [UIColor whiteColor];
		self.favoritesCountLabel.backgroundColor = [UIColor ATTBlue];
		[self.contentView addSubview:self.favoritesCountLabel];
		
		self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		self.activityIndicator.center = CGPointMake(160, 150);
		[self.activityIndicator startAnimating];
		self.activityIndicator.hidesWhenStopped = YES;
		[self.contentView addSubview:self.activityIndicator];

		self.createdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, picBottom-20, 100, 20)];
		self.createdLabel.font = [UIFont systemFontOfSize:12];
		self.createdLabel.adjustsFontSizeToFitWidth = YES;
		self.createdLabel.minimumScaleFactor = .7;
		self.createdLabel.text = @"Created";
		self.createdLabel.textAlignment = NSTextAlignmentLeft;
		self.createdLabel.textColor = [UIColor whiteColor];
		self.createdLabel.shadowColor = [UIColor blackColor];
		self.createdLabel.shadowOffset = CGSizeMake(1, 1);
		self.createdLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.createdLabel];
		

		self.backgroundColor=[UIColor grayColor];
		
		
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	
	float width=self.frame.size.width;
	self.bgView.frame = CGRectMake(2, 2, width-4, width-4);
	self.pic.frame = self.bgView.frame;
	
}

@end
