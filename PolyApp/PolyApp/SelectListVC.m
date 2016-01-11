//
//  SelectListVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/19/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "SelectListVC.h"
#import "ProfileVC.h"

@interface SelectListVC ()

@end

@implementation SelectListVC
@synthesize listArray, selectedValue;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.displayArray = [[NSMutableArray alloc] initWithArray:self.listArray];
    // Do any additional setup after loading the view from its nib.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	[self.displayArray removeAllObjects];
	for(NSString *line in self.listArray)
		if([[line uppercaseString] rangeOfString:[searchText uppercaseString]].location != NSNotFound)
			[self.displayArray addObject:line];
	
	[self.mainTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	cell.textLabel.text=[self.displayArray objectAtIndex:indexPath.row];
	
	if([[self.displayArray objectAtIndex:indexPath.row] isEqualToString:self.selectedValue])
		cell.accessoryType= UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.displayArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[(ProfileVC*)self.callBackViewController valueSelected:[self.displayArray objectAtIndex:indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
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
