//
//  ObjectiveCScripts.m
//  CardTap
//
//  Created by Rick Medved on 12/30/14.
//  Copyright (c) 2014 Rick Medved. All rights reserved.
//

#import "ObjectiveCScripts.h"
#import "NSDate+ATTDate.h"
#import "CoreDataLib.h"
#import "UIColor+ATTColor.h"
#import "NSDate+ATTDate.h"
#import "NSString+ATTString.h"


@implementation ObjectiveCScripts


+(NSString *)getProjectDisplayVersion
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
	NSString *version = infoDictionary[@"CFBundleShortVersionString"];
	UIDevice *device = [UIDevice currentDevice];
	NSString *model = [device model];
	
	return [NSString stringWithFormat:@"Version %@ (%@)", version, model];
}

+(UIColor *)darkColor {
	return [UIColor colorWithRed:(12/255.0) green:(37/255.0) blue:(119/255.0) alpha:1.0];
}

+(UIColor *)mediumkColor {
	return [UIColor colorWithRed:(6/255.0) green:(122/255.0) blue:(180/255.0) alpha:1.0];
}

+(UIColor *)lightColor {
	return [UIColor colorWithRed:(58/255.0) green:(165/255.0) blue:(220/255.0) alpha:1.0];
}

+(void)showAlertPopup:(NSString *)title message:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
	//	[alert show];
}

+(void)showAlertPopupWithDelegate:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(int)tag
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	alert.tag = tag;
	[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
	//	[alert show];
	//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
}


+(void)showConfirmationPopup:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(int)tag
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles: @"OK", nil];
	alert.tag = tag;
	[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//	[alert show];
	//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
}

+(void)showAcceptDeclinePopup:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"Decline"
										  otherButtonTitles: @"Accept", nil];
	
	[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
	//	[alert show];
	//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
}

+(NSString *)getResponseFromWeb:(NSString *)urlString deviceToken:(NSString *)deviceToken
{
	
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
	
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json; api-version=3" forHTTPHeaderField:@"Accept"];
	
	[request setValue:@"apn" forHTTPHeaderField:@"pn_type"];
	[request setValue:deviceToken forHTTPHeaderField:@"pn_reg_id"];
	
	//	NSString *secretKey = @"e18871ab-e10d-4b3f-93a4-80e7c198ce3d";
	//	NSString *user_agent_string = @"com.cardtapp.ctapp";
	//	NSString *consumer = @"TEST-CONS";
	//	NSString *timeStamp = [ObjectiveCScripts convertDateToString:[NSDate date] format:@"yyyyMMddHHmmss"];
	// Example: 20150420113644
	//	NSString *keyLength = @"256";
	//	NSString *payload = @"karnickel";
	//	NSString *message = [NSString stringWithFormat:@"%@%@%@", secretKey, payload, timeStamp];
	
	
	NSError *error = nil;
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	if(error) {
		[ObjectiveCScripts showAlertPopup:@"Network Error" message:error.localizedDescription];
		NSLog(@"+++Response: %@", error.description);
		return nil;
	}
	
	return responseString;
}

+(NSString *)formatStringForWebService:(NSString *)string {
	string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"[amp;]"];
	string = [string stringByReplacingOccurrencesOfString:@"|" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"`" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"[nl]"];
//	string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"[plus;]"];
	return string;
}

+(NSString *)deformatStringfromWebService:(NSString *)string {
	string = [string stringByReplacingOccurrencesOfString:@"[amp;]" withString:@"&"];
	string = [string stringByReplacingOccurrencesOfString:@"[nl]" withString:@"\n"];
	return string;
}

+(NSString *)getResponseFromServerUsingPost:(NSString *)webURL fieldList:(NSArray *)fieldList valueList:(NSArray *)valueList
{
	if([fieldList count] != [valueList count]) {
		return [NSString stringWithFormat:@"Invalid value list! (%lu, %lu) %@", (unsigned long)[fieldList count], (unsigned long)[valueList count], webURL];
	}
	int i=0;
	NSMutableString *fieldStr= [[NSMutableString alloc] init];
	for(NSString *name in fieldList)
		[fieldStr appendFormat:@"&%@=%@", name, [ObjectiveCScripts formatStringForWebService:[valueList objectAtIndex:i++]]];
	
//	NSString *responseString = nil;
	NSData *postData = [fieldStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
	
	
	NSURL *url = [NSURL URLWithString:webURL];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	NSURLResponse *response;
	NSError *err;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	NSString *reString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	reString = [self deformatStringfromWebService:reString];
//	responseString = [NSString stringWithFormat:@"%@", reString];
	
	if(responseData==nil)
		[ObjectiveCScripts showAlertPopup:@"WebService Error" message:@"Not able to connect to the server. Check internet connections."];
	
	return reString;
}

+(BOOL)validateStandardResponse:(NSString *)responseStr delegate:(id)delegate
{
	if(responseStr==nil || [responseStr length]==0)
		responseStr = @"No Response Sent.";
	
	if([responseStr length]>=7 && [[responseStr substringToIndex:7] isEqualToString:@"Success"]) {
		return YES;
	}
	else {
		if([responseStr length]>100)
			responseStr = [responseStr substringToIndex:100];
		[self showAlertPopup:@"Error" message:responseStr];
		return NO;
	}
}


+(NSData *)createJsonExample {
	NSMutableDictionary *documentDict = [[NSMutableDictionary alloc] init];
	[documentDict setValue:@"12345" forKey:@"end_user[id]"];
	[documentDict setValue:@"test msg" forKey:@"event"];
	
	NSDictionary *jsonDict = [NSDictionary dictionaryWithObject:documentDict forKey:@"trackingData"];
	NSLog(@"jsonDict is %@", jsonDict);
	
	NSData *jsonData = [NSJSONSerialization
						dataWithJSONObject:jsonDict
						options:NSJSONWritingPrettyPrinted
						error:nil];
	return jsonData;
}

/*
 +(NSString *)postRequestToWeb:(NSString *)urlString userId:(NSString *)userId message:(NSString *)message
 {
	
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
	
	
	NSMutableDictionary *documentDict = [[NSMutableDictionary alloc] init];
 [documentDict setValue:userId forKey:@"end_user[id]"];
 [documentDict setValue:message forKey:@"event"];
	
	NSDictionary *jsonDict = [NSDictionary dictionaryWithObject:documentDict forKey:@"trackingData"];
	NSLog(@"jsonDict is %@", jsonDict);
	
	NSData *jsonData = [NSJSONSerialization
 dataWithJSONObject:jsonDict
 options:NSJSONWritingPrettyPrinted
 error:nil];
 
	
	
 //	NSData *requestData = [NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: jsonData];
	
	
	NSError *error = nil;
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	if(error) {
 [ObjectiveCScripts showAlertPopup:@"Network Error" message:error.localizedDescription];
 NSLog(@"+++Response: %@", error.description);
 return nil;
	}
	
	return responseString;
 }
 */

+(NSString *)convertDateToString:(NSDate *)date format:(NSString *)format
{
	if(format==nil || [format isEqualToString:@""])
		format = @"MM/dd/yyyy hh:mm:ss a";
	
	if([format isEqualToString:@"short"])
		format = @"MM/dd/yyyy hh:mm a";
	
	if([format isEqualToString:@"date"])
		format = @"MM/dd/yyyy";
	
	if([format isEqualToString:@"long"])
		format = @"yyyy-MM-dd HH:mm:ss ZZ";
	
	if([format isEqualToString:@"cardtapp"])
		format = @"yyyyMMddHHmmss";
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:format];
	NSString *dateString = [df stringFromDate:date];
	if(dateString==nil)
		dateString=@"-";
	return dateString;
}


