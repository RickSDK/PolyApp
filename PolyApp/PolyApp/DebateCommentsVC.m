//
//  DebateCommentsVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/31/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "DebateCommentsVC.h"
#import "WallObj.h"
#import "WallCell.h"

@interface DebateCommentsVC ()

@end

@implementation DebateCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.textFieldElements addObject:self.messageTextView];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];

	[self startWebService:@selector(loadDataWebService) message:nil];
}

-(void)addButtonPressed {
	self.popupView.hidden=!self.popupView.hidden;
	self.messageTextView.text=@"";
}

-(BOOL)verifySubmit {
	if(self.messageTextView.text.length==0) {
		[ObjectiveCScripts showAlertPopup:@"No message!" message:@""];
		return NO;
	}
	return YES;
}

-(void)mainWebService {
	@autoreleasepool {
		self.popupView.hidden=YES;
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"debate_id", @"message", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.debateObj.debate_id],
							  self.messageTextView.text,
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/postDebateComment.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[self loadDataWebService];
		} else {
			[self stopWebService];
		}
	}
}

-(void)loadDataWebService {
	@autoreleasepool {
		[self.mainArray removeAllObjects];
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"debate_id", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [NSString stringWithFormat:@"%d", self.debateObj.debate_id],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getDebateComments.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"%@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					if(components.count>5) {
						WallObj *wallObj= [WallObj objectFromLine:line];
						[self.mainArray addObject:wallObj];
					}
				}
			[self.mainTableView reloadData];
		} else
			[ObjectiveCScripts showAlertPopup:@"Server Error" message:@"Unable to reach the server. Try again later."];
		[self stopWebService];
	}
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	WallCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[WallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	WallObj *obj = [self.mainArray objectAtIndex:indexPath.row];
	[WallCell populateCell:cell withObj:obj];
	
	cell.accessoryType= UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

@end
