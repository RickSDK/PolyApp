//
//  ChooseUserVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "ChooseUserVC.h"
#import "ObjectiveCScripts.h"

@interface ChooseUserVC ()

@end

@implementation ChooseUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.webServiceElements addObject:self.signupButton];
	[self.webServiceElements addObject:self.facebookButton];
	[self.webServiceElements addObject:self.iPoliticsButton];
	[self.webServiceElements addObject:self.userTextField];
	[self.webServiceElements addObject:self.loginButton];
	[self.webServiceElements addObject:self.loginTextField];
	[self.webServiceElements addObject:self.passwordTextField];
	
	[self.textFieldElements addObject:self.userTextField];
	[self.textFieldElements addObject:self.loginButton];
	[self.textFieldElements addObject:self.loginTextField];
	[self.textFieldElements addObject:self.passwordTextField];
	
	self.loginView.hidden=YES;
}

-(BOOL)verifySubmit {
	if(self.userTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Enter a username" message:@""];
		return NO;
	}
	return YES;
}

-(void)mainWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"code", @"username", nil];
		NSArray *valueList = [NSArray arrayWithObjects:@"123", self.userTextField.text, nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/checkUsername.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts setUserDefaultValue:self.userTextField.text forKey:@"userName"];
			[ObjectiveCScripts resetFlags];
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines) {
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					if(components.count>0) {
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:0] forKey:@"user_id"]; //<--- here!!!
					}
				}
			}
			NSLog(@"user_id: %d", [ObjectiveCScripts myUserId]);
			
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success!" message:@"" delegate:self tag:1];
		}
		[self stopWebService];
	}
}

-(void)loginWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"password", @"username", nil];
		NSArray *valueList = [NSArray arrayWithObjects:self.passwordTextField.text, self.loginTextField.text, nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/login.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines) {
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					if(components.count>23) {
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:0] forKey:@"user_id"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:1] forKey:@"userName"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:2] forKey:@"email"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:3] forKey:@"Country"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:4] forKey:@"firstName"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:5] forKey:@"lastname"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:6] forKey:@"profileState"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:7] forKey:@"profileCountry"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:8] forKey:@"sex"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:9] forKey:@"yearBorn"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:10] forKey:@"password"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:11] forKey:@"CandidateId"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:12] forKey:@"ClosestMatchId"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:13] forKey:@"conservativeMeter"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:14] forKey:@"govEcon"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:15] forKey:@"govMoral"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:16] forKey:@"ideology"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:17] forKey:@"level"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:18] forKey:@"answers"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:19] forKey:@"Year"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:20] forKey:@"ClosestMatchName"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:21] forKey:@"CandidateName"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:22] forKey:@"System"];
						[ObjectiveCScripts setUserDefaultValue:[components objectAtIndex:23] forKey:@"VoterType"];
						
						NSString *answers=[components objectAtIndex:18];
						if(answers.length>20) {
							NSArray *scores=[answers componentsSeparatedByString:@":"];
							int i=1;
							for(NSString *score in scores)
								[ObjectiveCScripts setUserDefaultValue:score forKey:[NSString stringWithFormat:@"Question%d", i++]];
							
						}
					}
				}
			}
			[ObjectiveCScripts resetFlags];
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success!" message:@"" delegate:self tag:1];
		}
		[self stopWebService];
	}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) loginPressed: (id) sender {
	if(self.loginTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Enter a login" message:@""];
		return;
	}
	if(self.passwordTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Enter a password" message:@""];
		return;
	}
	[self startWebService:@selector(loginWebService) message:@"Logging in..."];
}
- (IBAction) cancelPressed: (id) sender {
	self.loginView.hidden=YES;
}
- (IBAction) facebookPressed: (id) sender {
	[ObjectiveCScripts showAlertPopup:@"Not yet working" message:@""];
	
}
- (IBAction) iPoliticsPressed: (id) sender {
	self.loginView.hidden=NO;
}

@end
