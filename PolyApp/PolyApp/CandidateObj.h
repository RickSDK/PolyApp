//
//  CandidateObj.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CandidateObj : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *party;
@property (nonatomic, strong) NSString *ideology;
@property (nonatomic, strong) NSString *answers;
@property (nonatomic, strong) NSString *lastUpdServer;
@property (nonatomic, strong) NSString *lastUpdLocal;
@property (nonatomic, strong) NSString *quoteCounts;

@property (nonatomic) int candidate_id;
@property (nonatomic) int color;
@property (nonatomic) int govEcon;
@property (nonatomic) int govMoral;
@property (nonatomic) int conservativeMeter;
@property (nonatomic) int picLevel;
@property (nonatomic) int issuesLevel;
@property (nonatomic) int editLevel;
@property (nonatomic) int percentMatch;
@property (nonatomic) int pollingNumber;
@property (nonatomic) int likes;
@property (nonatomic) int favorites;
@property (nonatomic) int totalQuotes;
@property (nonatomic) int popularity;
@property (nonatomic) float xCord1;
@property (nonatomic) float xCord2;
@property (nonatomic) float yCord1;
@property (nonatomic) float yCord2;

@property (nonatomic) BOOL droppedOutFlg;
@property (nonatomic) BOOL hidden;
@property (nonatomic) BOOL fringeFlg;
@property (nonatomic) BOOL youLikeFlg;
@property (nonatomic) BOOL yourFavFlg;

+(CandidateObj*)objectFromManagedObject:(NSManagedObject *)mo;

@end
