//
//  ForumPostVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "ForumObj.h"
#import "UserObj.h"

@interface ForumPostVC : TemplateVC

@property (strong, nonatomic) UIViewController *forumVC;
@property (strong, nonatomic) ForumObj *categoryObj;
@property (strong, nonatomic) ForumObj *topicObj;
@property (strong, nonatomic) ForumObj *forumObj;
@property (strong, nonatomic) UserObj *userObj;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;

@property (strong, nonatomic) IBOutlet UIButton *userButton;
@property (strong, nonatomic) IBOutlet UIButton *voteUpButton;
@property (strong, nonatomic) IBOutlet UIButton *voteDownButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *topReplyButton;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *votesUpLabel;
@property (strong, nonatomic) IBOutlet UILabel *votesDownLabel;
@property (strong, nonatomic) IBOutlet UILabel *alreadyVotedLabel;
@property (strong, nonatomic) IBOutlet UITextView *bodyTextView;

@property (strong, nonatomic) IBOutlet UIView *replyView;
@property (strong, nonatomic) IBOutlet UITextView *replyTextView;

@property (nonatomic) int voteType;
@property (nonatomic) BOOL editModeFlg;


- (IBAction) mainMenuButtonPressed: (id) sender;
- (IBAction) forumButtonPressed: (id) sender;
- (IBAction) cancelButtonPressed: (id) sender;
- (IBAction) replyButtonPressed: (id) sender;
- (IBAction) voteUpButtonPressed: (id) sender;
- (IBAction) voteDownButtonPressed: (id) sender;
- (IBAction) editButtonPressed: (id) sender;

@end
