//
//  IssueCompareVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/27/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "IssueObj.h"

@interface IssueCompareVC : TemplateVC

@property (nonatomic, strong) IssueObj *issueObj;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *option1Label;
@property (nonatomic, strong) IBOutlet UILabel *option2Label;
@property (nonatomic, strong) IBOutlet UILabel *option3Label;
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIImageView *myCheckBox;

@property (nonatomic, strong) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) IBOutlet UIButton *prevButton;

@property (nonatomic, strong) NSMutableArray *candidates;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *issues;
@property (nonatomic, strong) NSMutableArray *labels;

@property (nonatomic) int issue_id;
@property (nonatomic) int movementStep;
@property (nonatomic) BOOL shift1Flg;
@property (nonatomic) BOOL shift2Flg;
@property (nonatomic) BOOL shift3Flg;


- (IBAction) nextButtonPressed: (id) sender;
- (IBAction) prevButtonPressed: (id) sender;

@end
