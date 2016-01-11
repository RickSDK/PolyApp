//
//  LikeFavBar.m
//  PolyApp
//
//  Created by Rick Medved on 12/31/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "LikeFavBar.h"
#import "UIColor+ATTColor.h"

@implementation LikeFavBar

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = YES;				// clips background images to rounded corners
	self.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:.7 alpha:1].CGColor;
	self.layer.borderWidth = 1.;

	float width = [[UIScreen mainScreen] bounds].size.width;
	self.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-158, width, 44);
	self.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
	
	self.likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 1, 70, 20)];
	self.likeLabel.font = [UIFont boldSystemFontOfSize:14];
	self.likeLabel.adjustsFontSizeToFitWidth = YES;
	self.likeLabel.minimumScaleFactor = .7;
	self.likeLabel.text = @"Likes";
	self.likeLabel.textAlignment = NSTextAlignmentCenter;
	self.likeLabel.textColor = [UIColor blackColor];
	self.likeLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:self.likeLabel];

	self.likesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 21, 70, 20)];
	self.likesCountLabel.font = [UIFont boldSystemFontOfSize:17];
	self.likesCountLabel.adjustsFontSizeToFitWidth = YES;
	self.likesCountLabel.minimumScaleFactor = .7;
	self.likesCountLabel.text = @"0";
	self.likesCountLabel.textAlignment = NSTextAlignmentCenter;
	self.likesCountLabel.textColor = [UIColor whiteColor];
	self.likesCountLabel.backgroundColor = [UIColor ATTBlue];
	[self addSubview:self.likesCountLabel];

	self.favLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-160, 1, 70, 20)];
	self.favLabel.font = [UIFont boldSystemFontOfSize:14];
	self.favLabel.adjustsFontSizeToFitWidth = YES;
	self.favLabel.minimumScaleFactor = .7;
	self.favLabel.text = @"Favorites";
	self.favLabel.textAlignment = NSTextAlignmentCenter;
	self.favLabel.textColor = [UIColor blackColor];
	self.favLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:self.favLabel];

	self.favCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-160, 21, 70, 20)];
	self.favCountLabel.font = [UIFont boldSystemFontOfSize:17];
	self.favCountLabel.adjustsFontSizeToFitWidth = YES;
	self.favCountLabel.minimumScaleFactor = .7;
	self.favCountLabel.text = @"0";
	self.favCountLabel.textAlignment = NSTextAlignmentCenter;
	self.favCountLabel.textColor = [UIColor whiteColor];
	self.favCountLabel.backgroundColor = [UIColor ATTBlue];
	[self addSubview:self.favCountLabel];
	
}

-(void)setupLikeFavBarButtonsForTarget:(id)target likeSelector:(SEL)likeSelector favSelector:(SEL)favSelector {
	float width = [[UIScreen mainScreen] bounds].size.width;
	self.favButton = [[UIButton alloc] initWithFrame:CGRectMake(width-85, 2, 80, 39)];
	[self.favButton setBackgroundImage:[UIImage imageNamed:@"whiteButton.png"] forState:UIControlStateNormal];
	[self.favButton setTitle:@"Favorite" forState:UIControlStateNormal];
	[self.favButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.favButton addTarget:target action:favSelector forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.favButton];
	
	self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 70, 39)];
	[self.likeButton setBackgroundImage:[UIImage imageNamed:@"whiteButton.png"] forState:UIControlStateNormal];
	[self.likeButton setTitle:@"Like" forState:UIControlStateNormal];
	[self.likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.likeButton addTarget:target action:likeSelector forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.likeButton];
}

-(void)displayLikeFavBarLikes:(int)likes favorites:(int)favorites youLikeFlg:(BOOL)youLikeFlg yourFavFlg:(BOOL)yourFavFlg
{
	self.likesCountLabel.text = [NSString stringWithFormat:@"%d", likes];
	self.favCountLabel.text = [NSString stringWithFormat:@"%d", favorites];
	self.favButton.enabled=!yourFavFlg;
	[self.likeButton setTitle:(youLikeFlg)?@"Unlike":@"Like" forState:UIControlStateNormal];
	self.likeLabel.text=(youLikeFlg)?@"You like!":@"Likes";
	self.likeLabel.textColor=(youLikeFlg)?[UIColor colorWithRed:0 green:.5 blue:0 alpha:1]:[UIColor blackColor];
	self.favLabel.text=(yourFavFlg)?@"Your Fav!":@"Favorites";
	self.favLabel.textColor=(yourFavFlg)?[UIColor magentaColor]:[UIColor blackColor];
}

@end
