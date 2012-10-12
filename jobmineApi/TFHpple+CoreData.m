//
//  TFHpple+CoreData.m
//  jobmineM
//
//  Created by edwin on 8/31/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "TFHpple+CoreData.h"

@implementation TFHpple (CoreData)

typedef JobmineApplicationDetail* (^applicationCreation) (TFHppleElement* obj, NSManagedObjectContext* aContext);


+ (void) insertDataString: (NSData*) aJobmineResponse
              forCategory: (CategoryListing) aCategory
       withManagedContext: (NSManagedObjectContext*) aContext{
    
        
    switch (aCategory) {
			
		case CategoryListingJobApplicationDetail:
		{
			
            NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:aJobmineResponse] searchWithXPathQuery:@"//*[@id=\"UW_CO_JOBDTL_VW_UW_CO_JOB_ID\"]"];
			[self insertJobmineApplicationDetail:[[NSString alloc] initWithData:aJobmineResponse
																	   encoding:NSUTF8StringEncoding]
										forJobID:((TFHppleElement*)[arrayOfEle lastObject]).content.intValue
									 withContext:aContext];
			
			
		}
			break;
        case CategoryListingApplicationShortList:
        {
            NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:aJobmineResponse] searchWithXPathQuery:@"/html/body/table/tr"];
            [self updateJobmineListWithLocalCoreData:arrayOfEle forCategory:aCategory withIdCol:0 withManagedContext:aContext];
        }
            break;
		case CategoryListingActiveApplicationList:
			//TODO: need to add CategoryListingActiveApplicationList
			break;
		case CategoryListingAllApplicationList:{
            NSArray* arrayOfEle = [[TFHpple hppleWithHTMLData:aJobmineResponse] searchWithXPathQuery:@"/html/body/table/tr"];
            [self updateJobmineListWithLocalCoreData:arrayOfEle forCategory:aCategory withIdCol:0 withManagedContext:aContext];
		}
			break;
            
        default:
            break;
    }
    
    
    
}




+ (void) insertJobmineApplicationDetail: (NSString* ) HTMLDataString
							   forJobID: (int) jID
							withContext: (NSManagedObjectContext* ) aContext{
	
	
	if (jID != 0) {
		NSFetchRequest* allShortListForDeletation = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([JobmineApplicationDetail class])];
		allShortListForDeletation.predicate = [NSPredicate predicateWithFormat:@"jID == %i", jID];
		allShortListForDeletation.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"jID" ascending:YES]];
		
		NSError* error = nil;
		NSArray *qResult = [aContext executeFetchRequest:allShortListForDeletation error:&error];
		if ([qResult count] == 1) {
			[(JobmineApplicationDetail*)[qResult lastObject] setJobDescription:HTMLDataString];
		}

	}
	
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
		case CategoryListingActiveApplicationList:
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
	switch ([allAppWithIDResult count]) {
		case 0:
			return aCreatorBlock(obj, aContext);
		default:
			return [allAppWithIDResult lastObject];
	}
	
	
}



+ (JobmineApplicationDetail* ) fetchAndUpdateApplicationDetail: (TFHppleElement*) obj
                                                   forCategory: (CategoryListing) aCategory
                                            withManagedContext:(NSManagedObjectContext* ) aContext{
    
    //JobmineApplicationDetail* resultApplicationDetail = nil;
    NSNumber* jobmineID = @([((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:0]).content integerValue]);
    
    
    switch (aCategory) {
        case CategoryListingApplicationShortList:
        {
			applicationCreation createApplicationShortListAppFromObject = ^ JobmineApplicationDetail* (TFHppleElement* obj, NSManagedObjectContext* aContext){
				JobmineApplicationDetail* resultApplicationDetail = nil;
				NSString* appTitle = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:1]).content;
				NSString* appEmployeeName = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:2]).content;
				NSString* appEmployeeUnit = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content;
				NSString* appLocation = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
				NSString* appStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:5]).content;
				//TODO: add Date conversion
				//NSDate* appLDTA = nil;
				NSNumber* appNumberOfApplicatite = @([((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:7]).content integerValue]);
				resultApplicationDetail = [NSEntityDescription insertNewObjectForEntityForName:[@"" stringByAppendingFormat:@"%@",NSStringFromClass([JobmineApplicationDetail class])]
																		inManagedObjectContext:aContext];
				resultApplicationDetail.jID = jobmineID;
				resultApplicationDetail.jobTitle = appTitle;
				resultApplicationDetail.employer = appEmployeeName;
				resultApplicationDetail.employmentUnit = appEmployeeUnit;
				resultApplicationDetail.employmentLocation = appLocation;
				resultApplicationDetail.jobStatus = appStatus;
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
			
		case CategoryListingActiveApplicationList:
			//TODO: need to add CategoryListingActiveApplicationList
			break;
		case CategoryListingAllApplicationList:
		{
			applicationCreation createAllApplicationListAppFromObject = ^ JobmineApplicationDetail* (TFHppleElement* obj, NSManagedObjectContext* aContext){
				JobmineApplicationDetail* resultApplicationDetail = nil;
				NSString* appTitle = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:1]).content;
				NSString* appEmployeeName = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:2]).content;
				NSString* appEmployeeUnit = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:3]).content;
				//NSString* appLocation = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
				NSString* appWorkTerm = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:4]).content;
				NSString* appStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:5]).content;
				NSString* appApplicatoinStatus = ((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:6]).content;
				//TODO: add Date conversion
				//NSDate* appLDTA = nil;
				NSNumber* appNumberOfApplicatite = @([((TFHppleElement*)[((TFHppleElement*)obj).children objectAtIndex:9]).content integerValue]);
				resultApplicationDetail = [NSEntityDescription insertNewObjectForEntityForName:[@"" stringByAppendingFormat:@"%@",NSStringFromClass([JobmineApplicationDetail class])]
																		inManagedObjectContext:aContext];
				resultApplicationDetail.jID = jobmineID;
				resultApplicationDetail.jobTitle = appTitle;
				resultApplicationDetail.employer = appEmployeeName;
				resultApplicationDetail.employmentUnit = appEmployeeUnit;
				resultApplicationDetail.workingTerm = appWorkTerm;
				//resultApplicationDetail.employmentLocation = appLocation;
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
            
        default:
            break;
    }
    
    return nil;
}





@end
