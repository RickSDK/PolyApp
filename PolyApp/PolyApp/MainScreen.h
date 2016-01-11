//
//  MainScreen.h
//  PolyApp
//
//  Created by Rick Medved on 12/14/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"

@interface MainScreen : TemplateVC

@property (strong, nonatomic) IBOutlet UILabel *currentChoiceLabel;

@property (strong, nonatomic) IBOutlet UIView *candidateView;
@property (strong, nonatomic) IBOutlet UIImageView *candidateImageView;
@property (strong, nonatomic) IBOutlet UIView *match1View;
@property (strong, nonatomic) IBOutlet UIView *match2View;
@property (strong, nonatomic) IBOutlet UIView *beliefs1View;
@property (strong, nonatomic) IBOutlet UIView *beliefs2View;

@property (strong, nonatomic) IBOutlet UIImageView *matchImageView;
@property (strong, nonatomic) IBOutlet UILabel *matchNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *beliefsLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftUsernameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *circleImageView;

@property (strong, nonatomic) IBOutlet UIImageView *issueUpdateImageView;
@property (strong, nonatomic) IBOutlet UILabel *issueUpdateLabel;


@property (strong, nonatomic) IBOutlet UILabel *nationLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;

@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UITextField *wallTextField;

@property (strong, nonatomic) NSMutableArray *mainMenu;


@end