+(UIImage *)imageFromUrl:(NSString *)urlString defaultImg:(UIImage *)defaultImg
{
	if(urlString.length==0)
		return nil;
	
	NSURL *url = [NSURL URLWithString:urlString];
	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
	if(image)
		return image;
	else
		return defaultImg;
}

+(void)setUserDefaultValue:(NSString *)value forKey:(NSString *)key
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:value forKey:key];
}

+(NSString *)getUserDefaultValue:(NSString *)key
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	return [userDefaults stringForKey:key];
}

+(void)makeSegment:(UISegmentedControl *)segment color:(UIColor *)color {
	[segment setTintColor:color];
	
	segment.layer.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1].CGColor; // BG gray
	segment.layer.cornerRadius = 7;
	
	UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
	NSMutableDictionary *attribsNormal = [NSMutableDictionary dictionaryWithObjectsAndKeys:font, NSForegroundColorAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
	
	NSMutableDictionary *attribsSelected = [NSMutableDictionary dictionaryWithObjectsAndKeys:font, NSForegroundColorAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
	
	[segment setTitleTextAttributes:attribsNormal forState:UIControlStateNormal];
	[segment setTitleTextAttributes:attribsSelected forState:UIControlStateSelected];
	
}

+(NSString *)convertNumberToMoneyString:(double)money
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	NSString *moneyStr = [formatter stringFromNumber:[NSNumber numberWithDouble:money]];
	
	return [moneyStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
}

+(double)convertMoneyStringToDouble:(NSString *)moneyStr
{
	moneyStr = [moneyStr stringByReplacingOccurrencesOfString:@"$" withString:@""];
	moneyStr = [moneyStr stringByReplacingOccurrencesOfString:@"," withString:@""];
	return [moneyStr doubleValue];
}

+(NSString *)subTypeForNumber:(int)number
{
	NSArray *subTypes = [self subtypeList];
	NSArray *items = [[subTypes objectAtIndex:number] componentsSeparatedByString:@"|"];
	return [items objectAtIndex:1];
}

+(NSString *)typeNameForType:(int)type {
	NSArray *types = [ObjectiveCScripts typeList];
	return [types objectAtIndex:type];
}

+(NSArray *)typeList {
	return [NSArray arrayWithObjects:
			@"Profile",
			@"Real Estate",
			@"Vehicle",
			@"Debt",
			@"Asset",
			@"N/A",
			nil];
}

+(NSArray *)fieldTypeList {
	return [NSArray arrayWithObjects:
			@"Value",
			@"Balance",
			@"Equity",
			@"Interest",
			nil];
}

+(NSString *)fieldTypeNameForFieldType:(int)fieldType {
	if(fieldType>3)
		return @"Error";
	else
		return [[self fieldTypeList] objectAtIndex:fieldType];
}

+(NSArray *)subtypeList {
			// type | sub_type | type#
	return [NSArray arrayWithObjects:
			@"Profile|Profile|0"
			, @"Profile|I Rent|0"
			, @"Real Estate|Primary Residence|1"
			, @"Real Estate|Rental|1"
			, @"Real Estate|Other Property|1"
			, @"Vehicle|Auto|2"
			, @"Vehicle|Motorcycle|2"
			, @"Vehicle|RV|2"
			, @"Vehicle|ATV|2"
			, @"Vehicle|Jet Ski|2"
			, @"Vehicle|Snomobile|2"
			, @"Vehicle|Other|2"
			, @"Debt|Credit Card|3"
			, @"Debt|Student Loan|3"
			, @"Debt|Loan|3"
			, @"Debt|Medical|3"
			, @"Asset|401k|4"
			, @"Asset|Retirement|4"
			, @"Asset|Stocks|4"
			, @"Asset|College Fund|4"
			, @"Asset|Bank Account|4"
			, @"Asset|Other Asset|4"
			, @"N/A|N/A|5"
			, @"N/A|N/A|5"
			, nil];
}

+(NSString *)typeFromSubType:(int)subtype {
	NSArray *subTypes = [self subtypeList];
	NSArray *items = [[subTypes objectAtIndex:subtype] componentsSeparatedByString:@"|"];
	return [items objectAtIndex:0];
}

+(int)typeNumberFromSubType:(int)subtype {
	NSArray *subTypes = [self subtypeList];
	NSArray *items = [[subTypes objectAtIndex:subtype] componentsSeparatedByString:@"|"];
	return [[items objectAtIndex:2] intValue];
}

+(int)typeNumberFromTypeString:(NSString *)typeStr {
	NSArray *types = [self typeList];
	int typeNum=0;
	for(NSString *type in types) {
		if([typeStr isEqualToString:type])
			return typeNum;
		typeNum++;
	}
	return typeNum;
}

+(int)subTypeFromSubTypeString:(NSString *)subType {
	NSArray *subTypes = [self subtypeList];
	int sub_type=0;
	for(NSString *item in subTypes) {
		NSArray *components = [item componentsSeparatedByString:@"|"];
		if([subType isEqualToString:[components objectAtIndex:1]])
			return sub_type;
		sub_type++;
	}
	return sub_type;
}

+(NSString *)typeFromFieldType:(int)fieldType
{
	switch (fieldType) {
  case 0:
			return @"text";
			break;
  case 1:
			return @"double";
			break;
  case 2:
			return @"int";
			break;
  case 3:
			return @"text";
			break;
  case 4:
			return @"float";
			break;
			
  default:
			break;
	}
	return @"text";
}



+(UIColor *)colorBasedOnNumber:(float)number lightFlg:(BOOL)lightFlg
{
	if(lightFlg) {
		if(number>=0)
			return [UIColor greenColor];
		else
			return [UIColor colorWithRed:1 green:.7 blue:0 alpha:1];
	}
	if(number>=0)
		return [UIColor colorWithRed:0 green:.5 blue:0 alpha:1];
	else
		return [UIColor redColor];
}

+(NSString *)yearMonthStringNowPlusMonths:(int)months
{
	int nowYear = [[[NSDate date] convertDateToStringWithFormat:@"YYYY"] intValue];
	int nowMonth = [[[NSDate date] convertDateToStringWithFormat:@"MM"] intValue];
	int changeYears = months/12;
	int remainingMonths = months-(changeYears*12);
	
	int newYear = nowYear+changeYears;
	int newMonth = nowMonth+remainingMonths;
	
	if(newMonth>12) {
		newMonth-=12;
		newYear++;
	}
	if(newMonth<1) {
		newMonth+=12;
		newYear--;
	}
	return [NSString stringWithFormat:@"%d%02d", newYear, newMonth];
}

+(NSArray *)monthListShort {
	return [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", @"X", nil];
}


+(BOOL)isStartupCompleted {
	return ([ObjectiveCScripts getUserDefaultValue:@"assetsFlg"].length>0);
}

+(int)calculateIdealNetWorth:(int)annual_income {
	int idealNetWorth = annual_income*10; // ideally you would like to retire and make the same amount
	if(idealNetWorth<400000)
		idealNetWorth=400000; // at least 400,000
	if(idealNetWorth>10000000)
		idealNetWorth=10000000; // at most 10 mil
	
	idealNetWorth=(idealNetWorth/100000)*100000; // rounded
	return idealNetWorth;
}

+(void)displayMoneyLabel:(UILabel *)label amount:(double)amount lightFlg:(BOOL)lightFlg revFlg:(BOOL)revFlg {
	label.text = [NSString stringWithFormat:@"%@", [ObjectiveCScripts convertNumberToMoneyString:amount]];
	if(revFlg)
		amount*=-1;
	label.textColor = [ObjectiveCScripts colorBasedOnNumber:amount lightFlg:lightFlg];
}


+(void)displayNetChangeLabel:(UILabel *)label amount:(double)amount lightFlg:(BOOL)lightFlg revFlg:(BOOL)revFlg {
	NSString *sign=(amount>=0)?@"+":@"";
	label.text = [NSString stringWithFormat:@"%@%@", sign, [ObjectiveCScripts convertNumberToMoneyString:amount]];
	if(revFlg)
		amount*=-1;
	label.textColor = [ObjectiveCScripts colorBasedOnNumber:amount lightFlg:lightFlg];
}

+(BOOL)shouldChangeCharactersForMoneyField:(UITextField *)textFieldlocal  replacementString:(NSString *)string {
	if(string.length==0) // backspace
		return YES;
	if([@"." isEqualToString:string])
		return YES;
	
	NSString *value = [NSString stringWithFormat:@"%@%@", textFieldlocal.text, string];
	value = [value stringByReplacingOccurrencesOfString:@"$" withString:@""];
	value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
	value = [ObjectiveCScripts convertNumberToMoneyString:[value doubleValue]];
	textFieldlocal.text = value;
	return NO;
}

+(void)updateSalary:(double)amount year:(int)year context:(NSManagedObjectContext *)context
{
	NSPredicate *predicate=[NSPredicate predicateWithFormat:@"year = %d", year];
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"INCOME" predicate:predicate sortColumn:nil mOC:context ascendingFlg:NO];
	NSManagedObject *mo=nil;
	if(items.count>0) {
		mo = [items objectAtIndex:0];
	} else {
		mo = [NSEntityDescription insertNewObjectForEntityForName:@"INCOME" inManagedObjectContext:context];
		[mo setValue:[NSNumber numberWithInt:year] forKey:@"year"];
	}
	[mo setValue:[NSNumber numberWithDouble:amount] forKey:@"amount"];
	[context save:nil];
}

+(NSPredicate *)predicateForItem:(int)item_id month:(int)month year:(int)year type:(int)type {
	if(type>0) {
		if(item_id>0)
			return [NSPredicate predicateWithFormat:@"year = %d AND month = %d AND item_id = %d AND type = %d", year, month, item_id, type];
		else
			return [NSPredicate predicateWithFormat:@"year = %d AND month = %d AND type = %d", year, month, type];
	} else {
		if(item_id>0)
			return [NSPredicate predicateWithFormat:@"year = %d AND month = %d AND item_id = %d", year, month, item_id];
		else
			return [NSPredicate predicateWithFormat:@"year = %d AND month = %d", year, month];
	}
	return nil;
}

+(double)amountForItem:(int)item_id month:(int)month year:(int)year field:(NSString *)field context:(NSManagedObjectContext *)context type:(int)type {
	double amount=0;
	NSPredicate *predicate=[ObjectiveCScripts predicateForItem:item_id month:month year:year type:type];
	NSArray *items = [CoreDataLib selectRowsFromEntity:@"VALUE_UPDATE" predicate:predicate sortColumn:nil mOC:context ascendingFlg:NO];
	for(NSManagedObject *mo in items) {
		if(field.length>0)
			amount += [[mo valueForKey:field] intValue];
		else
			amount += [[mo valueForKey:@"asset_value"] doubleValue]-[[mo valueForKey:@"balance_owed"] doubleValue];
	}
	return amount;
}

+(double)changedForItem:(int)item_id month:(int)month year:(int)year field:(NSString *)field context:(NSManagedObjectContext *)context numMonths:(int)numMonths type:(int)type {
	if(month==0 && year==0) {
		year = [[[NSDate date] convertDateToStringWithFormat:@"YYYY"] intValue];
		month = [[[NSDate date] convertDateToStringWithFormat:@"MM"] intValue];
	}
	
	int prevMonth = month;
	int prevYear = year;
	for(int i=1; i<=numMonths; i++) {
		prevMonth--;
		if(prevMonth<1) {
			prevMonth=12;
			prevYear--;
		}
	}
	if(item_id<0) {
		type=item_id*-1;
		item_id=0;
	}
	
	double prevAmount = [self amountForItem:item_id month:prevMonth year:prevYear field:field context:context type:type];
	double amount = [self amountForItem:item_id month:month year:year field:field context:context type:type];
	
	return amount-prevAmount;
}

+(double)changedEquityLast30ForItem:(int)item_id context:(NSManagedObjectContext *)context {
	return [ObjectiveCScripts changedForItem:item_id month:0 year:0 field:nil context:context numMonths:1 type:0];
}

+(double)changedBalanceLast30ForItem:(int)item_id context:(NSManagedObjectContext *)context {
	return [ObjectiveCScripts changedForItem:item_id month:0 year:0 field:@"balance_owed" context:context numMonths:1 type:0];
}

+(double)changedEquityLast30:(NSManagedObjectContext *)context {
	return [ObjectiveCScripts changedForItem:0 month:0 year:0 field:nil context:context numMonths:1 type:0];
}

+(int)calculatePaydownRate:(double)balToday balLastYear:(double)balLastYear bal30:(double)bal30 bal90:(double)bal90 {
	int principalPaid = (balLastYear-balToday)/12;
	if((bal30-balToday)>principalPaid)
		principalPaid = bal30-balToday;
	if((bal90-balToday)>principalPaid)
		principalPaid = (bal90-balToday)/3;
	return principalPaid;
}

+(float)screenWidth {
	return [[UIScreen mainScreen] bounds].size.width;
}

+(float)screenHeight {
	return [[UIScreen mainScreen] bounds].size.height;
}

+(float)chartHeightForSize:(float)height
{
	float width = [[UIScreen mainScreen] bounds].size.width;
	if(width<320)
		width=320;
	return height*width/320;
}

+(UIImage *)imageIconForType:(NSString *)typeStr {
	return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [[typeStr lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
}

+(void)swipeBackRecognizerForTableView:(UITableView *)tableview delegate:(id)delegate selector:(SEL)selector {
	UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:delegate
																					 action:selector];
	[recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
	[tableview addGestureRecognizer:recognizer];
}


+(UIColor *)colorForType:(int)type {
	if(type==1)
		return [UIColor colorWithRed:.5 green:.4 blue:.3 alpha:1];
	if(type==2)
		return [ObjectiveCScripts mediumkColor];
	if(type==3)
		return [UIColor colorWithRed:.6 green:.4 blue:.4 alpha:1];
	if(type==4)
		return [UIColor colorWithRed:.4 green:.55 blue:.4 alpha:1];
	
	return [UIColor blackColor];
}


+(NSString *)typeLabelForType:(int)type fieldType:(int)fieldType {
	if(type==0) {
		if(fieldType==0)
			return @"Assets";
		if(fieldType==1)
			return @"Debts";
		if(fieldType==2)
			return @"Net Worth";
		if(fieldType==3)
			return @"Debt Interest";
	} else
		return [ObjectiveCScripts typeNameForType:type];
	
	return @"Error";
}

+(UIImage *)imageForStatus:(int)status {
	if(status == 1)
		return [UIImage imageNamed:@"yellow.png"];
	else if(status == 2)
		return [UIImage imageNamed:@"red.png"];
	
	return [UIImage imageNamed:@"green.png"];
}

+(int)nowYear {
	return [[[NSDate date] convertDateToStringWithFormat:@"YYYY"] intValue];
}

+(int)nowMonth {
	return [[[NSDate date] convertDateToStringWithFormat:@"MM"] intValue];
}

+(void)applyBackgroundForCountry:(NSString *)country view:(UIView *)view {
	UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
	
	if(country.length==0)
		country = @"nil";
	
	country = [[country lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	NSString *defaultPath = [[NSBundle mainBundle] pathForResource:country ofType:@"jpg"];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:defaultPath]) {
		backgroundView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", country]];
	} else {
		backgroundView.image = [UIImage imageNamed:@"grayBG.jpg"];
	}
	
	backgroundView.alpha=.3;
	[view addSubview:backgroundView];
	[view sendSubviewToBack:backgroundView];
}

+(BOOL)handleTextField:(NSString *)currentString string:(NSString *)string max:(int)max {
	if([@"|" isEqualToString:string])
		return NO;
	if([@"`" isEqualToString:string])
		return NO;
	if(currentString.length+string.length>=max && string.length>1 && currentString.length<max) {
		[ObjectiveCScripts showAlertPopup:@"string too long!" message:@""];
		return NO;
	}
	
	if(currentString.length+string.length>max && string.length>0)
		return NO;
	
	return YES;
}

+(NSArray *)colorsForParty {
	return [NSArray arrayWithObjects:
			[UIColor whiteColor],
			[UIColor redColor],
			[UIColor blueColor],
			[UIColor greenColor],
			[UIColor yellowColor],
			[UIColor grayColor],
			[UIColor orangeColor],
			[UIColor purpleColor],
			[UIColor cyanColor],
			[UIColor blackColor],
			[UIColor colorWithRed:.5 green:0 blue:0 alpha:1],
			[UIColor colorWithRed:.8 green:.5 blue:0 alpha:1],
			[UIColor colorWithRed:0 green:.5 blue:.5 alpha:1],
			nil];
}

+(NSArray *)colorForPartyName {
	return [NSArray arrayWithObjects:
			[UIColor blackColor],
			[UIColor whiteColor],
			[UIColor whiteColor],
			[UIColor blackColor],
			[UIColor blackColor],
			[UIColor whiteColor],
			[UIColor blackColor],
			[UIColor whiteColor],
			[UIColor blackColor],
			[UIColor whiteColor],
			[UIColor whiteColor],
			[UIColor blackColor],
			[UIColor whiteColor],
			nil];
}

+(int)realColorNumberFromNumber:(int)number {
	NSArray *colors = [self colorsForParty];
	return number%colors.count;
}

+(UIColor *)colorOfNumber:(int)number {
	NSArray *colors = [self colorsForParty];
	return [colors objectAtIndex:number%colors.count];
}

+(int)realNameColorNumberFromNumber:(int)number {
	NSArray *colors = [self colorForPartyName];
	return number%colors.count;
}

+(UIColor *)nameColorOfNumber:(int)number {
	NSArray *colors = [self colorForPartyName];
	return [colors objectAtIndex:number%colors.count];
}

+(NSString *)imageUrlForId:(int)row_id type:(int)type dir:(NSString *)dir {
	//0=regular, 1=small
	if(type==0)
		return [NSString stringWithFormat:@"http://www.appdigity.com/poly/%@/img_%d.jpg", dir, row_id];
	else
		return [NSString stringWithFormat:@"http://www.appdigity.com/poly/%@/thumb_%d.jpg", dir, row_id];
}

+(UIImage *)imageFromUrl:(NSString *)urlString
{
	if(urlString.length==0)
		return nil;
	
	NSURL *url = [NSURL URLWithString:urlString];
	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
	if(image)
		return image;
	else
		return [UIImage imageNamed:@"unknown.jpg"];
}

+(UIImage *)cachedCandidateImageForRowId:(int)candidate_id thumbFlg:(BOOL)thumbFlg {
	return [self cachedImageForRowId:candidate_id type:(thumbFlg)?1:0 dir:@"pics" forceRecache:NO];
}

+(UIImage *)cachedImageForRowId:(int)row_id type:(int)type dir:(NSString *)dir forceRecache:(BOOL)forceRecache {
	NSString *urlLink = [ObjectiveCScripts imageUrlForId:row_id type:type dir:dir];
	UIImage *img = [self imageFromCacheForKey:urlLink];
	if(!forceRecache && img)
		return img;
	else {
		UIImage *image = [ObjectiveCScripts imageFromUrl:urlLink];
		if(image) {
			[self userDefaultsCacheImage:image key:urlLink];
			return image;
		}
	}
	return [UIImage imageNamed:@"unknown.jpg"];
}

+(void)userDefaultsCacheImage:(UIImage *)image key:(NSString *)key {
	NSLog(@"+++caching %@", key);
	NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:image];
	if(imageData)
		[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:key];
}

+(UIImage *)imageFromCacheForKey:(NSString *)key {
	NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if(imageData)
		return [NSKeyedUnarchiver unarchiveObjectWithData: imageData];
	else
		return nil;
}

+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)newSize {
	UIGraphicsBeginImageContext(newSize);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+(NSString *)polIdeologyFromGovEcon:(int)govEcon govMoral:(int)govMoral
{
	NSLog(@"govEcon: %d, govMoral: %d", govEcon, govMoral);
	if(govEcon==10 && govMoral==10)
		return @"Totalitarian";
	if(govEcon==-10 && govMoral==10)
		return @"Neo-Con";
	if(govEcon==10 && govMoral==-10)
		return @"Socialist";
	if(govEcon==-10 && govMoral==-10)
		return @"Anarchist";
	
	if(govEcon>=-1 && govEcon<=1 && govMoral>=-1 && govMoral<=1)
		return @"Centrist";
	
	if(govEcon>=-3 && govEcon<=0 && govMoral>=0 && govMoral<=3)
		return @"Moderate Conservative";
	if(govEcon>=0 && govEcon<=3 && govMoral>=-3 && govMoral<=0)
		return @"Moderate Liberal";
	if(govEcon>=0 && govEcon<=3 && govMoral>=0 && govMoral<=3)
		return @"Moderate Statist";
	if(govEcon>=-3 && govEcon<=0 && govMoral>=-3 && govMoral<=0)
		return @"Moderate Libertarian";
	
	if((govEcon==-10 && govMoral>=-4 && govMoral<=4) || (govEcon==-9 && govMoral>=-2 && govMoral<=2) || (govEcon==-8 && govMoral>=-1 && govMoral<=1))
		return @"Capitalist";
	if((govMoral==10 && govEcon>=-4 && govEcon<=4) || (govMoral==9 && govEcon>=-2 && govEcon<=2) || (govMoral==8 && govEcon>=-1 && govEcon<=1))
		return @"Nationalist";
	if((govEcon==10 && govMoral>=-4 && govMoral<=4) || (govEcon==9 && govMoral>=-2 && govMoral<=2) || (govEcon==8 && govMoral>=-1 && govMoral<=1))
		return @"Populist";
	if((govMoral==-10 && govEcon>=-4 && govEcon<=4) || (govMoral==-9 && govEcon>=-2 && govEcon<=2) || (govMoral==-8 && govEcon>=-1 && govEcon<=1))
		return @"Globalist";
	
	if(govEcon<= 0 && govMoral>=0)
		return @"Conservative";
	if(govEcon>=0 && govMoral<=0)
		return @"Liberal";
	if(govEcon>=0 && govMoral>=0)
		return @"Statist";
	if(govEcon<=0 && govMoral<=0)
		return @"Libertarian";
	
	
	return @"Unknown";
}


+(NSString *)textForIdeology:(NSString *)ideology {
	if([@"Neo-Con" isEqualToString:ideology])
		return @"Neo-Cons believe in free market capitalism and a vibrant economy that keeps the government out of the regulation business. They also believe people need to look out for themselves and their own families and not count on government programs to take care of them.\n\nNeo-Cons also have a strong sense of morals and believe there are some right ways to live and right uses for government, such as strong police and military.";
	if([@"Socialist" isEqualToString:ideology])
		return @"Socialists believe too much money is concentrated at the top and a strong government with good policies can help fix the problems. \n\nThey also believe in diversity and equal treatment of all citizens, especially those minority groups that have been surpressed.";
	if([@"Totalitarian" isEqualToString:ideology])
		return @"Totalitarians believe in a strong government that takes care of the people and makes sure all aspects of society are carefully protected. \n\nThey believe people should have high morals and government should help make sure everyone is adhering to them. They also believe the economy is there to serve the people, not the other way around.";
	if([@"Anarchist" isEqualToString:ideology])
		return @"Anarchists have a strong distrust of governments of all types and believe all politicians are corrupt or at least will eventually become corrupt. \n\nThey prefer that people take care of their own lives and keep the government out. Live and let live.";
	
	if([@"Centrist" isEqualToString:ideology])
		return @"Centrists tend to not have strong opinions on politics one way or the other. Their positions tend to be in the middle and prefer people run their own lives. \n\nWhen it comes to government, they trust those in the right positions to make good decisions on running the country.";
	
	if([@"Moderate Conservative" isEqualToString:ideology])
		return @"Moderate Conservatives tend to favor free market capitalism and a vibrant economy that keeps the government out of the regulation business. They also believe people need to look out for themselves and their own families and not count on government programs to take care of you.\n\nThey also lean towards a view that society should have good morals, which are encouraged by the government. There are some right ways to live and right uses for government, such as strong police and military, as long as they aren't overdone.";
	if([@"Moderate Liberal" isEqualToString:ideology])
		return @"Moderate Liberals tend to believe too much money is concentrated at the top and a strong government with good policies can help fix the problems. \n\nThey also believe in diversity and equal treatment of all citizens, especially those minority groups that have been surpressed, but their views are not too extreme in any direction.";
	if([@"Moderate Statist" isEqualToString:ideology])
		return @"Moderate Statists believe in a strong government that takes care of the people and makes sure most aspects of society are carefully protected. \n\nThey believe people should have high morals and government should help make sure everyone is adhering to them, as long as they show proper constraint. They also believe the economy is there to serve the people, not the other way around.";
	if([@"Moderate Libertarian" isEqualToString:ideology])
		return @"Moderate Libertarians tend to have a distrust of governments of all types and believe most politicians are corrupt or at least will eventually become corrupt. \n\nThey prefer that people take care of their own lives and keep the government out. Live and let live.";
	
	if([@"Capitalist" isEqualToString:ideology])
		return @"Capitalists believe in strong free market capitalism and a vibrant economy that keeps the government out of the regulation business. They also believe people need to look out for themselves and their own families and not count on government programs to take care of them.\n\nAs for social issues, they tend to believe everyone should live according to their own morals. It's not the government's business.";
	if([@"Nationalist" isEqualToString:ideology])
		return @"Nationalists have a strong sense of morals and believe there are right ways to live and right uses for government, such as strong police and military. \n\nAt the same time they favor a strong economy with plenty of jobs and rising wages, but with a lot of checks and balances in place to keep the system fair.";
	if([@"Populist" isEqualToString:ideology])
		return @"Populists believe that too much money is concentrated at the top and a strong government with good policies can help fix the problems. \n\nThey also believe in diversity and equal treatment of all citizens, but at the same time, believe government has a duty to ensure a strong moral fabric of society.";
	if([@"Globalist" isEqualToString:ideology])
		return @"Globalists believe in diversity and equal treatment of all citizens, especially those minority groups that have been surpressed. They also believe we need to do more to help the poor, not just in this country, but wherever help is needed.\n\nGlobalists tend to see themselves as citizens of the world and are often motivated humanitarians and environmentalists.";

	if([@"Conservative" isEqualToString:ideology])
		return @"Conservatives believe in strong free market capitalism and a vibrant economy that keeps the government out of the regulation business. They also believe people need to look out for themselves and their own families and not count on government programs to take care of them.\n\nThey also tend to be religious with a strong sense of morals and believe there are right ways to live and right uses for government. Such as strong police and military.";
	if([@"Liberal" isEqualToString:ideology])
		return @"Liberals believe too much money is concentrated at the top and a strong government with good policies can help fix the problems. \n\nThey also believe in diversity and equal treatment of all citizens, especially those minority groups that have been surpressed.";
	if([@"Statist" isEqualToString:ideology])
		return @"Statists believe in a strong government that takes care of the people and makes sure all aspects of society are carefully protected. They believe people should have high morals and government should help make sure everyone is adhering to them. \n\nThey also believe the economy is there to serve the people, not the other way around.";
	if([@"Libertarian" isEqualToString:ideology])
		return @"Libertarians have a strong distrust of governments of all types and believe all politicians are corrupt or at least will eventually become corrupt with time. \n\nThey prefer that people take care of their own lives and keep the government out. Live and let live.";

	return ideology;
}


+(int)candidatesPositionForNumber:(int)number answers:(NSString *)answers {
	if(answers.length<20)
		return 0;
	number--;
	if(number<0)
		number=0;
	NSArray *components = [answers componentsSeparatedByString:@":"];
	if(components.count>number)
		return [[components objectAtIndex:number] intValue];
	
	return 0;
}

+(int)percentMatch:(NSString *)answers {
	int percent = 0;
	NSArray *components = [answers componentsSeparatedByString:@":"];
	if(components.count>=20) {
		for(int i=1; i<=20; i++) {
			int answer = [[ObjectiveCScripts getUserDefaultValue:[NSString stringWithFormat:@"Question%d", i]] intValue];
			int canAnswer = [[components objectAtIndex:i-1] intValue];
			if(answer==canAnswer)
				percent+=5;
			else if(canAnswer>0 && abs(answer-canAnswer)==1)
				percent+=2;
		}
	}
	return percent;
}

+(void)positionIcon:(UIImageView *)icon govEcon:(int)govEcon govMoral:(int)govMoral bgView:(UIView*)bgView label:(UILabel *)label {
	float width = bgView.frame.size.width;
	float height = bgView.frame.size.height;
	float margins = 15;
	float squalsizeX=(width-margins)/40;
	float squalsizeY=(height-margins)/40;
	float posX = width/2+(govEcon*-1*squalsizeX)+(govMoral*squalsizeX);
	float posY = height/2+(govEcon*squalsizeY)+(govMoral*squalsizeY);
	icon.center = CGPointMake(posX, posY);
	label.center = CGPointMake(icon.center.x, icon.center.y+20);
}

+(BOOL)isCandidateIssuesComplete:(NSString *)answers {
	if(answers.length<20)
		return NO;
	NSArray *components = [answers componentsSeparatedByString:@":"];
	for(NSString *answer in components)
		if([answer intValue]==0)
			return NO;
	
	return YES;
}

+ (NSString *)base64EncodeImage:(UIImage *)image {
	NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
	
	//	NSLog(@"Img bytes: %lu", (unsigned long)imgData.base64Encoding.length);
	return [imgData base64EncodedStringWithOptions:kNilOptions];
	//return imgData.base64Encoding;
}

+(UIImage *)avatarImageOfType:(int)type {
	int imgType = [[ObjectiveCScripts getUserDefaultValue:@"imgType"] intValue];
	if(imgType==2) {
		return [ObjectiveCScripts cachedImageForRowId:[ObjectiveCScripts myUserId] type:type dir:@"userPics" forceRecache:NO];
	}
	int closestMatchId = [[ObjectiveCScripts getUserDefaultValue:@"ClosestMatchId"] intValue];
	if(closestMatchId>0) {
		UIImage *image = [ObjectiveCScripts cachedImageForRowId:closestMatchId type:type dir:@"pics" forceRecache:NO];
		if(image)
			return image;
	}
	return [UIImage imageNamed:@"unknown.jpg"];
}

+(void)resetFlags {
	for(int i=0; i<=6; i++)
		[ObjectiveCScripts setUserDefaultValue:@"Y" forKey:[ObjectiveCScripts updateFlgForNumber:i]];
}

+(void)deleteLocalDatabase:(NSManagedObjectContext *)context {
	NSLog(@"Deleting database!");
	[self deleteLocalDatabaseForEntity:@"CANDIDATE" context:context];
	[self deleteLocalDatabaseForEntity:@"QUOTE" context:context];
	[self deleteLocalDatabaseForEntity:@"ISSUE" context:context];
	[context save:nil];
	[self resetFlags];
	[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"ClosestMatchId"];
	[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"ClosestMatchName"];
	[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"CandidateId"];
	[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"Ccountry"];
	[ObjectiveCScripts setUserDefaultValue:@"" forKey:@"Year"];
}

+(void)deleteLocalDatabaseForEntity:(NSString *)entity context:(NSManagedObjectContext *)context {
	NSArray *items = [CoreDataLib selectRowsFromEntity:entity predicate:nil sortColumn:nil mOC:context ascendingFlg:NO];
	for(NSManagedObject *mo in items)
		[context deleteObject:mo];
}


+(BOOL)chooseLikeOrFavForEntity:(NSString *)entity primaryKey:(NSString *)primaryKey row_id:(int)row_id userField:(NSString *)userField {
	
	//type = likes or favorites
	NSArray *nameList = [NSArray arrayWithObjects:@"username", @"entity", @"primaryKey", @"row_id", @"userField", nil];
	NSArray *valueList = [NSArray arrayWithObjects:
						  [ObjectiveCScripts getUserDefaultValue:@"userName"],
						  entity,
						  primaryKey,
						  [NSString stringWithFormat:@"%d", row_id],
						  userField,
						  nil];
	NSString *webAddr = @"http://www.appdigity.com/poly/likeFav.php";
	NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
	if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil]) {
		return YES;
	}
	return NO;
}

