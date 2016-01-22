//
//  ChartsVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "ChartsVC.h"
#import "GraphLib.h"
#import "GraphObject.h"
#import "MultiLineDetailCellWordWrap.h"

@interface ChartsVC ()

@end

@implementation ChartsVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self calculateStats];
	
	self.candidateImageArray = [NSMutableArray new];
	self.allVotersArray = [NSMutableArray new];
	self.maleVotersArray = [NSMutableArray new];
	self.femaleVotersArray = [NSMutableArray new];
	
	[self.candidateImageArray addObject:self.candidate1ImageView];
	[self.candidateImageArray addObject:self.candidate2ImageView];
	[self.candidateImageArray addObject:self.candidate3ImageView];
	[self.candidateImageArray addObject:self.candidate4ImageView];
	[self.candidateImageArray addObject:self.candidate5ImageView];
	[self.candidateImageArray addObject:self.candidate6ImageView];
	[self.candidateImageArray addObject:self.candidate7ImageView];
	[self.candidateImageArray addObject:self.candidate8ImageView];
	
	[self startWebService:@selector(mainWebService) message:nil];
	[self clearImages];
	[ObjectiveCScripts updateFlagForNumber:8 toString:@""];

    // Do any additional setup after loading the view from its nib.
}

-(void)clearImages {
	for(UIImageView *view in self.candidateImageArray)
		view.hidden=YES;
}

-(void)mainWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", nil];
		NSArray *valueList = [NSArray arrayWithObjects:[ObjectiveCScripts getUserDefaultValue:@"userName"], nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getCharts.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"getCharts.php: %@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines) {
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					if(components.count>3) {
						int user_id = [[components objectAtIndex:0] intValue];
						NSString *name = [components objectAtIndex:1];
						int votes = [[components objectAtIndex:2] intValue];
						int femaleVotes = [[components objectAtIndex:3] intValue];
						float maleVotes = votes-femaleVotes;
						if(votes>self.maxVotes)
							self.maxVotes=votes;
						if(femaleVotes>self.maxFVotes)
							self.maxFVotes=femaleVotes;
						if(maleVotes>self.maxMVotes)
							self.maxMVotes=maleVotes;
						NSArray *names = [name componentsSeparatedByString:@" "];
						if(names.count>0)
							name = [names objectAtIndex:names.count-1];

						GraphObject *allVoters = [GraphObject graphObjectWithName:name amount:votes rowId:user_id reverseColorFlg:NO currentMonthFlg:NO];
						GraphObject *maleVoters = [GraphObject graphObjectWithName:name amount:maleVotes rowId:user_id reverseColorFlg:NO currentMonthFlg:NO];
						GraphObject *femaleVoters = [GraphObject graphObjectWithName:name amount:femaleVotes rowId:user_id reverseColorFlg:NO currentMonthFlg:NO];
						[self.allVotersArray addObject:allVoters];
						if(maleVoters>0)
							[self.maleVotersArray addObject:maleVoters];
						if(femaleVotes>0)
							[self.femaleVotersArray addObject:femaleVoters];
					}
				}
			}
		}

		[self doGraph];
		[self stopWebService];
	}
}

-(void)calculateStats {
}

-(void)doGraph {
	[self clearImages];
//	[self.mainArray removeAllObjects];
	if(self.sexSegment.selectedSegmentIndex==0)
		self.mainArray=self.allVotersArray;
	if(self.sexSegment.selectedSegmentIndex==1)
		self.mainArray=self.maleVotersArray;
	if(self.sexSegment.selectedSegmentIndex==2)
		self.mainArray=self.femaleVotersArray;
	
	if(self.sortSegment.selectedSegmentIndex==0) {
		self.mainPic.image = [GraphLib graphBarsWithItems:self.mainArray];
		[self positionImages];
	} else
		self.mainPic.image = [GraphLib pieChartWithItems:self.mainArray startDegree:self.startDegree];
	[self.mainTableView reloadData];
}

-(void)positionImages {
	int max=self.maxVotes;
	if(self.sexSegment.selectedSegmentIndex==1)
		max=self.maxMVotes;
	if(self.sexSegment.selectedSegmentIndex==2)
		max=self.maxFVotes;
	
	if(max==0)
		return;
	
	int totalWidth = [ObjectiveCScripts screenWidth];
	int bottomEdgeOfChart=190;
	float yMultiplier = (float)(self.mainPic.frame.size.height)/max;

	float leftEdgeOfChart=totalWidth/12.8;
	int i=0;
	int imgCount = (int)self.mainArray.count;
	if(imgCount==0 || imgCount>self.candidateImageArray.count)
		return;
	float spacing = totalWidth/(imgCount+1);
	if(imgCount<5)
		leftEdgeOfChart+=100/imgCount;
	
	float imgWidth = 280/(imgCount);
	if(totalWidth==320)
		leftEdgeOfChart-=imgWidth/6;

	if(imgWidth>60)
		imgWidth=60;
	for(GraphObject *obj in self.mainArray) {
		
		int top = bottomEdgeOfChart - (obj.amount *yMultiplier) + imgWidth/2;
		if(top<60)
			top=60;
		if(top>200-imgWidth/2)
			top = 200-imgWidth/2;
		UIImageView *img = [self.candidateImageArray objectAtIndex:i];
		img.image = [ObjectiveCScripts cachedCandidateImageForRowId:obj.rowId thumbFlg:YES];
		img.hidden=NO;
		img.frame = CGRectMake(leftEdgeOfChart+imgWidth/2+spacing*i, top, imgWidth, imgWidth);
		i++;
	}
}

-(IBAction)segmentChanged:(id)sender {
	[self.sortSegment changeSegment];
	[self.sexSegment changeSegment];
	[self doGraph];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	self.startTouchPosition = [touch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint newTouchPosition = [touch locationInView:self.view];
	
	if(self.sortSegment.selectedSegmentIndex==1 && CGRectContainsPoint(self.mainPic.frame, newTouchPosition)) {
		
		self.startDegree = [GraphLib spinPieChart:self.mainPic startTouchPosition:self.startTouchPosition newTouchPosition:newTouchPosition startDegree:self.startDegree barGraphObjects:self.mainArray];
		self.startTouchPosition=newTouchPosition;
		
	} 	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];

	MultiLineDetailCellWordWrap *cell = [[MultiLineDetailCellWordWrap alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withRows:self.mainArray.count labelProportion:.5];
	
	NSMutableArray *titles = [NSMutableArray new];
	NSMutableArray *values = [NSMutableArray new];
	NSMutableArray *colors = [NSMutableArray new];
	
	for(GraphObject *obj in self.mainArray) {
		[titles addObject:obj.name];
		[values addObject:[NSString stringWithFormat:@"%d", (int)round(obj.amount)]];
		[colors addObject:[UIColor blackColor]];
	}
	
	cell.titleTextArray = titles;
	cell.fieldTextArray = values;
	cell.fieldColorArray = colors;
	
	cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	cell.accessoryType= UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
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
	return self.mainArray.count*18+5;
}


@end
