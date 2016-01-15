//
//  UserDetailVC.h
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "TemplateVC.h"
#import "UserObj.h"

@interface UserDetailVC : TemplateVC

@property (strong, nonatomic) UserObj *userDataObj;
@property (strong, nonatomic) IBOutlet UILabel *wallNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postOnWallLabel;
@property (strong, nonatomic) IBOutlet UILabel *largeUserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *smallUserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *followingLabel;

@property (strong, nonatomic) IBOutlet UILabel *candidateNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *candidateImageView;

@property (strong, nonatomic) IBOutlet UIView *largeView;
@property (strong, nonatomic) IBOutlet UIImageView *largePolyView;
@property (strong, nonatomic) IBOutlet UIImageView *largeCircle;
@property (strong, nonatomic) IBOutlet UILabel *largeUserLabel;


@property (strong, nonatomic) IBOutlet UIImageView *circleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *beliefsView;
@property (strong, nonatomic) IBOutlet UIImageView *largeImageView;
@property (strong, nonatomic) IBOutlet UITextField *wallTextField;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *upgradeButton;
@property (nonatomic) BOOL followingFlg;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *imageIndicatorView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *dataIndicatorView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *wallIndicatorView;

/*
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdLabel;
@property (strong, nonatomic) IBOutlet UILabel *ideologyLabel;
@property (strong, nonatomic) IBOutlet UILabel *closestMatchLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLevelName;
@property (strong, nonatomic) IBOutlet UIImageView *userLevelImageView;
@property (strong, nonatomic) IBOutlet UIButton *favCartoonButton;
@property (strong, nonatomic) IBOutlet UIButton *favQuoteButton;
@property (strong, nonatomic) IBOutlet UIButton *favForumButton;
@property (strong, nonatomic) IBOutlet UIButton *favDebateButton;
@property (strong, nonatomic) IBOutlet UILabel *favCartoonLabel;
@property (strong, nonatomic) IBOutlet UILabel *favQuoteLabel;
@property (strong, nonatomic) IBOutlet UILabel *favDebateLabel;
@property (strong, nonatomic) IBOutlet UILabel *favForumLabel;
*/

-(IBAction)followButtonPressed:(id)sender;
-(IBAction)mainSegmentChanged:(id)sender;

-(IBAction)upgradeButtonPressed:(id)sender;

-(IBAction)testResultsButtonPressed:(id)sender;


@end
