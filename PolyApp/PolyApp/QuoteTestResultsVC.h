//
//  QuoteTestResultsVC.h
//  PolyApp
//
//  Created by Rick Medved on 1/9/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "TemplateVC.h"
#import "QuoteTestObj.h"

@interface QuoteTestResultsVC : TemplateVC

@property (strong, nonatomic) QuoteTestObj *quoteTestObj;
@property (strong, nonatomic) NSMutableArray *responsesArray;

@end
