//
//  AddNationVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/26/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "AddNationVC.h"
#import "SelectListVC.h"
#import "ObjectiveCScripts.h"

#define kConfirmButtonAlert	2

@interface AddNationVC ()

@end

@implementation AddNationVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.nowYear = [ObjectiveCScripts nowYear];
	self.year=self.nowYear;

	[self.yearButton setTitle:[NSString stringWithFormat:@"%d", self.year] forState:UIControlStateNormal];
}

- (IBAction) choosePressed: (id) sender {
	NSString *nation = self.countryButton.titleLabel.text;
	if([nation isEqualToString:@"Choose"]) {
		[ObjectiveCScripts showAlertPopup:@"Choose a country" message:@""];
		return;
	}
	if([self.govTypeButton.titleLabel.text isEqualToString:@"Choose"]) {
		[ObjectiveCScripts showAlertPopup:@"Choose a government type" message:@""];
		return;
	}
	if([self.voterTypeButton.titleLabel.text isEqualToString:@"Choose"]) {
		[ObjectiveCScripts showAlertPopup:@"Choose a voter type" message:@""];
		return;
	}
	[ObjectiveCScripts showConfirmationPopup:@"Add This Nation?" message:[NSString stringWithFormat:@"Add %@ with an election in %d?", nation, self.year] delegate:self tag:kConfirmButtonAlert];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex != alertView.cancelButtonIndex) {
		[self startWebService:@selector(addCountryWebServiceCall) message:nil];
	}
}

-(void)addCountryWebServiceCall {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", @"system", @"voterType", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"],
							  self.countryButton.titleLabel.text,
							  self.yearButton.titleLabel.text,
							  self.govTypeButton.titleLabel.text,
							  self.voterTypeButton.titleLabel.text,
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/addCountry.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts setUserDefaultValue:self.countryButton.titleLabel.text forKey:@"Country"];
			[ObjectiveCScripts setUserDefaultValue:self.yearButton.titleLabel.text forKey:@"Year"];
			[ObjectiveCScripts setUserDefaultValue:self.govTypeButton.titleLabel.text forKey:@"System"];
			[ObjectiveCScripts setUserDefaultValue:self.voterTypeButton.titleLabel.text forKey:@"VoterType"];
			[ObjectiveCScripts deleteLocalDatabase:self.managedObjectContext];
			[self stopWebService];
			[self.navigationController popViewControllerAnimated:YES];
			return;
		} else
			[self stopWebService];
	}
}

- (IBAction) nextYearPressed: (id) sender {
	self.year++;
	if(self.year>self.nowYear+6)
		self.year=self.nowYear;
	[self.yearButton setTitle:[NSString stringWithFormat:@"%d", self.year] forState:UIControlStateNormal];
}


