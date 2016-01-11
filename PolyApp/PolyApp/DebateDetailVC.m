//
//  DebateDetailVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/31/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "DebateDetailVC.h"
#import "DebateCell.h"
#import "MultiLineDetailCellWordWrap.h"
#import "DebateCommentsVC.h"
#import "EditTextViewVC.h"

#define kSuccessAlert	1
#define kDeleteAlert	99

@interface DebateDetailVC ()

@end

@implementation DebateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.titles = [[NSMutableArray alloc] init];
	
	self.bodyTextView.text=@"";
	[self.textFieldElements addObject:self.bodyTextView];
	
	NSString *user1 = [NSString stringWithFormat:@"%@'s", self.debateObj.username1];
	NSString *user2 = @"Your";
	if(self.debateObj.user2>0)
		user2 = [NSString stringWithFormat:@"%@'s", self.debateObj.username2];

	[self.titles addObjectsFromArray:[NSArray arrayWithObjects:
									  [NSString stringWithFormat:@"%@ Opening Statements", user1],
									  [NSString stringWithFormat:@"%@ Opening Statements", user2],
									  [NSString stringWithFormat:@"%@ First Rebuttal", user1],
									  [NSString stringWithFormat:@"%@ First Rebuttal", user2],
									  [NSString stringWithFormat:@"%@ Second Rebuttal", user1],
									  [NSString stringWithFormat:@"%@ Second Rebuttal", user2],
									  [NSString stringWithFormat:@"%@ Closing Statements", user1],
									  [NSString stringWithFormat:@"%@ Closing Statements", user2],
									  nil]];
	
	[self.mainArray addObjectsFromArray:[NSArray arrayWithObjects:
									  self.debateObj.opening1,
									  self.debateObj.opening2,
									  self.debateObj.firstRebuttal1,
									  self.debateObj.firstRebuttal2,
									  self.debateObj.secondRebuttal1,
									  self.debateObj.secondRebuttal2,
									  self.debateObj.closing1,
									  self.debateObj.closing2,
									  nil]];
	
	if(self.titles.count>self.debateObj.step+1)
		self.titleLabel.text = [self.titles objectAtIndex:self.debateObj.step+1];
	
	if(self.debateObj.youVotedFlg) {
		self.voteLeftButton.enabled=NO;
		self.voteRightButton.enabled=NO;
	}
	self.alreadyVotedLabel.hidden=!self.debateObj.youVotedFlg;
	
	
	self.debateWonView.hidden=YES;
	self.editView.hidden=YES;
	self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Comments" style:UIBarButtonItemStyleBordered target:self action:@selector(commentsButtonPressed)];
	self.navigationItem.rightBarButtonItem = self.rightButton;

	self.likeFavBar = [[LikeFavBar alloc] init];
	[self.view addSubview:self.likeFavBar];
	[self.likeFavBar setupLikeFavBarButtonsForTarget:self likeSelector:@selector(likeButtonPressed) favSelector:@selector(favButtonPressed)];
	[self displayLikeFavBar];
	
	if(self.debateObj.currentUser==[ObjectiveCScripts myUserId] && [@"Active" isEqualToString:self.debateObj.status])
		self.popupView.hidden=!self.popupView.hidden;

	

}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self positionBar];
}

-(void)positionBar {
	self.user1Votes.text = [NSString stringWithFormat:@"Votes: %d", self.debateObj.user1Votes];
	self.user2Votes.text = [NSString stringWithFormat:@"Votes: %d", self.debateObj.user2Votes];
	self.commentsLabel.text = [NSString stringWithFormat:@"Comments: %d", self.debateObj.comments];
	int totalVotes = self.debateObj.user1Votes+self.debateObj.user2Votes;
	int distance = self.votesBarView.frame.size.width;
	float amount = distance/2;
	if(totalVotes>0 && distance>0)
		amount = distance*self.debateObj.user1Votes/totalVotes;
	int xPos=distance-amount;
	self.yellowCircle.center=CGPointMake(xPos, self.yellowCircle.center.y);
	self.blueView.frame=CGRectMake(0, 0, xPos, 20);
	
	self.user1Label.text = self.debateObj.username1;
	self.user2Label.text = self.debateObj.username2;
}

