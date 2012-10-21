//
//  TFHpple+CoreData.m
//  jobmineM
//
//  Created by edwin on 8/31/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "TFHpple+CoreData.h"

@implementation TFHpple (CoreData)

typedef JobmineApplicationDetail* (^applicationCreation) (TFHppleElement* obj, JobmineApplicationDetail* aDetailedApp, NSManagedObjectContext* aContext);


+ (void) insertDataString: (NSData*) aJobmineResponse
              forCategory: (CategoryListing) aCategory
       withManagedContext: (NSManagedObjectContext*) aContext{
    
        
    switch (aCategory) {
			
		case CategoryListingJobApplicationDetail:
		{
			
		}
			break;
        case CategoryListingApplicationShortList:
        {
            NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:aJobmineResponse] searchWithXPathQuery:@"/html/body/table/tr"];
            [self updateJobmineListWithLocalCoreData:arrayOfEle forCategory:aCategory withIdCol:0 withManagedContext:aContext];
        }
            break;
		case CategoryListingActiveApplicationList:{
            NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:aJobmineResponse] searchWithXPathQuery:@"/html/body/table/tr"];
            [self updateJobmineListWithLocalCoreData:arrayOfEle forCategory:aCategory withIdCol:0 withManagedContext:aContext];
        }
			//TODO: need to add CategoryListingActiveApplicationList
			break;
		case CategoryListingAllApplicationList:{
            NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:aJobmineResponse] searchWithXPathQuery:@"/html/body/table/tr"];
            [self updateJobmineListWithLocalCoreData:arrayOfEle forCategory:aCategory withIdCol:0 withManagedContext:aContext];
		}
		case CategoryListingCencelledInterview:{
            NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:aJobmineResponse] searchWithXPathQuery:@"/html/body/table/tr"];
            [self updateJobmineListWithLocalCoreData:arrayOfEle forCategory:aCategory withIdCol:0 withManagedContext:aContext];
		}
		case CategoryListingSinglePersonInterview:{
            NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:aJobmineResponse] searchWithXPathQuery:@"/html/body/table/tr"];
            [self updateJobmineListWithLocalCoreData:arrayOfEle forCategory:aCategory withIdCol:0 withManagedContext:aContext];
		}
		case CategoryListingGroupInterview:{
            NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:aJobmineResponse] searchWithXPathQuery:@"/html/body/table/tr"];
            [self updateJobmineListWithLocalCoreData:arrayOfEle forCategory:aCategory withIdCol:0 withManagedContext:aContext];
		}
		case CategoryListingSpecialRequestInterview:{
            NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:aJobmineResponse] searchWithXPathQuery:@"/html/body/table/tr"];
            [self updateJobmineListWithLocalCoreData:arrayOfEle forCategory:aCategory withIdCol:0 withManagedContext:aContext];
		}
			break;
            
        default:
            break;
    }
    [SVProgressHUD showSuccessWithStatus:@"Update Successful"];
    
    
}




+ (NSString* ) insertJobmineApplicationDetail: (NSData* ) HTMLData
							withContext: (NSManagedObjectContext* ) aContext{
	
	NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:HTMLData] searchWithXPathQuery:@"//*[@id=\"UW_CO_JOBDTL_VW_UW_CO_JOB_ID\"]"];
	return [self insertJobmineApplicationDetail:[[NSString alloc] initWithData:HTMLData
															   encoding:NSUTF8StringEncoding]
								forJobID:((TFHppleElement*)[arrayOfEle lastObject]).content.intValue
							 withContext:aContext];
	
}



