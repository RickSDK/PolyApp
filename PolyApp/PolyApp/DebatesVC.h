//
//  DebatesVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "CustomSegment.h"
#import "UserObj.h"

@interface DebatesVC : TemplateVC

@property (strong, nonatomic) IBOutlet CustomSegment *topSegment;

@property (strong, nonatomic) IBOutlet UITextField *topicTextField;
@property (strong, nonatomic) IBOutlet UITextField *yourPositionTextField;
@property (strong, nonatomic) IBOutlet UITextField *opponentPositionTextField;
@property (strong, nonatomic) IBOutlet UITextView *openingTextView;

@property (strong, nonatomic) IBOutlet UIView *howWorkView;
@property (strong, nonatomic) UserObj *user1;
@property (strong, nonatomic) UserObj *user2;

-(IBAction)topSegmentClicked:(id)sender;
-(IBAction)howWorkButtonClicked:(id)sender;
-(IBAction)howXButtonClicked:(id)sender;

-(void)returningText:(NSString *)text;

@end
