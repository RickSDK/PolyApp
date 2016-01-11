//
//  CandidatesVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "CandidatesVC.h"
#import "CandidateCell.h"
#import "AddCandidateVC.h"
#import "ObjectiveCScripts.h"
#import "CandidateDetailVC.h"
#import "CoreDataLib.h"
#import "PolyTestVC.h"
#import "IssueCompareVC.h"


@interface CandidatesVC ()

@end

@implementation CandidatesVC

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if([ObjectiveCScripts needToUpdateForNumber:2])
		[self startWebService:@selector(loadDataWebService) message:@"Loading"];
	else
		[self loadDataFromDatabase];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.selectedCandidate=[CandidateObj new];
	
	self.adView.hidden=YES;
	
	self.currentParty = [[NSString alloc] init];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
	
	if(self.chooseFlg)
		self.compareButton.enabled=NO;
	
	if(self.chooseFlg)
		self.titleLabel.text = [NSString stringWithFormat:@"Your choice for %@ President in %@.", [ObjectiveCScripts getUserDefaultValue:@"Country"], [ObjectiveCScripts getUserDefaultValue:@"Year"]];
	else
		self.titleLabel.text = [NSString stringWithFormat:@"Potential candidates for %@ President in %@.", [ObjectiveCScripts getUserDefaultValue:@"Country"], [ObjectiveCScripts getUserDefaultValue:@"Year"]];

	if([ObjectiveCScripts getUserDefaultValue:@"CandidateId"].length==0 && self.mainArray.count>0)
		[ObjectiveCScripts showAlertPopup:@"Choose Your Candidate!" message:@"Choose your favorite candidate. If you don't have one, just choose anyone."];
	
	if(!self.chooseFlg)
		[PolyPopupView addPolyPopToView:self.view message:@"PolyApp is designed to be user driven. You can add new candidates by pressing the '+' button above." polyId:1];

}



