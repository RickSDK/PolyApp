//
//  CandidateIssueVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/21/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "CandidateIssueVC.h"
#import "ObjectiveCScripts.h"
#import "CoreDataLib.h"
#import "CandidateDetailVC.h"
#import "QuotesVC.h"
#import "QuoteObj.h"
#import "QuoteCell.h"
#import "IssueCompareVC.h"
#import "PolyPopupView.h"

@interface CandidateIssueVC ()

@end

@implementation CandidateIssueVC
@synthesize candidateObj, issueObj;

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self checkQuotesInCoreData];
	[self performSelectorInBackground:@selector(backgroundWebService) withObject:nil];
}

-(void)checkQuotesInCoreData {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"candidate_id = %d AND issue_id = %d", self.candidateObj.candidate_id, self.issueObj.issue_id];
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"QUOTE" predicate:predicate sortColumn:@"year|favorites|likes" mOC:self.managedObjectContext ascendingFlg:NO];
	NSLog(@"+++quote items: %d", (int)items.count);
	if(items.count<[self quotesForIssue] || [@"Y" isEqualToString:[ObjectiveCScripts getUserDefaultValue:@"forceQuoteUpdate"]])
		[self startWebService:@selector(getQuotesWebService) message:@"Loading..."];
	else {
		[self loadQuotesFromDatabase:items];
	}


}

-(void)loadQuotesFromDatabase:(NSArray *)items {
	if(items.count==0) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"candidate_id = %d AND issue_id = %d", self.candidateObj.candidate_id, self.issueObj.issue_id];
		items = [CoreDataLib selectRowsFromEntity:@"QUOTE" predicate:predicate sortColumn:@"year|popularity" mOC:self.managedObjectContext ascendingFlg:NO];
	}
	[self.mainArray removeAllObjects];
	for(NSManagedObject *mo in items) {
		QuoteObj *quoteObj = [QuoteObj objectFromManagedObject:mo];
		[self.mainArray addObject:quoteObj];
	}
	self.quotesPoliciesLabel.text = [NSString stringWithFormat:@"Quotes and Policies (%d)", (int)self.mainArray.count];
	[self.mainTableView reloadData];
}

-(void)backgroundWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"candidate_id", @"issue_id", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.candidateObj.candidate_id],
							  [NSString stringWithFormat:@"%d", self.issueObj.issue_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/issueQuoteCounts.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"%@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines) {
				NSArray *components = [line componentsSeparatedByString:@"|"];
				if(components.count>4) {
					int quote_id = [[components objectAtIndex:0] intValue];
					int likes = [[components objectAtIndex:1] intValue];
					int favorites = [[components objectAtIndex:2] intValue];
					NSString *youLikeFlg = [components objectAtIndex:3];
					NSString *yourFavFlg = [components objectAtIndex:4];
					NSManagedObject *mo=[self quoteFromQuoteId:quote_id];
					if(mo) {
						[mo setValue:[NSNumber numberWithInt:likes] forKey:@"likes"];
						[mo setValue:[NSNumber numberWithInt:favorites] forKey:@"favorites"];
						[mo setValue:[NSNumber numberWithInt:favorites*10+likes] forKey:@"popularity"];
						[mo setValue:[NSNumber numberWithBool:[@"Y" isEqualToString:youLikeFlg]] forKey:@"youLikeFlg"];
						[mo setValue:[NSNumber numberWithBool:[@"Y" isEqualToString:yourFavFlg]] forKey:@"yourFavFlg"];
						[self.managedObjectContext save:nil];
					}
				}
			}
		}
		[self loadQuotesFromDatabase:nil];
	}
}

-(NSManagedObject *)quoteFromQuoteId:(int)quote_id {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quote_id = %d", quote_id];
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"QUOTE" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
	if(items.count>0)
		return [items objectAtIndex:0];
	else
		return nil;
}

