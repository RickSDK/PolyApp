//
//  WallObj.m
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "WallObj.h"

@implementation WallObj

+(WallObj *)objectFromLine:(NSString *)line {
	WallObj *obj = [WallObj new];
	NSArray *components = [line componentsSeparatedByString:@"|"];
	if(components.count>6) {
		obj.message = [components objectAtIndex:0];
		obj.created = [components objectAtIndex:1];
		obj.createdBy = [[components objectAtIndex:2] intValue];
		obj.user_id = [[components objectAtIndex:2] intValue];
		obj.username = [components objectAtIndex:3];
		obj.imgDir = [components objectAtIndex:4];
		obj.imgNum = [[components objectAtIndex:5] intValue];
		obj.wall_id = [[components objectAtIndex:6] intValue];
	}
	return obj;
}

@end
