//
//  MainScreen.m
//  PolyApp
//
//  Created by Rick Medved on 12/14/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "MainScreen.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "ProfileVC.h"
#import "PolyTestVC.h"
#import "YourWallVC.h"
#import "CandidatesVC.h"
#import "ForumVC.h"
#import "DebatesVC.h"
#import "CartoonsVC.h"
#import "QuoteTestsVC.h"
#import "ChartsVC.h"
#import "MainMenuCell.h"
#import "ObjectiveCScripts.h"
#import "ChooseNationVC.h"
#import "ChooseUserVC.h"
#import "OptionsVC.h"
#import "UIColor+ATTColor.h"
#import "UsersVC.h"
#import "AboutVC.h"



@interface MainScreen ()

@end

@implementation MainScreen


- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"PolyApp"];
	
	[self.textFieldElements addObject:self.wallTextField];
	self.maxLength=256;
	
	if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
//		UIImage *image = [UIImage imageNamed:@"background.jpg"]; //greenGradient.png
//		[self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
		self.navigationController.navigationBar.barTintColor = [UIColor ATTDarkBlue];
		self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
		self.navigationController.navigationBar.translucent = NO;
		self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:.8 blue:0 alpha:1];
	}
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStyleBordered target:self action:@selector(aboutButtonPressed)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStyleBordered target:self action:@selector(optionsButtonPressed)];

	self.mainMenu = [[NSMutableArray alloc] init];
	[self.mainMenu addObject:@"Your Wall"];
	[self.mainMenu addObject:@"Candidates"];
	[self.mainMenu addObject:@"Forum"];
	[self.mainMenu addObject:@"Debates"];
	[self.mainMenu addObject:@"Cartoons"];
	[self.mainMenu addObject:@"Quote Tests"];
	[self.mainMenu addObject:@"Users"];
	[self.mainMenu addObject:@"Charts"];
	
	[self.webServiceElements addObject:self.submitButton];
	
	if([ObjectiveCScripts getUserDefaultValue:@"Year"].length>0)
		[self bgProcess];
	
	[self extendTableForGold];
	
	if([ObjectiveCScripts getUserDefaultValue:@"cacheAllThumbnails"].length==0)
		[self performSelectorInBackground:@selector(cacheAllThumbnails) withObject:nil];


//	[self checkUDID];
	
}

