//
//  ForumVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "ForumVC.h"
#import "ForumCatCell.h"
#import "ForumObj.h"
#import "ForumCategoryVC.h"
#import "EditTextViewVC.h"
#import "NSString+ATTString.h"
#import "NSDate+ATTDate.h"

@interface ForumVC ()

@end

@implementation ForumVC

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self startWebService:@selector(loadDataWebService) message:@"Loading"];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	

}

-(void)loadDataWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [ObjectiveCScripts getUserDefaultValue:@"Year"],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getForumCat.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7) {
					ForumObj *forumObj = [ForumObj categoryObjectFromLine:line];
					[self.mainArray addObject:forumObj];
				}
			[ObjectiveCScripts updateFlagForNumber:3 toString:@""];
		}

		[self stopWebService];
		[self.mainTableView reloadData];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	ForumCatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[ForumCatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	ForumObj *forumObj = [self.mainArray objectAtIndex:indexPath.row];
	cell.categoryLabel.text=[NSString stringWithFormat:@"   %@", forumObj.name];
	cell.postsLabel.text=[NSString stringWithFormat:@"%d", forumObj.posts];
	cell.repliesLabel.text=[NSString stringWithFormat:@"%d", forumObj.replies];
	cell.mostRecentLabel.text = forumObj.mostRecentDate;
	
	if([@"Admin" isEqualToString:forumObj.name])
		cell.categoryLabel.backgroundColor = [UIColor colorWithRed:.5 green:0 blue:0 alpha:1];
	
	cell.updatesPic.hidden=![ObjectiveCScripts newPostsForRowID:forumObj.row_id lastPost:forumObj.fullDate type:@"Cat"];
	
	
	cell.backgroundColor=(indexPath.row%2==0)?[UIColor whiteColor]:[UIColor colorWithWhite:.8 alpha:1];
	cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	
	return cell;
}
/*
-(BOOL)newPostsForCategory:(int)category lastPost:(NSString *)lastPost {
	if(lastPost.length==0)
		return NO;
	
	NSString *lastView = [ObjectiveCScripts getDateStringForForum:category type:@"Cat"];
	if(lastView.length==0)
		return YES;
	
	NSDate *lastPostDate = [ObjectiveCScripts dateFromString:lastPost];
	NSDate *lastViewDate = [ObjectiveCScripts dateFromString:lastView];
	int seconds = [lastViewDate timeIntervalSinceDate:lastPostDate];

	NSLog(@"[%@] [%@] %d", lastView, lastPost, seconds);
	
	return seconds<0;
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ForumCategoryVC *detailViewController = [[ForumCategoryVC alloc] initWithNibName:@"ForumCategoryVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Category";
	detailViewController.forumObj=[self.mainArray objectAtIndex:indexPath.row];
	detailViewController.forumVC=self;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

@end
