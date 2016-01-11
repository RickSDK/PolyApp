//
//  ChooseNationVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "ChooseNationVC.h"
#import "ObjectiveCScripts.h"
#import "SelectListVC.h"
#import "AddNationVC.h"

#define kAddButtonAlert		1
#define kConfirmButtonAlert	2
#define kSuccessAlert		3

@interface ChooseNationVC ()

@end

@implementation ChooseNationVC
@synthesize yearFlg;

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if(self.yearFlg) {
		self.titleLabel.text = @"Choose a Presidential Election year";
		[self startWebService:@selector(getYearsWebServiceCall) message:nil];
	} else {
		[self startWebService:@selector(getCountriesWebServiceCall) message:nil];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.mainArray = [[NSMutableArray alloc] init];
	self.startingValue = [[NSString alloc] init];
	self.startingValue = (self.yearFlg)?[ObjectiveCScripts getUserDefaultValue:@"Year"]:[ObjectiveCScripts getUserDefaultValue:@"Country"];
	
	self.nowYear = [ObjectiveCScripts nowYear];
	self.year=self.nowYear;
	
	[self.yearButton setTitle:[NSString stringWithFormat:@"%d", self.year] forState:UIControlStateNormal];
	
	self.rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
	self.navigationItem.rightBarButtonItem = self.rightButton;
	
	[self.webServiceElements addObject:self.selectButton];
	[self.webServiceElements addObject:self.rightButton];


}

-(void)getYearsWebServiceCall
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getYears.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self.mainArray removeAllObjects];
		self.selectedRow=-1;
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7)
					[self.mainArray addObject:line];
			
			[self stopWebService];
			[self.mainTableView reloadData];
			if(self.mainArray.count==0)
				self.selectButton.enabled=NO;
			if(self.mainArray.count==1)
				self.selectedRow=0;
		} else
			[self stopWebService];

	}
}


-(void)getCountriesWebServiceCall
{
	@autoreleasepool {
		NSString *country = [ObjectiveCScripts getUserDefaultValue:@"Country"];
		if(country.length==0)
			country = @"None";

		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  country,
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getCountries.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		[self.mainArray removeAllObjects];
		self.selectedRow=-1;
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7)
					[self.mainArray addObject:line];
			
			[self stopWebService];
			[self.mainTableView reloadData];
			if(self.mainArray.count==0)
				self.selectButton.enabled=NO;
			if(self.mainArray.count==1)
				self.selectedRow=0;
		}
	}
}

-(void)addYearWebServiceCall {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], self.yearButton.titleLabel.text, nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/addYear.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts setUserDefaultValue:self.yearButton.titleLabel.text forKey:@"Year"];
			[self startWebService:@selector(getYearsWebServiceCall) message:@"Loading..."];
		} else
			[self stopWebService];
	}
}

-(void)loadDataWebServiceCall {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getCountries.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"Data Loaded" delegate:self tag:kSuccessAlert];
		}
			 
		[self stopWebService];
	}
}

-(void)markCountry {
	if(self.yearFlg)
		[ObjectiveCScripts setUserDefaultValue:[self countryForRowId:self.selectedRow element:1] forKey:@"Year"];
	else {
		[ObjectiveCScripts setUserDefaultValue:[self countryForRowId:self.selectedRow element:1] forKey:@"Country"];
		[ObjectiveCScripts setUserDefaultValue:[self countryForRowId:self.selectedRow element:2] forKey:@"Year"];
		[ObjectiveCScripts setUserDefaultValue:[self countryForRowId:self.selectedRow element:3] forKey:@"System"];
		[ObjectiveCScripts setUserDefaultValue:[self countryForRowId:self.selectedRow element:4] forKey:@"VoterType"];
	}
	self.selectedValue = [self countryForRowId:self.selectedRow element:1];
}

