//
//  IssueObj.m
//  PolyApp
//
//  Created by Rick Medved on 12/18/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "IssueObj.h"

@implementation IssueObj

+(IssueObj*)objectFromManagedObject:(NSManagedObject *)mo {
	IssueObj *issueObj = [[IssueObj alloc] init];
	issueObj.issue_id = [[mo valueForKey:@"issue_id"] intValue];
	issueObj.category = [mo valueForKey:@"category"];
	issueObj.section = [mo valueForKey:@"section"];
	issueObj.name = [mo valueForKey:@"name"];
	issueObj.option1 = [mo valueForKey:@"option1"];
	issueObj.option2 = [mo valueForKey:@"option2"];
	issueObj.option3 = [mo valueForKey:@"option3"];
	return issueObj;
}

@end