+(NSString *)updateKeyForNumber:(int)number {
	return [NSString stringWithFormat:@"item%dUpdatedDate", number];
}

+(NSString *)updateFlgForNumber:(int)number {
	return [NSString stringWithFormat:@"item%dUpdatedFlg", number];
}

+(BOOL)needToUpdateForNumber:(int)number {
	return [@"Y" isEqualToString:[ObjectiveCScripts getUserDefaultValue:[ObjectiveCScripts updateFlgForNumber:number]]];
}

+(void)updateFlagForNumber:(int)number toString:(NSString *)toString {
	[ObjectiveCScripts setUserDefaultValue:toString forKey:[ObjectiveCScripts updateFlgForNumber:number]];
}

+(void)showUserButton:(UIButton *)button selector:(SEL)selector dir:(NSString *)dir number:(int)number name:(NSString *)name label:(UILabel *)label tarrget:(UIViewController *)tarrget
{
	[button setBackgroundImage:[ObjectiveCScripts cachedImageForRowId:number type:1 dir:dir forceRecache:NO] forState:UIControlStateNormal];
	if(selector)
		[button addTarget:tarrget action:selector forControlEvents:UIControlEventTouchUpInside];
	label.text = name;
}

+(int)myUserId {
	return [[ObjectiveCScripts getUserDefaultValue:@"user_id"] intValue];
}

