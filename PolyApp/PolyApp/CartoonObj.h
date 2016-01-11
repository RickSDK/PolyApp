//
//  CartoonObj.h
//  PolyApp
//
//  Created by Rick Medved on 12/28/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartoonObj : NSObject

@property (nonatomic) int cartoon_id;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *createdByName;
@property (nonatomic) int createdBy;
@property (nonatomic) int likes;
@property (nonatomic) int favorites;
@property (nonatomic) int popularity;
@property (nonatomic) BOOL youLikeFlg;
@property (nonatomic) BOOL yourFavFlg;

@end
