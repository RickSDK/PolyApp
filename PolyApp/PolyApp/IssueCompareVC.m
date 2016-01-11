//
//  IssueCompareVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/27/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "IssueCompareVC.h"
#import "CoreDataLib.h"
#import "ObjectiveCScripts.h"
#import "CandidateObj.h"
#import "UIColor+ATTColor.h"

@interface IssueCompareVC ()

@end

@implementation IssueCompareVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.candidates = [[NSMutableArray alloc] init];
	self.images = [[NSMutableArray alloc] init];
	self.labels = [[NSMutableArray alloc] init];
	
	[self setTitle:@"The Issues"];
	self.issue_id=self.issueObj.issue_id-1;
	if(self.issue_id<0)
		self.issue_id=0;
	
	[self loadIssueObject];
	[self loadCandidates];
	[self placeCandidatesWrapper];
}

-(void)loadIssueObject {
	[self checkButtons];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"issue_id = %d", self.issue_id+1];
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"ISSUE" predicate:predicate sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
	for(NSManagedObject *mo in items) {
		IssueObj *issueObj = [IssueObj objectFromManagedObject:mo];
		self.issueObj = issueObj;
	}
	self.nameLabel.text = self.issueObj.name;
	self.option1Label.text = self.issueObj.option1;
	self.option2Label.text = self.issueObj.option2;
	self.option3Label.text = self.issueObj.option3;
	if(self.issue_id<10) {
		self.option1Label.text = self.issueObj.option3; // keep libs on left
		self.option3Label.text = self.issueObj.option1;
	}
	
	int answer = [[ObjectiveCScripts getUserDefaultValue:[NSString stringWithFormat:@"Question%d", self.issue_id+1]] intValue];
	
	answer = [self keepLibsOnLeft:answer];

	
	if(answer==1)
		self.myCheckBox.center=CGPointMake(100, 35);
	if(answer==2)
		self.myCheckBox.center=CGPointMake([ObjectiveCScripts screenWidth]/2, 35);
	if(answer==3)
		self.myCheckBox.center=CGPointMake([ObjectiveCScripts screenWidth]-85, 35);

}

-(void)moveCandidates {
	int i=0;
	for(CandidateObj *candidateObj in self.candidates) {
		UIImageView *image = [self.images objectAtIndex:i];
		image.center = CGPointMake(candidateObj.xCord1, candidateObj.yCord1);
		UILabel *label = [self.labels objectAtIndex:i];
		label.center = CGPointMake(candidateObj.xCord1, candidateObj.yCord1+20);
		image.hidden=candidateObj.hidden;
		label.hidden=candidateObj.hidden;
		i++;
	}
	self.movementStep=0;
	[self performSelectorInBackground:@selector(candidatesInMotion) withObject:nil];
}

-(void)candidatesInMotion {
	@autoreleasepool {
		[NSThread sleepForTimeInterval:.01];
		self.movementStep+=5;
		if(self.movementStep>100)
			self.movementStep=100;
		int i=0;
		for(CandidateObj *candidateObj in self.candidates) {
			UIImageView *image = [self.images objectAtIndex:i];
			float x = (candidateObj.xCord1*(100-self.movementStep)/100) + (candidateObj.xCord2*self.movementStep/100);
			float y = (candidateObj.yCord1*(100-self.movementStep)/100) + (candidateObj.yCord2*self.movementStep/100);
			image.center = CGPointMake(x, y);
			UILabel *label = [self.labels objectAtIndex:i];
			label.center = CGPointMake(x, y+20);
			i++;
		}
		if(self.movementStep<100)
			[self performSelectorInBackground:@selector(candidatesInMotion) withObject:nil];
		else {
			for(CandidateObj *candidateObj in self.candidates) {
				candidateObj.xCord1=candidateObj.xCord2;
				candidateObj.yCord1=candidateObj.yCord2;
			}
		}
	}
	
}

