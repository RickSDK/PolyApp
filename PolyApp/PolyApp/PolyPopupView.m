//
//  PolyPopupView.m
//  PolyApp
//
//  Created by Rick Medved on 1/7/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "PolyPopupView.h"
#import "ObjectiveCScripts.h"

@implementation PolyPopupView

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
	self.layer.cornerRadius = 7;
	self.layer.masksToBounds = YES;				// clips background images to rounded corners
	self.layer.borderColor = [UIColor redColor].CGColor;
	self.layer.borderWidth = 4.;
	self.backgroundColor=[UIColor yellowColor];
	self.frame = CGRectMake(10, 10, 300, 260);
	
	UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 35)];
	topLabel.font = [UIFont boldSystemFontOfSize:30];
	topLabel.textAlignment = NSTextAlignmentCenter;
	topLabel.text = @"PolyApp Feature";
	topLabel.textColor = [UIColor blackColor];
	[self addSubview:topLabel];

	self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 280, 60)];
	self.messageLabel.font = [UIFont boldSystemFontOfSize:14];	// label is 17, system is 14
	self.messageLabel.textAlignment = NSTextAlignmentCenter;
	self.messageLabel.numberOfLines=4;
	self.messageLabel.textColor = [UIColor blackColor];
	self.messageLabel.text = @"message";
	[self addSubview:self.messageLabel];

	self.okButton = [CustomButton buttonWithType:UIButtonTypeRoundedRect];
	self.okButton.frame = CGRectMake(110, 200, 100, 40);
	[self.okButton setTitle:@"OK" forState:UIControlStateNormal];
	[self.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.okButton];

}

-(void)okButtonClicked {
	self.hidden=YES;
}

+(void)addPolyPopToView:(UIView *)view message:(NSString *)message polyId:(int)polyId {
	NSString *key = [NSString stringWithFormat:@"poly%d", polyId];
	if([ObjectiveCScripts getUserDefaultValue:key].length==0) {
		[ObjectiveCScripts setUserDefaultValue:@"Y" forKey:key];
		PolyPopupView *polyPopupView = [[PolyPopupView alloc] init];
		polyPopupView.messageLabel.text = message;
		[view addSubview:polyPopupView];
	}
}


@end
