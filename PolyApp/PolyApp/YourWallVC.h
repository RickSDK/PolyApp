//
//  YourWallVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"

@interface YourWallVC : TemplateVC

@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic) int recordsToDelete;

- (IBAction) deleteButtonPressed: (id) sender;
- (IBAction) xButtonPressed: (id) sender;

@end