-(void)displayLikeFavBar {
	[self.likeFavBar displayLikeFavBarLikes:self.debateObj.likes favorites:self.debateObj.favorites youLikeFlg:self.debateObj.youLikeFlg yourFavFlg:self.debateObj.yourFavFlg];
	if(![@"Complete" isEqualToString:self.debateObj.status]) {
		self.likeFavBar.likeButton.enabled=NO;
		self.likeFavBar.favButton.enabled=NO;
		self.rightButton.enabled=NO;
	}
}

-(void)commentsButtonPressed {
	DebateCommentsVC *detailViewController = [[DebateCommentsVC alloc] initWithNibName:@"DebateCommentsVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Comments";
	detailViewController.debateObj=self.debateObj;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

-(IBAction)user1VoteButtonPressed:(id)sender {
	self.winner=self.debateObj.user1;
	[self startWebService:@selector(voteWebService) message:nil];
}

-(IBAction)user2VoteButtonPressed:(id)sender {
	self.winner=self.debateObj.user2;
	[self startWebService:@selector(voteWebService) message:nil];
}

-(void)voteWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"debate_id", @"winner", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.debateObj.debate_id],
							  [NSString stringWithFormat:@"%d", self.winner],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/debateWinner.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"" delegate:self tag:1];
		}
		
		[self stopWebService];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	
	if(indexPath.row==0) {
		DebateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if(cell==nil)
			cell = [[DebateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		
		[DebateCell populateCell:cell withObj:self.debateObj selectorLeft:@selector(userButtonClicked) selectorRight:@selector(userButton2Clicked) target:self];

		
		cell.accessoryType= UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	} else if(indexPath.row==1) {
		MultiLineDetailCellWordWrap *cell = [[MultiLineDetailCellWordWrap alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withRows:2 labelProportion:.5];
		
		cell.mainTitle=@"Debate Positions";
		cell.alternateTitle=self.debateObj.shortDate;
		NSString *user1 = [NSString stringWithFormat:@"%@'s position", self.debateObj.username1];
		NSString *user2 = @"Your position";
		if(self.debateObj.user2>0)
			user2 = [NSString stringWithFormat:@"%@'s position", self.debateObj.username2];
		
		cell.titleTextArray=[NSArray arrayWithObjects:user1, user2, nil];
		cell.fieldTextArray=[NSArray arrayWithObjects:self.debateObj.position1, self.debateObj.position2, nil];
		cell.fieldColorArray=[NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], nil];
		
		cell.accessoryType= UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;

	} else {
		MultiLineDetailCellWordWrap *cell = [[MultiLineDetailCellWordWrap alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withRows:1 labelProportion:0];
		
		NSString *text = [self.mainArray objectAtIndex:indexPath.row-2];
		if(text.length==0) {
			text=@"No statements yet";
			cell.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
		}
		cell.mainTitle=[self.titles objectAtIndex:indexPath.row-2];
		cell.titleTextArray=[NSArray arrayWithObject:@""];
		cell.fieldTextArray=[NSArray arrayWithObject:text];
		cell.fieldColorArray=[NSArray arrayWithObject:[UIColor blackColor]];
		cell.backgroundColor=(indexPath.row%2==0)?[UIColor colorWithRed:1 green:.9 blue:.9 alpha:1]:[UIColor colorWithRed:.9 green:.9 blue:1 alpha:1];
		
		cell.accessoryType= UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
}

-(void)userButtonClicked {
	NSLog(@"Here1!");
}

-(void)userButton2Clicked {
	NSLog(@"Here2!");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count+2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(self.debateObj.step==0) {
		if(self.debateObj.user1 == [ObjectiveCScripts myUserId]) {
			self.editView.hidden=!self.editView.hidden;
			return;
		}
		self.popupView.hidden=!self.popupView.hidden;
		return;
	}
	if([@"Complete" isEqualToString:self.debateObj.status]) {
		self.debateWonView.hidden=!self.debateWonView.hidden;
		return;
	}
	
	if(self.debateObj.step<=6 && self.debateObj.currentUser == [ObjectiveCScripts myUserId])
		self.popupView.hidden=!self.popupView.hidden;

}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row==0)
		return 70;
	else if(indexPath.row==1)
		return [MultiLineDetailCellWordWrap cellHeightWithNoMainTitleForData:[NSArray arrayWithObjects:self.debateObj.position1, self.debateObj.position2, nil]
																   tableView:self.mainTableView
														labelWidthProportion:.5]+20;
	else
		return [MultiLineDetailCellWordWrap cellHeightWithNoMainTitleForData:[NSArray arrayWithObject:[self.mainArray objectAtIndex:indexPath.row-2]]
																   tableView:self.mainTableView
														labelWidthProportion:0]+20;;
}

-(BOOL)verifySubmit {
	if(self.bodyTextView.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"No message!" message:@""];
		return NO;
	}
	self.popupView.hidden=YES;
	return YES;
}

