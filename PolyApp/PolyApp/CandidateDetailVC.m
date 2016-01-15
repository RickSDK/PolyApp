//
//  CandidateDetailVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/18/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "CandidateDetailVC.h"
#import "ObjectiveCScripts.h"
#import "CoreDataLib.h"
#import "IssueObj.h"
#import "CandidateIssueVC.h"
#import "CandidateIssueCell.h"
#import "PolyTestVC.h"

@interface CandidateDetailVC ()

@end

@implementation CandidateDetailVC

-(void)updateStuff {
	self.ideologyLabel.text = self.candidateObj.ideology;
	
	self.percent = [ObjectiveCScripts percentMatch:self.candidateObj.answers];
	
	self.nameChartLabel.text=self.candidateObj.name;
	self.largeNameChartLabel.text=self.candidateObj.name;
	
	[ObjectiveCScripts positionIcon:self.circleImg govEcon:self.candidateObj.govEcon govMoral:self.candidateObj.govMoral bgView:self.graphicView label:self.nameChartLabel];
	[ObjectiveCScripts positionIcon:self.largeCircleImg govEcon:self.candidateObj.govEcon govMoral:self.candidateObj.govMoral bgView:self.largeGraphicView label:self.largeNameChartLabel];
	
	self.matchLabel.text = [NSString stringWithFormat:@"You match this candidate on %d%% of the issues.", self.percent];
	[self annimateLine];

}

-(NSManagedObject *)candidateCoreDataObj {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"candidate_id = %d", self.candidateObj.candidate_id];
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"CANDIDATE" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:YES];
	if(items.count>0)
		return [items objectAtIndex:0];
	else
		return nil;
}

-(void)loadCandidate {
	NSManagedObject *mo = [self candidateCoreDataObj];
	if(mo) {
		self.candidateObj.answers=[mo valueForKey:@"answers"];
		self.candidateObj.ideology=[mo valueForKey:@"ideology"];
		self.candidateObj.govEcon = [[mo valueForKey:@"govEcon"] intValue];
		self.candidateObj.govMoral = [[mo valueForKey:@"govMoral"] intValue];
		self.candidateObj.quoteCounts = [mo valueForKey:@"quoteCounts"];
		self.ideologyLabel.text = self.candidateObj.ideology;
		[mo setValue:[mo valueForKey:@"lastUpdServer"] forKey:@"lastUpdLocal"];
		[self.managedObjectContext save:nil];
//		NSLog(@"+++self.candidateObj.answers %@", self.candidateObj.answers);
	}
	[self updateStuff];
	[self.mainTableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.nameLabel.text = self.candidateObj.name;
	
	NSLog(@"%d %d %d", self.candidateObj.issuesLevel, self.candidateObj.picLevel, self.candidateObj.editLevel);
	
	self.quoteCountsArray = [[NSArray alloc] initWithArray:[self.candidateObj.quoteCounts componentsSeparatedByString:@":"]];
	self.droppedOutSwitch.on = self.candidateObj.droppedOutFlg;
	self.topTierSegment.selectedSegmentIndex = (self.candidateObj.fringeFlg)?1:0;
	
	self.saveChangesButton.hidden=YES;
	self.cancelChangesButton.hidden=YES;
	self.editCandidateView.hidden=YES;
	self.adminView.hidden=YES;
	self.largeImageView.hidden=YES;
	
	[self checkSync];
	
	[self.activityIndicator startAnimating];
	[self performSelectorInBackground:@selector(displayImage) withObject:nil];
	self.uploadPhotoButton.hidden=YES;
	self.largeGraphicView.hidden=YES;

	self.candidateIdeologyLabel.text = self.candidateObj.ideology;
	self.candidateIdeologyTextView.text = [ObjectiveCScripts textForIdeology:self.candidateObj.ideology];
	self.candidateIdeologyView.hidden=YES;
	
	self.nameTextField.text = self.candidateObj.name;
	[self.partyButton setTitle:self.candidateObj.party forState:UIControlStateNormal];
	
	self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonPressed)];
	self.navigationItem.rightBarButtonItem = self.rightButton;
	
	[self.webServiceElements addObject:self.rightButton];
	[self.webServiceElements addObject:self.droppedOutSwitch];
	[self.webServiceElements addObject:self.topTierSegment];
	[self.webServiceElements addObject:self.saveChangesButton];
	[self.webServiceElements addObject:self.cancelChangesButton];
	
	self.updateButton.enabled=NO;
	
	
	self.likeFavBar = [[LikeFavBar alloc] init];
	[self.view addSubview:self.likeFavBar];
	[self.likeFavBar setupLikeFavBarButtonsForTarget:self likeSelector:@selector(likeButtonPressed) favSelector:@selector(favButtonPressed)];
	
	[self loadIssues];
	
	if(self.favQuoteCandidate>0)
		[self performSelectorInBackground:@selector(loadFavQuote) withObject:nil];
}

