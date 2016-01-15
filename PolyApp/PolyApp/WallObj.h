//
//  WallObj.h
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WallObj : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *imgDir;
@property (nonatomic, strong) NSString *recipName;

@property (nonatomic) int wall_id;
@property (nonatomic) int user_id;
@property (nonatomic) int picId;
@property (nonatomic) int createdBy;
@property (nonatomic) int imgNum;
@property (nonatomic) int recipient;
@property (nonatomic) BOOL deleteFlg;
@property (nonatomic) BOOL redirectedFlg;

+(WallObj *)objectFromLine:(NSString *)line;

@end