-(void)mainWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"debate_id", @"message", @"editModeFlg", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.debateObj.debate_id],
							  self.bodyTextView.text,
							  (self.editModeFlg)?@"Y":@"N",
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/updateDebate.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"" delegate:self tag:kSuccessAlert];
		}
		
		[self stopWebService];
	}
}

-(void)deleteWebService
{
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"debate_id", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.debateObj.debate_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/deleteDebate.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self.mainArray removeAllObjects];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"" delegate:self tag:kSuccessAlert];
		}
		
		[self stopWebService];
	}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag==kDeleteAlert && buttonIndex!=alertView.cancelButtonIndex) {
		[self startWebService:@selector(deleteWebService) message:nil];
	}
	if(alertView.tag==kSuccessAlert)
		[self.navigationController popViewControllerAnimated:YES];
}


-(void)likeButtonPressed {
	[self startWebService:@selector(likeWebService) message:nil];
}

-(void)favButtonPressed {
	[self startWebService:@selector(favWebService) message:nil];
}

-(void)likeWebService {
	@autoreleasepool {
		if([ObjectiveCScripts chooseLikeOrFavForEntity:@"DEBATE" primaryKey:@"debate_id" row_id:self.debateObj.debate_id userField:@""]) {
			
			if(self.debateObj.youLikeFlg)
				self.debateObj.likes--;
			else
				self.debateObj.likes++;
			self.debateObj.youLikeFlg=!self.debateObj.youLikeFlg;
			[self displayLikeFavBar];
		}
		[self stopWebService];
	}
	
}

-(void)favWebService {
	@autoreleasepool {
		if([ObjectiveCScripts chooseLikeOrFavForEntity: @"DEBATE" primaryKey:@"debate_id" row_id:self.debateObj.debate_id userField:@"favDebate"]) {
			self.debateObj.yourFavFlg=YES;
			self.debateObj.favorites++;
			[self displayLikeFavBar];
		}
		
		[self stopWebService];
	}
	
}

-(IBAction)editButtonPressed:(id)sender {
	self.editView.hidden=YES;
	self.popupView.hidden=NO;
	self.editModeFlg=YES;
	self.bodyTextView.text = [self.mainArray objectAtIndex:0];
}

-(void)returningText:(NSString *)text {
	self.bodyTextView.text=text;
	[self.bodyTextView resignFirstResponder];
}


-(IBAction)deleteButtonPressed:(id)sender {
	self.editView.hidden=YES;
	[ObjectiveCScripts showConfirmationPopup:@"Delete this Debate?" message:@"" delegate:self tag:kDeleteAlert];
}



@end
