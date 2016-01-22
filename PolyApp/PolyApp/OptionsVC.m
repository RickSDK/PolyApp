//
//  OptionsVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/19/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "OptionsVC.h"
#import "ChooseNationVC.h"
#import "UpgradeVC.h"

#define kMenu1	@"Change Election Country"
#define kMenu2	@"Change Election Year"
#define kMenu3	@"Email Developer"
#define kMenu4	@"Bug Report"
#define kMenu5	@"Review App"

@interface OptionsVC ()

@end

@implementation OptionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.mainArray addObject:kMenu1];
	[self.mainArray addObject:kMenu2];
	[self.mainArray addObject:kMenu3];
	[self.mainArray addObject:kMenu4];
	[self.mainArray addObject:kMenu5];
	
	self.upgradeButton.hidden=[ObjectiveCScripts myLevel]>=2;
	
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	cell.textLabel.text=[self.mainArray objectAtIndex:indexPath.row];
	cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([kMenu1 isEqualToString:[self.mainArray objectAtIndex:indexPath.row]]) {
		ChooseNationVC *detailViewController = [[ChooseNationVC alloc] initWithNibName:@"ChooseNationVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Choose Nation";
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
	if([kMenu2 isEqualToString:[self.mainArray objectAtIndex:indexPath.row]]) {
		ChooseNationVC *detailViewController = [[ChooseNationVC alloc] initWithNibName:@"ChooseNationVC" bundle:nil];
		detailViewController.managedObjectContext = self.managedObjectContext;
		detailViewController.title = @"Choose Year";
		detailViewController.yearFlg=YES;
		[self.navigationController pushViewController:detailViewController animated:YES];
		return;
	}
	if([kMenu3 isEqualToString:[self.mainArray objectAtIndex:indexPath.row]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", @"rickmedved@hotmail.com"]]];
	}
	if([kMenu4 isEqualToString:[self.mainArray objectAtIndex:indexPath.row]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", @"rickmedved@hotmail.com"]]];
	}
	if([kMenu5 isEqualToString:[self.mainArray objectAtIndex:indexPath.row]]) {
		NSString *appId = @"1070878372";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/apple-store/id%@?mt=8", appId]]];
	}
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

- (IBAction) upgradeButtonPressed: (id) sender {
	UpgradeVC *detailViewController = [[UpgradeVC alloc] initWithNibName:@"UpgradeVC" bundle:nil];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.title = @"Upgrade!";
	[self.navigationController pushViewController:detailViewController animated:YES];
}

@end
