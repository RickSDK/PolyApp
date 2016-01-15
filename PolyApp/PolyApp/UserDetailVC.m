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
#import "MultiLineDetailCellWordWrap.h"
#import "CandidateDetailVC.h"
#import "CandidateObj.h"
#import "UserTestResultsVC.h"

@interface UserDetailVC ()

@end

@implementation UserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.textFieldElements addObject:self.wallTextField];
	self.largeView.hidden=YES;
	self.upgradeButton.enabled=[ObjectiveCScripts myLevel]<2;

	self.sortSegment.selectedSegmentIndex=1;
	[self.sortSegment changeSegment];
	
	[self setupDataForUser:self.userDataObj];
	self.followButton.enabled=NO;
	self.followingLabel.hidden=YES;
	self.largeImageView.hidden=YES;
	self.maxLength=200;
	
	[self.dataIndicatorView startAnimating];
	if(self.userDataObj.user_id>0)
		[self performSelectorInBackground:@selector(loadDataWebService) withObject:nil];
	else
		[ObjectiveCScripts showAlertPopup:@"Error" message:@"No uid!"];
	
	[self extendTableForGold];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint startTouchPosition = [touch locationInView:self.view];
	
	if(!self.largeImageView.hidden || !self.largeView.hidden) {
		self.largeImageView.hidden=YES;
		self.largeView.hidden=YES;
		self.mainTableView.hidden=NO;
	} else {
		self.mainTableView.hidden=YES;
		if(CGRectContainsPoint(self.mainPic.frame, startTouchPosition)) {
			self.largeImageView.hidden=!self.largeImageView.hidden;
		} else {
			self.largeView.hidden=!self.largeView.hidden;
		}
	}
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
						else
							[self removeFriend:self.userObj];
					}
				}
			if(self.userObj.user_id==0)
				[ObjectiveCScripts showAlertPopupWithDelegate:@"Error" message:@"No user data found!" delegate:self tag:1];
		}
		
		[self.dataIndicatorView stopAnimating];
		[self performSelectorInBackground:@selector(loadWallDataWebService) withObject:nil];

	}
}

