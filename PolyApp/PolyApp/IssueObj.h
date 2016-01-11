//
//  IssueObj.h
//  PolyApp
//
//  Created by Rick Medved on 12/18/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface IssueObj : NSObject

@property (nonatomic) int issue_id;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *section;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *option1;
@property (nonatomic, retain) NSString *option2;
@property (nonatomic, retain) NSString *option3;

+(IssueObj*)objectFromManagedObject:(NSManagedObject *)mo;

@end
