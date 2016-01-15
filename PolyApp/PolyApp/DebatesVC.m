//
//  DebatesVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "DebatesVC.h"
#import "DebateObj.h"
#import "DebateCell.h"
#import "DebateDetailVC.h"
#import "EditTextViewVC.h"
#import "UserDetailVC.h"

#define kSuccessAlert	1

@interface DebatesVC ()

@end

@implementation DebatesVC

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self startWebService:@selector(loadDataWebService) message:@"Loading"];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.howWorkView.hidden=YES;
	self.openingTextView.text=@"";
	
	self.user1 = [UserObj new];
	self.user2 = [UserObj new];
	
	[self.textFieldElements addObject:self.topicTextField];
	[self.textFieldElements addObject:self.yourPositionTextField];
	[self.textFieldElements addObject:self.opponentPositionTextField];
	[self.textFieldElements addObject:self.openingTextView];

	[self extendTableForGold];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
	NSLog(@"textViewDidBeginEditing");
	[self.openingTextView resignFirstResponder];
	EditTextViewVC *detailViewController = [[EditTextViewVC alloc] initWithNibName:@"EditTextViewVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.titleText = @"Enter your Opening Comments";
	detailViewController.startingText = self.openingTextView.text;
	detailViewController.callBackViewController=self;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)returningText:(NSString *)text {
	self.openingTextView.text=text;
	[self.openingTextView resignFirstResponder];
}


-(void)loadDataWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", @"status", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [ObjectiveCScripts getUserDefaultValue:@"Year"],
							  (self.topSegment.selectedSegmentIndex==0)?@"Open":@"Complete",
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getDebates.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7) {
					DebateObj *obj = [DebateObj objectFromLine:line];
					self.user1.user_id=obj.user1;
					self.user2.user_id=obj.user2;
					[self.mainArray addObject:obj];
					if(obj.currentUser==[ObjectiveCScripts myUserId] && [@"Active" isEqualToString:obj.status])
						[ObjectiveCScripts showAlertPopup:@"Notice!" message:[NSString stringWithFormat:@"It's your turn to add comments to debate: %@", obj.topic]];
				}
			[ObjectiveCScripts updateFlagForNumber:4 toString:@""];
		}
		
		if(self.mainArray.count==0 && self.topSegment.selectedSegmentIndex==0)
			[ObjectiveCScripts showAlertPopup:@"No Open Debates" message:@"Currently no open debates. Click the '+' button at the top to get the fun started!"];
		
		[self stopWebService];
		[self.mainTableView reloadData];
	}
}


-(void)addButtonPressed {
	self.popupView.hidden=!self.popupView.hidden;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	DebateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[DebateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	DebateObj *obj = [self.mainArray objectAtIndex:indexPath.row];
	[DebateCell populateCell:cell withObj:obj selectorLeft:@selector(userButtonClicked) selectorRight:@selector(userButton2Clicked) target:self];
	
	if(obj.currentUser==[ObjectiveCScripts myUserId] && [@"Active" isEqualToString:obj.status]) {
		cell.backgroundColor=[UIColor yellowColor];
		cell.statusLabel.textColor = [UIColor redColor];
	}


	cell.accessoryType= UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

-(void)userButtonClicked {
	[UserObj showUserDetailsForUser:self.user1 context:self.managedObjectContext navCtrl:self.navigationController];
}

-(void)userButton2Clicked {
	[UserObj showUserDetailsForUser:self.user2 context:self.managedObjectContext navCtrl:self.navigationController];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DebateDetailVC *detailViewController = [[DebateDetailVC alloc] initWithNibName:@"DebateDetailVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Debate Details";
	detailViewController.debateObj=[self.mainArray objectAtIndex:indexPath.row];
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

-(IBAction)topSegmentClicked:(id)sender {
	[self.topSegment changeSegment];
	[self startWebService:@selector(loadDataWebService) message:@"Loading"];
}


-(IBAction)howXButtonClicked:(id)sender {
	self.howWorkView.hidden=YES;
}
-(IBAction)howWorkButtonClicked:(id)sender {
	self.howWorkView.hidden=!self.howWorkView.hidden;
}

-(BOOL)verifySubmit {
	if(self.topicTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"No topic!" message:@""];
		return NO;
	}
	if(self.yourPositionTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"No position!" message:@""];
		return NO;
	}
	if(self.opponentPositionTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"No opponent's position!" message:@""];
		return NO;
	}
	if(self.openingTextView.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"No opening statement!" message:@""];
		return NO;
	}
	self.popupView.hidden=YES;
	return YES;
}

-(void)mainWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year",
							 @"topic", @"position1", @"position2", @"opening1", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [ObjectiveCScripts getUserDefaultValue:@"Year"],
							  self.topicTextField.text,
							  self.yourPositionTextField.text,
							  self.opponentPositionTextField.text,
							  self.openingTextView.text,
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/startDebate.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"Check back soon to see if your challenge has been accepted!" delegate:self tag:kSuccessAlert];
		}
		
		[self stopWebService];
		[self.mainTableView reloadData];
	}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag==kSuccessAlert)
		[self.navigationController popViewControllerAnimated:YES];
}



@end
