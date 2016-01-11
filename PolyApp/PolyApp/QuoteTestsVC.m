//
//  QuoteTestsVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "QuoteTestsVC.h"
#import "CoreDataLib.h"
#import "QuoteTestCell.h"
#import "QuoteTestResultsVC.h"

@interface QuoteTestsVC ()

@end

@implementation QuoteTestsVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[ObjectiveCScripts updateFlagForNumber:6 toString:@""];
	self.candidatesArray = [NSMutableArray new];
	self.quoteArray = [NSMutableArray new];
	self.quoteTestObj = [QuoteTestObj new];
	
	[self populateArray];
}

-(void)populateArray {
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"CANDIDATE" predicate:nil sortColumn:@"party" mOC:self.managedObjectContext ascendingFlg:YES];
	[self.candidatesArray removeAllObjects];
	for(NSManagedObject *mo in items) {
		int count = [self numberQuotesFromString:[mo valueForKey:@"quoteCounts"]];
		if(count>=20) {
			[self.candidatesArray addObject:mo];
		}
	}
	
	[self.mainArray removeAllObjects];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", @"quoteTest"];
	NSArray *quoteTests = [CoreDataLib selectRowsFromEntity:@"OBJECT" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
	[self.mainArray removeAllObjects];
	for (NSManagedObject *mo in quoteTests) {
		QuoteTestObj *quoteTestObj = [QuoteTestObj objFromDatabaseObj:mo];
		[self.mainArray addObject:quoteTestObj];
	}

	self.numberAvailableLabel.text = [NSString stringWithFormat:@"Out of %d", (int)self.candidatesArray.count];
	self.numberCompletedLabel.text = [NSString stringWithFormat:@"%d", (int)quoteTests.count];
	self.takeTestButton.enabled=quoteTests.count<self.candidatesArray.count;
	[self.mainTableView reloadData];
}

-(IBAction)testButtonPressed:(id)sender {
	self.takeTestButton.enabled=NO;
	[self startWebService:@selector(getQuotesWebService) message:nil];
}

-(void)postResultsWebService {
	@autoreleasepool {
		self.popupView.hidden=YES;
		NSLog(@"+++%@", self.quoteTestObj.quotes);
		NSLog(@"+++%@", self.quoteTestObj.responses);
		
		self.quoteTestObj.agreePercent = self.quoteTestObj.agreeCount*100/self.quoteArray.count;
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"row_id = %d AND type = %@", self.quoteTestObj.candidate_id, @"quoteTest"];
		NSArray *items = [CoreDataLib selectRowsFromEntity:@"OBJECT" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
		NSManagedObject *mo=nil;
		if(items.count>0)
			mo = [items objectAtIndex:0];
		else {
			mo = [NSEntityDescription insertNewObjectForEntityForName:@"OBJECT" inManagedObjectContext:self.managedObjectContext];
			[mo setValue:[NSNumber numberWithInt:self.quoteTestObj.candidate_id] forKey:@"row_id"];
			[mo setValue:@"quoteTest" forKey:@"type"];
			NSLog(@"Creating candidate: %d", self.quoteTestObj.candidate_id);
		}
		[mo setValue:self.quoteTestObj.name forKey:@"name"];
		[mo setValue:self.quoteTestObj.quotes forKey:@"attrib01"];
		[mo setValue:self.quoteTestObj.responses forKey:@"attrib02"];
		[mo setValue:[NSNumber numberWithInt:self.quoteTestObj.agreeCount] forKey:@"likes"];
		[mo setValue:[NSNumber numberWithInt:self.quoteTestObj.agreePercent] forKey:@"popularity"];

		[self.managedObjectContext save:nil];
		
		
		[self stopWebService];
		[self populateArray];
	}
}

-(int)countOfCandForNumber:(int)number {
	NSManagedObject *mo = [self.candidatesArray objectAtIndex:number];
	int candidate_id = [[mo valueForKey:@"candidate_id"] intValue];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"row_id = %d AND type = %@", candidate_id, @"quoteTest"];
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"OBJECT" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
	return (int)items.count;
}