-(void)loadCandidates {
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"CANDIDATE" predicate:nil sortColumn:nil mOC:self.managedObjectContext ascendingFlg:NO];
	for(NSManagedObject *mo in items) {
		CandidateObj *candidateObj = [CandidateObj objectFromManagedObject:mo];
		[self.candidates addObject:candidateObj];
		
		UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
		image.image = [ObjectiveCScripts cachedImageForRowId:candidateObj.candidate_id type:1 dir:@"pics" forceRecache:NO];
		image.layer.cornerRadius = 4;
		image.layer.masksToBounds = YES;				// clips background images to rounded corners
		image.layer.borderColor = [UIColor blackColor].CGColor;
		image.layer.borderWidth = 1.;

		[self.bgView addSubview:image];
		[self.images addObject:image];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,40,12)];
		label.font = [UIFont boldSystemFontOfSize:10];
		label.adjustsFontSizeToFitWidth = YES;
		label.minimumScaleFactor = .7;
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = [ObjectiveCScripts nameColorOfNumber:candidateObj.color];
		label.backgroundColor = [ObjectiveCScripts colorOfNumber:candidateObj.color];
		label.text=candidateObj.lastName;
		label.layer.cornerRadius = 4;
		label.layer.masksToBounds = YES;				// clips background images to rounded corners
		label.layer.borderColor = [UIColor blackColor].CGColor;
		label.layer.borderWidth = 1.;
		[self.bgView addSubview:label];
		[self.labels addObject:label];
		
	}
}
-(void)placeCandidatesWrapper {
	self.shift1Flg=NO;
	self.shift2Flg=NO;
	self.shift3Flg=NO;
	[self placeCandidates];
	if(self.shift1Flg || self.shift2Flg || self.shift3Flg)
		[self placeCandidates];
	[self moveCandidates];
}

-(int)keepLibsOnLeft:(int)answer {
	if(answer==1 && self.issue_id<10) // keep liberals on the left
		answer=3;
	else if (answer==3 && self.issue_id<10)
		answer=1;
	return answer;
}

-(void)placeCandidates {
	int topY = 100;
	int botY=[ObjectiveCScripts screenHeight]-topY-60;
	float screenWidth = [ObjectiveCScripts screenWidth];
	
	int yStart=topY+50;
	int y1=topY;
	int y2=topY;
	int y3=topY;
	int x1=(self.shift1Flg)?38:58;
	int x2=(self.shift2Flg)?screenWidth/2-22:screenWidth/2+3;
	int x3=(self.shift3Flg)?screenWidth-83:screenWidth-50;
	int x=0;
	int y=0;
	
	int i=0;
	
	for(CandidateObj *candidateObj in self.candidates) {
		NSArray *answers = [candidateObj.answers componentsSeparatedByString:@":"];
		int answer = [[answers objectAtIndex:self.issue_id] intValue];
		
		candidateObj.hidden=YES;
		if(answer==0)
			continue;
		candidateObj.hidden=NO;
		
		answer = [self keepLibsOnLeft:answer];
		
		if(answer==1) {
			y1+=50;
			if(y1>botY) {
				self.shift1Flg=YES;
				y1=yStart;
				x1+=45;
			}
			x=x1;
			y=y1;
		}
		if(answer==2) {
			y2+=50;
			if(y2>botY) {
				self.shift2Flg=YES;
				y2=yStart;
				x2+=45;
			}
			x=x2;
			y=y2;
		}
		if(answer==3) {
			y3+=50;
			if(y3>botY) {
				self.shift3Flg=YES;
				y3=yStart;
				x3+=45;
			}
			x=x3;
			y=y3;
		}
		candidateObj.xCord2=x;
		candidateObj.yCord2=y;
		i++;
		
	}

}

-(void)checkButtons {
	self.nextButton.enabled=self.issue_id<19;
	self.prevButton.enabled=self.issue_id>0;
}

- (IBAction) nextButtonPressed: (id) sender {
	self.issue_id++;
	if(self.issue_id>=20)
		self.issue_id=0;
	[self loadIssueObject];
	[self placeCandidatesWrapper];
}
- (IBAction) prevButtonPressed: (id) sender {
	self.issue_id--;
	if(self.issue_id<0)
		self.issue_id=19;
	[self loadIssueObject];
	[self placeCandidatesWrapper];
}

@end
