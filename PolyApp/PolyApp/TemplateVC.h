//
//  TemplateVC.h
//  PolyApp
//
//  Created by Rick Medved on 12/15/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "WebServiceView.h"
#import "ObjectiveCScripts.h"
#import "CustomSegment.h"
#import "UIColor+ATTColor.h"
#import "UserObj.h"

@interface TemplateVC : UIViewController <ADBannerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) ADBannerView *adView;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet WebServiceView *webServiceView;
@property (strong, nonatomic) IBOutlet CustomSegment *sortSegment;

@property (strong, nonatomic) NSMutableArray *webServiceElements;
@property (strong, nonatomic) NSMutableArray *textFieldElements;
@property (strong, nonatomic) NSMutableArray *mainArray;

//image picker
@property (strong, nonatomic) IBOutlet UIButton *uploadPhotoButton;
@property (strong, nonatomic) UIImage *imageLarge;
@property (strong, nonatomic) UIImage *imageThumb;
@property (nonatomic, strong) IBOutlet UIImageView *mainPic;

@property (strong, nonatomic) UIBarButtonItem *rightButton;
@property (strong, nonatomic) IBOutlet UIView *popupView;

@property (strong, nonatomic) IBOutlet UITextView *mainTextView;
@property (strong, nonatomic) NSString *textViewTitle;
@property (strong, nonatomic) UserObj *userObj;


@property (nonatomic) int maxLength; //TextField length
@property (nonatomic) int largeImageSize; // pixels
@property (nonatomic) int skipNumber; //<-- mySql Limit
@property (nonatomic) BOOL allowMoreFlg; //<-- mySql limit

-(void)startWebService:(SEL)aSelector message:(NSString *)message;
-(void)stopWebService;
-(void)showPhotoActionSheet;
-(void)resignResponders;
-(void)returningText:(NSString *)text;

- (IBAction) submitButtonPressed: (id) sender;
- (IBAction) uploadPhotoButtonPressed: (id) sender;
- (IBAction) xButtonPressed: (id) sender;
- (IBAction) sortSegmentChanged: (id) sender;


@end
