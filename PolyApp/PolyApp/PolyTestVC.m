//
//  PolyTestVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "PolyTestVC.h"
#import "UserCell.h"
#import "ObjectiveCScripts.h"
#import "IssueObj.h"
#import "CoreDataLib.h"
#import "CandidateIssueCell.h"
#import "UserObj.h"
#import "CustomLabel.h"
#import "UserDetailVC.h"

@interface PolyTestVC ()

@end

@implementation PolyTestVC

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.circleImageView.hidden=YES;
	self.usernameLabel.hidden=YES;
	[self performSelectorInBackground:@selector(calculateScore) withObject:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.issuesArray = [[NSMutableArray alloc] init];
	self.friendCirclesArray = [[NSMutableArray alloc] init];
	self.friendNamesArray = [[NSMutableArray alloc] init];
	self.friendsArray = [[NSMutableArray alloc] init];

	self.questionView.hidden=YES;
	
	self.usernameLabel.text = [ObjectiveCScripts getUserDefaultValue:@"userName"];
	self.usernameLabel.layer.cornerRadius = 7;
	self.usernameLabel.layer.masksToBounds = YES;				// clips background images to rounded corners
	self.usernameLabel.layer.borderColor = [UIColor blackColor].CGColor;
	self.usernameLabel.layer.borderWidth = 1.;
	
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"FRIEND" predicate:nil sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
	for(NSManagedObject *mo in items) {
		UserObj *userObj = [UserObj objectFromFriendObj:mo];
		[self.friendsArray addObject:userObj];
		UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
		img.image=[UIImage imageNamed:@"circle.png"];
		img.hidden=YES;
		[self.view addSubview:img];
		[self.friendCirclesArray addObject:img];
		
		CustomLabel *customLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
		customLabel.font = [UIFont systemFontOfSize:12];
		customLabel.backgroundColor = [UIColor ATTBlue];
		customLabel.text = userObj.userName;
		customLabel.adjustsFontSizeToFitWidth = YES;
		customLabel.minimumScaleFactor = .7;
		customLabel.textAlignment = NSTextAlignmentCenter;
		customLabel.textColor = [UIColor whiteColor];
		customLabel.hidden=YES;
		[self.view addSubview:customLabel];
		[self.friendNamesArray addObject:customLabel];
		
		
		[ObjectiveCScripts positionIcon:img govEcon:userObj.govEcon govMoral:userObj.govMoral bgView:self.polyBGView label:customLabel];
	}

	if([ObjectiveCScripts needToUpdateForNumber:0])
		[self startWebService:@selector(loadIssuesWebService) message:@"Loading"];
	else
		[self loadIssuesFromDatabase];
	
	if([ObjectiveCScripts getUserDefaultValue:@"ClosestMatchId"].length==0) {
		self.usernameLabel.hidden=YES;
		self.circleImageView.hidden=YES;

		self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Start!" style:UIBarButtonItemStyleBordered target:self action:@selector(startButtonPressed)];
		self.navigationItem.rightBarButtonItem = self.rightButton;

		[ObjectiveCScripts showAlertPopup:@"Poly Test" message:@"Take this test to find out your political ideology. Press the 'Start' button at the top."];
	} else {
		self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Ideology" style:UIBarButtonItemStyleBordered target:self action:@selector(ideologyButtonPressed)];
		self.navigationItem.rightBarButtonItem = self.rightButton;

	}
	[self.webServiceElements addObject:self.rightButton];
	[self extendTableForGold];

}


-(void)ideologyButtonPressed {
	self.ideologyLabel.text = [ObjectiveCScripts getUserDefaultValue:@"title"];
	self.ideologytextView.text = [ObjectiveCScripts textForIdeology:[ObjectiveCScripts getUserDefaultValue:@"title"]];
	self.popupView.hidden=!self.popupView.hidden;
	self.sortSegment.selectedSegmentIndex=0;
	[self segmentChanged:nil];
}


- (IBAction) retakeButtonPressed: (id) sender {
	[self ideologyButtonPressed];
	[self startButtonPressed];
}

-(void)loadIssuesFromDatabase {
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"ISSUE" predicate:nil sortColumn:@"issue_id" mOC:self.managedObjectContext ascendingFlg:YES];
	if(items.count<20) {
		[ObjectiveCScripts showAlertPopup:@"Issue error!" message:@"Code 1174"];
		[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"issueUpdLocal"];
	}
	[self.issuesArray removeAllObjects];
	for(NSManagedObject *mo in items) {
		IssueObj *issueObj = [IssueObj objectFromManagedObject:mo];
		[self.issuesArray addObject:issueObj];
	}
	[self.mainTableView reloadData];
}

