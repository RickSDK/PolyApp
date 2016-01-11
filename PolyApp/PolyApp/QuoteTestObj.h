//
//  QuoteTestObj.h
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface QuoteTestObj : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *quotes;
@property (nonatomic, strong) NSString *responses;

@property (nonatomic) int candidate_id;
@property (nonatomic) int agreeCount;
@property (nonatomic) int agreePercent;

+(QuoteTestObj *)objFromDatabaseObj:(NSManagedObject *)mo;

@end