+ (NSString* ) insertJobmineApplicationDetail: (NSString* ) HTMLDataString
							   forJobID: (int) jID
							withContext: (NSManagedObjectContext* ) aContext{
	
	
	if (jID != 0) {
		NSFetchRequest* allShortListForDeletation = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([JobmineApplicationDetail class])];
		allShortListForDeletation.predicate = [NSPredicate predicateWithFormat:@"jID == %i", jID];
		allShortListForDeletation.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"jID" ascending:YES]];
		
		NSError* error = nil;
		NSArray *qResult = [aContext executeFetchRequest:allShortListForDeletation error:&error];
		if ([qResult count] == 1) {
			
			
			HTMLDataString = [HTMLDataString stringByRemoveContentBetweenStrings:@"<script" andSecondString:@"</script>"];
			HTMLDataString = [HTMLDataString stringByRemoveContentBetweenStrings:@"<a" andSecondString:@"</a>"];
			HTMLDataString = [HTMLDataString stringByRemoveContentBetweenStrings:@"<iframe" andSecondString:@"</iframe>"];
			HTMLDataString = [HTMLDataString stringByRemoveContentBetweenStrings:@"<img" andSecondString:@">"];
			
			
			[(JobmineApplicationDetail*)[qResult lastObject] setJobDescription:HTMLDataString];
			return HTMLDataString;
		}
		return @"";
	}
	return @"";
}




+ (void) updateJobmineListWithLocalCoreData: (NSArray*) arrayOfEle
                                forCategory: (CategoryListing) aCategory
                                  withIdCol: (int) colNumner
                         withManagedContext: (NSManagedObjectContext*) aContext{
    
    
    // extract all the ids 
    NSMutableArray* arrayOfId = [NSMutableArray new];
    
    [arrayOfEle enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx>0) {
            //NSLog(@"%@", ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:0]).content);
            [arrayOfId addObject:[NSNumber numberWithInt:[((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:colNumner]).content integerValue]]];
        }
    }];
    
    
    NSMutableArray* mutableArraryOfElement = [arrayOfEle mutableCopy];
    [mutableArraryOfElement removeObjectAtIndex:0];
    // fetch all the object that should be deleted 
    NSFetchRequest* allShortListForDeletation = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([JobmineInfo class])];
    allShortListForDeletation.predicate = [NSPredicate predicateWithFormat:@"(applicationListing = %i) AND NOT(jID IN %@)", aCategory
                                           , arrayOfId];
    allShortListForDeletation.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"jID" ascending:YES]];
    
    NSError* error = nil;
    NSArray *qResult = [aContext executeFetchRequest:allShortListForDeletation error:&error];
    // deleted all the object
	
	//FIXME: missing a case
	// when the application is both in application short list and it in some category and is being deleted and that will create a duplicated application short list
	
    [qResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (aCategory == CategoryListingApplicationShortList ||
			(aCategory != CategoryListingApplicationShortList && ((JobmineInfo*)obj).isFavourite.intValue == NO)) {
			[aContext deleteObject:obj];
		}else if (((JobmineInfo*)obj).isFavourite.intValue == @(YES).intValue){
			((JobmineInfo*)obj).applicationListing = @(CategoryListingApplicationShortList);
		}
    }];
    
    // fetch again for insert missing ones
    NSFetchRequest* allShortListAfterDeletation = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([JobmineInfo class])];
    allShortListAfterDeletation.predicate = [NSPredicate predicateWithFormat:@"applicationListing = %i", aCategory];
    allShortListAfterDeletation.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"jID" ascending:YES]];
    
    NSError* otherError = nil;
    NSArray *aResult = [aContext executeFetchRequest:allShortListAfterDeletation error:&otherError];
    
    [aResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[JobmineInfo class]]) {
            NSNumber* tempAppID = ((JobmineInfo*)obj).jID;
            __block int itemIndexToBeDeleted;
            [arrayOfId enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (((NSNumber*) obj).intValue == tempAppID.intValue){
                    itemIndexToBeDeleted = idx;
                    [mutableArraryOfElement removeObjectAtIndex:itemIndexToBeDeleted];
                    [arrayOfId removeObjectAtIndex:itemIndexToBeDeleted];
                    *stop = YES;
                }
            }];
        }
    }];
    
    if ([mutableArraryOfElement count] > 0) {
        [mutableArraryOfElement enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self createMissingJobmineApplication:obj forCategory:aCategory withManagedContext:aContext];
            
        }];
    }
}



