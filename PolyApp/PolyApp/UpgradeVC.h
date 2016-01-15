//
//  UpgradeVC.h
//  PolyApp
//
//  Created by Rick Medved on 1/2/16.
//  Copyright (c) 2016 Rick Medved. All rights reserved.
//

#import "TemplateVC.h"

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface UpgradeVC : TemplateVC <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) IBOutlet UIButton *silverButton;
@property (strong, nonatomic) IBOutlet UIButton *goldButton;
@property (strong, nonatomic) IBOutlet UIButton *restoreSilverButton;
@property (strong, nonatomic) IBOutlet UIButton *restoreGoldButton;
@property (strong, nonatomic) SKProduct *proUpgradeProduct;
@property (strong, nonatomic) SKProductsRequest *productsRequest;
@property (strong, nonatomic) NSString *productID;
@property (nonatomic) int upgradeType;

-(IBAction)upgradeSilverButtonClicked:(id)sender;
-(IBAction)upgradeGoldButtonClicked:(id)sender;
-(IBAction)restoreSilverButtonClicked:(id)sender;
-(IBAction)restoreGoldButtonClicked:(id)sender;

- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;

@end
