//
//  CandidateIssueVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/21/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "CandidateObj.h"
#import "IssueObj.h"
#import "QuoteObj.h"

@interface CandidateIssueVC : TemplateVC

@property (nonatomic, strong) UIViewController *callbackViewController;
@property (nonatomic, strong) CandidateObj *candidateObj;
@property (nonatomic, strong) IssueObj *issueObj;
@property (nonatomic, strong) QuoteObj *quoteObj;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *partyLabel;
@property (nonatomic, strong) IBOutlet UILabel *issueLabel;
@property (nonatomic, strong) IBOutlet UILabel *option1Label;
@property (nonatomic, strong) IBOutlet UILabel *option2Label;
@property (nonatomic, strong) IBOutlet UILabel *option3Label;

@property (nonatomic, strong) IBOutlet UIButton *you1Button;
@property (nonatomic, strong) IBOutlet UIButton *you2Button;
@property (nonatomic, strong) IBOutlet UIButton *you3Button;
@property (nonatomic, strong) IBOutlet UIButton *can1Button;
@property (nonatomic, strong) IBOutlet UIButton *can2Button;
@property (nonatomic, strong) IBOutlet UIButton *can3Button;
@property (strong, nonatomic) UIBarButtonItem *rightButton;

@property (nonatomic, strong) IBOutlet UIButton *updateButton;
@property (nonatomic, strong) IBOutlet UIButton *addQuoteButton;

@property (nonatomic, strong) IBOutlet UIImageView *candidateImage;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImage;

@property (nonatomic, strong) IBOutlet UITextView *quoteTextView;
@property (nonatomic, strong) IBOutlet UILabel *sourceLabel;
@property (nonatomic, strong) IBOutlet UILabel *yearLabel;
@property (nonatomic, strong) IBOutlet UILabel *createdByLabel;
@property (nonatomic, strong) IBOutlet UIButton *editButton;
@property (nonatomic, strong) IBOutlet UIImageView *candidateImageView;
@property (nonatomic, strong) IBOutlet UILabel *candidateNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *issueNameLabel;

@property (nonatomic, strong) IBOutlet UILabel *quotesPoliciesLabel;


//Needed for likes
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *favoriteButton;
@property (nonatomic, strong) IBOutlet UILabel *likeCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *favCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *youLikeLabel;
@property (nonatomic, strong) IBOutlet UILabel *yourFavoriteLabel;



@property (nonatomic) BOOL editMode;
@property (nonatomic) int canPosition;
@property (nonatomic) int favQuote;

@property (nonatomic) int govEcon;
@property (nonatomic) int govMoral;
@property (nonatomic) int conservativeMeter;
@property (strong, nonatomic) NSString *ideology;
@property (strong, nonatomic) NSString *answers;

- (IBAction) canButtonPressed: (id) sender;
- (IBAction) quoteButtonPressed: (id) sender;
- (IBAction) editQuoteButtonPressed: (id) sender;
- (IBAction) deleteButtonPressed: (id) sender;
- (IBAction) likeButtonPressed: (id) sender;
- (IBAction) favoriteButtonPressed: (id) sender;
- (IBAction) compareButtonPressed: (id) sender;


@end
