//
//  UserObj.h
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface UserObj : NSObject

@property (nonatomic) int user_id;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *ideology;
@property (nonatomic, retain) NSString *imgDir;
@property (nonatomic, retain) NSString *candidateName;
@property (nonatomic, retain) NSString *created;
@property (nonatomic, retain) NSString *closestMatch;
@property (nonatomic, retain) NSString *lastLogin;
@property (nonatomic, retain) NSString *answers;

@property (nonatomic) int govEcon;
@property (nonatomic) int govMoral;
@property (nonatomic) int imgNum;
@property (nonatomic) int candidate_id;
@property (nonatomic) int followingFlg;
@property (nonatomic) int level;

@property (nonatomic) int favQuote;
@property (nonatomic) int favQuoteCandidate;
@property (nonatomic) int favQuoteIssue;
@property (nonatomic) int favCartoon;
@property (nonatomic) int favForum;
@property (nonatomic) int favDebate;

+(UserObj *)objectFromLine:(NSString *)line;
+(UserObj *)fullDataObjectFromLine:(NSString *)line;
+(UserObj *)objectFromFriendObj:(NSManagedObject *)mo;


+(void)showUserDetailsForUser:(UserObj *)user context:(NSManagedObjectContext *)context navCtrl:(UINavigationController *)navCtrl;

@end
