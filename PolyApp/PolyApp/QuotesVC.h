//
//  QuotesVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/22/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "CandidateObj.h"
#import "IssueObj.h"
#import "QuoteObj.h"

@interface QuotesVC : TemplateVC

@property (nonatomic, strong) CandidateObj *candidateObj;
@property (nonatomic, strong) IssueObj *issueObj;
@property (nonatomic, strong) QuoteObj *quoteObj;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *issueLabel;
@property (nonatomic, strong) IBOutlet UILabel *issueBlurbLabel;
@property (nonatomic, strong) IBOutlet UITextField *quoteTextField;
@property (nonatomic, strong) IBOutlet UITextField *sourceTextField;
@property (nonatomic, strong) IBOutlet UITextField *yearTextField;

@end