-(IBAction)compareButtonClicked:(id)sender {
	IssueCompareVC *detailViewController = [[IssueCompareVC alloc] initWithNibName:@"IssueCompareVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
//	detailViewController.title = @"Add Candidate";
	[self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)loadDataFromDatabase {
	NSLog(@"+++loadDataFromDatabase");
	NSString *sort = @"popularity";
	if (self.sortSegment.selectedSegmentIndex==1)
		sort = @"party";
	if (self.sortSegment.selectedSegmentIndex==2)
		sort = @"percentMatch";

	NSArray *items = [CoreDataLib selectRowsFromEntity:@"CANDIDATE" predicate:nil sortColumn:sort mOC:self.managedObjectContext ascendingFlg:NO];
	[self.mainArray removeAllObjects];
	for(NSManagedObject *mo in items) {
		CandidateObj *candidateObj = [CandidateObj objectFromManagedObject:mo];
		
		NSArray *quotes = [candidateObj.quoteCounts componentsSeparatedByString:@":"];
		int totalQuotes=0;
		for(NSString *quote in quotes)
			totalQuotes+=[quote intValue];
		candidateObj.totalQuotes=totalQuotes;
		
		if(self.topTierSegment.selectedSegmentIndex==0 || !candidateObj.fringeFlg)
			[self.mainArray addObject:candidateObj];
	}
	[self.mainTableView reloadData];

	if(self.mainArray.count==0)
		[ObjectiveCScripts showAlertPopup:@"No Candidates!" message:@"There are no candidates entered yet for your country. Press the '+' button at the top to get started."];
}

-(void)loadDataWebService
{
	@autoreleasepool {
		NSLog(@"+++loadDataWebService");
		self.forceRecache=YES;
		self.currentRow=0;
		self.sections=0;
		self.rows=0;
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], [ObjectiveCScripts getUserDefaultValue:@"Year"], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getCandidates.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			self.rows=0;
			for(NSString *line in lines)
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					if(components.count>18) {
						
						int candidate_id = [[components objectAtIndex:0] intValue];
						NSPredicate *predicate = [NSPredicate predicateWithFormat:@"candidate_id = %d", candidate_id];
						NSArray *items = [CoreDataLib selectRowsFromEntity:@"CANDIDATE" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
						NSManagedObject *mo=nil;
						if(items.count>0)
							mo = [items objectAtIndex:0];
						else {
							mo = [NSEntityDescription insertNewObjectForEntityForName:@"CANDIDATE" inManagedObjectContext:self.managedObjectContext];
							[mo setValue:[NSNumber numberWithInt:candidate_id] forKey:@"candidate_id"];
							NSLog(@"Creating candidate: %d", candidate_id);
						}
						
						[mo setValue:[components objectAtIndex:1] forKey:@"name"];
						[mo setValue:[components objectAtIndex:2] forKey:@"party"];
						[mo setValue:[NSNumber numberWithInt:[[components objectAtIndex:3] intValue]] forKey:@"color"];
						[mo setValue:[NSNumber numberWithInt:[[components objectAtIndex:4] intValue]] forKey:@"govEcon"];
						[mo setValue:[NSNumber numberWithInt:[[components objectAtIndex:5] intValue]] forKey:@"govMoral"];
						[mo setValue:[NSNumber numberWithInt:[[components objectAtIndex:6] intValue]] forKey:@"conservativeMeter"];
						[mo setValue:[components objectAtIndex:7] forKey:@"ideology"];
						[mo setValue:[components objectAtIndex:8] forKey:@"answers"];
						[mo setValue:[NSNumber numberWithInt:[[components objectAtIndex:9] intValue]] forKey:@"picLevel"];
						[mo setValue:[NSNumber numberWithInt:[[components objectAtIndex:10] intValue]] forKey:@"issuesLevel"];
						[mo setValue:[components objectAtIndex:11] forKey:@"lastUpdServer"];
						//here!!!

						int percentMatch = [ObjectiveCScripts percentMatch:[mo valueForKey:@"answers"]];
						[mo setValue:[NSNumber numberWithInt:percentMatch] forKey:@"percentMatch"];
						[mo setValue:[components objectAtIndex:12] forKey:@"quoteCounts"];
						[mo setValue:[NSNumber numberWithBool:[[components objectAtIndex:13] isEqualToString:@"Y"]] forKey:@"droppedOutFlg"];
						[mo setValue:[NSNumber numberWithInt:[[components objectAtIndex:14] intValue]] forKey:@"pollingNumber"];
						[mo setValue:[NSNumber numberWithBool:[[components objectAtIndex:15] isEqualToString:@"Y"]] forKey:@"fringeFlg"];
						
						int likes = [[components objectAtIndex:16] intValue];
						int favorites = [[components objectAtIndex:17] intValue];
						[mo setValue:[NSNumber numberWithInt:likes] forKey:@"likes"];
						[mo setValue:[NSNumber numberWithInt:favorites] forKey:@"favorites"];
						[mo setValue:[NSNumber numberWithInt:favorites*10+likes] forKey:@"popularity"];
						[mo setValue:[NSNumber numberWithInt:[[components objectAtIndex:18] intValue]] forKey:@"attrib03"];
					}
				}
			[self.mainTableView reloadData];
			self.forceRecache=NO;
		} else
			[ObjectiveCScripts showAlertPopup:@"Server Error" message:@"Unable to reach the server. Try again later."];

		[self.managedObjectContext save:nil];
		[ObjectiveCScripts updateFlagForNumber:2 toString:@""];

		[self stopWebService];
		[self loadDataFromDatabase];

	}
}


