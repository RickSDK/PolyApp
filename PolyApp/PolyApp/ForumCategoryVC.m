//
//  ForumCategoryVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "ForumCategoryVC.h"
#import "ForumPostVC.h"
#import "ForumTopicCell.h"

@interface ForumCategoryVC ()

@end

@implementation ForumCategoryVC

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self startWebService:@selector(loadDataWebService) message:@"Loading"];
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	self.forumTitle.text = self.forumObj.name;

	
	self.userObj = [UserObj new];
	
	self.createTopicView.hidden=YES;
	self.maxLength=40;
	self.textViewTitle = @"Message Body";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];

}

-(void)loadDataWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", @"category_id", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [ObjectiveCScripts getUserDefaultValue:@"Year"],
							  [NSString stringWithFormat:@"%d", self.forumObj.row_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getForumTopics.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSString *systemTimeStamp = @"";
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7) {
					if(line.length<=20)
						systemTimeStamp = line;
					ForumObj *forumObj = [ForumObj postObjectFromLine:line];
					if(forumObj.title.length>0)
						[self.mainArray addObject:forumObj];
				}
		}
		[ObjectiveCScripts setDateStringForForum:self.forumObj.row_id type:@"Cat" systemTimeStamp:systemTimeStamp];

		
		[self stopWebService];
		[self.mainTableView reloadData];
	}
}


-(void)addButtonPressed {
	self.createTopicView.hidden=!self.createTopicView.hidden;
	[self.titleTextField resignFirstResponder];
	[self.mainTextView resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	ForumTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[ForumTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	ForumObj *forumObj = [self.mainArray objectAtIndex:indexPath.row];
	cell.topicLabel.text = forumObj.title;
	cell.bodyLabel.text = forumObj.body;
	cell.mostRecentLabel.text = forumObj.mostRecentDate;
	cell.replyByLabel.text = forumObj.mostRecentName;
	cell.repliesLabel.text = [NSString stringWithFormat:@"%d", forumObj.replies];
	
	[ObjectiveCScripts showUserButton:cell.userButton selector:@selector(userSelected:) dir:forumObj.imgDir number:forumObj.imgNum name:forumObj.name label:cell.userNameLabel tarrget:self];
	cell.userButton.tag=indexPath.row;
	
	cell.updatesPic.hidden=![ObjectiveCScripts newPostsForRowID:forumObj.row_id lastPost:forumObj.fullDate type:@"Post"];

	cell.backgroundColor=(indexPath.row%2==0)?[UIColor whiteColor]:[UIColor colorWithWhite:.8 alpha:1];
	cell.accessoryType= UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	return cell;
}


-(void)userSelected:(UIButton *)button {
	ForumObj *forumObj = [self.mainArray objectAtIndex:button.tag];
	self.userObj.user_id = forumObj.user_id;
	[UserObj showUserDetailsForUser:self.userObj context:self.managedObjectContext navCtrl:self.navigationController];
}
	 
	 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ForumPostVC *detailViewController = [[ForumPostVC alloc] initWithNibName:@"ForumPostVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Forum Post";
	detailViewController.categoryObj=self.forumObj;
	detailViewController.forumVC=self.forumVC;
	detailViewController.topicObj = [self.mainArray objectAtIndex:indexPath.row];
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
	return 60;
}

- (IBAction) cancelButtonPressed: (id) sender {
	[self.titleTextField resignFirstResponder];
	[self.mainTextView resignFirstResponder];
	self.createTopicView.hidden=YES;
}

-(BOOL)verifySubmit {
	if(self.titleTextField.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"No title!" message:@""];
		return NO;
	}
	if(self.mainTextView.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"No body!" message:@""];
		return NO;
	}
	[self.titleTextField resignFirstResponder];
	[self.mainTextView resignFirstResponder];

	return YES;
}

-(void)mainWebService {
	@autoreleasepool {
		self.createTopicView.hidden=YES;
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", @"category_id", @"title", @"body", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [ObjectiveCScripts getUserDefaultValue:@"Year"],
							  [NSString stringWithFormat:@"%d", self.forumObj.row_id],
							  self.titleTextField.text,
							  self.mainTextView.text,
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/addForumPost.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		[self stopWebService];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[self startWebService:@selector(loadDataWebService) message:@"Loading"];
		}
	}
	
}



@end
