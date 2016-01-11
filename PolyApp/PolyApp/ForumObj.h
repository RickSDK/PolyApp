//
//  ForumObj.h
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForumObj : NSObject

@property (nonatomic) int row_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mostRecentDate;
@property (nonatomic, strong) NSString *fullDate;
@property (nonatomic, strong) NSString *mostRecentName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *imgDir;
@property (nonatomic) int user_id;
@property (nonatomic) int imgNum;
@property (nonatomic) int mostRecentUserId;
@property (nonatomic) int posts;
@property (nonatomic) int replies;
@property (nonatomic) int votesUp;
@property (nonatomic) int votesDown;
@property (nonatomic) BOOL votedFlg;

+(ForumObj*)categoryObjectFromLine:(NSString *)line;
+(ForumObj*)postObjectFromLine:(NSString *)line;

@end
