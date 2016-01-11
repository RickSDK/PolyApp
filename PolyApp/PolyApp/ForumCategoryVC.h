//
//  ForumCategoryVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "ForumObj.h"
#import "UserObj.h"

@interface ForumCategoryVC : TemplateVC

@property (strong, nonatomic) UIViewController *forumVC;

@property (strong, nonatomic) ForumObj *forumObj;
@property (strong, nonatomic) UserObj *userObj;
@property (strong, nonatomic) IBOutlet UILabel *forumTitle;
@property (strong, nonatomic) IBOutlet UIView *createTopicView;
@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
//@property (strong, nonatomic) IBOutlet UITextView *bodyTextView;

- (IBAction) cancelButtonPressed: (id) sender;

@end
