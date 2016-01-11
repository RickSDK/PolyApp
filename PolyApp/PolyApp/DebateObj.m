//
//  DebateObj.m
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "DebateObj.h"

@implementation DebateObj

+(DebateObj *)objectFromLine:(NSString *)line {
	DebateObj *obj = [DebateObj new];
	NSArray *components = [line componentsSeparatedByString:@"|"];
	if(components.count>33) {
		obj.debate_id = [[components objectAtIndex:0] intValue];
		obj.user1 = [[components objectAtIndex:1] intValue];
		obj.user2 = [[components objectAtIndex:2] intValue];
		obj.currentUser = [[components objectAtIndex:3] intValue];
		obj.status = [components objectAtIndex:4];
		obj.topic = [components objectAtIndex:5];
		obj.position1 = [components objectAtIndex:6];
		obj.position2 = [components objectAtIndex:7];
		obj.opening1 = [components objectAtIndex:8];
		obj.opening2 = [components objectAtIndex:9];
		obj.firstRebuttal1 = [components objectAtIndex:10];
		obj.firstRebuttal2 = [components objectAtIndex:11];
		obj.secondRebuttal1 = [components objectAtIndex:12];
		obj.secondRebuttal2 = [components objectAtIndex:13];
		obj.closing1 = [components objectAtIndex:14];
		obj.closing2 = [components objectAtIndex:15];
		obj.created = [components objectAtIndex:16];
		obj.lastUpd = [components objectAtIndex:17];
		obj.lastUpdBy = [[components objectAtIndex:18] intValue];
		obj.imgDir1 = [components objectAtIndex:19];
		obj.imgDir2 = [components objectAtIndex:20];
		obj.imgNum1 = [[components objectAtIndex:21] intValue];
		obj.imgNum2 = [[components objectAtIndex:22] intValue];
		obj.username1 = [components objectAtIndex:23];
		obj.username2 = [components objectAtIndex:24];
		obj.step = [[components objectAtIndex:25] intValue];
		NSArray *dateParts = [obj.created componentsSeparatedByString:@" "];
		if(dateParts.count>0)
			obj.shortDate = [dateParts objectAtIndex:0];
		obj.likes = [[components objectAtIndex:26] intValue];
		obj.favorites = [[components objectAtIndex:27] intValue];
		obj.user1Votes = [[components objectAtIndex:28] intValue];
		obj.user2Votes = [[components objectAtIndex:29] intValue];
		obj.youLikeFlg = [[components objectAtIndex:30] isEqualToString:@"Y"];
		obj.yourFavFlg = [[components objectAtIndex:31] isEqualToString:@"Y"];
		obj.youVotedFlg = [[components objectAtIndex:32] isEqualToString:@"Y"];
		obj.comments = [[components objectAtIndex:33] intValue];
		
		
	} else
		NSLog(@"Only %d elements found!", (int)components.count);
	
	return obj;
}



@end
