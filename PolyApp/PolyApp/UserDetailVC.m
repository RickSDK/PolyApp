//
//  UserDetailVC.m
//  PolyApp
//
//  Created by Rick Medved on 1/1/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "UserDetailVC.h"
#import "WallObj.h"
#import "WallCell.h"
#import "CartoonsVC.h"
#import "CandidateIssueVC.h"
#import "CoreDataLib.h"
#import "UpgradeVC.h"

@interface UserDetailVC ()

@end

@implementation UserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.textFieldElements addObject:self.wallTextField];
	self.largeView.hidden=YES;

	
	[self setupDataForUser:self.userDataObj];
	self.followButton.enabled=NO;
	self.followingLabel.hidden=YES;
	
	[self.dataIndicatorView startAnimating];
	if(self.userDataObj.user_id>0)
		[self performSelectorInBackground:@selector(loadDataWebService) withObject:nil];
	else
		[ObjectiveCScripts showAlertPopup:@"Error" message:@"No uid!"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	UITouch *touch = [[event allTouches] anyObject];
//	CGPoint startTouchPosition = [touch locationInView:self.view];
	
	self.largeView.hidden=!self.largeView.hidden;
//	if(self.largeView.hidden==YES && CGRectContainsPoint(self.beliefsView.frame, startTouchPosition)) {
//		self.largeView.hidden=NO;
//	}
}

-(void)setupDataForUser:(UserObj *)user {
	self.wallNameLabel.text=[NSString stringWithFormat:@"%@'s Wall", user.userName];
	self.postOnWallLabel.text=[NSString stringWithFormat:@"Post on %@'s Wall", user.userName];
	self.largeUserNameLabel.text=user.userName;
	self.smallUserNameLabel.text=user.userName;
	self.largeUserLabel.text=user.userName;
	[self setTitle:user.userName];
	if(user.candidate_id>0) {
		self.candidateNameLabel.text = user.candidateName;
		self.candidateImageView.image = [ObjectiveCScripts cachedCandidateImageForRowId:user.candidate_id thumbFlg:YES];
	}
	
	self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", user.state, user.country];
	if(user.state.length==0)
		self.locationLabel.text = @"Unknown";
	self.ideologyLabel.text = user.ideology;
	self.createdLabel.text = user.created;
	self.closestMatchLabel.text = user.closestMatch;
	
	self.favCartoonButton.enabled=user.favCartoon>0;
	self.favDebateButton.enabled=user.favDebate>0;
	self.favForumButton.enabled=user.favForum>0;
	self.favQuoteButton.enabled=user.favQuote>0;
	
	self.favCartoonLabel.hidden=user.favCartoon>0;
	self.favDebateLabel.hidden=user.favDebate>0;
	self.favForumLabel.hidden=user.favForum>0;
	self.favQuoteLabel.hidden=user.favQuote>0;
	
	self.userLevelImageView.image = [ObjectiveCScripts imageForLevel:user.level];
	self.userLevelName.text = [ObjectiveCScripts userNameForLevel:user.level];
	
	[self.imageIndicatorView startAnimating];
	[self setupFollowingButton];
	[self performSelectorInBackground:@selector(displayImage:) withObject:user];
}

-(void)loadDataWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"uid", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.userDataObj.user_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getUserData.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"getUserData.php: %@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					if(components.count>5) {
						self.userObj= [UserObj fullDataObjectFromLine:line];
						self.followingFlg=self.userObj.followingFlg;
						[self setupDataForUser:self.userObj];
						self.followButton.enabled=(self.userObj.user_id!=[ObjectiveCScripts myUserId]);
						[ObjectiveCScripts positionIcon:self.circleImageView govEcon:self.userObj.govEcon govMoral:self.userObj.govMoral bgView:self.beliefsView label:self.smallUserNameLabel];
						[ObjectiveCScripts positionIcon:self.largeCircle govEcon:self.userObj.govEcon govMoral:self.userObj.govMoral bgView:self.largePolyView label:self.largeUserLabel];
						if(self.followingFlg)
							[self updateFriend:self.userObj];
					}
				}
			if(self.userObj.user_id==0)
				[ObjectiveCScripts showAlertPopupWithDelegate:@"Error" message:@"No user data found!" delegate:self tag:1];
		} else
			[ObjectiveCScripts showAlertPopup:@"Server Error" message:@"Unable to reach the server. Try again later."];
		[self.dataIndicatorView stopAnimating];
		[self performSelectorInBackground:@selector(loadWallDataWebService) withObject:nil];

	}
}

