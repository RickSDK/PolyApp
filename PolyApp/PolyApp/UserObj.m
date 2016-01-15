//
//  UserObj.m
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "UserObj.h"
#import "UserDetailVC.h"

@implementation UserObj

+(UserObj *)objectFromLine:(NSString *)line {
	UserObj *obj = [UserObj new];
	
	NSArray *components = [line componentsSeparatedByString:@"|"];
	if(components.count>6) {
		obj.user_id = [[components objectAtIndex:0] intValue];
		obj.userName = [components objectAtIndex:1];
		obj.ideology = [components objectAtIndex:2];
		obj.imgDir = [components objectAtIndex:3];
		obj.imgNum = [[components objectAtIndex:4] intValue];
		obj.state = [components objectAtIndex:5];
		obj.country = [components objectAtIndex:6];
	}
	return obj;
}

+(UserObj *)fullDataObjectFromLine:(NSString *)line {
	UserObj *obj = [UserObj new];
	
	NSArray *components = [line componentsSeparatedByString:@"|"];
	if(components.count>22) {
		obj.user_id = [[components objectAtIndex:0] intValue];
		obj.userName = [components objectAtIndex:1];
		obj.ideology = [components objectAtIndex:2];
		obj.imgDir = [components objectAtIndex:3];
		obj.imgNum = [[components objectAtIndex:4] intValue];
		obj.state = [components objectAtIndex:5];
		obj.country = [components objectAtIndex:6];
		obj.govEcon = [[components objectAtIndex:7] intValue];
		obj.govMoral = [[components objectAtIndex:8] intValue];
		obj.candidate_id = [[components objectAtIndex:9] intValue];
		obj.candidateName = [components objectAtIndex:10];
		obj.followingFlg = [@"Y" isEqualToString:[components objectAtIndex:11]];
		obj.created = [components objectAtIndex:12];
		NSArray *dateParts = [obj.created componentsSeparatedByString:@" "];
		if(dateParts.count>0)
			obj.created = [dateParts objectAtIndex:0];
		obj.closestMatch = [components objectAtIndex:13];
		obj.level = [[components objectAtIndex:14] intValue];
		obj.favQuote = [[components objectAtIndex:15] intValue];
		obj.favForum = [[components objectAtIndex:16] intValue];
		obj.favDebate = [[components objectAtIndex:17] intValue];
		obj.favCartoon = [[components objectAtIndex:18] intValue];
		obj.lastLogin = [components objectAtIndex:19];
		obj.answers = [components objectAtIndex:20];
		obj.favQuoteCandidate = [[components objectAtIndex:21] intValue];
		obj.favQuoteIssue = [[components objectAtIndex:22] intValue];
	}
	return obj;
}

+(void)showUserDetailsForUser:(UserObj *)user context:(NSManagedObjectContext *)context navCtrl:(UINavigationController *)navCtrl {
	if(user.user_id>1) {
		UserDetailVC *detailViewController = [[UserDetailVC alloc] initWithNibName:@"UserDetailVC" bundle:nil];
		detailViewController.managedObjectContext = context;
		detailViewController.userDataObj=user;
		[navCtrl pushViewController:detailViewController animated:YES];
	}
}

+(UserObj *)objectFromFriendObj:(NSManagedObject *)mo {
	UserObj *obj = [UserObj new];
	obj.user_id = [[mo valueForKey:@"user_id"] intValue];
	obj.userName = [mo valueForKey:@"name"];
	obj.govEcon = [[mo valueForKey:@"govEcon"] intValue];
	obj.govMoral = [[mo valueForKey:@"govMoral"] intValue];
	obj.imgDir = [mo valueForKey:@"imgDir"];
	obj.ideology = [mo valueForKey:@"ideology"];
	obj.imgNum = [[mo valueForKey:@"imgNum"] intValue];
	obj.state = [mo valueForKey:@"state"];
	obj.country = [mo valueForKey:@"country"];
	return obj;
}


@end
