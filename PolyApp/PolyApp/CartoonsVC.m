//
//  CartoonsVC.m
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import "CartoonsVC.h"
#import "CartoonCell.h"
#import "ObjectiveCScripts.h"
#import "CartoonObj.h"

@interface CartoonsVC ()

@end

@implementation CartoonsVC

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if(self.favoriteCartoon>0) {
		[self blowupPic:self.favoriteCartoon];
		self.xButton.hidden=YES;
	} else
		[self loadFromScratch];
}

-(void)loadFromScratch {
	self.xButton.hidden=YES;
	self.mainPic.hidden=YES;
	self.mainTableView.hidden=YES;
	self.allowMoreFlg=YES;
	[self.mainArray removeAllObjects];
	self.skipNumber=0;
	[self startWebService:@selector(loadDataWebService) message:@"Loading"];
}

- (IBAction) sortSegmentChanged: (id) sender {
	[self loadFromScratch];
}


-(void)loadDataWebService
{
	@autoreleasepool {
		NSLog(@"+++loadDataWebService");
		if(!self.allowMoreFlg)
			return;
		self.allowMoreFlg=NO;
		NSLog(@"+++loadDataWebService yes");
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"orderBy", @"skipNumber", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  (self.sortSegment.selectedSegmentIndex==0)?@"popularity":@"created",
							  [NSString stringWithFormat:@"%d", self.skipNumber],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/getCartoons.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		NSLog(@"%@", responseStr);
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			NSArray *lines = [responseStr componentsSeparatedByString:@"<br>"];
			for(NSString *line in lines)
				if(line.length>7) {
					NSArray *components = [line componentsSeparatedByString:@"|"];
					if(components.count>5) {
						CartoonObj *cartoonObj = [CartoonObj new];
						cartoonObj.cartoon_id = [[components objectAtIndex:0] intValue];
						cartoonObj.createdBy = [[components objectAtIndex:1] intValue];
						cartoonObj.likes = [[components objectAtIndex:2] intValue];
						cartoonObj.favorites = [[components objectAtIndex:3] intValue];
						cartoonObj.created = [components objectAtIndex:4];
						NSString *created = [components objectAtIndex:4];
						NSArray *dateSegs = [created componentsSeparatedByString:@" "];
						if(dateSegs.count>0)
							cartoonObj.created = [dateSegs objectAtIndex:0];
						cartoonObj.youLikeFlg = [@"Y" isEqualToString:[components objectAtIndex:5]];
						cartoonObj.yourFavFlg = [@"Y" isEqualToString:[components objectAtIndex:6]];
						
						[self.mainArray addObject:cartoonObj];
						self.skipNumber++;
						self.allowMoreFlg=YES;
					}
				}
			[ObjectiveCScripts updateFlagForNumber:5 toString:@""];
		} else
			[ObjectiveCScripts showAlertPopup:@"Server Error" message:@"Unable to reach the server. Try again later."];
		
		
		self.mainTableView.hidden=NO;
		[self stopWebService];
		[self.mainTableView reloadData];
	}
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
	
	self.largeImageSize = 740;
	self.skipNumber=0;
	
	[self extendTableForGold];
	
}

