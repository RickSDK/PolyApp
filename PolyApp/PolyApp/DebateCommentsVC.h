//
//  DebateCommentsVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/31/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "DebateObj.h"

@interface DebateCommentsVC : TemplateVC

@property (strong, nonatomic) DebateObj *debateObj;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;

@end
