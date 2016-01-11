//
//  ProfileVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "ProfileVC.h"
#import "ObjectiveCScripts.h"
#import "SelectListVC.h"
#import "UpgradeVC.h"

@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.mainPic.image = [ObjectiveCScripts avatarImageOfType:0];
	
	self.usernameLabel.text = [ObjectiveCScripts getUserDefaultValue:@"userName"];
	
	if([ObjectiveCScripts getUserDefaultValue:@"firstName"].length>0) {
		self.firstNameField.text = [ObjectiveCScripts getUserDefaultValue:@"firstName"];
		self.yearBornField.text = [ObjectiveCScripts getUserDefaultValue:@"yearBorn"];
		self.emailField.text = [ObjectiveCScripts getUserDefaultValue:@"email"];
		self.lastNameField.text = [ObjectiveCScripts getUserDefaultValue:@"lastname"];
		self.passwordField.text = [ObjectiveCScripts getUserDefaultValue:@"password"];
		self.confirmField.text = [ObjectiveCScripts getUserDefaultValue:@"password"];
		[self.countryButton setTitle:[ObjectiveCScripts getUserDefaultValue:@"profileCountry"] forState:UIControlStateNormal];
		[self.stateButton setTitle:[ObjectiveCScripts getUserDefaultValue:@"profileState"] forState:UIControlStateNormal];
		self.sexSegment.selectedSegmentIndex=[[ObjectiveCScripts getUserDefaultValue:@"sex"] isEqualToString:@"F"];
	}
	
	[self.textFieldElements addObject:self.firstNameField];
	[self.textFieldElements addObject:self.yearBornField];
	[self.textFieldElements addObject:self.emailField];
	[self.textFieldElements addObject:self.lastNameField];
	[self.textFieldElements addObject:self.passwordField];
	[self.textFieldElements addObject:self.confirmField];
	
	self.levelImageView.image = [ObjectiveCScripts imageForLevel:[ObjectiveCScripts myLevel]];
	self.levelLabel.text = [ObjectiveCScripts userNameForLevel:[ObjectiveCScripts myLevel]];


	self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleBordered target:self action:@selector(updateButtonPressed)];
	self.navigationItem.rightBarButtonItem = self.rightButton;
	self.rightButton.enabled=NO;
	self.updateProfileButton.enabled=NO;
	self.userIdLabel.text = [NSString stringWithFormat:@"%d", [ObjectiveCScripts myUserId]];
	self.versionLabel.text = [ObjectiveCScripts getProjectDisplayVersion];
	
}

-(BOOL)textField:(UITextField *)textFieldlocal shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	self.rightButton.enabled=YES;
	self.updateProfileButton.enabled=YES;
	return [ObjectiveCScripts handleTextField:textFieldlocal.text string:string max:self.maxLength];
}

- (IBAction) updateProfileButtonPressed: (id) sender {
	[self updateButtonPressed];
}


-(void)updateButtonPressed {
	if(self.firstNameField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Notice" message:@"Fill in a first name"];
		return;
	}
	if(self.lastNameField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Notice" message:@"Fill in a last name"];
		return;
	}
	int yearBorn=[self.yearBornField.text intValue];
	if(yearBorn<1900 || yearBorn>=[ObjectiveCScripts nowYear]) {
		[ObjectiveCScripts showAlertPopup:@"Notice" message:@"Fill in a valid year born"];
		return;
	}
	if(self.emailField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Notice" message:@"Fill in an email address"];
		return;
	}
	if(self.passwordField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Notice" message:@"Fill in a password"];
		return;
	}
	if(![self.passwordField.text isEqualToString:self.confirmField.text]) {
		[ObjectiveCScripts showAlertPopup:@"Notice" message:@"Password do not match"];
		return;
	}
	if([@"Country" isEqualToString:self.countryButton.titleLabel.text]) {
		[ObjectiveCScripts showAlertPopup:@"Notice" message:@"Choose a Country"];
		return;
	}
	if([@"State" isEqualToString:self.stateButton.titleLabel.text]) {
		[ObjectiveCScripts showAlertPopup:@"Notice" message:@"Choose a State"];
		return;
	}
	[self startWebService:@selector(postProfileWebServiceCall) message:nil];

}

