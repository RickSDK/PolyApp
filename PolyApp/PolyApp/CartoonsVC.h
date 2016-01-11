//
//  CartoonsVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "CustomSegment.h"

@interface CartoonsVC : TemplateVC

@property (nonatomic) int cartoon_id;
@property (strong, nonatomic) IBOutlet UIButton *xButton;
@property (nonatomic) CGPoint startTouchPosition;
@property (nonatomic) CGPoint initTouchPosition;
@property (nonatomic) int cacheCount;
@property (nonatomic) int favoriteCartoon;

@end