+ (void) createMissingJobmineApplication: (TFHppleElement*) obj forCategory: (CategoryListing) aCategory withManagedContext:(NSManagedObjectContext* ) aContext{
    
    switch (aCategory) {
        case CategoryListingApplicationShortList:{
            NSNumber* jobmineID = [NSNumber numberWithInt:[((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:0]).content integerValue]];
            if (jobmineID.intValue != 0) {
                    JobmineInfo* aInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineInfo class])
                                                                       inManagedObjectContext:aContext];
                    aInfo.jID = jobmineID;
                    aInfo.applicationListing = @(aCategory);
                    aInfo.isFavourite = @(YES);
                    aInfo.refreToApplication = [self fetchAndUpdateApplicationDetail:obj forCategory:aCategory withManagedContext:aContext];
            }
        }
            break;
		case CategoryListingActiveApplicationList:{
            NSNumber* jobmineID = [NSNumber numberWithInt:[((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:0]).content integerValue]];
            if (jobmineID.intValue != 0) {
				JobmineInfo* aInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineInfo class])
																   inManagedObjectContext:aContext];
				aInfo.jID = jobmineID;
				aInfo.applicationListing = @(aCategory);
				aInfo.refreToApplication = [self fetchAndUpdateApplicationDetail:obj forCategory:aCategory withManagedContext:aContext];
            }
        }
			
			break;
		case CategoryListingAllApplicationList:{
			NSNumber* jobmineID = [NSNumber numberWithInt:[((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:0]).content integerValue]];
            if (jobmineID.intValue != 0) {
				JobmineInfo* aInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineInfo class])
																   inManagedObjectContext:aContext];
				aInfo.jID = jobmineID;
				aInfo.applicationListing = @(aCategory);
				aInfo.refreToApplication = [self fetchAndUpdateApplicationDetail:obj forCategory:aCategory withManagedContext:aContext];
            }
		}
			break;
		case CategoryListingSinglePersonInterview:{
			NSNumber* jobmineID = [NSNumber numberWithInt:[((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:0]).content integerValue]];
            if (jobmineID.intValue != 0) {
				JobmineInfo* aInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineInfo class])
																   inManagedObjectContext:aContext];
				aInfo.jID = jobmineID;
				aInfo.applicationListing = @(aCategory);
				aInfo.refreToApplication = [self fetchAndUpdateApplicationDetail:obj forCategory:aCategory withManagedContext:aContext];
            }
		}
			break;
		case CategoryListingGroupInterview:{
			NSNumber* jobmineID = [NSNumber numberWithInt:[((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:0]).content integerValue]];
            if (jobmineID.intValue != 0) {
				JobmineInfo* aInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineInfo class])
																   inManagedObjectContext:aContext];
				aInfo.jID = jobmineID;
				aInfo.applicationListing = @(aCategory);
				aInfo.refreToApplication = [self fetchAndUpdateApplicationDetail:obj forCategory:aCategory withManagedContext:aContext];
            }
		}
			break;
		case CategoryListingCencelledInterview:{
			NSNumber* jobmineID = [NSNumber numberWithInt:[((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:0]).content integerValue]];
            if (jobmineID.intValue != 0) {
				JobmineInfo* aInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineInfo class])
																   inManagedObjectContext:aContext];
				aInfo.jID = jobmineID;
				aInfo.applicationListing = @(aCategory);
				aInfo.refreToApplication = [self fetchAndUpdateApplicationDetail:obj forCategory:aCategory withManagedContext:aContext];
            }
		}
			break;
		case CategoryListingSpecialRequestInterview:{
			NSNumber* jobmineID = [NSNumber numberWithInt:[((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:0]).content integerValue]];
            if (jobmineID.intValue != 0) {
				JobmineInfo* aInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineInfo class])
																   inManagedObjectContext:aContext];
				aInfo.jID = jobmineID;
				aInfo.applicationListing = @(aCategory);
				aInfo.refreToApplication = [self fetchAndUpdateApplicationDetail:obj forCategory:aCategory withManagedContext:aContext];
            }
		}
			break;
        default:
            break;
    }
    
}


