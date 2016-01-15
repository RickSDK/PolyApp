//
//  UserTestResultsVC.h
//  PolyApp
//
//  Created by Rick Medved on 1/13/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "TemplateVC.h"

@interface UserTestResultsVC : TemplateVC

@property (strong, nonatomic) UserObj *uObj;
@property (nonatomic) int selectedRow;
@property (nonatomic) BOOL showMoreFlg;

@end