-(void)loadFavQuote {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"issue_id = %d", self.favQuoteIssue];
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"ISSUE" predicate:predicate sortColumn:@"issue_id" mOC:self.managedObjectContext ascendingFlg:YES];
	if(items.count>0) {
		NSManagedObject *mo = [items objectAtIndex:0];
		IssueObj *issueObj = [IssueObj objectFromManagedObject:mo];
		CandidateIssueVC *detailViewController = [[CandidateIssueVC alloc] initWithNibName:@"CandidateIssueVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Favorite Quote";
		detailViewController.candidateObj = self.candidateObj;
		detailViewController.issueObj = issueObj;
		detailViewController.favQuote_id=self.favQuote_id;
		detailViewController.callbackViewController=self;
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	
	self.updateMessageLabel.hidden = [ObjectiveCScripts isCandidateIssuesComplete:self.candidateObj.answers];
	[self updateStuff];
	[self.mainTableView reloadData];
	
	[self performSelectorInBackground:@selector(backgroundWebService) withObject:nil];
}



-(void)displayLikeFavBar {
	[self.likeFavBar displayLikeFavBarLikes:self.candidateObj.likes favorites:self.candidateObj.favorites youLikeFlg:self.youLikeFlg yourFavFlg:self.yourFavFlg];
}


-(void)annimateLine {
	self.motionStep=0;
	self.matchPercentLabel.text = @"...";
	self.matchPercentView.hidden=YES;
	[self performSelector:@selector(lineInMotion) withObject:nil afterDelay:1];
}

-(void)lineInMotion {
	@autoreleasepool {
		[NSThread sleepForTimeInterval:.01];
		self.motionStep+=5;
		if(self.motionStep>100)
			self.motionStep=100;
		self.matchPercentView.hidden=NO;
		int fullWidth = self.view.frame.size.width;
		float percent = self.percent*self.motionStep/100;
		int width=0;
		if(fullWidth>0)
			width = percent*fullWidth/100;
		self.matchPercentView.frame = CGRectMake(0, self.matchPercentView.frame.origin.y, width, self.matchPercentView.frame.size.height);
		
		[self.matchPercentLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d%%", (int)percent] waitUntilDone:NO];
		if(self.motionStep<100)
			[self performSelectorInBackground:@selector(lineInMotion) withObject:nil];
	}
}

-(void)checkSync {
	if(![self.candidateObj.lastUpdLocal isEqualToString:self.candidateObj.lastUpdServer]) {
		self.forceRecache=YES;
		self.candidateObj.lastUpdLocal = self.candidateObj.lastUpdServer;
		[self loadCandidate];
		NSLog(@"resyncing!");
	}

}

-(void)loadIssues {
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"ISSUE" predicate:nil sortColumn:@"issue_id" mOC:self.managedObjectContext ascendingFlg:YES];
	[self.mainArray	removeAllObjects];
	for(NSManagedObject *mo in items) {
		IssueObj *issueObj = [IssueObj objectFromManagedObject:mo];
		[self.mainArray	addObject:issueObj];
	}
	if(self.mainArray.count==0)
		[ObjectiveCScripts showAlertPopupWithDelegate:@"Notice!" message:@"Issues have not been loaded. Press of to load issues." delegate:self tag:1];
	[self.mainTableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	PolyTestVC *detailViewController = [[PolyTestVC alloc] initWithNibName:@"PolyTestVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Poly Test";
	[self.navigationController pushViewController:detailViewController animated:YES];
}


-(void)editButtonPressed {
	if([ObjectiveCScripts confirmEditOK:self.candidateObj.editLevel]) {
		self.editMode=!self.editMode;
		self.uploadPhotoButton.hidden=!self.editMode;
		self.editCandidateView.hidden=!self.editMode;
		self.adminView.hidden=!self.editMode;
		self.mainTableView.hidden=self.editMode;
		self.nameLabel.hidden=self.editMode;
	}
}

-(void)displayImage {
	@autoreleasepool {
		UIImage *image = [ObjectiveCScripts cachedImageForRowId:self.candidateObj.candidate_id type:0 dir:@"pics" forceRecache:self.forceRecache];
		if(image) {
			self.mainPic.image = image;
			self.largeImageView.image = image;
		}
		
		if(self.forceRecache) {
			[ObjectiveCScripts cachedImageForRowId:self.candidateObj.candidate_id type:1 dir:@"pics" forceRecache:self.forceRecache];
		}
		
		[self.activityIndicator stopAnimating];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	CandidateIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[CandidateIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	IssueObj *issueObj = [self.mainArray objectAtIndex:indexPath.row];
	
	int yourPosition = [[ObjectiveCScripts getUserDefaultValue:[NSString stringWithFormat:@"Question%d", (int)indexPath.row+1]] intValue];
	int canPosition = [ObjectiveCScripts candidatesPositionForNumber:(int)indexPath.row+1 answers:self.candidateObj.answers];
	
	[CandidateIssueCell updateCell:cell issueObj:issueObj option:canPosition otherOption:yourPosition];
	
	int quotes=0;
	if(self.quoteCountsArray.count>indexPath.row)
		quotes = [[self.quoteCountsArray objectAtIndex:indexPath.row] intValue];
	if(quotes>0)
		cell.quoteCountLabel.text = [NSString stringWithFormat:@"%d Quote%@", quotes, (quotes==1)?@"":@"s"];
	
	cell.popCountLabel.text = [NSString stringWithFormat:@"%d", 0]; //<-- needs work

	cell.nameLabel.text=issueObj.name;
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
	CandidateIssueVC *detailViewController = [[CandidateIssueVC alloc] initWithNibName:@"CandidateIssueVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"On This Issues";
	detailViewController.candidateObj = self.candidateObj;
	detailViewController.issueObj = [self.mainArray objectAtIndex:indexPath.row];
	detailViewController.callbackViewController=self;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint startTouchPosition = [touch locationInView:self.view];
	if(self.largeImageView.hidden && self.largeGraphicView.hidden && CGRectContainsPoint(self.mainPic.frame, startTouchPosition)) {
		self.largeImageView.hidden=NO;
		self.mainTableView.hidden=YES;
		self.rightButton.enabled=NO;
		return;
	}
	if(self.largeImageView.hidden==NO) {
		self.largeImageView.hidden=YES;
		self.mainTableView.hidden=NO;
		self.rightButton.enabled=YES;
		return;
	}

	
	if(self.largeGraphicView.hidden==YES && !self.editMode && CGRectContainsPoint(self.graphicView.frame, startTouchPosition)) {
		self.largeGraphicView.hidden=NO;
		self.candidateIdeologyView.hidden=NO;
		self.rightButton.enabled=NO;
		self.hideUserFlg=NO;
		self.largeCircleImg.hidden=self.hideUserFlg;
		self.largeNameChartLabel.hidden=self.hideUserFlg;
		return;
	}
	if(self.largeGraphicView.hidden==YES && CGRectContainsPoint(self.mainPic.frame, startTouchPosition)) {
		[self editButtonPressed];
		return;
	}
	if(self.largeGraphicView.hidden==NO && CGRectContainsPoint(self.largeGraphicView.frame, startTouchPosition)) {
		self.hideUserFlg=!self.hideUserFlg;
		self.largeCircleImg.hidden=self.hideUserFlg;
		self.largeNameChartLabel.hidden=self.hideUserFlg;
		return;
	}
}

- (IBAction) xButtonPressed: (id) sender {
	self.largeGraphicView.hidden=YES;
	self.candidateIdeologyView.hidden=YES;
	self.rightButton.enabled=YES;
}

-(void)postPhotoUpload {
	self.uploadPhotoButton.hidden=YES;
	self.saveChangesButton.hidden=NO;
	self.cancelChangesButton.hidden=NO;
}

- (IBAction) saveButtonPressed: (id) sender {
	self.saveChangesButton.hidden=YES;
	self.cancelChangesButton.hidden=YES;
	if([ObjectiveCScripts confirmEditOK:self.candidateObj.picLevel])
		[self startWebService:@selector(uploadPhotoWebService) message:@"Uploading..."];
}
- (IBAction) cancelButtonPressed: (id) sender {
	self.saveChangesButton.hidden=YES;
	self.cancelChangesButton.hidden=YES;
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)uploadPhotoWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"candidate_id", @"image", @"smallImage", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [NSString stringWithFormat:@"%d", self.candidateObj.candidate_id],
							  [ObjectiveCScripts base64EncodeImage:self.imageLarge],
							  [ObjectiveCScripts base64EncodeImage:self.imageThumb], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/updatePhoto.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"Note, some times the new image will not show up for several minutes." delegate:self tag:0];
			[ObjectiveCScripts updateFlagForNumber:2 toString:@"Y"];
		}
		
		[self stopWebService];
	}
	
}

-(void)mainWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"candidate_id", @"droppedOutFlg", @"fringeFlg", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [NSString stringWithFormat:@"%d", self.candidateObj.candidate_id],
							  [NSString stringWithFormat:@"%@", (self.droppedOutSwitch.on)?@"Y":@""],
							  [NSString stringWithFormat:@"%@", (self.topTierSegment.selectedSegmentIndex==1)?@"Y":@""],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/updateCandidate.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopup:@"Success" message:@""];
			[ObjectiveCScripts updateFlagForNumber:2 toString:@"Y"];
		}
		
		[self stopWebService];
	}
	
}

