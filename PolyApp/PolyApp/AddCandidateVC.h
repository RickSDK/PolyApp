//
//  AddCandidateVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/16/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"

@interface AddCandidateVC : TemplateVC <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *partyButton;
@property (strong, nonatomic) IBOutlet UIButton *imgButton;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic) int partyColor;
@property (strong, nonatomic) NSString *partyName;
@property (strong, nonatomic) UIImage *candidateImage;
@property (strong, nonatomic) UIImage *candidateThumbnailImage;

- (IBAction) partyButtonPressed: (id) sender;
- (IBAction) imgButtonPressed: (id) sender;

-(void)populatePartyField:(NSString *)line;

@end
