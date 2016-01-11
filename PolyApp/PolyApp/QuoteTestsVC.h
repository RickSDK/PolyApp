//
//  QuoteTestsVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

//OBJECT
//type = ‘quoteTest’
//row_id = candidate_id
//likes = agreeCount
//popularity = agree%
//name = name
//attrib01 = quotes
//attrib02 = responses

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "QuoteTestObj.h"

@interface QuoteTestsVC : TemplateVC

@property (strong, nonatomic) IBOutlet UILabel *numberCompletedLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberAvailableLabel;
@property (strong, nonatomic) IBOutlet UIButton *takeTestButton;

@property (strong, nonatomic) IBOutlet UILabel *quoteLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIButton *yesButton;
@property (strong, nonatomic) IBOutlet UIButton *noButton;
@property (strong, nonatomic) QuoteTestObj *quoteTestObj;

@property (strong, nonatomic) NSMutableArray *candidatesArray;
@property (strong, nonatomic) NSMutableArray *quoteArray;
@property (nonatomic) int quoteIndex;

-(IBAction)testButtonPressed:(id)sender;
-(IBAction)answerButtonPressed:(id)sender;

@end
