//
//  ForumObj.m
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "ForumObj.h"

@implementation ForumObj

+(ForumObj*)categoryObjectFromLine:(NSString *)line {
	ForumObj *forumObj = [ForumObj new];
	NSArray *components = [line componentsSeparatedByString:@"|"];
	if(components.count>6) {
		forumObj.row_id = [[components objectAtIndex:0] intValue];
		forumObj.name = [components objectAtIndex:1];
		forumObj.posts = [[components objectAtIndex:2] intValue];
		forumObj.replies = [[components objectAtIndex:3] intValue];
		forumObj.fullDate = [components objectAtIndex:4];
		forumObj.mostRecentUserId = [[components objectAtIndex:5] intValue];
		forumObj.mostRecentName = [components objectAtIndex:6];
		NSArray *dateParts = [forumObj.fullDate componentsSeparatedByString:@" "];
		if(dateParts.count>0)
			forumObj.mostRecentDate = [dateParts objectAtIndex:0];
	}
	return forumObj;
}

+(ForumObj*)postObjectFromLine:(NSString *)line {
	ForumObj *forumObj = [ForumObj new];
	NSArray *components = [line componentsSeparatedByString:@"|"];
	if(components.count>14) {
		forumObj.row_id = [[components objectAtIndex:0] intValue];
		forumObj.title = [components objectAtIndex:1];
		forumObj.body = [components objectAtIndex:2];
		forumObj.replies = [[components objectAtIndex:3] intValue];
		forumObj.fullDate = [components objectAtIndex:4];
		forumObj.user_id = [[components objectAtIndex:5] intValue];
		forumObj.name = [components objectAtIndex:6];
		forumObj.votesUp = [[components objectAtIndex:7] intValue];
		forumObj.votesDown = [[components objectAtIndex:8] intValue];
		forumObj.imgDir = [components objectAtIndex:9];
		forumObj.imgNum = [[components objectAtIndex:10] intValue];
		forumObj.votedFlg = [[components objectAtIndex:11] intValue]>0;
		forumObj.mostRecentUserId = [[components objectAtIndex:12] intValue];
		forumObj.mostRecentName = [components objectAtIndex:13];
		forumObj.mostRecentDate = [components objectAtIndex:14];
		NSArray *dateParts = [forumObj.mostRecentDate componentsSeparatedByString:@" "];
		if(dateParts.count>0)
			forumObj.mostRecentDate = [dateParts objectAtIndex:0];
	}
	return forumObj;
}

@end