-(int)quotesForIssue {
	if(self.issueObj.issue_id==0)
		return 0;
	NSArray *numbers = [self.candidateObj.quoteCounts componentsSeparatedByString:@":"];
	if(numbers.count>=20)
		return [[numbers objectAtIndex:self.issueObj.issue_id-1] intValue];
	return 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.ideology = [[NSString alloc] init];
	self.answers = [[NSString alloc] init];
	
	self.answers=self.candidateObj.answers;
	self.ideology=self.candidateObj.ideology;
	self.govEcon=self.candidateObj.govEcon;
	self.govMoral=self.candidateObj.govMoral;
	self.conservativeMeter=self.candidateObj.conservativeMeter;
	
	NSLog(@"+++favQuote %d", self.favQuote);
	
	self.canPosition = [ObjectiveCScripts candidatesPositionForNumber:self.issueObj.issue_id answers:self.candidateObj.answers];

	
	UIImage *image = [ObjectiveCScripts cachedImageForRowId:self.candidateObj.candidate_id type:1 dir:@"pics" forceRecache:NO];
	if(image) {
		self.candidateImage.image = image;
		
	}

	self.candidateImageView.image = [ObjectiveCScripts cachedImageForRowId:self.candidateObj.candidate_id type:0 dir:@"pics" forceRecache:NO];
	
	self.avatarImage.image = [ObjectiveCScripts avatarImageOfType:1];
	
	self.nameLabel.text=self.candidateObj.name;
	self.partyLabel.text=[NSString stringWithFormat:@"%@ Party", self.candidateObj.party];
	self.issueLabel.text=self.issueObj.name;
	self.option1Label.text=self.issueObj.option1;
	self.option2Label.text=self.issueObj.option2;
	self.option3Label.text=self.issueObj.option3;
	self.candidateNameLabel.text=self.candidateObj.name;
	self.issueNameLabel.text = [NSString stringWithFormat:@"On %@", self.issueObj.name];
	

	self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonPressed)];
	self.navigationItem.rightBarButtonItem = self.rightButton;
	
	[self.webServiceElements addObject:self.rightButton];
	[self.webServiceElements addObject:self.updateButton];
	self.updateButton.hidden=YES;

	[PolyPopupView addPolyPopToView:self.view message:@"PolyApp is designed to be user driven. You can add new quotes and update candidates positions here." polyId:2];

	[self setupButtons];
}

-(void)getQuotesWebService {
	@autoreleasepool {
		NSLog(@"+++loading Quotes");
		[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"forceQuoteUpdate"];
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"candidate_id", @"issue_id", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.candidateObj.candidate_id],
							  [NSString stringWithFormat:@"%d", self.issueObj.issue_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getQuotes.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines) {
				if(line.length>10) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					if(components.count>4) {
						QuoteObj *quoteObj = [QuoteObj new];
						quoteObj.quote_id = [[components objectAtIndex:0] intValue];
						quoteObj.quote = [components objectAtIndex:1];
						quoteObj.source = [components objectAtIndex:2];
						quoteObj.year = [components objectAtIndex:3];
						quoteObj.createdByName = [components objectAtIndex:4];
						NSManagedObject *mo = [self coreDataObjectForEntity:@"QUOTE" key:@"quote_id" row_id:quoteObj.quote_id];
						[mo setValue:quoteObj.quote forKey:@"quote"];
						[mo setValue:quoteObj.source forKey:@"source"];
						[mo setValue:quoteObj.year forKey:@"year"];
						[mo setValue:quoteObj.createdByName forKey:@"createdByName"];
						[mo setValue:[NSNumber numberWithInt:self.candidateObj.candidate_id] forKey:@"candidate_id"];
						[mo setValue:[NSNumber numberWithInt:self.issueObj.issue_id] forKey:@"issue_id"];
						[self.mainArray addObject:quoteObj];
					}
				}
			}
			[self.managedObjectContext save:nil];
		}
		[self stopWebService];
		[self loadQuotesFromDatabase:nil];
	}
	
}


-(NSManagedObject *)coreDataObjectForEntity:(NSString *)entity key:(NSString *)key row_id:(int)row_id {
	NSString *preStr = [NSString stringWithFormat:@"%@ = %%d", key];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:preStr, row_id];
	NSArray *items = [CoreDataLib selectRowsFromEntity:entity predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
	NSManagedObject *mo=nil;
	if(items.count>0)
		mo = [items objectAtIndex:0];
	else {
		mo = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self.managedObjectContext];
		[mo setValue:[NSNumber numberWithInt:row_id] forKey:key];
	}
	return mo;
}


-(void)editButtonPressed {
	BOOL isComplete = [ObjectiveCScripts isCandidateIssuesComplete:self.candidateObj.answers];
	if(!isComplete || [ObjectiveCScripts confirmEditOK:self.candidateObj.issuesLevel]) {
		self.popupView.hidden=YES;
		self.editMode=!self.editMode;
		self.updateButton.enabled=NO;
		if(!self.editMode)
			self.updateButton.hidden=YES;
		
		[self setupButtons];
	}
}

-(void)spliceInNewAnswer {
	if(self.answers.length<20)
		self.answers = @"0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0";
	NSMutableArray *components = [NSMutableArray arrayWithArray:[self.answers componentsSeparatedByString:@":"]];
	if(components.count>self.issueObj.issue_id-1) {
		[components replaceObjectAtIndex:self.issueObj.issue_id-1 withObject:[NSString stringWithFormat:@"%d", self.canPosition]];
	}
	self.answers = [components componentsJoinedByString:@":"];
}

