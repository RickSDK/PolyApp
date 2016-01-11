//
//  QuoteTestResultsVC.m
//  PolyApp
//
//  Created by Rick Medved on 1/9/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "QuoteTestResultsVC.h"
#import "QuoteResponsesCell.h"

@interface QuoteTestResultsVC ()

@end

@implementation QuoteTestResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:self.quoteTestObj.name];
	self.responsesArray = [NSMutableArray new];
	
	self.responsesArray = [NSMutableArray arrayWithArray:[self.quoteTestObj.responses componentsSeparatedByString:@"|"]];
	self.mainArray = [NSMutableArray arrayWithArray:[self.quoteTestObj.quotes componentsSeparatedByString:@"|"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	QuoteResponsesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
		cell = [[QuoteResponsesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

	cell.quoteLabel.text=[self.mainArray objectAtIndex:indexPath.row];
	NSString *response = [self.responsesArray objectAtIndex:indexPath.row];
	cell.pic.image = ([@"Y" isEqualToString:response])?[UIImage imageNamed:@"checkbox1.png"]:[UIImage imageNamed:@"checkbox0.png"];
	cell.quoteLabel.textColor = ([@"Y" isEqualToString:response])?[UIColor blackColor]:[UIColor redColor];

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
