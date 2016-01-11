//
//  CandidatesVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "CustomSegment.h"
#import "PolyPopupView.h"
#import "CandidateObj.h"

@interface CandidatesVC : TemplateVC

@property (nonatomic) BOOL chooseFlg;
@property (nonatomic) BOOL forceRecache;
@property (nonatomic) int sections;
@property (nonatomic) int rows;
@property (nonatomic) int currentRow;
@property (nonatomic, strong) NSString *currentParty;
@property (nonatomic, strong) CandidateObj *selectedCandidate;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet CustomSegment *sortSegment;
@property (strong, nonatomic) IBOutlet CustomSegment *topTierSegment;
@property (strong, nonatomic) IBOutlet UIButton *compareButton;
//@property (strong, nonatomic) PolyPopupView *polyPopupView;

-(IBAction)sortSegmentClicked:(id)sender;
-(IBAction)bottomSegmentClicked:(id)sender;
-(IBAction)compareButtonClicked:(id)sender;


@end
