//
//  AddNationVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/26/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"

@interface AddNationVC : TemplateVC

@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UIButton *yearButton;

@property (strong, nonatomic) IBOutlet UIButton *countryButton;
@property (strong, nonatomic) IBOutlet UIButton *govTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *voterTypeButton;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) int selectedRow;
@property (nonatomic) int selectedSection;
@property (nonatomic) int year;
@property (nonatomic) int nowYear;
@property (nonatomic) BOOL yearFlg;
@property (strong, nonatomic) NSMutableArray *mainArray;
@property (strong, nonatomic) NSMutableArray *countryArray;
@property (strong, nonatomic) UIBarButtonItem *rightButton;
@property (strong, nonatomic) NSString *startingValue;

- (IBAction) choosePressed: (id) sender;
- (IBAction) countryPressed: (id) sender;
- (IBAction) govSystemPressed: (id) sender;
- (IBAction) voterTypePressed: (id) sender;
- (IBAction) nextYearPressed: (id) sender;

@end