+ (JobmineApplicationDetail* ) fetchAndUpdateSingleApplicationDetail: (TFHppleElement*) obj
													   withJobmineID: (NSNumber*) jobmineID
														 forCategory: (CategoryListing) aCategory
												  withManagedContext:(NSManagedObjectContext* ) aContext
										withApplicationCreationBlock: (applicationCreation) aCreatorBlock{
	
	
	
	NSFetchRequest* allAppWithId = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([JobmineApplicationDetail class])];
	allAppWithId.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"jID" ascending:YES]];
	allAppWithId.predicate = [NSPredicate predicateWithFormat:@"jID == %i", jobmineID.intValue];
	NSError* fetchError = nil;
	
	NSArray* allAppWithIDResult = [aContext executeFetchRequest:allAppWithId error:&fetchError];
	
	return aCreatorBlock(obj, [allAppWithIDResult lastObject], aContext);
	
	
}



+ (JobmineApplicationDetail* ) fetchAndUpdateApplicationDetail: (TFHppleElement*) obj
                                                   forCategory: (CategoryListing) aCategory
                                            withManagedContext:(NSManagedObjectContext* ) aContext{
    
    //JobmineApplicationDetail* resultApplicationDetail = nil;
    NSNumber* jobmineID = @([((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:0]).content integerValue]);
    
    
    switch (aCategory) {
        case CategoryListingApplicationShortList:
        {
			applicationCreation createApplicationShortListAppFromObject = ^ JobmineApplicationDetail* (TFHppleElement* obj, JobmineApplicationDetail* aDetailedApp, NSManagedObjectContext* aContext){
				JobmineApplicationDetail* resultApplicationDetail = nil;
				NSString* appTitle = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:1]).content;
				NSString* appEmployeeName = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:2]).content;
				NSString* appEmployeeUnit = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content;
				NSString* appLocation = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
				NSString* appStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:5]).content;
				NSDateFormatter* aDateFormator = [NSDateFormatter new];
				[aDateFormator setDateFormat:@"dd MMM yyyy"];
				NSString* appLDTA = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:6]).content;
				NSNumber* appNumberOfApplicatite = @([((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:7]).content integerValue]);
				
				if (!aDetailedApp) {
					resultApplicationDetail = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineApplicationDetail class])
																			inManagedObjectContext:aContext];
				} else {
					resultApplicationDetail = aDetailedApp;
				}
				
				
				resultApplicationDetail.jID = jobmineID;
				resultApplicationDetail.jobTitle = appTitle;
				resultApplicationDetail.employer = appEmployeeName;
				resultApplicationDetail.employmentUnit = appEmployeeUnit;
				resultApplicationDetail.employmentLocation = appLocation;
				resultApplicationDetail.jobStatus = appStatus;
				resultApplicationDetail.lastDayToApply = [aDateFormator dateFromString:appLDTA];
				resultApplicationDetail.numberOfApplications = appNumberOfApplicatite;
				return resultApplicationDetail;
			};
			return [self fetchAndUpdateSingleApplicationDetail:obj
												 withJobmineID:jobmineID
												   forCategory:aCategory
											withManagedContext:aContext
								  withApplicationCreationBlock:createApplicationShortListAppFromObject];
		}
            break;
			
		case CategoryListingActiveApplicationList:{
			applicationCreation createAllApplicationListAppFromObject = ^ JobmineApplicationDetail* (TFHppleElement* obj, JobmineApplicationDetail* aDetailedApp, NSManagedObjectContext* aContext){
				JobmineApplicationDetail* resultApplicationDetail = nil;
				NSString* appTitle = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:1]).content;
				NSString* appEmployeeName = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:2]).content;
				NSString* appEmployeeUnit = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content;
				//NSString* appLocation = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
				NSString* appWorkTerm = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
				NSString* appStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:5]).content;
				NSString* appApplicatoinStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:6]).content;
				NSString* appLDTA = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:8]).content;
				NSDateFormatter* aDateFormator = [NSDateFormatter new];
				[aDateFormator setDateFormat:@"dd-MMM-yyyy"];
				NSNumber* appNumberOfApplicatite = @([((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:9]).content integerValue]);
				
				if (!aDetailedApp) {
					resultApplicationDetail = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineApplicationDetail class])
																			inManagedObjectContext:aContext];
				} else {
					resultApplicationDetail = aDetailedApp;
				}
				resultApplicationDetail.jID = jobmineID;
				resultApplicationDetail.jobTitle = appTitle;
				resultApplicationDetail.employer = appEmployeeName;
				resultApplicationDetail.employmentUnit = appEmployeeUnit;
				resultApplicationDetail.workingTerm = appWorkTerm;
				//resultApplicationDetail.employmentLocation = appLocation;
				resultApplicationDetail.lastDayToApply = [aDateFormator dateFromString:appLDTA];
				resultApplicationDetail.jobStatus = appStatus;
				resultApplicationDetail.applicationStatus = appApplicatoinStatus;
				resultApplicationDetail.numberOfApplications = appNumberOfApplicatite;
				return resultApplicationDetail;
			};
			return [self fetchAndUpdateSingleApplicationDetail:obj
												 withJobmineID:jobmineID
												   forCategory:aCategory
											withManagedContext:aContext
								  withApplicationCreationBlock:createAllApplicationListAppFromObject];
		}
			break;
		case CategoryListingAllApplicationList:
		{
			applicationCreation createAllApplicationListAppFromObject = ^ JobmineApplicationDetail* (TFHppleElement* obj, JobmineApplicationDetail* aDetailedApp, NSManagedObjectContext* aContext){
				JobmineApplicationDetail* resultApplicationDetail = nil;
				NSString* appTitle = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:1]).content;
				NSString* appEmployeeName = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:2]).content;
				NSString* appEmployeeUnit = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content;
				//NSString* appLocation = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
				NSString* appWorkTerm = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
				NSString* appStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:5]).content;
				NSString* appApplicatoinStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:6]).content;
				NSDateFormatter* aDateFormator = [NSDateFormatter new];
				[aDateFormator setDateFormat:@"dd-MMM-yyyy"];
				NSString* appLDTA = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:8]).content;
				NSNumber* appNumberOfApplicatite = @([((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:9]).content integerValue]);
				
				if (!aDetailedApp) {
					resultApplicationDetail = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineApplicationDetail class])
																			inManagedObjectContext:aContext];
				} else {
					resultApplicationDetail = aDetailedApp;
				}
				resultApplicationDetail.jID = jobmineID;
				resultApplicationDetail.jobTitle = appTitle;
				resultApplicationDetail.employer = appEmployeeName;
				resultApplicationDetail.employmentUnit = appEmployeeUnit;
				resultApplicationDetail.workingTerm = appWorkTerm;
				//resultApplicationDetail.employmentLocation = appLocation;
				resultApplicationDetail.jobStatus = appStatus;
				resultApplicationDetail.lastDayToApply = [aDateFormator dateFromString:appLDTA];
				resultApplicationDetail.applicationStatus = appApplicatoinStatus;
				resultApplicationDetail.numberOfApplications = appNumberOfApplicatite;
				return resultApplicationDetail;
			};
			return [self fetchAndUpdateSingleApplicationDetail:obj
												 withJobmineID:jobmineID
												   forCategory:aCategory
											withManagedContext:aContext
								  withApplicationCreationBlock:createAllApplicationListAppFromObject];
		}
			break;
		case CategoryListingCencelledInterview:
		{
			applicationCreation createAllApplicationListAppFromObject = ^ JobmineApplicationDetail* (TFHppleElement* obj, JobmineApplicationDetail* aDetailedApp, NSManagedObjectContext* aContext){
				JobmineApplicationDetail* resultApplicationDetail = nil;
				NSString* appTitle = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:2]).content;
				NSString* appEmployeeName = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:1]).content;
