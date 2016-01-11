//
//  DebateDetailVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/31/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "DebateObj.h"
#import "LikeFavBar.h"

@interface DebateDetailVC : TemplateVC

@property (strong, nonatomic) DebateObj *debateObj;
@property (strong, nonatomic) NSMutableArray *titles;

@property (strong, nonatomic) IBOutlet UITextView *bodyTextView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *user1Votes;
@property (strong, nonatomic) IBOutlet UILabel *user2Votes;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;

@property (strong, nonatomic) IBOutlet UIImageView *yellowCircle;
@property (strong, nonatomic) IBOutlet UIView *votesBarView;
@property (strong, nonatomic) IBOutlet UIView *blueView;
@property (strong, nonatomic) IBOutlet LikeFavBar *likeFavBar;

@property (strong, nonatomic) IBOutlet UIView *debateWonView;
@property (strong, nonatomic) IBOutlet UILabel *user1Label;
@property (strong, nonatomic) IBOutlet UILabel *user2Label;

@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) IBOutlet UIButton *voteLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *voteRightButton;
@property (strong, nonatomic) IBOutlet UILabel *alreadyVotedLabel;

@property (nonatomic) int winner;
@property (nonatomic) BOOL editModeFlg;

-(IBAction)user1VoteButtonPressed:(id)sender;
-(IBAction)user2VoteButtonPressed:(id)sender;

-(IBAction)editButtonPressed:(id)sender;
-(IBAction)deleteButtonPressed:(id)sender;

@end
