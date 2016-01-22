//
//  TemplateVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "TemplateVC.h"
#import "EditTextViewVC.h"

@interface TemplateVC ()

@end

@implementation TemplateVC

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if([self respondsToSelector:@selector(edgesForExtendedLayout)])
		[self setEdgesForExtendedLayout:UIRectEdgeBottom];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.webServiceElements = [[NSMutableArray alloc] init];
	self.textFieldElements = [[NSMutableArray alloc] init];
	self.mainArray = [[NSMutableArray alloc] init];
	self.textViewTitle = [NSString new];
	self.userObj = [UserObj new];

	self.responseString = [[NSMutableString alloc] init];

	self.maxLength=25;
	self.popupView.hidden=YES;
	
	if([ObjectiveCScripts myLevel]!=2) {
		self.adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
		self.adView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height-89);
		[self.view addSubview:self.adView];
		self.adView.delegate=self;
	}
	
	self.webServiceView = [[WebServiceView alloc] initWithFrame:CGRectMake(36, 203, 257, 178)];
	[self.view addSubview:self.webServiceView];
	[ObjectiveCScripts applyBackgroundForCountry:[ObjectiveCScripts getUserDefaultValue:@"Country"] view:self.view];
	
	self.largeImageSize=300;
	

	
}

-(void)extendTableForGold {
	if([ObjectiveCScripts myLevel]==2)
		self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height+50);
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
	NSLog(@"textViewDidBeginEditing");
	[textView resignFirstResponder];
	EditTextViewVC *detailViewController = [[EditTextViewVC alloc] initWithNibName:@"EditTextViewVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.titleText = self.textViewTitle;
	detailViewController.startingText = textView.text;
	detailViewController.callBackViewController=self;
	[self.navigationController pushViewController:detailViewController animated:YES];
}


-(void)returningText:(NSString *)text {
	self.mainTextView.text=text;
	[self.mainTextView resignFirstResponder];
}

-(void)startWebService:(SEL)aSelector message:(NSString *)message {
	for(UIControl *button in self.webServiceElements)
		button.enabled=NO;
	[self resignResponders];
	
	[self.webServiceView startWithTitle:message];
	[self performSelectorInBackground:aSelector withObject:nil];
}

-(void)stopWebService {
	for(UIControl *button in self.webServiceElements)
		button.enabled=YES;
	[self.webServiceView stop];
}

-(void)resignResponders {
	for(UIControl *textField in self.textFieldElements)
		[textField resignFirstResponder];
}

- (IBAction) xButtonPressed: (id) sender {
	self.popupView.hidden=YES;
	[self resignResponders];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	self.adView.alpha=0;
//	NSLog(@"no");
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
//	NSLog(@"yes");
	self.adView.alpha=1;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	[self cancelAds];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:YES];
	[self cancelAds];
}

-(void)cancelAds {
	[self.adView cancelBannerViewAction];
	self.adView=nil;
	self.adView.alpha=0;
}

- (IBAction) submitButtonPressed: (id) sender {
	if([self verifySubmit])
		[self startWebService:@selector(mainWebService) message:nil];
}

-(BOOL)verifySubmit {
	return YES;
}

-(void)mainWebService {
	@autoreleasepool {
		[NSThread sleepForTimeInterval:1];
		[self stopWebService];
	}
	
}


-(BOOL)textField:(UITextField *)textFieldlocal shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return [ObjectiveCScripts handleTextField:textFieldlocal.text string:string max:self.maxLength];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	return [ObjectiveCScripts handleTextField:textView.text string:text max:500];
}

- (IBAction) uploadPhotoButtonPressed: (id) sender {
	[self showPhotoActionSheet];
}

-(void)showPhotoActionSheet {
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
	
	self.imageLarge = [ObjectiveCScripts resizeImage:image size:CGSizeMake(self.largeImageSize, self.largeImageSize)];
	self.imageThumb = [ObjectiveCScripts resizeImage:image size:CGSizeMake(60, 60)];
	self.mainPic.image=self.imageLarge;
	[self dismissViewControllerAnimated:YES completion:nil];
	NSLog(@"Pic captured %f height!!!! (%f)", self.imageLarge.size.height, self.imageThumb.size.height);
	[self postPhotoUpload];
	
}

-(void)postPhotoUpload {
	
}

- (IBAction) sortSegmentChanged: (id) sender {
	NSLog(@"sortSegmentChanged");
	[self.sortSegment changeSegment];
	[self startWebService:@selector(loadDataWebService) message:nil];
}

-(void)loadDataWebService {
	@autoreleasepool {
		[NSThread sleepForTimeInterval:1];
		[self stopWebService];
	}
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"+++didReceiveResponse");
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"+++didFailWithError");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[self.responseString appendString:response];
	NSLog(@"+++didReceiveData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if(self.responseString.length>0) {
		NSLog(@"+++response: %@", self.responseString);
	}
}






@end
