//
//  UserTestResultsVC.m
//  PolyApp
//
//  Created by Rick Medved on 1/13/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "UserTestResultsVC.h"
#import "CoreDataLib.h"
#import "IssueObj.h"
#import "CandidateIssueCell.h"

@interface UserTestResultsVC ()

@end

@implementation UserTestResultsVC
@synthesize userObj;

- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"self.userObj.answers %@", self.uObj.answers);
	[self loadIssuesFromDatabase];
	
	[self extendTableForGold];

}

-(void)loadIssuesFromDatabase {
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"ISSUE" predicate:nil sortColumn:@"issue_id" mOC:self.managedObjectContext ascendingFlg:YES];
	if(items.count<20) {
		[ObjectiveCScripts showAlertPopup:@"Issue error!" message:@"Code 1174"];
		[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"issueUpdLocal"];
	}
	[self.mainArray removeAllObjects];
	for(NSManagedObject *mo in items) {
		IssueObj *issueObj = [IssueObj objectFromManagedObject:mo];
		[self.mainArray addObject:issueObj];
	}
	[self.mainTableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];

	CandidateIssueCell *cell = [[CandidateIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	IssueObj *issueObj = [self.mainArray objectAtIndex:indexPath.row];
	
	NSArray *components = [self.uObj.answers componentsSeparatedByString:@":"];
	int selectedOption=0;
	if(components.count>indexPath.row)
		selectedOption = [[components objectAtIndex:indexPath.row] intValue];
	
	int otherOption = [[ObjectiveCScripts getUserDefaultValue:[NSString stringWithFormat:@"Question%d", (int)indexPath.row+1]] intValue];
	[CandidateIssueCell updateCell:cell issueObj:issueObj option:selectedOption otherOption:otherOption];
	cell.popCountLabel.text=@"";
	cell.popularityLabel.text=@"";
	
	
	if(self.showMoreFlg && self.selectedRow==indexPath.row) {
		cell.backgroundColor=[UIColor colorWithRed:1 green:1 blue:.6 alpha:1];
		cell.positionLabel.text = [NSString stringWithFormat:@"%@'s Position: %@", self.uObj.userName, cell.positionLabel.text];
	} else {
		cell.backgroundColor=[UIColor whiteColor];
	}
	
	
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
	if(self.showMoreFlg) {
		if(indexPath.row==self.selectedRow)
			self.showMoreFlg=NO;
	} else
		self.showMoreFlg=YES;
	
	self.selectedRow=(int)indexPath.row;
	[self.mainTableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(self.showMoreFlg && self.selectedRow==indexPath.row)
		return 60;
	else
		return 44;
}

@end
