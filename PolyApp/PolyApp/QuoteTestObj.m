//
//  QuoteTestObj.m
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "QuoteTestObj.h"

@implementation QuoteTestObj

+(QuoteTestObj *)objFromDatabaseObj:(NSManagedObject *)mo {
	QuoteTestObj *obj = [QuoteTestObj new];
	obj.type = [mo valueForKey:@"type"];
	obj.candidate_id = [[mo valueForKey:@"row_id"] intValue];
	obj.agreeCount = [[mo valueForKey:@"likes"] intValue];
	obj.agreePercent = [[mo valueForKey:@"popularity"] intValue];
	obj.name = [mo valueForKey:@"name"];
	obj.quotes = [mo valueForKey:@"attrib01"];
	obj.responses = [mo valueForKey:@"attrib02"];
	return obj;
}


@end
