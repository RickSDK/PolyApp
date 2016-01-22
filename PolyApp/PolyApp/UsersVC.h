//
//  UsersVC.h
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "TemplateVC.h"

@interface UsersVC : TemplateVC

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) BOOL endOfResultsFlg;

@end
