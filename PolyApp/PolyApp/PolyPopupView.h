//
//  PolyPopupView.h
//  PolyApp
//
//  Created by Rick Medved on 1/7/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface PolyPopupView : UIView

@property (nonatomic, strong) CustomButton *okButton;
@property (nonatomic, strong) UILabel *messageLabel;

+(void)addPolyPopToView:(UIView *)view message:(NSString *)message polyId:(int)polyId;

@end
