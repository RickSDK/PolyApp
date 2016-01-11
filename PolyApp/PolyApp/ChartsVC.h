//
//  ChartsVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateVC.h"
#import "CustomSegment.h"

@interface ChartsVC : TemplateVC

@property (nonatomic) int startDegree;
@property (nonatomic) CGPoint startTouchPosition;

@property (strong, nonatomic) IBOutlet UIImageView *candidate1ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *candidate2ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *candidate3ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *candidate4ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *candidate5ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *candidate6ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *candidate7ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *candidate8ImageView;

@property (strong, nonatomic) NSMutableArray *candidateImageArray;

@property (strong, nonatomic) NSMutableArray *allVotersArray;
@property (strong, nonatomic) NSMutableArray *maleVotersArray;
@property (strong, nonatomic) NSMutableArray *femaleVotersArray;

@property (nonatomic) int maxVotes;

@property (strong, nonatomic) IBOutlet CustomSegment *sexSegment;

-(IBAction)segmentChanged:(id)sender;

@end
