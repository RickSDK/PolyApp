//
//  CandidateObj.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "CandidateObj.h"

@implementation CandidateObj

//attrib03 editLevel

+(CandidateObj*)objectFromManagedObject:(NSManagedObject *)mo {
	CandidateObj *candidateObj = [[CandidateObj alloc] init];
	candidateObj.candidate_id = [[mo valueForKey:@"candidate_id"] intValue];
	candidateObj.name = [mo valueForKey:@"name"];
	candidateObj.party = [mo valueForKey:@"party"];
	candidateObj.answers = [mo valueForKey:@"answers"];
	candidateObj.ideology = [mo valueForKey:@"ideology"];
	candidateObj.color = [[mo valueForKey:@"color"] intValue];
	candidateObj.govEcon = [[mo valueForKey:@"govEcon"] intValue];
	candidateObj.govMoral = [[mo valueForKey:@"govMoral"] intValue];
	candidateObj.conservativeMeter = [[mo valueForKey:@"conservativeMeter"] intValue];
	candidateObj.picLevel = [[mo valueForKey:@"picLevel"] intValue];
	candidateObj.issuesLevel = [[mo valueForKey:@"issuesLevel"] intValue];
	candidateObj.percentMatch = [[mo valueForKey:@"percentMatch"] intValue];
	candidateObj.lastUpdServer = [mo valueForKey:@"lastUpdServer"];
	candidateObj.lastUpdLocal = [mo valueForKey:@"lastUpdLocal"];
	candidateObj.quoteCounts = [mo valueForKey:@"quoteCounts"];
	candidateObj.droppedOutFlg = [[mo valueForKey:@"droppedOutFlg"] boolValue];
	candidateObj.pollingNumber = [[mo valueForKey:@"pollingNumber"] intValue];
	candidateObj.fringeFlg = [[mo valueForKey:@"fringeFlg"] boolValue];
	candidateObj.likes = [[mo valueForKey:@"likes"] boolValue];
	candidateObj.favorites = [[mo valueForKey:@"favorites"] boolValue];
	candidateObj.popularity = [[mo valueForKey:@"popularity"] intValue];
	candidateObj.editLevel = [[mo valueForKey:@"attrib03"] intValue];
	if(candidateObj.popularity==0)
		candidateObj.popularity = (candidateObj.favorites*10)+candidateObj.likes;
	NSArray *names = [candidateObj.name componentsSeparatedByString:@" "];
	if(names.count>0)
		candidateObj.lastName = [names objectAtIndex:names.count-1];
	
	return candidateObj;
}

@end