+(BOOL)postMessageToWallofUser:(int)uid message:(NSString *)message {
	if(uid==0) {
		[ObjectiveCScripts showAlertPopup:@"Error" message:@"No UID"];
		return NO;
	}
	NSArray *nameList = [NSArray arrayWithObjects:@"username", @"uid", @"message", nil];
	NSArray *valueList = [NSArray arrayWithObjects:
						  [ObjectiveCScripts getUserDefaultValue:@"userName"],
						  [NSString stringWithFormat:@"%d", uid],
						  message,
						  nil];
	NSString *webAddr = @"http://www.appdigity.com/poly/postToWall.php";
	NSString *responseStr = [ObjectiveCScripts getResponseFromServerUsingPost:webAddr fieldList:nameList valueList:valueList];
	if([ObjectiveCScripts validateStandardResponse:responseStr delegate:nil])
		return YES;
	else
		return NO;
}

+(NSString *)stringNameForForumRow:(int)row_id type:(NSString *)type {
	return [NSString stringWithFormat:@"forumView%@%d", type, row_id];
}

+(NSString *)getDateStringForForum:(int)row_id type:(NSString *)type {
	return [ObjectiveCScripts getUserDefaultValue:[self stringNameForForumRow:row_id type:type]];
}

+(NSString *)dateStringForDatabase {
	return @"yyyy-MM-dd HH:mm:ss";
}

