//
//  JobmineApplicationDetail.h
//  Jobmine Mobile
//
//  Created by edwin on 10/18/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JobmineInfo;

@interface JobmineApplicationDetail : NSManagedObject

@property (nonatomic, retain) NSString * applicationStatus;
@property (nonatomic, retain) NSString * employer;
@property (nonatomic, retain) NSString * employmentLocation;
@property (nonatomic, retain) NSString * employmentUnit;
@property (nonatomic, retain) NSDate * interviewDate;
@property (nonatomic, retain) NSString * interviewer;
@property (nonatomic, retain) NSString * interviewInstructions;
@property (nonatomic, retain) NSNumber * interviewLength;
@property (nonatomic, retain) NSString * interviewRoom;
@property (nonatomic, retain) NSString * interviewType;
@property (nonatomic, retain) NSNumber * isFavourite;
@property (nonatomic, retain) NSNumber * jID;
@property (nonatomic, retain) NSString * jobDescription;
@property (nonatomic, retain) NSString * jobStatus;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSDate * lastDayToApply;
@property (nonatomic, retain) NSNumber * numberOfApplications;
@property (nonatomic, retain) NSNumber * numberOfOpennings;
@property (nonatomic, retain) NSString * workingTerm;
@property (nonatomic, retain) NSDate * groupInterviewDate;
@property (nonatomic, retain) NSString * groupInterviewRoom;
@property (nonatomic, retain) NSString * groupInterviewInstruction;
@property (nonatomic, retain) NSString * spicalRequestInstruction;
@property (nonatomic, retain) NSSet *inTheseCategory;
@end

@interface JobmineApplicationDetail (CoreDataGeneratedAccessors)

- (void)addInTheseCategoryObject:(JobmineInfo *)value;
- (void)removeInTheseCategoryObject:(JobmineInfo *)value;
- (void)addInTheseCategory:(NSSet *)values;
- (void)removeInTheseCategory:(NSSet *)values;

@end