-(void)loadFriendsFromDatabase {
	[self.issuesArray removeAllObjects];
	[self.mainTableView reloadData];
}

-(void)loadIssuesWebService {
	@autoreleasepool {
		NSLog(@"loadIssuesWebService");
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], [ObjectiveCScripts getUserDefaultValue:@"Year"], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getIssues.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
//		NSLog(@"+++%@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					if(components.count>9) {
						
						int issue_id = [[components objectAtIndex:0] intValue];
						NSPredicate *predicate = [NSPredicate predicateWithFormat:@"issue_id = %d", issue_id];
						NSArray *items = [CoreDataLib selectRowsFromEntity:@"ISSUE" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
						NSManagedObject *mo=nil;
						if(items.count>0)
							mo = [items objectAtIndex:0];
						else {
							mo = [NSEntityDescription insertNewObjectForEntityForName:@"ISSUE" inManagedObjectContext:self.managedObjectContext];
							[mo setValue:[NSNumber numberWithInt:issue_id] forKey:@"issue_id"];
						}
						
						[mo setValue:[components objectAtIndex:1] forKey:@"category"];
						[mo setValue:[components objectAtIndex:2] forKey:@"section"];
						[mo setValue:[components objectAtIndex:3] forKey:@"name"];
						[mo setValue:[components objectAtIndex:4] forKey:@"option1"];
						[mo setValue:[components objectAtIndex:5] forKey:@"option2"];
						[mo setValue:[components objectAtIndex:6] forKey:@"option3"];
						[mo setValue:[components objectAtIndex:7] forKey:@"option1Local"];
						[mo setValue:[components objectAtIndex:8] forKey:@"option2Local"];
						[mo setValue:[components objectAtIndex:9] forKey:@"option3Local"];

					}
				}
		} else
			[ObjectiveCScripts showAlertPopup:@"Server Error" message:@"Unable to reach the server. Try again later."];
		
		NSLog(@"issuesLoaded");
		[self.managedObjectContext save:nil];
		[ObjectiveCScripts updateFlagForNumber:0 toString:@""];
		[self stopWebService];
		[self loadIssuesFromDatabase];
	}
	
}

-(void)submitTestWebService {
	@autoreleasepool {
		self.usernameLabel.hidden=NO;
		self.circleImageView.hidden=NO;
		
		NSMutableArray *answerArray = [[NSMutableArray alloc] init];
		for(int i=1; i<=20; i++) {
			int answer = [[ObjectiveCScripts getUserDefaultValue:[NSString stringWithFormat:@"Question%d", i]] intValue];
			[answerArray addObject:[NSString stringWithFormat:@"%d", answer]];
		}
		
		NSString *answers = [answerArray componentsJoinedByString:@":"];
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"answers", @"govEcon", @"govMoral", @"conservativeMeter", @"title", @"closest_match_id", @"ClosestMatchName", @"candidate_id", @"CandidateName", @"Country", nil];
		
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"],
							  answers,
							  [ObjectiveCScripts getUserDefaultValue:@"govEcon"],
							  [ObjectiveCScripts getUserDefaultValue:@"govMoral"],
							  [ObjectiveCScripts getUserDefaultValue:@"conservativeMeter"],
							  [ObjectiveCScripts getUserDefaultValue:@"title"],
							  [ObjectiveCScripts getUserDefaultValue:@"ClosestMatchId"],
							  [ObjectiveCScripts getUserDefaultValue:@"ClosestMatchName"],
							  [ObjectiveCScripts getUserDefaultValue:@"CandidateId"],
							  [ObjectiveCScripts getUserDefaultValue:@"CandidateName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/postPolyTest.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopup:@"Success" message:@""];
			[self loadIssuesFromDatabase];
			[self performSelectorOnMainThread:@selector(ideologyButtonPressed) withObject:nil waitUntilDone:NO];
		}
		
		
		[self stopWebService];
		self.rightButton.enabled=NO;
		[self.mainTableView reloadData];
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.hideCirclesFlg=!self.hideCirclesFlg;
	self.circleImageView.hidden=self.hideCirclesFlg;
	self.usernameLabel.hidden=self.hideCirclesFlg;
//	UITouch *touch = [[event allTouches] anyObject];
//	CGPoint startTouchPosition = [touch locationInView:self.view];
}

