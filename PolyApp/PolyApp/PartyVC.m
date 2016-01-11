//
//  PartyVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/16/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "PartyVC.h"
#import "ObjectiveCScripts.h"
#import "CandidateCell.h"
#import "AddCandidateVC.h"

@interface PartyVC ()

@end

@implementation PartyVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
	self.navigationItem.rightBarButtonItem = self.rightButton;
	self.colorButton.backgroundColor = [ObjectiveCScripts colorOfNumber:self.colorNum];

	[self.webServiceElements addObject:self.rightButton];
	[self.webServiceElements addObject:self.submitButton];
	[self.webServiceElements addObject:self.colorButton];
	[self.webServiceElements addObject:self.nameTextField];
	
	self.maxLength=30;
	
	[self startWebService:@selector(loadDataWebService) message:@"Loading"];

}

-(void)loadDataWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getParties.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7)
					[self.mainArray addObject:line];
			
			[self.mainTableView reloadData];
		}
		[self stopWebService];
		if(self.mainArray.count==0)
			[ObjectiveCScripts showAlertPopup:@"No Parties!" message:@"There are no party groups entered yet for your country. Press the '+' button at the top to get started."];
	}
}


-(void)addButtonPressed {
	self.nameTextField.text=@"";
	self.popupView.hidden=!self.popupView.hidden;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	NSArray *components = [[self.mainArray objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"];
	if(components.count>2) {
		cell.textLabel.text=[components objectAtIndex:1];
		int colorNum = [[components objectAtIndex:2] intValue];
		cell.textLabel.textColor = [ObjectiveCScripts nameColorOfNumber:colorNum];
		cell.backgroundColor = [ObjectiveCScripts colorOfNumber:colorNum];
	}

	cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[(AddCandidateVC*)self.callbackController populatePartyField:[self.mainArray objectAtIndex:indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
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

- (IBAction) colorButtonPressed: (id) sender {
	self.colorNum++;
	self.colorButton.backgroundColor = [ObjectiveCScripts colorOfNumber:self.colorNum];
	[self.colorButton setTitleColor:[ObjectiveCScripts nameColorOfNumber:self.colorNum] forState:UIControlStateNormal];
}



-(BOOL)verifySubmit {
	if(self.nameTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Error" message:@"Enter a Party Name"];
		return NO;
	}
	return YES;
}

-(void)mainWebService {
	@autoreleasepool {
		NSString *party = self.nameTextField.text;
		party = [party stringByReplacingOccurrencesOfString:@" Party" withString:@""];
		party = [party stringByReplacingOccurrencesOfString:@" party" withString:@""];
		self.colorNum = [ObjectiveCScripts realColorNumberFromNumber:self.colorNum];
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"name", @"color", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], party, [NSString stringWithFormat:@"%d", self.colorNum], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/addParty.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self.mainArray removeAllObjects];
		[self stopWebService];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopup:@"Success" message:@""];
			NSLog(@"another...");
			[self startWebService:@selector(loadDataWebService) message:@"Loading"];
		}
	}
	
}



@end