-(void)updateFriend:(UserObj *)friend {
	NSPredicate *predicate= [NSPredicate predicateWithFormat:@"user_id = %d", friend.user_id];
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"FRIEND" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
	NSManagedObject *mo=nil;
	if(items.count>0)
		mo = [items objectAtIndex:0];
	else {
		mo = [NSEntityDescription insertNewObjectForEntityForName:@"FRIEND" inManagedObjectContext:self.managedObjectContext];
		[mo setValue:[NSNumber numberWithInt:friend.user_id] forKey:@"user_id"];
		NSLog(@"Creating FRIEND: %d", friend.user_id);
		[self.managedObjectContext save:nil];
	}
	BOOL needsUpdate=NO;
	needsUpdate = [self checkString:friend.userName field:@"name" mo:mo needsUpdate:needsUpdate];
	needsUpdate = [self checkInt:friend.govEcon field:@"govEcon" mo:mo needsUpdate:needsUpdate];
	needsUpdate = [self checkInt:friend.govMoral field:@"govMoral" mo:mo needsUpdate:needsUpdate];
	needsUpdate = [self checkString:friend.imgDir field:@"imgDir" mo:mo needsUpdate:needsUpdate];
	needsUpdate = [self checkString:friend.ideology field:@"ideology" mo:mo needsUpdate:needsUpdate];
	needsUpdate = [self checkString:friend.state field:@"state" mo:mo needsUpdate:needsUpdate];
	needsUpdate = [self checkString:friend.country field:@"country" mo:mo needsUpdate:needsUpdate];
	needsUpdate = [self checkInt:friend.imgNum field:@"imgNum" mo:mo needsUpdate:needsUpdate];
	
	if(needsUpdate)
		[self.managedObjectContext save:nil];
}

-(BOOL)checkString:(NSString *)string field:(NSString *)field mo:(NSManagedObject *)mo needsUpdate:(BOOL)needsUpdate {
	NSString *value = [mo valueForKey:field];
	if([field isEqualToString:value])
		return needsUpdate;
	[mo setValue:string forKey:field];
	return YES;
}

-(BOOL)checkInt:(int)amount field:(NSString *)field mo:(NSManagedObject *)mo needsUpdate:(BOOL)needsUpdate {
	int value = [[mo valueForKey:field] intValue];
	if(amount==value)
		return needsUpdate;
	[mo setValue:[NSNumber numberWithInt:amount] forKey:field];
	return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)mainWebService {
	@autoreleasepool {
		if([ObjectiveCScripts postMessageToWallofUser:self.userDataObj.user_id message:self.wallTextField.text]) {
			[self loadWallDataWebService];
		} else {
			[self.wallIndicatorView stopAnimating];
			[self stopWebService];
		}
	}
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
						  [NSString stringWithFormat:@"%d", self.userDataObj.user_id],
						  nil];
	NSString *webAddr = @"http://www.appdigity.com/poly/getWall.php";
	NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
//	NSLog(@"+++getWall.php: %d %@", self.userDataObj.user_id, responseStr);
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
	
	[self.wallIndicatorView stopAnimating];
	self.mainTableView.hidden=NO;
	[self stopWebService];
	[self.mainTableView reloadData];
}


-(void)displayImage:(UserObj *)user {
	@autoreleasepool {
		self.mainPic.image = [ObjectiveCScripts cachedImageForRowId:user.imgNum type:0 dir:user.imgDir forceRecache:NO];
		[self.imageIndicatorView stopAnimating];
	}
}

-(BOOL)verifySubmit {
	if(self.wallTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"No message!" message:@""];
		return NO;
	}
	[self.wallIndicatorView startAnimating];
	return YES;
}

-(IBAction)followButtonPressed:(id)sender {
	self.followButton.enabled=NO;
	self.followingFlg=!self.followingFlg;
	if(self.followingFlg)
		[self updateFriend:self.userObj];
	[self setupFollowingButton];
	[self performSelectorInBackground:@selector(followWebService) withObject:nil];
}

-(void)setupFollowingButton {
	self.followingLabel.hidden=!self.followingFlg;
	[self.followButton setTitle:(self.followingFlg)?@"Un-Follow":@"Friend/Follow" forState:UIControlStateNormal];
}

-(void)followWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"uid", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.userDataObj.user_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/follow.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++follow.php: %@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
		}
	}
}

-(IBAction)mainSegmentChanged:(id)sender {
	[self.sortSegment changeSegment];
	self.mainTableView.hidden=self.sortSegment.selectedSegmentIndex==1;
	self.popupView.hidden=self.sortSegment.selectedSegmentIndex==0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	WallCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[WallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	WallObj *wallObj = [self.mainArray objectAtIndex:indexPath.row];
	[WallCell populateCell:cell withObj:wallObj];
	
	cell.accessoryType= UITableViewCellAccessoryNone;
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

-(IBAction)favCartoonButtonPressed:(id)sender {
	CartoonsVC *detailViewController = [[CartoonsVC alloc] initWithNibName:@"CartoonsVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Cartoons";
	detailViewController.favoriteCartoon=self.userObj.favCartoon;
	[self.navigationController pushViewController:detailViewController animated:YES];
}
-(IBAction)favQuoteButtonPressed:(id)sender {
}
-(IBAction)favForumButtonPressed:(id)sender {
}
-(IBAction)favDebateButtonPressed:(id)sender {
}
-(IBAction)testResultsButtonPressed:(id)sender {
	[ObjectiveCScripts showAlertPopup:@"Notice" message:@"You must be a Silver member to see results. Please Upgrade!"];
}

-(IBAction)upgradeButtonPressed:(id)sender {
	UpgradeVC *detailViewController = [[UpgradeVC alloc] initWithNibName:@"UpgradeVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Upgrade";
	[self.navigationController pushViewController:detailViewController animated:YES];
}

@end
