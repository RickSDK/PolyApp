//
//  ChooseAvatarVC.m
//  PolyApp
//
//  Created by Rick Medved on 1/13/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "ChooseAvatarVC.h"
#import "ProfileVC.h"

#define numCols	5

@interface ChooseAvatarVC ()

@end

@implementation ChooseAvatarVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.userAvatars = [NSMutableArray new];
	self.candidateAvatars = [NSMutableArray new];

	[self.mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];

	self.chooseButton.enabled=NO;
	
	[self startWebService:@selector(mainWebService) message:nil];
}

-(void)mainWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getAvatars.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self stopWebService];
		NSLog(@"+++%@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			if(lines.count>2) {
				[self.candidateAvatars addObjectsFromArray:[[lines objectAtIndex:1] componentsSeparatedByString:@"|"]];
				[self.userAvatars addObjectsFromArray:[[lines objectAtIndex:2] componentsSeparatedByString:@"|"]];
				self.mainArray=self.userAvatars;
				[self.mainCollectionView reloadData];
			}
		}
		
	}
	
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return ceil((float)self.mainArray.count/numCols);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	return numCols;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
	UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	
	UIImageView *bg = [[UIImageView alloc] initWithImage:[self imageForIndexPath:indexPath thumbFlg:YES]];
	cell.backgroundView = bg;
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	self.chooseButton.enabled=YES;
	self.mainPic.image = [self imageForIndexPath:indexPath thumbFlg:NO];
}

-(UIImage *)imageForIndexPath:(NSIndexPath *)indexPath thumbFlg:(BOOL)thumbFlg {
	int number = (int)indexPath.row+(int)indexPath.section*numCols;
	self.selectedNum = 0;
	if(number<self.mainArray.count)
		self.selectedNum = [[self.mainArray objectAtIndex:number] intValue];
	if(self.selectedNum==0) {
		self.chooseButton.enabled=NO;
		return nil;
	} else
		return [ObjectiveCScripts cachedImageForRowId:self.selectedNum type:thumbFlg dir:[self imgDir] forceRecache:NO];
}

- (IBAction) uploadNewButtonPressed: (id) sender {
	if([ObjectiveCScripts myLevel]<2)
		[ObjectiveCScripts showAlertPopup:@"Notice!" message:@"Only Gold Members can upload their own avatars. Please upgrade on the previous screen."];
	else
		[self showPhotoActionSheet];

}

-(void)postPhotoUpload {
	[self startWebService:@selector(uploadPhotoWebService) message:@"Uploading"];
}

-(void)uploadPhotoWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"image", @"smallImage", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts base64EncodeImage:self.imageLarge],
							  [ObjectiveCScripts base64EncodeImage:self.imageThumb],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/uploadAvatar.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self stopWebService];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			if(lines.count>1) {
				int imgNum = [[lines objectAtIndex:1] intValue];
				[ObjectiveCScripts setUserDefaultValue:@"avatars" forKey:@"imgDir"];
				[ObjectiveCScripts setUserDefaultValue:[NSString stringWithFormat:@"%d", imgNum] forKey:@"imgNum"];
				[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"Note, some times the new image will not show up for several minutes." delegate:self tag:0];
			}
		}
		
	}
	
}

- (IBAction) chooseButtonPressed: (id) sender {
	[ObjectiveCScripts setUserDefaultValue:[self imgDir] forKey:@"imgDir"];
	[ObjectiveCScripts setUserDefaultValue:[NSString stringWithFormat:@"%d", self.selectedNum] forKey:@"imgNum"];
	[self performSelectorInBackground:@selector(backgroundWebService) withObject:nil];
	[(ProfileVC *)self.callBackViewController drawMainPic:self.mainPic.image];
	[self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)imgDir {
	return (self.sortSegment.selectedSegmentIndex==0)?@"avatars":@"pics";
}

-(void)backgroundWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username",@"imgDir", @"imgNum", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [self imgDir],
							  [NSString stringWithFormat:@"%d", self.selectedNum],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/changeAvatar.php";
		[ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
	}
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[(ProfileVC *)self.callBackViewController drawMainPic:self.imageLarge];
	[self.navigationController popViewControllerAnimated:YES];
}



- (IBAction) segmentChanged: (id) sender {
	[self.sortSegment changeSegment];
	if(self.sortSegment.selectedSegmentIndex==0)
		self.mainArray=self.userAvatars;
	else
		self.mainArray=self.candidateAvatars;

	[self.mainCollectionView reloadData];
}



@end