-(void)calculateTestScores {
	if(self.answers.length<20)
		self.answers = @"0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0";
	
	NSMutableArray *components = [NSMutableArray arrayWithArray:[self.answers componentsSeparatedByString:@":"]];
	
	int govEcon = 0;
	int govMoral = 0;
	int conservativeMeter=0;
	int i=1;
	for(NSString *item in components) {
		int answer = [item intValue];
		answer-=2;
		if(answer<-1)
			answer=0;
		
		if(i<=10) {
			govEcon+=answer;
			conservativeMeter+=answer*-1;
		} else {
			govMoral+=answer;
			conservativeMeter+=answer;
		}
		i++;
	}
	self.govEcon=govEcon;
	self.govMoral=govMoral;
	self.conservativeMeter=conservativeMeter;
	
	self.ideology = [ObjectiveCScripts polIdeologyFromGovEcon:govEcon govMoral:govMoral];
}



-(void)mainWebService {
	@autoreleasepool {
		self.editMode=NO;
		self.updateButton.hidden=YES;
		[self setupButtons];
		
		[self spliceInNewAnswer];
		[self calculateTestScores];
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"candidate_id", @"answers", @"ideology", @"govEcon", @"govMoral", @"conservativeMeter", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [NSString stringWithFormat:@"%d", self.candidateObj.candidate_id],
							  self.answers,
							  self.ideology,
							  [NSString stringWithFormat:@"%d", self.govEcon],
							  [NSString stringWithFormat:@"%d", self.govMoral],
							  [NSString stringWithFormat:@"%d", self.conservativeMeter],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/updateCandidateScores.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"candidate_id = %d", self.candidateObj.candidate_id];
		NSArray *items = [CoreDataLib selectRowsFromEntity:@"CANDIDATE" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:YES];
		if(items.count>0) {
			NSManagedObject *mo = [items objectAtIndex:0];
			[mo setValue:self.answers forKey:@"answers"];
			[mo setValue:self.ideology forKey:@"ideology"];
			[mo setValue:[NSNumber numberWithInt:self.govEcon] forKey:@"govEcon"];
			[mo setValue:[NSNumber numberWithInt:self.govMoral] forKey:@"govMoral"];
			[mo setValue:self.answers forKey:@"answers"];
			[self.managedObjectContext save:nil];
			[(CandidateDetailVC*)self.callbackViewController loadCandidate];
		}

		[self stopWebService];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts updateFlagForNumber:2 toString:@"Y"];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	
}

-(void)setupButtons {
	self.can1Button.enabled=self.editMode;
	self.can2Button.enabled=self.editMode;
	self.can3Button.enabled=self.editMode;
	self.you1Button.enabled=NO;
	self.you2Button.enabled=NO;
	self.you3Button.enabled=NO;
	self.addQuoteButton.hidden=self.editMode;
	
	int answer = [[ObjectiveCScripts getUserDefaultValue:[NSString stringWithFormat:@"Question%d", self.issueObj.issue_id]] intValue];
	if(answer==1)
		[self.you1Button setBackgroundImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];
	if(answer==2)
		[self.you2Button setBackgroundImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];
	if(answer==3)
		[self.you3Button setBackgroundImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];

	[self.can1Button setBackgroundImage:(self.canPosition==1)?[UIImage imageNamed:@"checkbox1.png"]:[UIImage imageNamed:@"checkbox0.png"] forState:UIControlStateNormal];
	[self.can2Button setBackgroundImage:(self.canPosition==2)?[UIImage imageNamed:@"checkbox1.png"]:[UIImage imageNamed:@"checkbox0.png"] forState:UIControlStateNormal];
	[self.can3Button setBackgroundImage:(self.canPosition==3)?[UIImage imageNamed:@"checkbox1.png"]:[UIImage imageNamed:@"checkbox0.png"] forState:UIControlStateNormal];
	
}