- (IBAction) countryPressed: (id) sender {
	self.selectedSection=1;
	SelectListVC *detailViewController = [[SelectListVC alloc] initWithNibName:@"SelectListVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Select Country";
	detailViewController.listArray=[self getCountryArray];
	detailViewController.selectedValue=@"";
	detailViewController.callBackViewController	= self;
	[self.navigationController pushViewController:detailViewController animated:YES];
}
- (IBAction) govSystemPressed: (id) sender {
	self.selectedSection=2;
	SelectListVC *detailViewController = [[SelectListVC alloc] initWithNibName:@"SelectListVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Select Gov";
	detailViewController.listArray=[NSArray arrayWithObjects:@"Presidential Republic",
									@"Partiamentary Republic",
									@"Semi-Presidential Republic",
									@"Consitutional Monarchy",
									@"Absolute Monarchy/Dictatorship",
									@"Single Party State", nil];
	detailViewController.selectedValue=@"";
	detailViewController.callBackViewController	= self;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction) voterTypePressed: (id) sender {
	self.selectedSection=3;
	SelectListVC *detailViewController = [[SelectListVC alloc] initWithNibName:@"SelectListVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Select Voter Type";
	detailViewController.listArray=[NSArray arrayWithObjects:@"President",
									@"Party",
									nil];
	detailViewController.selectedValue=@"";
	detailViewController.callBackViewController	= self;
	[self.navigationController pushViewController:detailViewController animated:YES];
	
}


-(void)valueSelected:(NSString *)value {
	if(self.selectedSection==1)
		[self.countryButton setTitle:value forState:UIControlStateNormal];
	if(self.selectedSection==2)
		[self.govTypeButton setTitle:value forState:UIControlStateNormal];
	if(self.selectedSection==3)
		[self.voterTypeButton setTitle:value forState:UIControlStateNormal];
}


-(NSArray *)getCountryArray
{
	return [NSArray arrayWithObjects:@"Afghanistan",
			@"Albania",
			@"Algeria",
			@"Andorra",
			@"Angola",
			@"Antigua and Barbuda",
			@"Argentina",
			@"Armenia",
			@"Australia",
			@"Austria",
			@"Azerbaijan",
			@"Bahamas, The",
			@"Bahrain",
			@"Bangladesh",
			@"Barbados",
			@"Belarus",
			@"Belgium",
			@"Belize",
			@"Benin",
			@"Bhutan",
			@"Bolivia",
			@"Bosnia and Herzegovina",
			@"Botswana",
			@"Brazil",
			@"Brunei",
			@"Bulgaria",
			@"Burkina Faso",
			@"Burma",
			@"Burundi",
			@"Cambodia",
			@"Cameroon",
			@"Canada",
			@"Cape Verde",
			@"Central African Republic",
			@"Chad",
			@"Chile",
			@"China",
			@"Colombia",
			@"Comoros",
			@"Congo, Democratic Republic of the",
			@"Congo, Republic of the",
			@"Costa Rica",
			@"Cote d'Ivoire",
			@"Croatia",
			@"Cuba",
			@"Cyprus",
			@"Czech Republic",
			@"Denmark",
			@"Djibouti",
			@"Dominica",
			@"Dominican Republic",
			@"East Timor",
			@"Ecuador",
			@"Egypt",
			@"El Salvador",
			@"Equatorial Guinea",
			@"Eritrea",
			@"Estonia",
			@"Ethiopia",
			@"Fiji",
			@"Finland",
			@"France",
			@"Gabon",
			@"Gambia, The",
			@"Georgia",
			@"Germany",
			@"Ghana",
			@"Greece",
			@"Grenada",
			@"Guatemala",
			@"Guinea",
			@"Guinea-Bissau",
			@"Guyana",
			@"Haiti",
			@"Holy See",
			@"Honduras",
			@"Hong Kong",
			@"Hungary",
			@"Iceland",
			@"India",
			@"Indonesia",
			@"Iran",
			@"Iraq",
			@"Ireland",
			@"Israel",
			@"Italy",
			@"Jamaica",
			@"Japan",
			@"Jordan",
			@"Kazakhstan",
			@"Kenya",
			@"Kiribati",
			@"Kosovo",
			@"Kuwait",
			@"Kyrgyzstan",
			@"Laos",
			@"Latvia",
			@"Lebanon",
			@"Lesotho",
			@"Liberia",
			@"Libya",
			@"Liechtenstein",
			@"Lithuania",
			@"Luxembourg",
			@"Macau",
			@"Macedonia",
			@"Madagascar",
			@"Malawi",
			@"Malaysia",
			@"Maldives",
			@"Mali",
			@"Malta",
			@"Marshall Islands",
			@"Mauritania",
			@"Mauritius",
			@"Mexico",
			@"Micronesia",
			@"Moldova",
			@"Monaco",
			@"Mongolia",
			@"Montenegro",
			@"Morocco",
			@"Namibia",
			@"Nauru",
			@"Nepal",
			@"Netherlands",
			@"Netherlands Antilles",
			@"New Zealand",
			@"Nicaragua",
			@"Niger",
			@"Nigeria",
			@"North Korea",
			@"Norway",
			@"Oman",
			@"Pakistan",
			@"Palau",
			@"Palestinian Territories",
			@"Panama",
			@"Papua New Guinea",
			@"Paraguay",
			@"Peru",
			@"Philippines",
			@"Poland",
			@"Portugal",
			@"Qatar",
			@"Romania",
			@"Russia",
			@"Rwanda",
			@"Saint Kitts and Nevis",
			@"Saint Lucia",
			@"Saint Vincent and the Grenadines",
			@"Samoa",
			@"San Marino",
			@"Sao Tome and Principe",
			@"Saudi Arabia",
			@"Senegal",
			@"Serbia",
			@"Seychelles",
			@"Sierra Leone",
			@"Singapore",
			@"Slovakia",
			@"Slovenia",
			@"Solomon Islands",
			@"Somalia",
			@"South Africa",
			@"South Korea",
			@"South Sudan",
			@"Spain",
			@"Sri Lanka",
			@"Sudan",
			@"Suriname",
			@"Swaziland",
			@"Sweden",
			@"Switzerland",
			@"Syria",
			@"Taiwan",
			@"Tajikistan",
			@"Tanzania",
			@"Thailand",
			@"Timor-Leste",
			@"Togo",
			@"Tonga",
			@"Trinidad and Tobago",
			@"Tunisia",
			@"Turkey",
			@"Turkmenistan",
			@"Tuvalu",
			@"Uganda",
			@"Ukraine",
			@"United Arab Emirates",
			@"United Kingdom",
			@"Uruguay",
			@"United States",
			@"Uzbekistan",
			@"Vanuatu",
			@"Venezuela",
			@"Vietnam",
			@"Yemen",
			@"Zambia",
			@"Zimbabwe",
			nil];
}



@end
