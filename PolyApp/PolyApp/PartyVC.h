//
//  PartyVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/16/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "CustomButton.h"

@interface PartyVC : TemplateVC

@property (strong, nonatomic) UIBarButtonItem *rightButton;
@property (nonatomic, strong) UIViewController *callbackController;
//@property (strong, nonatomic) IBOutlet UIView *addPartyView;
@property (strong, nonatomic) IBOutlet CustomButton *colorButton;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) int colorNum;

- (IBAction) colorButtonPressed: (id) sender;
//- (IBAction) cancelButtonPressed: (id) sender;

@end
