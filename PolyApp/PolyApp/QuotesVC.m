//
//  QuotesVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/22/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "QuotesVC.h"
#import "ObjectiveCScripts.h"

@interface QuotesVC ()

@end

@implementation QuotesVC

- (void)viewDidLoad {
    [super viewDidLoad];
	UIImage *image = [ObjectiveCScripts cachedImageForRowId:self.candidateObj.candidate_id type:1 dir:@"pics" forceRecache:NO];
	if(image)
		self.mainPic.image = image;
	
	[self.textFieldElements addObject:self.quoteTextField];
	[self.textFieldElements addObject:self.yearTextField];
	
	self.nameLabel.text = self.candidateObj.name;
	self.issueLabel.text = self.issueObj.name;
	self.issueBlurbLabel.text = [NSString stringWithFormat:@"Enter a quote or policy position for this candidate on the issue of %@.", self.issueObj.name];
	
	self.maxLength=200;
	
	if(self.quoteObj) {
		self.quoteTextField.text=self.quoteObj.quote;
		self.sourceTextField.text=self.quoteObj.source;
		self.yearTextField.text=self.quoteObj.year;
	}
	[self extendTableForGold];
	
}

-(BOOL)verifySubmit {
	[self.quoteTextField resignFirstResponder];
	[self.yearTextField resignFirstResponder];
	if(self.quoteTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Quote field is blank" message:@""];
		return NO;
	}
	if(self.yearTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Year field is blank" message:@""];
		return NO;
	}
	return YES;
}

-(void)mainWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"candidate_id", @"issue_id", @"quote", @"year", @"quote_id", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.candidateObj.candidate_id],
							  [NSString stringWithFormat:@"%d", self.issueObj.issue_id],
							  self.quoteTextField.text,
							  self.yearTextField.text,
							  [NSString stringWithFormat:@"%d", self.quoteObj.quote_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/addQuote.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts setUserDefaultValue:@"Y" forKey:@"forceQuoteUpdate"];
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Quote Added" message:@"" delegate:self tag:0];
		}
		[self stopWebService];
	}
	
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}





@end
