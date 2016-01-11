//
//  AddCandidateVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/16/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "AddCandidateVC.h"
#import "PartyVC.h"
#import "ObjectiveCScripts.h"

@interface AddCandidateVC ()

@end

@implementation AddCandidateVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.partyName = [[NSString alloc] init];
	
	[self.webServiceElements addObject:self.imgButton];
	[self.webServiceElements addObject:self.submitButton];
	[self.webServiceElements addObject:self.nameTextField];
	[self.webServiceElements addObject:self.partyButton];
	
}

- (IBAction) partyButtonPressed: (id) sender {
	PartyVC *detailViewController = [[PartyVC alloc] initWithNibName:@"PartyVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Party";
	detailViewController.callbackController = self;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction) imgButtonPressed: (id) sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Photo Library" otherButtonTitles:nil, nil];
	actionSheet.tag=1;
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == [actionSheet cancelButtonIndex])
		return;

	UIImagePickerController *cameraView = [[UIImagePickerController alloc] init];
	cameraView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	cameraView.delegate = self;
	cameraView.allowsEditing=YES;
	[self presentViewController:cameraView animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Code here to work with media
	UIImage *image = info[UIImagePickerControllerEditedImage];
	if (image == nil)
		image = info[UIImagePickerControllerOriginalImage];
	
	self.candidateImage = [ObjectiveCScripts resizeImage:image size:CGSizeMake(300, 300)];
	self.candidateThumbnailImage = [ObjectiveCScripts resizeImage:image size:CGSizeMake(60, 60)];
	[self.imgButton setBackgroundImage:image forState:UIControlStateNormal];
	[self dismissViewControllerAnimated:YES completion:nil];
	NSLog(@"Pic captured %f height!!!! (%f)", self.candidateImage.size.height, self.candidateThumbnailImage.size.height);
	
}




-(BOOL)verifySubmit {
	if(self.partyName.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Error" message:@"Enter a Party Name"];
		return NO;
	}
	if(!self.candidateImage) {
		[ObjectiveCScripts showAlertPopup:@"Error" message:@"Choose a Candidate's image"];
		return NO;
	}
	if(self.nameTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"Error" message:@"Enter a Candidate's Name"];
		return NO;
	}
	return YES;
}

-(void)populatePartyField:(NSString *)line {
	NSArray *components = [line componentsSeparatedByString:@"|"];
	if(components.count>2) {
		self.partyName = [components objectAtIndex:1];
		[self.partyButton setTitle:self.partyName forState:UIControlStateNormal];
		self.partyColor = [[components objectAtIndex:2] intValue];
		self.partyButton.backgroundColor = [ObjectiveCScripts colorOfNumber:self.partyColor];
		[self.partyButton setTitleColor:[ObjectiveCScripts nameColorOfNumber:self.partyColor] forState:UIControlStateNormal];
	}
}

-(void)mainWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"name", @"year", @"party", @"color", @"image", @"smallImage", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], [ObjectiveCScripts getUserDefaultValue:@"Country"], self.nameTextField.text, [ObjectiveCScripts getUserDefaultValue:@"Year"], self.partyName, [NSString stringWithFormat:@"%d", self.partyColor], [ObjectiveCScripts base64EncodeImage:self.candidateImage], [ObjectiveCScripts base64EncodeImage:self.candidateThumbnailImage], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/addCandidate.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"" delegate:self tag:0];
			[ObjectiveCScripts updateFlagForNumber:2 toString:@"Y"];
		}
		
		[self stopWebService];
	}
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}


@end
