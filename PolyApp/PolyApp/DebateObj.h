//
//  DebateObj.h
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebateObj : NSObject

@property (nonatomic) int debate_id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *position1;
@property (nonatomic, strong) NSString *position2;
@property (nonatomic, strong) NSString *opening1;
@property (nonatomic, strong) NSString *opening2;
@property (nonatomic, strong) NSString *firstRebuttal1;
@property (nonatomic, strong) NSString *firstRebuttal2;
@property (nonatomic, strong) NSString *secondRebuttal1;
@property (nonatomic, strong) NSString *secondRebuttal2;
@property (nonatomic, strong) NSString *closing1;
@property (nonatomic, strong) NSString *closing2;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *lastUpd;
@property (nonatomic, strong) NSString *imgDir1;
@property (nonatomic, strong) NSString *imgDir2;
@property (nonatomic, strong) NSString *username1;
@property (nonatomic, strong) NSString *username2;
@property (nonatomic, strong) NSString *shortDate;

@property (nonatomic) int user1;
@property (nonatomic) int user2;
@property (nonatomic) int currentUser;
@property (nonatomic) int lastUpdBy;
@property (nonatomic) int imgNum1;
@property (nonatomic) int imgNum2;
@property (nonatomic) int step;
@property (nonatomic) int likes;
@property (nonatomic) int favorites;
@property (nonatomic) int comments;
@property (nonatomic) int user1Votes;
@property (nonatomic) int user2Votes;

@property (nonatomic) BOOL youLikeFlg;
@property (nonatomic) BOOL yourFavFlg;
@property (nonatomic) BOOL youVotedFlg;

+(DebateObj *)objectFromLine:(NSString *)line;

@end
