//
//  EditTextViewVC.h
//  PolyApp
//
//  Created by Rick Medved on 1/2/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "TemplateVC.h"

@interface EditTextViewVC : TemplateVC

@property (strong, nonatomic) NSString *startingText;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) UIViewController *callBackViewController;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *charsRemainingLabel;
@property (strong, nonatomic) IBOutlet UITextView *bodyTextView;

@property (nonatomic) int maxChars;
@property (nonatomic) BOOL changesMade;

-(void)returningText:(NSString *)text;

@end
