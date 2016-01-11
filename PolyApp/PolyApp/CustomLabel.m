//
//  CustomLabel.m
//  PolyApp
//
//  Created by Rick Medved on 12/18/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "CustomLabel.h"
#import "UIColor+ATTColor.h"

@implementation CustomLabel

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

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
	self.layer.borderColor = [UIColor ATTDarkBlue].CGColor;
	self.layer.borderWidth = 1.;
}


@end
