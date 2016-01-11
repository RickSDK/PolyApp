//
//  UsersVC.m
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "UsersVC.h"
#import "UserCell.h"
#import "UserDetailVC.h"

@interface UsersVC ()

@end

@implementation UsersVC

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	[ObjectiveCScripts updateFlagForNumber:7 toString:@""];
	[self startWebService:@selector(loadDataWebService) message:@"Loading"];
}

-(void)loadDataWebService
{
	@autoreleasepool {
		[self.mainArray removeAllObjects];
		self.skipNumber=0;
		self.mainTableView.hidden=YES;
		[self doTheWork];
	}
}

-(void)doTheWork {
	self.allowMoreFlg=NO;
	NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"orderBy", @"skipNumber", nil];
	NSArray *valueList = [NSArray arrayWithObjects:
						  [ObjectiveCScripts getUserDefaultValue:@"userName"],
						  [ObjectiveCScripts getUserDefaultValue:@"Country"],
						  (self.sortSegment.selectedSegmentIndex==0)?@"created":@"name",
						  [NSString stringWithFormat:@"%d", self.skipNumber],
						  nil];
	NSString *webAddr = @"http://www.appdigity.com/poly/getUsers.php";
	NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
	NSLog(@"%@", responseStr);
	if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
		NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
		for(NSString *line in lines)
			if(line.length>7) {
				NSArray *components = [line componentsSeparatedByString:@"|"];
				if(components.count>5) {
					UserObj *userObj= [UserObj objectFromLine:line];
					[self.mainArray addObject:userObj];
					self.skipNumber++;
					self.allowMoreFlg=YES;
				}
			}
	} else
		[ObjectiveCScripts showAlertPopup:@"Server Error" message:@"Unable to reach the server. Try again later."];
	
	
	self.mainTableView.hidden=NO;
	[self stopWebService];
	[self.mainTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	UserCell *cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

	UserObj *userObj= [self.mainArray objectAtIndex:indexPath.row];
	[UserCell populateCell:cell withObj:userObj];
	
	cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UserDetailVC *detailViewController = [[UserDetailVC alloc] initWithNibName:@"UserDetailVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"User Details";
	detailViewController.userDataObj=[self.mainArray objectAtIndex:indexPath.row];
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
	return 44;
}

@end
