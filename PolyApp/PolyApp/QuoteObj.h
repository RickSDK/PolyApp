//
//  QuoteObj.h
//  PolyApp
//
//  Created by Rick Medved on 12/22/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface QuoteObj : NSObject

@property (nonatomic) int quote_id;
@property (nonatomic, strong) NSString *quote;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSString *createdByName;
@property (nonatomic) int likes;
@property (nonatomic) int favorites;
@property (nonatomic) int popularity;
@property (nonatomic) BOOL youLikeFlg;
@property (nonatomic) BOOL yourFavFlg;

+(QuoteObj*)objectFromManagedObject:(NSManagedObject *)mo;

@end