- (IBAction) canButtonPressed: (id) sender {
	UIButton *button = sender;
	self.canPosition=(int)button.tag;
	self.updateButton.enabled=YES;
	self.updateButton.hidden=NO;
	[self setupButtons];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	QuoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[QuoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	QuoteObj *quoteObj = [self.mainArray objectAtIndex:indexPath.row];
	cell.quoteLabel.text=[NSString stringWithFormat:@"%@ (%@)", quoteObj.quote, quoteObj.year];
	cell.likesLabel.text=(quoteObj.likes>0)?[NSString stringWithFormat:@"Likes: %d", quoteObj.likes]:@"";
	cell.favoritesLabel.text=(quoteObj.favorites>0)?[NSString stringWithFormat:@"Fav: %d", quoteObj.favorites]:@"";
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
	self.popupView.hidden=NO;
	self.quoteObj = [self.mainArray objectAtIndex:indexPath.row];
	self.editButton.tag = indexPath.row;
	self.quoteTextView.text=[NSString stringWithFormat:@"%@ (%@)", self.quoteObj.quote, self.quoteObj.year];
	self.sourceLabel.text=self.quoteObj.source;
	self.yearLabel.text=self.quoteObj.year;
	self.createdByLabel.text=self.quoteObj.createdByName;
	[self setupLikesView];
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

- (IBAction) quoteButtonPressed: (id) sender {
	QuotesVC *detailViewController = [[QuotesVC alloc] initWithNibName:@"QuotesVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Add Quote";
	detailViewController.candidateObj=self.candidateObj;
	detailViewController.issueObj=self.issueObj;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction) editQuoteButtonPressed: (id) sender {
	QuotesVC *detailViewController = [[QuotesVC alloc] initWithNibName:@"QuotesVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Edit Quote";
	detailViewController.candidateObj=self.candidateObj;
	detailViewController.issueObj=self.issueObj;
	detailViewController.quoteObj = self.quoteObj;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction) deleteButtonPressed: (id) sender {
	[ObjectiveCScripts showConfirmationPopup:@"Delete this Quote?" message:@"" delegate:self tag:99];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex != alertView.cancelButtonIndex) {
//		[self startWebService:@selector(deleteQuote) message:nil];
		[ObjectiveCScripts showAlertPopup:@"This feature not set up yet" message:@""];
	}
}

-(void)deleteQuote {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"quote_id", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.quoteObj.quote_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/deleteQuote.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quote_id = %d", self.quoteObj.quote_id];
		NSArray *items = [CoreDataLib selectRowsFromEntity:@"QUOTE" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:YES];
		if(items.count>0) {
//			NSManagedObject *mo = [items objectAtIndex:0];
			NSLog(@"Here");
//			[self.managedObjectContext save:nil];
		}
		
		[self stopWebService];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopup:@"Success" message:@""];
		}
	}
	
}

- (IBAction) likeButtonPressed: (id) sender {
	[self startWebService:@selector(likeWebService) message:nil];
}

-(void)likeWebService {
	@autoreleasepool {
		self.updateButton.enabled=NO;
		if([ObjectiveCScripts chooseLikeOrFavForEntity:@"QUOTE" primaryKey:@"quote_id" row_id:self.quoteObj.quote_id userField:@""]) {
			if(self.quoteObj.youLikeFlg)
				self.quoteObj.likes--;
			else
				self.quoteObj.likes++;
			self.quoteObj.youLikeFlg=!self.quoteObj.youLikeFlg;
			[self setupLikesView];
			[self performSelectorInBackground:@selector(backgroundWebService) withObject:nil];
		}
		[self stopWebService];
	}
}

- (IBAction) favoriteButtonPressed: (id) sender {
	[self startWebService:@selector(favWebService) message:nil];
}

-(void)favWebService {
	@autoreleasepool {
		self.updateButton.enabled=NO;
		if([ObjectiveCScripts chooseLikeOrFavForEntity:@"QUOTE" primaryKey:@"quote_id" row_id:self.quoteObj.quote_id userField:@"favQuote"]) {
			
			self.quoteObj.favorites++;
			self.quoteObj.yourFavFlg=YES;
			
			[self setupLikesView];
			[self performSelectorInBackground:@selector(backgroundWebService) withObject:nil];
		}
		[self stopWebService];
	}
}


-(void)setupLikesView {
	NSLog(@"setupLikesView: likes: %d", self.quoteObj.likes);
	self.likeCountLabel.text = [NSString stringWithFormat:@"%d", self.quoteObj.likes];
	self.favCountLabel.text = [NSString stringWithFormat:@"%d", self.quoteObj.favorites];
	self.favoriteButton.enabled=!self.quoteObj.yourFavFlg;
	[self.likeButton setTitle:self.quoteObj.youLikeFlg?@"Unlike":@"Like" forState:UIControlStateNormal];
	self.yourFavoriteLabel.hidden=!self.quoteObj.yourFavFlg;
	self.youLikeLabel.hidden=!self.quoteObj.youLikeFlg;
}

- (IBAction) compareButtonPressed: (id) sender {
	IssueCompareVC *detailViewController = [[IssueCompareVC alloc] initWithNibName:@"IssueCompareVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.issueObj=self.issueObj;
	detailViewController.title = @"Issue Compare";
	[self.navigationController pushViewController:detailViewController animated:YES];	
}


@end