-(void)postProfileWebServiceCall {
	@autoreleasepool {
		NSString *sex = (self.sexSegment.selectedSegmentIndex==0)?@"M":@"F";
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"firstName", @"lastname", @"email", @"password", @"state", @"country", @"sex", @"yearBorn", @"candidate_id", @"closest_match_id", @"level", @"countryName",
							 @"Year", @"ClosestMatchName", @"CandidateName", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  self.firstNameField.text,
							  self.lastNameField.text,
							  self.emailField.text,
							  self.passwordField.text,
							  self.stateButton.titleLabel.text,
							  self.countryButton.titleLabel.text,
							  sex,
							  self.yearBornField.text,
							  [ObjectiveCScripts getUserDefaultValue:@"CandidateId"],
							  [ObjectiveCScripts getUserDefaultValue:@"ClosestMatchId"],
							  [NSString stringWithFormat:@"%d", [ObjectiveCScripts myLevel]],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [ObjectiveCScripts getUserDefaultValue:@"Year"],
							  [ObjectiveCScripts getUserDefaultValue:@"ClosestMatchName"],
							  [ObjectiveCScripts getUserDefaultValue:@"CandidateName"],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/updateProfile.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts setUserDefaultValue:self.firstNameField.text forKey:@"firstName"];
			[ObjectiveCScripts setUserDefaultValue:self.lastNameField.text forKey:@"lastname"];
			[ObjectiveCScripts setUserDefaultValue:self.yearBornField.text forKey:@"yearBorn"];
			[ObjectiveCScripts setUserDefaultValue:self.emailField.text forKey:@"email"];
			[ObjectiveCScripts setUserDefaultValue:self.passwordField.text forKey:@"password"];
			[ObjectiveCScripts setUserDefaultValue:self.countryButton.titleLabel.text forKey:@"profileCountry"];
			[ObjectiveCScripts setUserDefaultValue:self.stateButton.titleLabel.text forKey:@"profileState"];
			[ObjectiveCScripts setUserDefaultValue:sex forKey:@"sex"];
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"" delegate:self tag:0];
		}
		[self stopWebService];

		
		
	}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)segmentClicked:(id)sender {
	[self resignResponders];
	self.rightButton.enabled=YES;
	self.updateProfileButton.enabled=YES;
	[self.sexSegment changeSegment];
}




- (IBAction) countryButtonPressed: (id) sender {
	[self resignResponders];
	self.selectedButton=1;
	SelectListVC *detailViewController = [[SelectListVC alloc] initWithNibName:@"SelectListVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Select Country";
	detailViewController.listArray=[self countriesArray];
	detailViewController.selectedValue=self.countryButton.titleLabel.text;
	detailViewController.callBackViewController	= self;
	[self.navigationController pushViewController:detailViewController animated:YES];
}
- (IBAction) stateButtonPressed: (id) sender {
	[self resignResponders];
	self.selectedButton=2;
	SelectListVC *detailViewController = [[SelectListVC alloc] initWithNibName:@"SelectListVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Select State";
	detailViewController.callBackViewController	= self;
	detailViewController.selectedValue=self.stateButton.titleLabel.text;
	detailViewController.listArray=[self statesArray];
	[self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)valueSelected:(NSString *)value {
	self.updateProfileButton.enabled=YES;
	self.rightButton.enabled=YES;
	if(self.selectedButton==1) {
		[self.countryButton setTitle:value forState:UIControlStateNormal];
		if(![value isEqualToString:@"United States"]) {
			[self.stateButton setTitle:@"-" forState:UIControlStateNormal];
			self.stateButton.enabled=NO;
		}
	}
	if(self.selectedButton==2)
		[self.stateButton setTitle:value forState:UIControlStateNormal];
}

- (IBAction) changeAvatarButtonPressed: (id) sender {
	[ObjectiveCScripts showAlertPopup:@"Upgrade!" message:@"You must be a silver member to change your avatar. Click the upgrade button below."];
}

-(void)postPhotoUpload {
	[self startWebService:@selector(mainWebService) message:nil];
}

-(void)mainWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"dir", @"image", @"smallImage", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"],
							  @"userPics",
							  [ObjectiveCScripts base64EncodeImage:self.imageLarge],
							  [ObjectiveCScripts base64EncodeImage:self.imageThumb], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/addAvatarPic.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			self.mainPic.image=self.imageLarge;
			[ObjectiveCScripts setUserDefaultValue:@"2" forKey:@"imgType"];
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"" delegate:self tag:0];
		}
		
		[self stopWebService];
	}
}

- (IBAction) upgradeButtonPressed: (id) sender {
	UpgradeVC *detailViewController = [[UpgradeVC alloc] initWithNibName:@"UpgradeVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Upgrade";
	[self.navigationController pushViewController:detailViewController animated:YES];
}


-(NSArray *)statesArray
{
	return [NSArray arrayWithObjects:@"AK", @"AL", @"AR", @"AZ", @"CA", @"CO", @"CT", @"DE", @"FL", @"GA",
			@"HI", @"IA", @"ID", @"IL", @"IN", @"KS", @"KY", @"LA", @"MA", @"MD", @"ME",
			@"MI", @"MN", @"MO", @"MS", @"MT", @"NC", @"ND", @"NE", @"NH", @"NJ", @"NM",
			@"NV", @"NY", @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX",
			@"UT", @"VA", @"VT", @"WA", @"WI", @"WV", @"WY",
			nil];
}

-(NSArray *)countriesArray
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