//				NSString* appEmployeeUnit = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content;
//				//NSString* appLocation = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
//				NSString* appWorkTerm = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
//				NSString* appStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:5]).content;
//				NSString* appApplicatoinStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:6]).content;
				//NSDate* appLDTA = nil;
				//NSNumber* appNumberOfApplicatite = @([((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:9]).content integerValue]);
				
				if (!aDetailedApp) {
					resultApplicationDetail = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineApplicationDetail class])
																			inManagedObjectContext:aContext];
				} else {
					resultApplicationDetail = aDetailedApp;
				}
				
				resultApplicationDetail.jID = jobmineID;
				resultApplicationDetail.jobTitle = appTitle;
				resultApplicationDetail.employer = appEmployeeName;
				//resultApplicationDetail.numberOfApplications = appNumberOfApplicatite;
//				resultApplicationDetail.employmentUnit = appEmployeeUnit;
//				resultApplicationDetail.workingTerm = appWorkTerm;
//				//resultApplicationDetail.employmentLocation = appLocation;
//				resultApplicationDetail.jobStatus = appStatus;
//				resultApplicationDetail.applicationStatus = appApplicatoinStatus;
//				resultApplicationDetail.numberOfApplications = appNumberOfApplicatite;
				return resultApplicationDetail;
			};
			return [self fetchAndUpdateSingleApplicationDetail:obj
												 withJobmineID:jobmineID
												   forCategory:aCategory
											withManagedContext:aContext
								  withApplicationCreationBlock:createAllApplicationListAppFromObject];
		}
			break;
		case CategoryListingSinglePersonInterview:
		{
			applicationCreation createAllApplicationListAppFromObject = ^ JobmineApplicationDetail* (TFHppleElement* obj, JobmineApplicationDetail* aDetailedApp, NSManagedObjectContext* aContext){
				JobmineApplicationDetail* resultApplicationDetail = nil;
				NSString* appEmployeeName = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:1]).content;
				NSString* appTitle = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:2]).content;
				NSString* appInterviewType = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
				
				NSNumber* appInterviewLength = @(((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:7]).content.intValue);
				NSString* appInterviewRoom = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:8]).content;
				NSString* appInterviewInstrusction = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:9]).content;
				NSString* appInterviewer = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:10]).content;
				NSString* appJobStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:11]).content;
				NSString* appDateAndTime = [NSString stringWithFormat:@"%@ %@",
											((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content,
											((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:6]).content];
				NSDateFormatter* aDateFormator = [NSDateFormatter new];
				[aDateFormator setDateFormat:@"dd MMM yyyy hh:mm aa"];
//				NSString* appEmployeeUnit = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content;
				//NSString* appLocation = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
//				NSString* appWorkTerm = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
//				NSString* appStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:5]).content;
//				NSString* appApplicatoinStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:6]).content;
//				NSNumber* appNumberOfApplicatite = @([((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:9]).content integerValue]);
				
				if (!aDetailedApp) {
					resultApplicationDetail = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineApplicationDetail class])
																			inManagedObjectContext:aContext];
				} else {
					resultApplicationDetail = aDetailedApp;
				}
				
				resultApplicationDetail.jID = jobmineID;
				resultApplicationDetail.jobTitle = appTitle;
				resultApplicationDetail.employer = appEmployeeName;
				resultApplicationDetail.interviewType = appInterviewType;
				resultApplicationDetail.interviewLength = appInterviewLength;
				resultApplicationDetail.interviewRoom = appInterviewRoom;
				resultApplicationDetail.interviewInstructions = appInterviewInstrusction;
				resultApplicationDetail.interviewer = appInterviewer;
				resultApplicationDetail.jobStatus = appJobStatus;
				resultApplicationDetail.interviewDate = [aDateFormator dateFromString:appDateAndTime];