-(void)addButtonPressed {
	[self showPhotoActionSheet];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifierSection%dRow%d", (int)indexPath.section, (int)indexPath.row];
	CartoonCell *cell = [[CartoonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

	CartoonObj *cartoonObj = [self.mainArray objectAtIndex:indexPath.row];
	cell.createdLabel.text = cartoonObj.created;
	NSString *imageName = [NSString stringWithFormat:@"Cartoon%d", cartoonObj.cartoon_id];
	
	if([ObjectiveCScripts getUserDefaultValue:imageName].length==0) {
		self.cacheCount++;
		[cell.activityIndicator startAnimating];
		cell.pic.image=[ObjectiveCScripts cachedImageForRowId:cartoonObj.cartoon_id type:1 dir:@"cartoons" forceRecache:NO];
		cell.bgView.backgroundColor=[UIColor grayColor];
		[self performSelectorInBackground:@selector(cacheImage:) withObject:[NSString stringWithFormat:@"%d", cartoonObj.cartoon_id]];
	} else {
		UIImage *img = [ObjectiveCScripts cachedImageForRowId:cartoonObj.cartoon_id type:0 dir:@"cartoons" forceRecache:NO];
		if(img) {
			[cell.activityIndicator stopAnimating];
			cell.pic.image = img;
			cell.bgView.backgroundColor=[UIColor whiteColor];
		}
	}
	
	cell.likesCountLabel.text = [NSString stringWithFormat:@"%d", cartoonObj.likes];
	cell.favoritesCountLabel.text = [NSString stringWithFormat:@"%d", cartoonObj.favorites];
	cell.likeButton.tag = indexPath.row;
	cell.favoriteButton.tag = indexPath.row;
	[cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchDown];
	[cell.favoriteButton addTarget:self action:@selector(favoriteButtonPressed:) forControlEvents:UIControlEventTouchDown];
	
	if(cartoonObj.youLikeFlg) {
		cell.likesLabel.text = @"You Like!";
		cell.likesLabel.textColor=[UIColor colorWithRed:0 green:.5 blue:0 alpha:1];
		cell.likeButton.enabled=NO;
	} else {
		cell.likesLabel.text = @"Likes";
		cell.likesLabel.textColor=[UIColor blackColor];
		cell.likeButton.enabled=YES;
	}
	if(cartoonObj.yourFavFlg) {
		cell.favoritesLabel.text = @"Your Fav!";
		cell.favoritesLabel.textColor=[UIColor magentaColor];
		cell.favoriteButton.enabled=NO;
	} else {
		cell.favoritesLabel.text = @"Favorites";
		cell.favoritesLabel.textColor=[UIColor blackColor];
		cell.favoriteButton.enabled=YES;
	}

	cell.accessoryType= UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if(indexPath.row==self.mainArray.count-1 && self.allowMoreFlg) {
		NSLog(@"Load More!");
		[self startWebService:@selector(loadDataWebService) message:@"Loading"];

	}
	return cell;
}

-(void)likeButtonPressed:(UIButton *)button {
	if([self updateCartoonObjForRow:(int)button.tag likeFlg:YES])
		[self startWebService:@selector(likeWebService) message:nil];
}

-(void)favoriteButtonPressed:(UIButton *)button {
	if([self updateCartoonObjForRow:(int)button.tag likeFlg:NO])
		[self startWebService:@selector(favWebService) message:nil];
}

-(BOOL)updateCartoonObjForRow:(int)row likeFlg:(BOOL)likeFlg {
	CartoonObj *cartoonObj = [self.mainArray objectAtIndex:row];
	if(likeFlg) {
		if(cartoonObj.youLikeFlg)
			cartoonObj.likes--;
		else
			cartoonObj.likes++;
		cartoonObj.youLikeFlg=!cartoonObj.youLikeFlg;
	} else {
		if(cartoonObj.yourFavFlg)
			return NO;
		cartoonObj.yourFavFlg=YES;
		cartoonObj.favorites++;
	}
	self.cartoon_id = cartoonObj.cartoon_id;
	return YES;
}

-(void)likeWebService {
	@autoreleasepool {
		NSLog(@"self.cartoon_id: %d", self.cartoon_id);
		if([ObjectiveCScripts chooseLikeOrFavForEntity:@"CARTOON" primaryKey:@"cartoon_id" row_id:self.cartoon_id userField:@""]) {
			[self.mainTableView reloadData];
		}
		[self stopWebService];
	}
}


-(void)favWebService {
	@autoreleasepool {
		NSLog(@"self.cartoon_id: %d", self.cartoon_id);
		if([ObjectiveCScripts chooseLikeOrFavForEntity:@"CARTOON" primaryKey:@"cartoon_id" row_id:self.cartoon_id userField:@"favCartoon"]) {
			[self.mainTableView reloadData];
		}
		[self stopWebService];
	}
}


-(void)cacheImage:(NSString *)string {
	@autoreleasepool {
		int row_id = [string intValue];
		NSLog(@"cacheing : %d", row_id);
		if(row_id==0)
			return;
		[NSThread sleepForTimeInterval:1];
		[ObjectiveCScripts cachedImageForRowId:row_id type:0 dir:@"cartoons" forceRecache:NO];
		NSString *imageName = [NSString stringWithFormat:@"Cartoon%d", row_id];
		[ObjectiveCScripts setUserDefaultValue:@"Y" forKey:imageName];
		self.cacheCount--;
		if(self.cacheCount==0) {
			NSLog(@"reloadData");
			[self.mainTableView reloadData];
		}
	}
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mainArray.count;
}

-(void)blowupPic:(int)picNumber {
	self.mainTableView.hidden=YES;
	self.sortSegment.enabled=NO;
	self.mainPic.hidden=NO;
	self.mainPic.image = [ObjectiveCScripts cachedImageForRowId:picNumber type:0 dir:@"cartoons" forceRecache:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CartoonObj *cartoonObj = [self.mainArray objectAtIndex:indexPath.row];
	[self blowupPic:cartoonObj.cartoon_id];
	self.xButton.hidden=NO;
}

-(IBAction)xButtonPressed:(id)sender {
	self.sortSegment.enabled=YES;
	self.mainTableView.hidden=NO;
	self.xButton.hidden=YES;
	self.mainPic.hidden=YES;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ObjectiveCScripts screenWidth]+44;
}

-(void)uploadPhotoWebService {
	@autoreleasepool {
		NSArray *nameList = [NSArray arrayWithObjects:@"username", @"Country", @"image", @"smallImage", nil];
		NSArray *valueList = [NSArray arrayWithObjects:
							  [ObjectiveCScripts getUserDefaultValue:@"userName"],
							  [ObjectiveCScripts getUserDefaultValue:@"Country"],
							  [ObjectiveCScripts base64EncodeImage:self.imageLarge],
							  [ObjectiveCScripts base64EncodeImage:self.imageThumb],
							  nil];
		NSString *webAddr = @"http://www.appdigity.com/poly/uploadCartoon.php";
		NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
		[self stopWebService];
		if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
			[ObjectiveCScripts showAlertPopupWithDelegate:@"Success" message:@"Note, some times the new image will not show up for several minutes." delegate:self tag:0];
			[self loadFromScratch];
		}
		
	}
	
}

-(void)postPhotoUpload {
	[self startWebService:@selector(uploadPhotoWebService) message:@"Uploading"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	self.startTouchPosition = [touch locationInView:self.view];
	self.initTouchPosition = [touch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint newPosition = [touch locationInView:self.view];
	
	int halfPoint = self.mainPic.frame.size.width/2;
	
	CGPoint currentCenter = self.mainPic.center;
	float distX = newPosition.x-self.startTouchPosition.x;
	float distY = newPosition.y-self.startTouchPosition.y;
	CGPoint newCenter = CGPointMake(currentCenter.x+distX, currentCenter.y+distY);
	int width = self.view.frame.size.width;
	int height = self.view.frame.size.height-44;
	float newX = newCenter.x;
	if(newX>halfPoint)
		newX=halfPoint;
	float newY = newCenter.y;
	if(newY>halfPoint)
		newY=halfPoint;

	if(newX<width-halfPoint)
		newX=width -halfPoint;
	if(newY<height-halfPoint)
		newY=height-halfPoint;

	
	self.mainPic.center=CGPointMake(newX, newY);
	self.startTouchPosition=newPosition;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint newPosition = [touch locationInView:self.view];
	if(newPosition.x==self.initTouchPosition.x && newPosition.y==self.initTouchPosition.y) {
		[self xButtonPressed:nil];
	}
}

@end
