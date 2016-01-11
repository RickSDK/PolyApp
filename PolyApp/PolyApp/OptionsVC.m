//
//  OptionsVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/19/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "OptionsVC.h"
#import "ChooseNationVC.h"

#define kMenu1	@"Change Election Country"
#define kMenu2	@"Change Election Year"
#define kMenu3	@"Email Developer"

@interface OptionsVC ()

@end

@implementation OptionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.mainArray addObject:kMenu1];
	[self.mainArray addObject:kMenu2];
	[self.mainArray addObject:kMenu3];
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