-(void)backgroundWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"candidate_id", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.candidateObj.candidate_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/candidateQuoteCounts.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"%@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *components = [responseStr componentsSeparatedByString:@"|"];
			if(components.count>5) {
				NSString *quoteCounts = [components objectAtIndex:1];
				int likes = [[components objectAtIndex:2] intValue];
				int favorites = [[components objectAtIndex:3] intValue];
				self.youLikeFlg = [@"Y" isEqualToString:[components objectAtIndex:4]];
				self.yourFavFlg = [@"Y" isEqualToString:[components objectAtIndex:5]];
				NSManagedObject *mo = [self candidateCoreDataObj];
				[mo setValue:[NSNumber numberWithInt:likes] forKey:@"likes"];
				[mo setValue:[NSNumber numberWithInt:favorites] forKey:@"favorites"];
				if(![quoteCounts isEqualToString:self.candidateObj.quoteCounts]) {
					[mo setValue:quoteCounts forKey:@"quoteCounts"];
					NSLog(@"updating quote counts.");
					[self.mainTableView reloadData];
					
				}
				[self.managedObjectContext save:nil];
				self.candidateObj.likes=likes;
				self.candidateObj.favorites=favorites;
				[self setupLikesView];
			}
		}
		
	}
	
}

-(void)setupLikesView {
	[self displayLikeFavBar];
}

