//
//  ChooseAvatarVC.h
//  PolyApp
//
//  Created by Rick Medved on 1/13/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "TemplateVC.h"

@interface ChooseAvatarVC : TemplateVC

@property (strong, nonatomic) UIViewController *callBackViewController;
@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *chooseButton;

@property (strong, nonatomic) NSMutableArray *userAvatars;
@property (strong, nonatomic) NSMutableArray *candidateAvatars;

@property (nonatomic) int selectedNum;

- (IBAction) uploadNewButtonPressed: (id) sender;
- (IBAction) chooseButtonPressed: (id) sender;
- (IBAction) segmentChanged: (id) sender;

@end
