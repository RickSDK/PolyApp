//
//  LikeFavBar.h
//  PolyApp
//
//  Created by Rick Medved on 12/31/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "CustomView.h"

@interface LikeFavBar : CustomView

@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UILabel *likesCountLabel;
@property (nonatomic, strong) UILabel *favLabel;
@property (nonatomic, strong) UILabel *favCountLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *favButton;

-(void)setupLikeFavBarButtonsForTarget:(id)target likeSelector:(SEL)likeSelector favSelector:(SEL)favSelector;
-(void)displayLikeFavBarLikes:(int)likes favorites:(int)favorites youLikeFlg:(BOOL)youLikeFlg yourFavFlg:(BOOL)yourFavFlg;

@end
