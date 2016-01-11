//
//  QuoteObj.m
//  PolyApp
//
//  Created by Rick Medved on 12/22/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "QuoteObj.h"

@implementation QuoteObj

+(QuoteObj*)objectFromManagedObject:(NSManagedObject *)mo {
	QuoteObj *quoteObj = [QuoteObj new];
	quoteObj.quote_id = [[mo valueForKey:@"quote_id"] intValue];
	quoteObj.likes = [[mo valueForKey:@"likes"] intValue];
	quoteObj.favorites = [[mo valueForKey:@"favorites"] intValue];
	quoteObj.popularity = [[mo valueForKey:@"popularity"] intValue];
	quoteObj.youLikeFlg = [[mo valueForKey:@"youLikeFlg"] boolValue];
	quoteObj.yourFavFlg = [[mo valueForKey:@"yourFavFlg"] boolValue];
	quoteObj.quote = [mo valueForKey:@"quote"];
	quoteObj.source = [mo valueForKey:@"source"];
	quoteObj.year = [mo valueForKey:@"year"];
	quoteObj.createdByName = [mo valueForKey:@"createdByName"];
	return quoteObj;
}

@end
