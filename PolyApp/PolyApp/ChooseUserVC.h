//
//  ChooseUserVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ChooseUserVC : TemplateVC

@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *iPoliticsButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FBLoginButton;

@property (strong, nonatomic) NSString *fBUsername;
@property (strong, nonatomic) NSString *fBImageURL;

@property (nonatomic) BOOL *showLoginFlg;

- (IBAction) loginPressed: (id) sender;
- (IBAction) cancelPressed: (id) sender;
- (IBAction) facebookPressed: (id) sender;
- (IBAction) iPoliticsPressed: (id) sender;


@end
