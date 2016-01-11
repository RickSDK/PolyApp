//
//  EditTextViewVC.m
//  PolyApp
//
//  Created by Rick Medved on 1/2/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "EditTextViewVC.h"

@interface EditTextViewVC ()

@end

@implementation EditTextViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"Enter Text"];
	
	if(self.maxChars==0)
		self.maxChars=500;
	
	self.maxLength=self.maxChars;
	
	self.bodyTextView.text=self.startingText;
	self.titleLabel.text = self.titleText;
	[self showMaxCharsLabel:0];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed)];
	
	[self.bodyTextView becomeFirstResponder];
	
}

-(void)returningText:(NSString *)text {
	//dummy
}

-(void)showMaxCharsLabel:(int)charLength {
	self.charsRemainingLabel.text = [NSString stringWithFormat:@"%d chars remaining", (int)self.maxLength-(int)self.bodyTextView.text.length-charLength];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	self.changesMade=YES;
	[self showMaxCharsLabel:(text.length>0)?(int)text.length:-1];
	return [ObjectiveCScripts handleTextField:textView.text string:text max:self.maxLength];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
	NSLog(@"override");
}


-(void)cancelButtonPressed {
	if(self.changesMade)
		[ObjectiveCScripts showConfirmationPopup:@"Discard Changes?" message:@"" delegate:self tag:1];
	else
		[self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex==alertView.cancelButtonIndex)
		return;
	else
		[self.navigationController popViewControllerAnimated:YES];
}

-(void)doneButtonPressed {
	[(EditTextViewVC*)self.callBackViewController returningText:self.bodyTextView.text];
	[self.navigationController popViewControllerAnimated:YES];
}



@end