-(void)bgProcess {
	NSArray *fieldNames = [NSArray arrayWithObjects:@"username", @"Country", @"year", nil];
	NSArray *fieldValues = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], [ObjectiveCScripts getUserDefaultValue:@"Year"], nil];
	[ObjectiveCScripts asyncWebserviceUsingPost:@"getUpdates.php" fieldList:fieldNames valueList:fieldValues delegate:self];

}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self performSelectorInBackground:@selector(displayAvatarImage) withObject:nil];
	
	self.nationLabel.text = [ObjectiveCScripts getUserDefaultValue:@"Country"];
	self.yearLabel.text = [ObjectiveCScripts getUserDefaultValue:@"Year"];
	int candidate_id= [[ObjectiveCScripts getUserDefaultValue:@"CandidateId"] intValue];
	NSLog(@"+++CandidateId: %d, System: %@", candidate_id, [ObjectiveCScripts getUserDefaultValue:@"System"]);
	
	if(candidate_id>0) {
		self.candidateImageView.image = [ObjectiveCScripts cachedImageForRowId:candidate_id type:1 dir:@"pics" forceRecache:NO];
		self.currentChoiceLabel.text = [ObjectiveCScripts getUserDefaultValue:@"CandidateName"];
	}
	int closestMatchId = [[ObjectiveCScripts getUserDefaultValue:@"ClosestMatchId"] intValue];
	if(closestMatchId>0) {
		self.matchNameLabel.text = [ObjectiveCScripts getUserDefaultValue:@"ClosestMatchName"];
		
		self.beliefsLabel.text = [ObjectiveCScripts getUserDefaultValue:@"title"];
		int govEcon = [[ObjectiveCScripts getUserDefaultValue:@"govEcon"] intValue];
		int govMoral = [[ObjectiveCScripts getUserDefaultValue:@"govMoral"] intValue];
		[ObjectiveCScripts positionIcon:self.circleImageView govEcon:govEcon govMoral:govMoral bgView:self.beliefs1View label:self.self.usernameLabel];
		self.usernameLabel.text = [ObjectiveCScripts getUserDefaultValue:@"userName"];
		self.usernameLabel.layer.cornerRadius = 7;
		self.usernameLabel.layer.masksToBounds = YES;				// clips background images to rounded corners
		self.usernameLabel.layer.borderColor = [UIColor blackColor].CGColor;
		self.usernameLabel.layer.borderWidth = 1.;
	}
	self.leftUsernameLabel.text = [ObjectiveCScripts getUserDefaultValue:@"userName"];
	
	
	if([ObjectiveCScripts getUserDefaultValue:@"userName"].length==0) {
		ChooseUserVC *detailViewController = [[ChooseUserVC alloc] initWithNibName:@"ChooseUserVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Choose User";
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
	if([ObjectiveCScripts getUserDefaultValue:@"Country"].length==0) {
		ChooseNationVC *detailViewController = [[ChooseNationVC alloc] initWithNibName:@"ChooseNationVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Choose Nation";
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
	if([ObjectiveCScripts getUserDefaultValue:@"CandidateId"].length==0) {
		CandidatesVC *detailViewController = [[CandidatesVC alloc] initWithNibName:@"CandidatesVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Choose Candidate";
		detailViewController.chooseFlg=YES;
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
	if([ObjectiveCScripts getUserDefaultValue:@"ClosestMatchId"].length==0) {
		PolyTestVC *detailViewController = [[PolyTestVC alloc] initWithNibName:@"PolyTestVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Poly Test";
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
	
	self.issueUpdateImageView.hidden = ![@"Y" isEqualToString:[ObjectiveCScripts getUserDefaultValue:[ObjectiveCScripts updateFlgForNumber:0]]];
	
	[self.mainTableView reloadData];
}

-(void)displayAvatarImage {
	@autoreleasepool {
		self.matchImageView.image = [ObjectiveCScripts avatarImageThumbSize:NO];
	}
}



-(void)checkUDID {
	NSString *userKey = @"com.polyApp.user";
	// read from iCloud
	NSString *userID = [[NSUbiquitousKeyValueStore defaultStore] stringForKey:userKey];
	NSLog(@"+++userID: %@", userID);
	if(userID.length==0)
		[self createUDID];
}

-(void)createUDID {
	NSUUID *userUUID = [NSUUID UUID];
	// convert to string
	NSString *userID = [userUUID UUIDString];
	// create the key to store the ID
	NSString *userKey = @"com.polyApp.user";
	NSLog(@"+++key created: %@", userID);
	
	// Save to iCloud
	[[NSUbiquitousKeyValueStore defaultStore] setString:userID forKey:userKey];
}

-(void)aboutButtonPressed {
	AboutVC *detailViewController = [[AboutVC alloc] initWithNibName:@"AboutVC" bundle:nil];
	detailViewController.title = @"About PolyApp";
	[self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	BOOL refreshScreen=NO;
	if(self.responseString.length>0) {
		if([ObjectiveCScripts validateStandardResponse:self.responseString delegate:nil]) {
			NSLog(@"+++updates: %@", self.responseString);
			NSArray *lines = [self.responseString componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines) {
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					int i=0;
					for(NSString *updateDate in components) {
						if(i> 6 || updateDate.length==0) {
							i++;
							continue;
						}
						NSString *updateKey = [ObjectiveCScripts updateKeyForNumber:i];
						NSString *updateFlg = [ObjectiveCScripts updateFlgForNumber:i];
						if(![updateDate isEqualToString:[ObjectiveCScripts getUserDefaultValue:updateKey]]) {
							NSLog(@"item %d need updating!!!", i);
							refreshScreen=YES;
							[ObjectiveCScripts setUserDefaultValue:@"Y" forKey:updateFlg];
							[ObjectiveCScripts setUserDefaultValue:updateDate forKey:updateKey];
							if(i==0) { // issues need updating
								self.issueUpdateImageView.hidden = NO;
							}
						} //<-- if
						i++;
					}
					//					NSString *sysdate = [components objectAtIndex:11];
					//					[ObjectiveCScripts setUserDefaultValue:sysdate forKey:@"LastLoginTimeStamp"];
					//					NSLog(@"sysdate: %@", sysdate);
				}
			}
		}
		if(refreshScreen)
			[self.mainTableView reloadData];
	}
}

/*
-(void)backgroundWebService {
	@autoreleasepool {
		BOOL refreshScreen=NO;
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], [ObjectiveCScripts getUserDefaultValue:@"Year"], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getUpdates.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++updates: %@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines) {
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					int i=0;
					for(NSString *updateDate in components) {
						if(i> 5 && updateDate.length==0) {
							i++;
							continue;
						}
						NSString *updateKey = [ObjectiveCScripts updateKeyForNumber:i];
						NSString *updateFlg = [ObjectiveCScripts updateFlgForNumber:i];
						if(![updateDate isEqualToString:[ObjectiveCScripts getUserDefaultValue:updateKey]]) {
							NSLog(@"item %d need updating!!!", i);
							refreshScreen=YES;
							[ObjectiveCScripts setUserDefaultValue:@"Y" forKey:updateFlg];
							[ObjectiveCScripts setUserDefaultValue:updateDate forKey:updateKey];
							if(i==0) { // issues need updating
								self.issueUpdateImageView.hidden = NO;
							}
						} //<-- if
						i++;
					}
//					NSString *sysdate = [components objectAtIndex:11];
//					[ObjectiveCScripts setUserDefaultValue:sysdate forKey:@"LastLoginTimeStamp"];
//					NSLog(@"sysdate: %@", sysdate);
				}
			}
		}
		if(refreshScreen)
			[self.mainTableView reloadData];
	}
	
}
*/
-(void)cacheAllThumbnails {
	NSLog(@"cacheAllThumbnails");
	[ObjectiveCScripts setUserDefaultValue:@"Y" forKey:@"cacheAllThumbnails"];
	NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", nil];
	NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], [ObjectiveCScripts getUserDefaultValue:@"Year"], nil];
	NSString *webAddr = @"http://www.appdigity.com/poly/getCandidates.php";
	NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
	if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
		NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
		for(NSString *line in lines) {
			if(line.length>7) {
				NSArray *components = [line componentsSeparatedByString:@"|"];
				if(components.count>11) {
					int candidate_id = [[components objectAtIndex:0] intValue];
					[ObjectiveCScripts cachedImageForRowId:candidate_id type:1 dir:@"pics" forceRecache:NO];
				}
			}
		}
	}
}


-(void)optionsButtonPressed {
	OptionsVC *detailViewController = [[OptionsVC alloc] initWithNibName:@"OptionsVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Options";
	[self.navigationController pushViewController:detailViewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	MainMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[MainMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	cell.nameLabel.text=[self.mainMenu objectAtIndex:indexPath.row];
	
	cell.backgroundColor = [UIColor ATTBlue];
	
	cell.pic.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%d.jpg", (int)indexPath.row]];
	
	cell.yellowBlob.hidden = ![@"Y" isEqualToString:[ObjectiveCScripts getUserDefaultValue:[ObjectiveCScripts updateFlgForNumber:(int)indexPath.row+1]]];

	cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainMenu.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *title = [self.mainMenu objectAtIndex:indexPath.row];
	if([@"Your Wall" isEqualToString:title]) {
		YourWallVC *detailViewController = [[YourWallVC alloc] initWithNibName:@"YourWallVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = title;
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
	if([@"Candidates" isEqualToString:title]) {
		CandidatesVC *detailViewController = [[CandidatesVC alloc] initWithNibName:@"CandidatesVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = title;
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
	if([@"Forum" isEqualToString:title]) {
		if([ObjectiveCScripts getUserDefaultValue:@"firstName"].length==0) {
			[ObjectiveCScripts showAlertPopup:@"Notice" message:@"You must update your profile before accessing this feature. Click on your Avatar at the Top-Left."];
			return;
		}
		ForumVC *detailViewController = [[ForumVC alloc] initWithNibName:@"ForumVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = title;
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
	if([@"Debates" isEqualToString:title]) {
		if([ObjectiveCScripts getUserDefaultValue:@"firstName"].length==0) {
			[ObjectiveCScripts showAlertPopup:@"Notice" message:@"You must update your profile before accessing this feature. Click on your Avatar at the Top-Left."];
			return;
		}
		DebatesVC *detailViewController = [[DebatesVC alloc] initWithNibName:@"DebatesVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = title;
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
	if([@"Cartoons" isEqualToString:title]) {
		CartoonsVC *detailViewController = [[CartoonsVC alloc] initWithNibName:@"CartoonsVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = title;
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
	if([@"Quote Tests" isEqualToString:title]) {
		QuoteTestsVC *detailViewController = [[QuoteTestsVC alloc] initWithNibName:@"QuoteTestsVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = title;
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
	if([@"Users" isEqualToString:title]) {
		UsersVC *detailViewController = [[UsersVC alloc] initWithNibName:@"UsersVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = title;
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
	if([@"Charts" isEqualToString:title]) {
		ChartsVC *detailViewController = [[ChartsVC alloc] initWithNibName:@"ChartsVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = title;
		[self.navigationController pushViewController:detailViewController animated:YES];
	}

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint startTouchPosition = [touch locationInView:self.view];
	
	
	if(CGRectContainsPoint(self.candidateView.frame, startTouchPosition)) {
		CandidatesVC *detailViewController = [[CandidatesVC alloc] initWithNibName:@"CandidatesVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Choose Candidate";
		detailViewController.chooseFlg=YES;
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
	if(CGRectContainsPoint(self.match1View.frame, startTouchPosition) || CGRectContainsPoint(self.match2View.frame, startTouchPosition)) {
		ProfileVC *detailViewController = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Profile";
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
	if(CGRectContainsPoint(self.beliefs1View.frame, startTouchPosition) || CGRectContainsPoint(self.beliefs2View.frame, startTouchPosition)) {
		PolyTestVC *detailViewController = [[PolyTestVC alloc] initWithNibName:@"PolyTestVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Poly Test";
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
	if(CGRectContainsPoint(self.nationLabel.frame, startTouchPosition)) {
		ChooseNationVC *detailViewController = [[ChooseNationVC alloc] initWithNibName:@"ChooseNationVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Choose Nation";
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
	if(CGRectContainsPoint(self.yearLabel.frame, startTouchPosition)) {
		ChooseNationVC *detailViewController = [[ChooseNationVC alloc] initWithNibName:@"ChooseNationVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Choose Year";
		detailViewController.yearFlg=YES;
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
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

-(BOOL)verifySubmit {
	if(self.wallTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Error" message:@"Field is blank"];
		return NO;
	}
	return YES;
}

-(void)mainWebService {
	@autoreleasepool {
		if([ObjectiveCScripts postMessageToWallofUser:[ObjectiveCScripts myUserId] message:self.wallTextField.text])
			[ObjectiveCScripts showAlertPopup:@"Posted!" message:@""];
		
		[self stopWebService];
		self.wallTextField.text=@"";
	}
	
}
/*
-(void)postWallWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"code", @"username", nil];
		NSArray *valueList = [NSArray arrayWithObjects:@"123", self.wallTextField.text, nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/postWallMessage.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++postWallMessage.php %@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success!" message:@"" delegate:self tag:1];
		}
		[self stopWebService];
	}
}
*/




@end
