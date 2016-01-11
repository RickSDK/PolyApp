//
//  SelectListVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/19/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"

@interface SelectListVC : TemplateVC

@property (strong, nonatomic) NSArray *listArray;
@property (strong, nonatomic) NSMutableArray *displayArray;
@property (strong, nonatomic) NSString *selectedValue;
@property (strong, nonatomic) UIViewController *callBackViewController;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