- (IBAction) selectPressed: (id) sender {
	if(self.mainArray.count==0) {
		[ObjectiveCScripts showAlertPopup:@"Error" message:@"Nothing selected"];
		return;
	}
	if(self.selectedValue.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Error" message:@"Nothing selected"];
		return;
	}
	NSLog(@"selectedValue: %@; self.startingValue: %@", self.selectedValue, self.startingValue);
	
	if([self.selectedValue isEqualToString:self.startingValue]) {
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	[ObjectiveCScripts deleteLocalDatabase:self.managedObjectContext];
	[self markCountry];

	self.mainTableView.hidden=YES;
	[self startWebService:@selector(loadDataWebServiceCall) message:nil];
}

- (IBAction) choosePressed: (id) sender {
	NSString *nation = self.countryButton.titleLabel.text;
	if(self.yearFlg)
		[ObjectiveCScripts showConfirmationPopup:@"Add This Year?" message:[NSString stringWithFormat:@"Add election year %d for %@?", self.year, nation] delegate:self tag:kConfirmButtonAlert];
	else {
		if([self.govTypeButton.titleLabel.text isEqualToString:@"Choose"]) {
			[ObjectiveCScripts showAlertPopup:@"Choose a government type" message:@""];
			return;
		}
		[ObjectiveCScripts showConfirmationPopup:@"Add This Nation?" message:[NSString stringWithFormat:@"Add %@ with an election in %d?", nation, self.year] delegate:self tag:kConfirmButtonAlert];
	}
}

-(void)addButtonPressed {
	if(self.yearFlg) {
		int currentYear = [[ObjectiveCScripts getUserDefaultValue:@"Year"] intValue];
		if(currentYear>=self.nowYear) {
			[ObjectiveCScripts showAlertPopup:@"Sorry" message:@"You cannot add a new year until the current election year is over."];
			return;
		}
		[ObjectiveCScripts showConfirmationPopup:@"Add Year?" message:@"Warning! Do you want to add a new election year to this app? There will not be any candidates until you or someone adds them." delegate:self tag:kAddButtonAlert];
	} else
		[ObjectiveCScripts showConfirmationPopup:@"Add Nation?" message:@"Warning! Do you want to add a new nation to this app? There will not be any candidates until you or someone adds them." delegate:self tag:kAddButtonAlert];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag==kSuccessAlert) {
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	if(buttonIndex != alertView.cancelButtonIndex) {
		if(alertView.tag==kAddButtonAlert) {
			self.rightButton.enabled=NO;
			AddNationVC *detailViewController = [[AddNationVC alloc] initWithNibName:@"AddNationVC" bundle:nil];
			detailViewController.managedObjectContext = self.managedObjectContext;
			detailViewController.title = @"Add Country";
			[self.navigationController pushViewController:detailViewController animated:YES];
		}
		if(alertView.tag==kConfirmButtonAlert) {
			if(self.yearFlg) {
				int currentYear = [[ObjectiveCScripts getUserDefaultValue:@"Year"] intValue];
				int selectedYear = [self.yearButton.titleLabel.text intValue];
				if(selectedYear==currentYear) {
					[ObjectiveCScripts showAlertPopup:@"Error" message:@"You must select a new year"];
					return;
				}
				[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"Year"];
				[self startWebService:@selector(addYearWebServiceCall) message:nil];
				return;
			}
			[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"Country"];
			[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"Year"];
			
		}
	}
}

-(NSString *)countryForRowId:(int)row element:(int)element {
	NSString *line = [self.mainArray objectAtIndex:row];
	NSArray *componenets = [line componentsSeparatedByString:@"|"];
	if(componenets.count>element) {
		return [componenets objectAtIndex:element];
	}
	return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	cell.textLabel.text=[self countryForRowId:(int)indexPath.row element:1];
	
	if(self.yearFlg) {
		if([[self countryForRowId:(int)indexPath.row element:1] isEqualToString:[ObjectiveCScripts getUserDefaultValue:@"Year"]])
		self.selectedRow=(int)indexPath.row;
	} else
		if([[self countryForRowId:(int)indexPath.row element:1] isEqualToString:[ObjectiveCScripts getUserDefaultValue:@"Country"]])
			self.selectedRow=(int)indexPath.row;
	
	if(self.selectedRow==indexPath.row) {
		cell.backgroundColor= [UIColor whiteColor];
		cell.accessoryType= UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType= UITableViewCellAccessoryNone;
		cell.backgroundColor= [UIColor colorWithWhite:.8 alpha:1];
	}
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
	self.selectedRow=(int)indexPath.row;
	[self markCountry];
	[self.mainTableView reloadData];
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}



@end
