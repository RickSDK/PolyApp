//
//  CandidateDetailVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/18/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "CandidateObj.h"
#import "CustomSegment.h"
#import "LikeFavBar.h"

@interface CandidateDetailVC : TemplateVC

@property (nonatomic, strong) CandidateObj *candidateObj;
@property (nonatomic, strong) NSArray *quoteCountsArray;
@property (nonatomic, strong) LikeFavBar *likeFavBar;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *ideologyLabel;
@property (nonatomic, strong) IBOutlet UILabel *matchLabel;
@property (nonatomic, strong) IBOutlet UILabel *updateMessageLabel;
@property (nonatomic, strong) IBOutlet UIImageView *largeImageView;

@property (nonatomic, strong) IBOutlet UIButton *saveChangesButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelChangesButton;

@property (nonatomic, strong) IBOutlet UIView *graphicView;
@property (nonatomic, strong) IBOutlet UIImageView *circleImg;
@property (nonatomic, strong) IBOutlet UILabel *nameChartLabel;

@property (nonatomic, strong) IBOutlet UIView *largeGraphicView;
@property (nonatomic, strong) IBOutlet UIImageView *largeCircleImg;
@property (nonatomic, strong) IBOutlet UILabel *largeNameChartLabel;

@property (nonatomic, strong) IBOutlet UIView *editCandidateView;
@property (nonatomic, strong) IBOutlet UISwitch *droppedOutSwitch;
@property (nonatomic, strong) IBOutlet CustomSegment *topTierSegment;
@property (nonatomic, strong) IBOutlet UIButton *updateButton;

@property (nonatomic, strong) IBOutlet UIView *candidateIdeologyView;
@property (nonatomic, strong) IBOutlet UILabel *candidateIdeologyLabel;
@property (nonatomic, strong) IBOutlet UITextView *candidateIdeologyTextView;

@property (nonatomic, strong) IBOutlet UIView *matchPercentView;
@property (nonatomic, strong) IBOutlet UILabel *matchPercentLabel;


@property (nonatomic) BOOL youLikeFlg;
@property (nonatomic) BOOL yourFavFlg;
@property (nonatomic) BOOL hideUserFlg;
@property (nonatomic) int favQuote_id;
@property (nonatomic) int favQuoteCandidate;
@property (nonatomic) int favQuoteIssue;

//Admin
@property (nonatomic, strong) IBOutlet UIView *adminView;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UIButton *partyButton;




@property (nonatomic) BOOL editMode;
@property (nonatomic) BOOL forceRecache;
@property (nonatomic) int percent;
@property (nonatomic) int motionStep;



-(void)loadCandidate;
- (IBAction) xButtonPressed: (id) sender;
- (IBAction) saveButtonPressed: (id) sender;
- (IBAction) cancelButtonPressed: (id) sender;
- (IBAction) switchPressed: (id) sender;
- (IBAction) segmentChanged: (id) sender;
- (IBAction) updateButtonPressed: (id) sender;
- (IBAction) deleteButtonPressed: (id) sender;


@end
