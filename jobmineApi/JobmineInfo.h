//
//  JobmineInfo.h
//  jobmineM
//
//  Created by edwin on 9/28/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JobmineApplicationDetail;

@interface JobmineInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * applicationListing;
@property (nonatomic, retain) NSNumber * jID;
@property (nonatomic, retain) NSNumber * isFavourite;
@property (nonatomic, retain) JobmineApplicationDetail *refreToApplication;

@end