-(int)numberOfCandidate {
	int candidate_id = 0;
	int numberAvailable = (int)self.candidatesArray.count-(int)self.mainArray.count;
	NSLog(@"numberAvailable: %d", numberAvailable);
	if(numberAvailable>3) {
		for(int x=0; x<=100; x++) {
			int randomNum = arc4random()%self.candidatesArray.count;
			int count = [self countOfCandForNumber:randomNum];
			if(count==0)
				return randomNum;
		}
	} else {
		for (int i=0; i<self.candidatesArray.count;i++) {
			int count = [self countOfCandForNumber:i];
			if(count==0)
				return i;
		}
	}
	return candidate_id;
}

-(void)getQuotesWebService {
	@autoreleasepool {
		
		int randomNum = [self numberOfCandidate];
		NSManagedObject *mo = [self.candidatesArray objectAtIndex:randomNum];
		self.quoteTestObj.candidate_id = [[mo valueForKey:@"candidate_id"] intValue];
		self.quoteTestObj.name = [mo valueForKey:@"name"];

		if(self.quoteTestObj.candidate_id==0) {
			[ObjectiveCScripts showAlertPopup:@"Error!" message:@""];
			return;
		}

		NSLog(@"+++quote test for: %@ (%d) %d",self.quoteTestObj.name , self.quoteTestObj.candidate_id, randomNum);
		
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"candidate_id", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.quoteTestObj.candidate_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getQuotesForTest.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		[self.quoteArray removeAllObjects];
		self.quoteIndex=0;
		self.quoteTestObj.agreeCount=0;
		self.quoteTestObj.quotes=@"";
		self.quoteTestObj.responses=@"";

		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines) {
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					if(components.count>2) {
						if(self.quoteArray.count<20)
							[self.quoteArray addObject:[components objectAtIndex:2]];
					}
				}
			}
		}
		if(self.quoteIndex<self.quoteArray.count)
			[self displayQuote];
		else
			self.takeTestButton.enabled=YES;

		[self stopWebService];
	}
}

-(void)displayQuote {
	self.popupView.hidden=NO;
	self.quoteLabel.text = [self.quoteArray objectAtIndex:self.quoteIndex];
	self.yesButton.enabled=YES;
	self.noButton.enabled=YES;
	self.countLabel.text = [NSString stringWithFormat:@"%d / %d", self.quoteIndex+1, (int)self.quoteArray.count];
}

-(void)advanceIndex {
	self.quoteIndex++;
	if(self.quoteIndex<self.quoteArray.count)
		[self displayQuote];
	else
		[self startWebService:@selector(postResultsWebService) message:@"Sending Results"];
}


-(IBAction)answerButtonPressed:(UIButton *)button {
	self.yesButton.enabled=NO;
	self.noButton.enabled=NO;
	NSString *response = (button.tag==1)?@"Y":@"N";
	if(button.tag==1) {
		self.quoteTestObj.agreeCount++;
	}
	if(self.quoteTestObj.quotes.length==0) {
		self.quoteTestObj.quotes=[self.quoteArray objectAtIndex:self.quoteIndex];
		self.quoteTestObj.responses=response;
	} else {
		self.quoteTestObj.quotes = [NSString stringWithFormat:@"%@|%@", self.quoteTestObj.quotes, [self.quoteArray objectAtIndex:self.quoteIndex]];
		self.quoteTestObj.responses = [NSString stringWithFormat:@"%@|%@", self.quoteTestObj.responses, response];
	}
	
	[self advanceIndex];
}

-(int)numberQuotesFromString:(NSString *)string {
	int number=0;
	NSArray *components = [string componentsSeparatedByString:@":"];
	for(NSString *numStr in components)
		number+=[numStr intValue];
	
	return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	QuoteTestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[QuoteTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	QuoteTestObj *obj = [self.mainArray objectAtIndex:indexPath.row];
	[QuoteTestCell updateCell:cell obj:obj];

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
	QuoteTestResultsVC *detailViewController = [[QuoteTestResultsVC alloc] initWithNibName:@"QuoteTestResultsVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.quoteTestObj=[self.mainArray objectAtIndex:indexPath.row];
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
	return 70;
}

@end