-(void)addButtonPressed {
	AddCandidateVC *detailViewController = [[AddCandidateVC alloc] initWithNibName:@"AddCandidateVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Add Candidate";
	[self.navigationController pushViewController:detailViewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	CandidateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[CandidateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	CandidateObj *candidateObj = [self.mainArray objectAtIndex:indexPath.row];
	

	cell.nameLabel.text = candidateObj.name;
	cell.partyLabel.text = [NSString stringWithFormat:@"%@ Party", candidateObj.party];
	cell.quoteCountLabel.text = [NSString stringWithFormat:@"%d", candidateObj.totalQuotes];
	cell.popularityLabel.text = [NSString stringWithFormat:@"%d", candidateObj.popularity];
	
	if(candidateObj.conservativeMeter>=0)
		cell.ideologyLabel.textColor=[UIColor redColor];
	else
		cell.ideologyLabel.textColor=[UIColor blueColor];
	
	float screenWidth=[ObjectiveCScripts screenWidth];
	
	cell.ideologyLabel.frame = CGRectMake(screenWidth/2-35, 39, 100, 11);

	if(candidateObj.conservativeMeter>=0 && candidateObj.conservativeMeter<6) {
		cell.ideologyLabel.frame = CGRectMake(screenWidth/2-100, 39, 100, 11);
		cell.ideologyLabel.textColor=[UIColor blackColor];
	}
	
	if(candidateObj.conservativeMeter<=0 && candidateObj.conservativeMeter>-6) {
		cell.ideologyLabel.frame = CGRectMake(screenWidth/2, 39, 100, 11);
		cell.ideologyLabel.textColor=[UIColor blackColor];
	}

	if([ObjectiveCScripts isCandidateIssuesComplete:candidateObj.answers]) {
		cell.ideologyLabel.text = candidateObj.ideology;
		
		int percent = [ObjectiveCScripts percentMatch:candidateObj.answers];
		cell.percentMatchLabel.textColor = [self colorForPercent:percent];
		cell.percentMatchLabel.text = [NSString stringWithFormat:@"%d%% Match", percent];
		if([ObjectiveCScripts getUserDefaultValue:@"CandidateId"].length==0)
			cell.percentMatchLabel.text = @""; //<-- haven't taken test yet
	} else {
		cell.ideologyLabel.text = @"(Unknown)";
		cell.percentMatchLabel.text = @"Profile Incomplete";
	}
	
	cell.outImg.hidden=!candidateObj.droppedOutFlg;
	cell.bgView.backgroundColor = (candidateObj.droppedOutFlg)?[UIColor colorWithWhite:.8 alpha:1]:[UIColor whiteColor];
	
	float totalWidth = [ObjectiveCScripts screenWidth]-kConservativeMeterGap;
	if(totalWidth<1)
		totalWidth=242;
	float segment=totalWidth/40;
	float xCord = 50+(candidateObj.conservativeMeter+20)*segment;
	cell.yellowCircle.center = CGPointMake(xCord, 45);
	cell.liberalView.frame = CGRectMake(xCord-50, 0, [ObjectiveCScripts screenWidth], 11);
	
	if(candidateObj.droppedOutFlg) {
		cell.percentMatchLabel.text = @"Dropped Out!";
		cell.percentMatchLabel.textColor = [UIColor redColor];
	}

	
	cell.backgroundColor = [UIColor ATTBlue];
	cell.pic.image = [ObjectiveCScripts cachedImageForRowId:candidateObj.candidate_id type:1 dir:@"pics" forceRecache:self.forceRecache];
//	cell.pic.layer.borderColor = [ObjectiveCScripts colorOfNumber:candidateObj.color].CGColor;
	cell.partyLabel.textColor = [ObjectiveCScripts colorOfNumber:candidateObj.color];
	cell.partyLabel.shadowColor = [ObjectiveCScripts nameColorOfNumber:candidateObj.color];
	cell.partyLabel.shadowOffset = CGSizeMake(1, 1);
//	cell.pic.layer.borderWidth = 1.;
	
	
	if(self.chooseFlg) {
		int candidate_id= [[ObjectiveCScripts getUserDefaultValue:@"CandidateId"] intValue];
		if(candidate_id==candidateObj.candidate_id) {
			cell.accessoryType= UITableViewCellAccessoryCheckmark;
			cell.bgView.backgroundColor=[UIColor yellowColor];
		}
	}

	cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	return cell;
}

-(UIColor *)colorForPercent:(int)percent {
	if(percent<=10)
		return [UIColor blackColor];
	if(percent<=50)
		return [UIColor redColor];
	if(percent<=75)
		return [UIColor orangeColor];
	if(percent<=90)
		return [UIColor colorWithRed:0 green:.4 blue:0 alpha:1];
	return [UIColor colorWithRed:0 green:.7 blue:0 alpha:1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CandidateObj *candidateObj = [self.mainArray objectAtIndex:indexPath.row];
	if(self.chooseFlg) {
		self.selectedCandidate = candidateObj;
		[ObjectiveCScripts showConfirmationPopup:[NSString stringWithFormat:@"Choose %@?", candidateObj.name] message:@"Is this your choice for president?" delegate:self tag:1];
		return;
	}
	CandidateDetailVC *detailViewController = [[CandidateDetailVC alloc] initWithNibName:@"CandidateDetailVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = candidateObj.name;
	detailViewController.candidateObj = candidateObj;
	[self.navigationController pushViewController:detailViewController animated:YES];
	
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex!=alertView.cancelButtonIndex) {
		if([ObjectiveCScripts chooseLikeOrFavForEntity: @"CANDIDATE" primaryKey:@"candidate_id" row_id:self.selectedCandidate.candidate_id userField:@"favCandidate"]) {
			[ObjectiveCScripts setUserDefaultValue:self.selectedCandidate.name forKey:@"CandidateName"];
			[ObjectiveCScripts setUserDefaultValue:[NSString stringWithFormat:@"%d", self.selectedCandidate.candidate_id] forKey:@"CandidateId"];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 54;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}


-(IBAction)sortSegmentClicked:(id)sender {
	[self.sortSegment changeSegment];
	[self loadDataFromDatabase];
}

-(IBAction)bottomSegmentClicked:(id)sender {
	[self.topTierSegment changeSegment];
	[self loadDataFromDatabase];
}

-(void)favWebService {
	@autoreleasepool {
		
		[self stopWebService];
	}
	
}



@end
