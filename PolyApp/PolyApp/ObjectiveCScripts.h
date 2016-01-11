//
//  ObjectiveCScripts.h
//  WealthTracker
//
//  Created by Rick Medved on 7/10/15.
//  Copyright (c) 2015 Rick Medved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define kTestMode	0

@interface ObjectiveCScripts : NSObject

+(NSString *)getProjectDisplayVersion;
+(UIColor *)darkColor;
+(UIColor *)mediumkColor;
+(UIColor *)lightColor;
+(void)showAlertPopup:(NSString *)title message:(NSString *)message;
+(void)showConfirmationPopup:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(int)tag;
+(NSString *)convertNumberToMoneyString:(double)money;
+(double)convertMoneyStringToDouble:(NSString *)moneyStr;
+(void)setUserDefaultValue:(NSString *)value forKey:(NSString *)key;
+(NSString *)getUserDefaultValue:(NSString *)key;
+(void)showAlertPopupWithDelegate:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(int)tag;

+(NSString *)subTypeForNumber:(int)number;
+(NSString *)typeFromSubType:(int)subtype;
+(NSString *)typeFromFieldType:(int)fieldType;
+(int)typeNumberFromSubType:(int)subtype;
+(NSString *)typeNameForType:(int)type;
+(int)subTypeFromSubTypeString:(NSString *)subType;
+(int)typeNumberFromTypeString:(NSString *)typeStr;
+(NSArray *)typeList;
+(UIColor *)colorBasedOnNumber:(float)number lightFlg:(BOOL)lightFlg;
+(NSString *)yearMonthStringNowPlusMonths:(int)months;
+(NSArray *)monthListShort;
+(BOOL)isStartupCompleted;
+(int)calculateIdealNetWorth:(int)annual_income;
+(void)displayMoneyLabel:(UILabel *)label amount:(double)amount lightFlg:(BOOL)lightFlg revFlg:(BOOL)revFlg;
+(void)displayNetChangeLabel:(UILabel *)label amount:(double)amount lightFlg:(BOOL)lightFlg revFlg:(BOOL)revFlg;
+(BOOL)shouldChangeCharactersForMoneyField:(UITextField *)textFieldlocal  replacementString:(NSString *)string;
+(void)updateSalary:(double)amount year:(int)year context:(NSManagedObjectContext *)context;

+(double)changedForItem:(int)item_id month:(int)month year:(int)year field:(NSString *)field context:(NSManagedObjectContext *)context numMonths:(int)numMonths type:(int)type;
+(double)changedEquityLast30ForItem:(int)item_id context:(NSManagedObjectContext *)context;
+(double)changedBalanceLast30ForItem:(int)item_id context:(NSManagedObjectContext *)context;
+(double)changedEquityLast30:(NSManagedObjectContext *)context;
+(float)chartHeightForSize:(float)height;
+(UIImage *)imageIconForType:(NSString *)typeStr;
+(double)amountForItem:(int)item_id month:(int)month year:(int)year field:(NSString *)field context:(NSManagedObjectContext *)context type:(int)type;
+(NSString *)getResponseFromServerUsingPost:(NSString *)webURL fieldList:(NSArray *)fieldList valueList:(NSArray *)valueList;
+(BOOL)validateStandardResponse:(NSString *)responseStr delegate:(id)delegate;
+(void)swipeBackRecognizerForTableView:(UITableView *)tableview delegate:(id)delegate selector:(SEL)selector;
//+(int)badgeStatusForAppWithContext:(NSManagedObjectContext *)context label:(UILabel *)label;
+(NSString *)fieldTypeNameForFieldType:(int)fieldType;
+(NSString *)typeLabelForType:(int)type fieldType:(int)fieldType;
+(int)calculatePaydownRate:(double)balToday balLastYear:(double)balLastYear bal30:(double)bal30 bal90:(double)bal90;
+(UIImage *)imageForStatus:(int)status;
+(int)nowYear;
+(int)nowMonth;
+(NSString *)formatStringForWebService:(NSString *)string;
+(NSString *)deformatStringfromWebService:(NSString *)string;
+(UIColor *)colorForType:(int)type;
+(NSArray *)colorForPartyName;
+(UIColor *)nameColorOfNumber:(int)number;
+(void)applyBackgroundForCountry:(NSString *)country view:(UIView *)view;
+(BOOL)handleTextField:(NSString *)currentString string:(NSString *)string max:(int)max;
+(UIColor *)colorOfNumber:(int)number;
+(int)realColorNumberFromNumber:(int)number;
+(UIImage *)imageFromUrl:(NSString *)urlString;
+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)newSize;
+(NSString *)polIdeologyFromGovEcon:(int)govEcon govMoral:(int)govMoral;
+(NSString *)textForIdeology:(NSString *)ideology;
+(int)candidatesPositionForNumber:(int)number answers:(NSString *)answers;
+(int)percentMatch:(NSString *)answers;
+(void)positionIcon:(UIImageView *)icon govEcon:(int)govEcon govMoral:(int)govMoral bgView:(UIView*)bgView label:(UILabel *)label;
+(BOOL)isCandidateIssuesComplete:(NSString *)answers;
+ (NSString *)base64EncodeImage:(UIImage *)image;
+(UIImage *)avatarImageOfType:(int)type;
+(void)resetFlags;
+(void)deleteLocalDatabase:(NSManagedObjectContext *)context;
+(BOOL)chooseLikeOrFavForEntity:(NSString *)entity primaryKey:(NSString *)primaryKey row_id:(int)row_id userField:(NSString *)userField;
+(UIImage *)cachedImageForRowId:(int)row_id type:(int)type dir:(NSString *)dir forceRecache:(BOOL)forceRecache;
+(float)screenWidth;
+(float)screenHeight;
+(NSString *)updateKeyForNumber:(int)number;
+(NSString *)updateFlgForNumber:(int)number;
+(BOOL)needToUpdateForNumber:(int)number;
+(void)updateFlagForNumber:(int)number toString:(NSString *)toString;
+(void)showUserButton:(UIButton *)button selector:(SEL)selector dir:(NSString *)dir number:(int)number name:(NSString *)name label:(UILabel *)label tarrget:(UIViewController *)tarrget;
+(int)myUserId;
+(BOOL)postMessageToWallofUser:(int)uid message:(NSString *)message;
+(UIImage *)cachedCandidateImageForRowId:(int)candidate_id thumbFlg:(BOOL)thumbFlg;
+(void)setDateStringForForum:(int)row_id type:(NSString *)type systemTimeStamp:(NSString *)systemTimeStamp;
+(NSString *)getDateStringForForum:(int)row_id type:(NSString *)type;
+(NSDate *)dateFromString:(NSString *)dateString;
+(BOOL)newPostsForRowID:(int)row_id lastPost:(NSString *)lastPost type:(NSString *)type;
+(NSString *)userNameForLevel:(int)level;
+(int)myLevel;
+(void)changeLevelTo:(int)level;
+(UIImage *)imageForLevel:(int)level;
+(BOOL)confirmEditOK:(int)level;

@end