//				resultApplicationDetail.employmentUnit = appEmployeeUnit;
//				resultApplicationDetail.workingTerm = appWorkTerm;
//				//resultApplicationDetail.employmentLocation = appLocation;
//				resultApplicationDetail.jobStatus = appStatus;
//				resultApplicationDetail.applicationStatus = appApplicatoinStatus;
//				resultApplicationDetail.numberOfApplications = appNumberOfApplicatite;
				return resultApplicationDetail;
			};
			return [self fetchAndUpdateSingleApplicationDetail:obj
												 withJobmineID:jobmineID
												   forCategory:aCategory
											withManagedContext:aContext
								  withApplicationCreationBlock:createAllApplicationListAppFromObject];
		}
			break;
		case CategoryListingGroupInterview:
		{
			applicationCreation createAllApplicationListAppFromObject = ^ JobmineApplicationDetail* (TFHppleElement* obj, JobmineApplicationDetail* aDetailedApp, NSManagedObjectContext* aContext){
				JobmineApplicationDetail* resultApplicationDetail = nil;
				NSString* appTitle = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:2]).content;
				NSString* appEmployeeName = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:1]).content;
//				NSString* appEmployeeUnit = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content;
				//NSString* appLocation = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
//				NSString* appWorkTerm = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
//				NSString* appStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:5]).content;
//				NSString* appApplicatoinStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:6]).content;
				NSString* appInterviewRoom = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:6]).content;
				NSString* appInterviewInstrusction = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:7]).content;
				NSString* appDateAndTime = [NSString stringWithFormat:@"%@ %@",
											((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content,
											((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content];
				NSDateFormatter* aDateFormator = [NSDateFormatter new];
				[aDateFormator setDateFormat:@"dd MMM yyyy hh:mm aa"];
				
				if (!aDetailedApp) {
					resultApplicationDetail = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineApplicationDetail class])
																			inManagedObjectContext:aContext];
				} else {
					resultApplicationDetail = aDetailedApp;
				}
				
				resultApplicationDetail.jID = jobmineID;
				resultApplicationDetail.jobTitle = appTitle;
				resultApplicationDetail.employer = appEmployeeName;
				resultApplicationDetail.groupInterviewDate = [aDateFormator dateFromString:appDateAndTime];
				resultApplicationDetail.groupInterviewRoom = appInterviewRoom;
				resultApplicationDetail.groupInterviewInstruction = appInterviewInstrusction;
				//resultApplicationDetail.numberOfApplications = appNumberOfApplicatite;
				return resultApplicationDetail;
			};
			return [self fetchAndUpdateSingleApplicationDetail:obj
												 withJobmineID:jobmineID
												   forCategory:aCategory
											withManagedContext:aContext
								  withApplicationCreationBlock:createAllApplicationListAppFromObject];
		}
			break;
		case CategoryListingSpecialRequestInterview:
		{
			applicationCreation createAllApplicationListAppFromObject = ^ JobmineApplicationDetail* (TFHppleElement* obj, JobmineApplicationDetail* aDetailedApp, NSManagedObjectContext* aContext){
				JobmineApplicationDetail* resultApplicationDetail = nil;
				NSString* appTitle = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:2]).content;
				NSString* appEmployeeName = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:1]).content;
				NSString* appInterviewInstrusction = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content;
				//NSString* appLocation = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