-(void)displayQuestion {
	if(self.questionNumber>0 && self.questionNumber<self.issuesArray.count+1) {
		IssueObj *issueObj = [self.issuesArray objectAtIndex:self.questionNumber-1];
		self.categoryLabel.text = issueObj.category;
		self.sectionLabel.text = issueObj.section;
		self.nameLabel.text = issueObj.name;
		self.option1Label.text = issueObj.option1;
		self.option2Label.text = issueObj.option2;
		self.option3Label.text = issueObj.option3;
	}
	self.counterLabel.text = [NSString stringWithFormat:@"%d/20", self.questionNumber];
	[self.button1 setBackgroundImage:[UIImage imageNamed:@"checkbox0.png"] forState:UIControlStateNormal];
	[self.button2 setBackgroundImage:[UIImage imageNamed:@"checkbox0.png"] forState:UIControlStateNormal];
	[self.button3 setBackgroundImage:[UIImage imageNamed:@"checkbox0.png"] forState:UIControlStateNormal];
	self.prevButton.enabled=self.questionNumber>1;
	[self displayButtons];
	[self performSelectorInBackground:@selector(calculateScore) withObject:nil];

}

-(void)startButtonPressed {
	self.questionNumber=1;
	self.questionView.hidden=NO;
	self.rightButton.enabled=NO;
	[self displayQuestion];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	
	if(self.sortSegment.selectedSegmentIndex==0) {
		CandidateIssueCell *cell = [[CandidateIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		
		IssueObj *issueObj = [self.issuesArray objectAtIndex:indexPath.row];
		int selectedOption = [[ObjectiveCScripts getUserDefaultValue:[NSString stringWithFormat:@"Question%d", (int)indexPath.row+1]] intValue];
		
		[CandidateIssueCell updateCell:cell issueObj:issueObj option:selectedOption otherOption:selectedOption];
		cell.popCountLabel.text=@"";
		cell.popularityLabel.text=@"";
		if(self.showMoreFlg && self.selectedRow==indexPath.row) {
			cell.backgroundColor=[UIColor colorWithRed:1 green:1 blue:.6 alpha:1];
			cell.positionLabel.text = [NSString stringWithFormat:@"Your Position: %@", cell.positionLabel.text];
		} else {
			cell.backgroundColor=[UIColor whiteColor];
		}
		

		
		cell.accessoryType= UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	} else {
		UserCell *cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

		UserObj *userObj = [self.friendsArray objectAtIndex:indexPath.row];
		NSLog(@"+++%d", userObj.user_id);
		[UserCell populateCell:cell withObj:userObj];
	
		CustomLabel *customLabel = [self.friendNamesArray objectAtIndex:indexPath.row];
		customLabel.hidden=NO;
		UIImageView *img = [self.friendCirclesArray objectAtIndex:indexPath.row];
		img.hidden=NO;

		cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(self.sortSegment.selectedSegmentIndex==0)
		return self.issuesArray.count;
	else
		return self.friendsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(self.sortSegment.selectedSegmentIndex==0) {
		if(self.showMoreFlg) {
			if(indexPath.row==self.selectedRow)
				self.showMoreFlg=NO;
		} else
			self.showMoreFlg=YES;
		
		self.selectedRow=(int)indexPath.row;
		[self.mainTableView reloadData];
	} else {
		UserDetailVC *detailViewController = [[UserDetailVC alloc] initWithNibName:@"UserDetailVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"User Details";
		detailViewController.userDataObj=[self.friendsArray objectAtIndex:indexPath.row];
		[self.navigationController pushViewController:detailViewController animated:YES];
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
	if(self.showMoreFlg && self.selectedRow==indexPath.row)
		return 60;
	else
		return 44;
}

- (IBAction) checkButtonPressed: (id) sender {
	UIButton *button=sender;
	[ObjectiveCScripts setUserDefaultValue:[NSString stringWithFormat:@"%d", (int)button.tag] forKey:[NSString stringWithFormat:@"Question%d", self.questionNumber]];
	[self displayQuestion];
}

-(void)displayButtons {
	self.selectedOption = [[ObjectiveCScripts getUserDefaultValue:[NSString stringWithFormat:@"Question%d", self.questionNumber]] intValue];
	switch (self.selectedOption) {
  case 1:
			[self.button1 setBackgroundImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];
			break;
  case 2:
			[self.button2 setBackgroundImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];
			break;
  case 3:
			[self.button3 setBackgroundImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];
			break;
			
  default:
			break;
	} ;
}

-(void)calculateScore {
	@autoreleasepool {
		[NSThread sleepForTimeInterval:.3];
		int govEcon = 0;
		int govMoral = 0;
		int conservativeMeter=0;
		for(int i=1; i<=20; i++) {
			int answer = [[ObjectiveCScripts getUserDefaultValue:[NSString stringWithFormat:@"Question%d", i]] intValue];
			answer-=2;
			if(i<=10) {
				govEcon+=answer;
				conservativeMeter+=answer*-1;
			} else {
				govMoral+=answer;
				conservativeMeter+=answer;
			}
		}
		NSLog(@"calculating score");
		[ObjectiveCScripts positionIcon:self.circleImageView govEcon:govEcon govMoral:govMoral bgView:self.polyBGView label:self.usernameLabel];
		[ObjectiveCScripts setUserDefaultValue:[NSString stringWithFormat:@"%d", govEcon] forKey:@"govEcon"];
		[ObjectiveCScripts setUserDefaultValue:[NSString stringWithFormat:@"%d", govMoral] forKey:@"govMoral"];
		[ObjectiveCScripts setUserDefaultValue:[NSString stringWithFormat:@"%d", conservativeMeter] forKey:@"conservativeMeter"];
		
		NSString *title = [ObjectiveCScripts polIdeologyFromGovEcon:govEcon govMoral:govMoral];
		[ObjectiveCScripts setUserDefaultValue:title forKey:@"title"];
		self.circleImageView.hidden=NO;
		self.usernameLabel.hidden=NO;

	}
}

-(void)findClosestMatch {
	NSString *closestMatchId=nil;
	NSString *closestMatchName=@"";
	int max=0;
	
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"CANDIDATE" predicate:nil sortColumn:@"party" mOC:self.managedObjectContext ascendingFlg:YES];
	[self.mainArray removeAllObjects];
	for(NSManagedObject *mo in items) {
		int percentMatch = [ObjectiveCScripts percentMatch:[mo valueForKey:@"answers"]];
		if(percentMatch>max || max==0) {
			closestMatchId = [mo valueForKey:@"candidate_id"];
			closestMatchName = [mo valueForKey:@"name"];
			max=percentMatch;
		}
		
	}
	[ObjectiveCScripts setUserDefaultValue:closestMatchId forKey:@"ClosestMatchId"];
	[ObjectiveCScripts setUserDefaultValue:closestMatchName forKey:@"ClosestMatchName"];
}

- (IBAction) nextButtonPressed: (id) sender {
	if(self.selectedOption==0) {
		[ObjectiveCScripts showAlertPopup:@"Notice" message:@"Select your choice first!"];
		return;
	}
	if(self.questionNumber<20) {
		self.questionNumber++;
		[self displayQuestion];
	} else {
		self.questionView.hidden=YES;
		[self findClosestMatch];
		[self startWebService:@selector(submitTestWebService) message:@"Submitting..."];
	}
	if(self.questionNumber==20)
		[self.nextButton setTitle:@"Done!" forState:UIControlStateNormal];
}
- (IBAction) prevButtonPressed: (id) sender {
	self.questionNumber--;
	[self displayQuestion];
	if(self.questionNumber==19)
		[self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
}

- (IBAction) segmentChanged: (id) sender {
	[self.friendsSegment changeSegment];
	[self.mainTableView reloadData];
	
	for(CustomLabel *customLabel in self.friendNamesArray)
		customLabel.hidden=YES;

	for(UIImageView *img in self.friendCirclesArray)
		img.hidden=YES;

}

- (IBAction) scienceButtonPressed: (id) sender {
	self.ideologytextView.text = @"Here's the science behind the PolyTest:\n\nThe first 10 questions are based on 'Economic & Fairness' items. For these types of issues both Liberals and Statists tend to favor MORE government control. While Conservatives and Libertarians tend to favor LESS government control.\n\nThe last 10 questions are issues of 'Morals & Greatness'. For these issues Conservatives and Statists favor MORE government control. Liberals and Libertarians favor less government control.\n\nThe final result is liberals tend to want maximum government control of 'Economic & Fairness' issues while minimum amount of control for issues related to 'Morals & Greatness'. Conservatives want exactly the opposite.\n\nLibertarians tend to want less government control for all issues, and Statists want maximum government control of all issues. The results are charted on a diamond shaped diagram, which is shown on this page.";
}



@end