- (IBAction) uploadPhotoButtonPressed: (id) sender {
	if([ObjectiveCScripts confirmEditOK:self.candidateObj.picLevel])
		[self showPhotoActionSheet];
}


- (IBAction) updateButtonPressed: (id) sender {
	self.updateButton.enabled=NO;
	if([ObjectiveCScripts confirmEditOK:self.candidateObj.editLevel])
		[self startWebService:@selector(mainWebService) message:nil];
}

- (IBAction) switchPressed: (id) sender {
	self.updateButton.enabled=YES;
	if(self.droppedOutSwitch.on) {
		self.topTierSegment.selectedSegmentIndex=1;
		[self.topTierSegment changeSegment];
	}
}
- (IBAction) segmentChanged: (id) sender {
	self.updateButton.enabled=YES;
	[self.topTierSegment changeSegment];
	if(self.topTierSegment.selectedSegmentIndex==0)
		self.droppedOutSwitch.on=NO;
}

-(void)likeButtonPressed {
	[self startWebService:@selector(likeWebService) message:nil];
}

-(void)favButtonPressed {
	[self startWebService:@selector(favWebService) message:nil];
}

-(void)likeWebService {
	@autoreleasepool {
		self.updateButton.enabled=NO;
		if([ObjectiveCScripts chooseLikeOrFavForEntity:@"CANDIDATE" primaryKey:@"candidate_id" row_id:self.candidateObj.candidate_id userField:@""]) {
			
			if(self.youLikeFlg)
				self.candidateObj.likes--;
			else
				self.candidateObj.likes++;
			self.youLikeFlg=!self.youLikeFlg;
			[self setupLikesView];
		}
		[self stopWebService];
	}
	
}

-(void)favWebService {
	@autoreleasepool {
		self.updateButton.enabled=NO;
		if([ObjectiveCScripts chooseLikeOrFavForEntity: @"CANDIDATE" primaryKey:@"candidate_id" row_id:self.candidateObj.candidate_id userField:@"favCandidate"]) {
			[ObjectiveCScripts setUserDefaultValue:self.candidateObj.name forKey:@"CandidateName"];
			[ObjectiveCScripts setUserDefaultValue:[NSString stringWithFormat:@"%d", self.candidateObj.candidate_id] forKey:@"CandidateId"];

			self.yourFavFlg=YES;
			self.candidateObj.favorites++;
			[self setupLikesView];
		}

		[self stopWebService];
	}
	
}







@end
