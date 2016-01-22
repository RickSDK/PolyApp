//
//  PolyTestVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "CustomSegment.h"

@interface PolyTestVC : TemplateVC

@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;

@property (strong, nonatomic) IBOutlet UIButton *prevButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutlet UIView *polyBGView;

@property (strong, nonatomic) IBOutlet UILabel *counterLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *sectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *option1Label;
@property (strong, nonatomic) IBOutlet UILabel *option2Label;
@property (strong, nonatomic) IBOutlet UILabel *option3Label;
@property (strong, nonatomic) IBOutlet UIView *questionView;
@property (strong, nonatomic) IBOutlet UIImageView *circleImageView;
@property (strong, nonatomic) IBOutlet UIView *graphicImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet CustomSegment *friendsSegment;

@property (strong, nonatomic) IBOutlet UILabel *ideologyLabel;
@property (strong, nonatomic) IBOutlet UITextView *ideologytextView;


@property (strong, nonatomic) UIBarButtonItem *rightButton;
@property (strong, nonatomic) NSMutableArray *issuesArray;
@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (strong, nonatomic) NSMutableArray *friendCirclesArray;
@property (strong, nonatomic) NSMutableArray *friendNamesArray;

@property (nonatomic) int selectedOption;
@property (nonatomic) int selectedRow;
@property (nonatomic) BOOL showMoreFlg;
@property (nonatomic) int questionNumber;
@property (nonatomic) BOOL hideCirclesFlg;

- (IBAction) checkButtonPressed: (id) sender;
- (IBAction) nextButtonPressed: (id) sender;
- (IBAction) prevButtonPressed: (id) sender;
- (IBAction) segmentChanged: (id) sender;
- (IBAction) retakeButtonPressed: (id) sender;
- (IBAction) scienceButtonPressed: (id) sender;

@end
