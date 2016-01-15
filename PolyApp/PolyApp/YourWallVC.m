//
//  YourWallVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "YourWallVC.h"
#import "WallObj.h"
#import "WallCell.h"

@interface YourWallVC ()

@end

@implementation YourWallVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[ObjectiveCScripts updateFlagForNumber:1 toString:@""];
	[self startWebService:@selector(loadWallDataWebService) message:nil];
	[self extendTableForGold];
}

-(void)loadWallDataWebService {
	@autoreleasepool {
		[self.mainArray removeAllObjects];
		[self doTheWork];
	}
}

-(void)doTheWork {
	self.allowMoreFlg=NO;
	
	NSArray *nameList = [NSArray arrayWithObjects:@"username", @"uid", nil];
	NSArray *valueList = [NSArray arrayWithObjects:
						  [ObjectiveCScripts getUserDefaultValue:@"userName"],
						  [NSString stringWithFormat:@"%d", [ObjectiveCScripts myUserId]],
						  nil];
	NSString *webAddr = @"http://www.appdigity.com/poly/getWall.php";
	NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
	NSLog(@"+++response: %@", responseStr);
	if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
		NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
		for(NSString *line in lines)
			if(line.length>7) {
				NSArray *components = [line componentsSeparatedByString:@"|"];
				if(components.count>5) {
					WallObj *wallObj = [WallObj objectFromLine:line];
					[self.mainArray addObject:wallObj];
				}
			}
	}
	
	self.mainTableView.hidden=NO;
	[self stopWebService];
	self.recordsToDelete=0;
	[self.mainTableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	WallCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[WallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	WallObj *wallObj = [self.mainArray objectAtIndex:indexPath.row];
	[WallCell populateCell:cell withObj:wallObj];

	[ObjectiveCScripts showUserButton:cell.userButton selector:@selector(userSelected:) dir:wallObj.imgDir number:wallObj.imgNum name:wallObj.username label:cell.usernameLabel tarrget:self];
	cell.userButton.tag=indexPath.row;
	cell.checkButton.hidden=self.popupView.hidden;
	[cell.checkButton setBackgroundImage:(wallObj.deleteFlg)?[UIImage imageNamed:@"checkMark.jpg"]:nil forState:UIControlStateNormal];
	[cell.checkButton addTarget:self action:@selector(boxChecked:) forControlEvents:UIControlEventTouchDown];
	cell.checkButton.tag = indexPath.row;
	if(wallObj.deleteFlg)
		self.recordsToDelete++;

	self.deleteButton.enabled=self.recordsToDelete>0;

	cell.accessoryType= UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

-(void)boxChecked:(UIButton *)button {
	WallObj *wallObj = [self.mainArray objectAtIndex:button.tag];
	wallObj.deleteFlg = !wallObj.deleteFlg;
	self.recordsToDelete=0;
	[self.mainTableView reloadData];
}

-(void)userSelected:(UIButton *)button {
	WallObj *obj = [self.mainArray objectAtIndex:button.tag];
	self.userObj.user_id = obj.user_id;
	[UserObj showUserDetailsForUser:self.userObj context:self.managedObjectContext navCtrl:self.navigationController];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self toggleView];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	WallObj *wallObj = [self.mainArray objectAtIndex:indexPath.row];
	return [WallCell heightForCellWithText:wallObj.message];
}

-(void)toggleView {
	self.popupView.hidden=!self.popupView.hidden;
	self.deleteButton.enabled=self.recordsToDelete>0;
	self.recordsToDelete=0;
	[self.mainTableView reloadData];
}

- (IBAction) deleteButtonPressed: (id) sender {
	[self startWebService:@selector(deleteRecords) message:nil];
}

-(void)deleteRecords {
	NSMutableArray *newArray = [NSMutableArray new];
	NSMutableArray *deleteArray = [NSMutableArray new];
	for(WallObj *wallObj in self.mainArray) {
		if(wallObj.deleteFlg)
			[deleteArray addObject:[NSString stringWithFormat:@"%d", wallObj.wall_id]];
		else
			[newArray addObject:wallObj];
	}
	NSString *delRecords = [deleteArray componentsJoinedByString:@":"];
	NSArray *nameList = [NSArray arrayWithObjects:@"username", @"delRecords", nil];
	NSArray *valueList = [NSArray arrayWithObjects:
						  [ObjectiveCScripts getUserDefaultValue:@"userName"],
						  delRecords,
						  nil];
	NSString *webAddr = @"http://www.appdigity.com/poly/deleteWall.php";
	NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
	NSLog(@"+++response: %@", responseStr);
	self.mainArray=newArray;
	[self stopWebService];
	[self toggleView];
}

- (IBAction) xButtonPressed: (id) sender {
	[self toggleView];
}

@end
