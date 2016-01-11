//
//  ForumPostVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/30/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "ForumPostVC.h"
#import "ForumObj.h"
#import "MultiLineDetailCellWordWrap.h"

@interface ForumPostVC ()

@end

@implementation ForumPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.titleLabel.text = self.topicObj.title;

	
	self.replyView.hidden=YES;
	self.categoryLabel.text = self.categoryObj.name;
	self.userObj = [UserObj new];

	[self startWebService:@selector(loadDataWebService) message:@"Loading"];

}

-(void)loadDataWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"year", @"post_id", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [ObjectiveCScripts getUserDefaultValue:@"Year"],
							  [NSString stringWithFormat:@"%d", self.topicObj.row_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getForumTopics.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++getForumTopics.php: %@", responseStr);
		NSString *systemTimeStamp=@"";
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7) {
					if(line.length<=20)
						systemTimeStamp=line;
					ForumObj *forumObj = [ForumObj postObjectFromLine:line];
					if(forumObj.row_id>0)
						[self.mainArray addObject:forumObj];
				}
		}
		if(self.mainArray.count>0)
			self.forumObj = [self.mainArray objectAtIndex:0];

		[ObjectiveCScripts setDateStringForForum:self.topicObj.row_id type:@"Post" systemTimeStamp:systemTimeStamp];
		[self stopWebService];
		[self.mainTableView reloadData];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	
	MultiLineDetailCellWordWrap *cell = [[MultiLineDetailCellWordWrap alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withRows:1 labelProportion:0];
	
	ForumObj *forumObj = [self.mainArray objectAtIndex:indexPath.row];
	cell.mainTitle=forumObj.name;
	cell.alternateTitle=forumObj.fullDate;
	cell.titleTextArray=[NSArray arrayWithObject:@""];
	cell.fieldTextArray=[NSArray arrayWithObject:forumObj.body];
	cell.fieldColorArray=[NSArray arrayWithObject:[UIColor blackColor]];
	
	cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	cell.accessoryType= UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
	//override
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.replyView.hidden=YES;
	self.editModeFlg=NO;
	self.forumObj = [self.mainArray objectAtIndex:indexPath.row];
	self.editButton.hidden=self.forumObj.user_id!=[ObjectiveCScripts myUserId];
	self.dateLabel.hidden=self.forumObj.user_id==[ObjectiveCScripts myUserId];
	self.userObj.user_id=self.forumObj.user_id;
	self.bodyTextView.text=self.forumObj.body;
	self.dateLabel.text=self.forumObj.mostRecentDate;
	self.voteDownButton.enabled=!self.forumObj.votedFlg;
	self.voteUpButton.enabled=!self.forumObj.votedFlg;
	self.alreadyVotedLabel.hidden=!self.forumObj.votedFlg;
	self.votesUpLabel.text = [NSString stringWithFormat:@"%d", self.forumObj.votesUp];
	self.votesDownLabel.text = [NSString stringWithFormat:@"%d", self.forumObj.votesDown];
	
	[ObjectiveCScripts showUserButton:self.userButton selector:@selector(userButtonClicked) dir:self.forumObj.imgDir number:self.forumObj.imgNum name:self.forumObj.name label:self.usernameLabel tarrget:self];

	self.popupView.hidden=NO;
}

-(void)userButtonClicked {
	[UserObj showUserDetailsForUser:self.userObj context:self.managedObjectContext navCtrl:self.navigationController];
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	ForumObj *forumObj = [self.mainArray objectAtIndex:indexPath.row];
	if(forumObj.body.length==0)
		return 60;
	else
		return [MultiLineDetailCellWordWrap cellHeightWithNoMainTitleForData:[NSArray arrayWithObject:forumObj.body]
															   tableView:self.mainTableView
													labelWidthProportion:0]+20;
}

- (IBAction) mainMenuButtonPressed: (id) sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
	
}
- (IBAction) forumButtonPressed: (id) sender {
	[self.navigationController popToViewController:self.forumVC animated:YES];
}

- (IBAction) replyButtonPressed: (id) sender {
	self.popupView.hidden=YES;
	self.replyView.hidden=NO;
	self.replyTextView.text=@"";
	self.topReplyButton.enabled=NO;
	[self.replyTextView becomeFirstResponder];
}

- (IBAction) voteUpButtonPressed: (id) sender {
	self.voteType=1;
	[self startWebService:@selector(voteWebService) message:nil];
}
- (IBAction) voteDownButtonPressed: (id) sender {
	self.voteType=2;
	[self startWebService:@selector(voteWebService) message:nil];
}

- (IBAction) cancelButtonPressed: (id) sender {
	self.topReplyButton.enabled=YES;
	self.replyView.hidden=YES;
}

-(void)voteWebService {
	@autoreleasepool {
		self.popupView.hidden=YES;
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"post_id", @"direction", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.forumObj.row_id],
							  (self.voteType==1)?@"U":@"D",
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/forumVote.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[self loadDataWebService];
		} else
			[self stopWebService];
	}
	
}


-(BOOL)verifySubmit {
	if(self.replyTextView.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"No message!" message:@""];
		return NO;
	}
	[self.replyTextView resignFirstResponder];
	self.replyView.hidden=YES;
	
	return YES;
}

-(void)mainWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"category_id", @"topic_id", @"parent_id", @"body", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [NSString stringWithFormat:@"%d", self.categoryObj.row_id],
							  [NSString stringWithFormat:@"%d", self.topicObj.row_id],
							  [NSString stringWithFormat:@"%d", self.forumObj.row_id],
							  self.replyTextView.text,
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/addForumPost.php";
		if(self.editModeFlg)
			webAddr = @"http://www.appdigity.com/poly/editForumPost.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"+++%@", responseStr);
		[self stopWebService];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[self startWebService:@selector(loadDataWebService) message:@"Loading"];
		}
	}
	
}

- (IBAction) editButtonPressed: (id) sender {
	self.replyView.hidden=NO;
	self.popupView.hidden=YES;
	self.replyTextView.text=self.forumObj.body;
	self.editModeFlg=YES;
}





@end