//				NSString* appWorkTerm = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
//				NSString* appStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:5]).content;
//				NSString* appApplicatoinStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:6]).content;
				//NSDate* appLDTA = nil;
//				NSNumber* appNumberOfApplicatite = @([((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:9]).content integerValue]);

				
				if (!aDetailedApp) {
					resultApplicationDetail = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobmineApplicationDetail class])
																			inManagedObjectContext:aContext];
				} else {
					resultApplicationDetail = aDetailedApp;
				}
				
				resultApplicationDetail.jID = jobmineID;
				resultApplicationDetail.jobTitle = appTitle;
				resultApplicationDetail.employer = appEmployeeName;
				resultApplicationDetail.spicalRequestInstruction = appInterviewInstrusction;
//				resultApplicationDetail.workingTerm = appWorkTerm;
				//resultApplicationDetail.employmentLocation = appLocation;
//				resultApplicationDetail.jobStatus = appStatus;
//				resultApplicationDetail.applicationStatus = appApplicatoinStatus;
//				resultApplicationDetail.numberOfApplications = appNumberOfApplicatite;
				return resultApplicationDetail;
			};
			return [self fetchAndUpdateSingleApplicationDetail:obj
												 withJobmineID:jobmineID
												   forCategory:aCategory
											withManagedContext:aContext
								  withApplicationCreationBlock:createAllApplicationListAppFromObject];
		}
			break;
            
        default:
            break;
    }
    
    return nil;
}





@end