+(void)setDateStringForForum:(int)row_id type:(NSString *)type systemTimeStamp:(NSString *)systemTimeStamp {
	if(systemTimeStamp.length==0)
		systemTimeStamp = [[NSDate date] convertDateToStringWithFormat:[self dateStringForDatabase]];
	NSLog(@"setting timestamp: %@ [%@]", systemTimeStamp, [self stringNameForForumRow:row_id type:type]);
	[ObjectiveCScripts setUserDefaultValue:systemTimeStamp forKey:[self stringNameForForumRow:row_id type:type]];
}

+(NSDate *)dateFromString:(NSString *)dateString {
	return [dateString convertStringToDateWithFormat:[self dateStringForDatabase]];
}

+(BOOL)newPostsForRowID:(int)row_id lastPost:(NSString *)lastPost type:(NSString *)type {
	if(lastPost.length==0)
		return NO;
	
	NSString *lastView = [ObjectiveCScripts getDateStringForForum:row_id type:type];
	if(lastView.length==0)
		return YES;
	
	NSDate *lastPostDate = [ObjectiveCScripts dateFromString:lastPost];
	NSDate *lastViewDate = [ObjectiveCScripts dateFromString:lastView];
	int seconds = [lastViewDate timeIntervalSinceDate:lastPostDate];
	
	NSLog(@"[%@] [%@] %d", lastView, lastPost, seconds);
	
	return seconds<0;
}

+(int)myLevel {
	return [[ObjectiveCScripts getUserDefaultValue:@"level"] intValue];
}

+(void)changeLevelTo:(int)level {
	[ObjectiveCScripts setUserDefaultValue:[NSString stringWithFormat:@"%d", level] forKey:@"level"];
}

+(NSString *)userNameForLevel:(int)level {
	NSArray *names = [NSArray arrayWithObjects:@"Bronze", @"Silver", @"Gold", @"Admin", @"SAdmin", @"Owner", nil];
	return [names objectAtIndex:level];
}

+(UIImage *)imageForLevel:(int)level {
	return [UIImage imageNamed:[NSString stringWithFormat:@"level%d.png", level]];
}

+(BOOL)confirmEditOK:(int)level {
	if([ObjectiveCScripts myLevel]<level) {
		[ObjectiveCScripts showAlertPopup:@"Record Locked" message:[NSString stringWithFormat:@"You must be level %@ to edit this record. Please upgrade under the 'Options' menu.", [ObjectiveCScripts userNameForLevel:level]]];
		return NO;
	}
	return YES;
}




















@end
