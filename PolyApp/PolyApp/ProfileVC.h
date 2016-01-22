//
//  ProfileVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "CustomSegment.h"

@interface ProfileVC : TemplateVC <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *yearBornField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *confirmField;
@property (strong, nonatomic) IBOutlet CustomSegment *sexSegment;
@property (strong, nonatomic) IBOutlet UIButton *countryButton;
@property (strong, nonatomic) IBOutlet UIButton *stateButton;
@property (strong, nonatomic) IBOutlet UIButton *updateProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *upgradeButton;
@property (strong, nonatomic) UIBarButtonItem *rightButton;

@property (strong, nonatomic) IBOutlet UIImageView *levelImageView;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;


@property (nonatomic) int selectedButton;
@property (nonatomic) BOOL editFieldsGrayFlg;

-(void)valueSelected:(NSString *)value;

-(IBAction)segmentClicked:(id)sender;
-(IBAction)drawMainPic:(UIImage *)image;
- (IBAction) countryButtonPressed: (id) sender;
- (IBAction) stateButtonPressed: (id) sender;
- (IBAction) changeAvatarButtonPressed: (id) sender;
- (IBAction) updateProfileButtonPressed: (id) sender;
- (IBAction) upgradeButtonPressed: (id) sender;

@end