-(void)removeFriend:(UserObj *)friend {
	NSPredicate *predicate= [NSPredicate predicateWithFormat:@"user_id = %d", friend.user_id];
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"FRIEND" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
	if(items.count>0) {
		NSManagedObject *mo = [items objectAtIndex:0];
		[self.managedObjectContext deleteObject:mo];
		[self.managedObjectContext save:nil];
		NSLog(@"Deleting friend!");
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
		self.largeImageView.image = [ObjectiveCScripts cachedImageForRowId:user.imgNum type:0 dir:user.imgDir forceRecache:NO];
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
	else
		[self removeFriend:self.userObj];
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
	self.popupView.hidden=self.sortSegment.selectedSegmentIndex==0;
	[self.mainTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d_%d", (int)indexPath.section, (int)indexPath.row, (int)self.sortSegment.selectedSegmentIndex];
	
	if(self.sortSegment.selectedSegmentIndex==0) {
		WallCell *cell = [[WallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		
		WallObj *wallObj = [self.mainArray objectAtIndex:indexPath.row];
		[WallCell populateCell:cell withObj:wallObj];
		
		cell.accessoryType= UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	} else {
		if(indexPath.row==0) {
			NSMutableArray *titles = [NSMutableArray new];
			NSMutableArray *values = [NSMutableArray new];
			NSMutableArray *colors = [NSMutableArray new];
			
			[titles addObject:@"Username"];
			[values addObject:[ObjectiveCScripts validString:self.userObj.userName]];
			[colors addObject:[UIColor blackColor]];
			
			NSString *location = [NSString stringWithFormat:@"%@, %@", self.userObj.state, self.userObj.country];
			if(self.userObj.state.length==0)
				location = @"Unknown";
			[titles addObject:@"Location"];
			[values addObject:location];
			[colors addObject:[UIColor blackColor]];
			
			[titles addObject:@"Created"];
			[values addObject:[ObjectiveCScripts validString:self.userObj.created]];
			[colors addObject:[UIColor blackColor]];
			[titles addObject:@"Ideology"];
			[values addObject:[ObjectiveCScripts validString:self.userObj.ideology]];
			[colors addObject:[UIColor blackColor]];
			
			[titles addObject:@"Closest Match"];
			[values addObject:[ObjectiveCScripts validString:self.userObj.closestMatch]];
			[colors addObject:[UIColor blackColor]];
			
			[titles addObject:@"Level"];
			[values addObject:[ObjectiveCScripts userNameForLevel:self.userObj.level]];
			[colors addObject:[UIColor blackColor]];
			
			[titles addObject:@"Last Login"];
			[values addObject:[ObjectiveCScripts validString:self.userObj.lastLogin]];
			[colors addObject:[UIColor blackColor]];
			
			MultiLineDetailCellWordWrap *cell = [[MultiLineDetailCellWordWrap alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withRows:titles.count labelProportion:.4];
			
		
			cell.titleTextArray = titles;
			cell.fieldTextArray = values;
			cell.fieldColorArray = colors;
			
			cell.accessoryType= UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			return cell;
		} else {
			UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			
			NSArray *titles = [NSArray arrayWithObjects:@"None", @"Favorite Cartoon", @"Favorite Quote", @"Favorite Forum", @"Favorite Debate", nil];
			NSArray *numbers = [NSArray arrayWithObjects:
								@"0",
								[NSString stringWithFormat:@"%d", self.userObj.favCartoon],
								[NSString stringWithFormat:@"%d", self.userObj.favQuote],
								[NSString stringWithFormat:@"%d", self.userObj.favForum],
								[NSString stringWithFormat:@"%d", self.userObj.favDebate],
								nil];
			
			int num = [[numbers objectAtIndex:indexPath.row] intValue];
			if(num>0) {
				cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
				cell.textLabel.textColor = [UIColor blackColor];
			} else {
				cell.accessoryType= UITableViewCellAccessoryNone;
				cell.textLabel.textColor = [UIColor grayColor];
			}
			cell.textLabel.text=[titles objectAtIndex:indexPath.row];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			return cell;

		}
	}
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(self.sortSegment.selectedSegmentIndex==0)
		return self.mainArray.count;
	else
		return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(self.sortSegment.selectedSegmentIndex==1 && self.userObj.favCartoon>0) {
		if(indexPath.row==1) {
			CartoonsVC *detailViewController = [[CartoonsVC alloc] initWithNibName:@"CartoonsVC" bundle:nil];
			detailViewController.managedObjectContext = self.managedObjectContext;
			detailViewController.title = @"Cartoons";
			detailViewController.favoriteCartoon=self.userObj.favCartoon;
			[self.navigationController pushViewController:detailViewController animated:YES];
		}
		if(indexPath.row==2) {
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"candidate_id = %d", self.userObj.favQuoteCandidate];
			NSArray *items = [CoreDataLib selectRowsFromEntity:@"CANDIDATE" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
			if(items.count>0) {
				NSManagedObject *mo = [items objectAtIndex:0];
				CandidateObj *candidateObj = [CandidateObj objectFromManagedObject:mo];
				[self gotoCandidateQuote:candidateObj];
			}
		}
	}
}


-(void)gotoCandidateQuote:(CandidateObj *)candidateObj {
	CandidateDetailVC *detailViewController = [[CandidateDetailVC alloc] initWithNibName:@"CandidateDetailVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = candidateObj.name;
	detailViewController.candidateObj = candidateObj;
	detailViewController.favQuoteCandidate = self.userObj.favQuoteCandidate;
	detailViewController.favQuoteIssue = self.userObj.favQuoteIssue;
	detailViewController.favQuote_id=self.userObj.favQuote;
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
	if(self.sortSegment.selectedSegmentIndex==0) {
		WallObj *wallObj = [self.mainArray objectAtIndex:indexPath.row];
		return [WallCell heightForCellWithText:wallObj.message];
	} else {
		if(indexPath.row==0)
			return 18*7+5;
		else
			return 44;
	}
}

-(IBAction)testResultsButtonPressed:(id)sender {
	if([ObjectiveCScripts myLevel]==0)
		[ObjectiveCScripts showAlertPopup:@"Notice" message:@"You must be a Silver member to see results. Please Upgrade!"];

	UserTestResultsVC *detailViewController = [[UserTestResultsVC alloc] initWithNibName:@"UserTestResultsVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = self.userObj.userName;
	detailViewController.uObj = self.userObj;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

-(IBAction)upgradeButtonPressed:(id)sender {
	UpgradeVC *detailViewController = [[UpgradeVC alloc] initWithNibName:@"UpgradeVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Upgrade";
	[self.navigationController pushViewController:detailViewController animated:YES];
}

@end
