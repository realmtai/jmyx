//
//  jobmineCellConfigetor.m
//  jobmineM
//
//  Created by edwin on 9/23/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "jobmineCellConfigetor.h"
#import "JobmineApplicationDetail.h"
#import "jobmineApi.h"

#import "jobmineApplicationShortListCell.h"
#import "jobmineAllApplicationCell.h"
#import "jobmineSingleInterviewCell.h"
#import "jobmineGroupedInterviewCell.h"
#import "jobmineCancelledCell.h"
#import "jobmineSpcialRequestInterviewCell.h"



@interface jobmineCellConfigetor ()




@end






@implementation jobmineCellConfigetor




+ (UITableViewCell *)configApplicationShortListCell:(UITableView *)aTableView
							 forDetailedApplication:(JobmineInfo *)aApplicationInfo
							   withTranslationTable: (NSDictionary*) aTranslationTable{
	
    UITableViewCell *resultCell;
	JobmineApplicationDetail* aDetailedApplication = aApplicationInfo.refreToApplication;
	NSNumber* jobSectionNumber = aApplicationInfo.applicationListing;
    jobmineApplicationShortListCell *cell = [aTableView dequeueReusableCellWithIdentifier:[aTranslationTable objectForKey:[jobSectionNumber stringValue]]];
    cell.jobApplicationName.text = aDetailedApplication.jobTitle;
    cell.jobEmployeerName.text = aDetailedApplication.employer;
	cell.jobNumberOfOpenningVSNumberOfApplicant.text = [NSString stringWithFormat:@"%@/%@",
												   ((aDetailedApplication.numberOfOpennings.intValue == 0)?@"?":aDetailedApplication.numberOfOpennings),
												   ((aDetailedApplication.numberOfApplications.intValue == 0)?@"?":aDetailedApplication.numberOfApplications)];
    resultCell = cell;
    return resultCell;
}


+ (UITableViewCell *)configAllApplicationCell:(UITableView *)aTableView
					   forDetailedApplication:(JobmineInfo *)aApplicationInfo
						 withTranslationTable: (NSDictionary*) aTranslationTable{
    UITableViewCell *resultCell;
	JobmineApplicationDetail* aDetailedApplication = aApplicationInfo.refreToApplication;
	NSNumber* jobSectionNumber = aApplicationInfo.applicationListing;
    jobmineAllApplicationCell *cell = [aTableView dequeueReusableCellWithIdentifier:[aTranslationTable objectForKey:[jobSectionNumber stringValue]]];
    cell.jobApplicationName.text = aDetailedApplication.jobTitle;
    cell.jobEmployeerName.text = aDetailedApplication.employer;
	cell.jobNumberOfOpenningVSNumberOfApplicant.text = [NSString stringWithFormat:@"%@/%@",
														((aDetailedApplication.numberOfOpennings.intValue == 0)?@"?":aDetailedApplication.numberOfOpennings),
														((aDetailedApplication.numberOfApplications.intValue == 0)?@"?":aDetailedApplication.numberOfApplications)];
	cell.jobJobStatus.text = aDetailedApplication.jobStatus;
	cell.jobApplicationStatus.text = aDetailedApplication.applicationStatus;
	
    resultCell = cell;
    return resultCell;
}


+ (UITableViewCell *)configSingleInterviewCell:(UITableView *)aTableView
						forDetailedApplication:(JobmineInfo *)aApplicationInfo
						  withTranslationTable: (NSDictionary*) aTranslationTable{
    UITableViewCell *resultCell;
	JobmineApplicationDetail* aDetailedApplication = aApplicationInfo.refreToApplication;
	NSNumber* jobSectionNumber = aApplicationInfo.applicationListing;
    jobmineSingleInterviewCell *cell = [aTableView dequeueReusableCellWithIdentifier:[aTranslationTable objectForKey:[jobSectionNumber stringValue]]];
    cell.jobApplicationName.text = aDetailedApplication.jobTitle;
    cell.jobEmployeerName.text = aDetailedApplication.employer;
	cell.jobNumberOfOpenningVSNumberOfApplicant.text = [NSString stringWithFormat:@"%@/%@",
														((aDetailedApplication.numberOfOpennings.intValue == 0)?@"?":aDetailedApplication.numberOfOpennings),
														((aDetailedApplication.numberOfApplications.intValue == 0)?@"?":aDetailedApplication.numberOfApplications)];
	
	NSDateFormatter* aDateFormator = [NSDateFormatter new];
	[aDateFormator setDateStyle:NSDateFormatterShortStyle];
	[aDateFormator setTimeStyle:NSDateFormatterShortStyle];
	cell.jobInterviewStartingTime.text = [aDateFormator stringFromDate:aDetailedApplication.interviewDate];
	cell.jobInterviewDuriection.text = [aDetailedApplication.interviewLength description];
	cell.jobInterviewer.text = aDetailedApplication.interviewer;
	cell.jobInterviewRoom.text = aDetailedApplication.interviewRoom;
	
	//	cell.jobJobStatus.text = aDetailedApplication.jobStatus;
	//	cell.jobApplicationStatus.text = aDetailedApplication.applicationStatus;
	
    resultCell = cell;
    return resultCell;
}
+ (UITableViewCell *)configGroupedInterviewCell:(UITableView *)aTableView
						 forDetailedApplication:(JobmineInfo *)aApplicationInfo
						   withTranslationTable: (NSDictionary*) aTranslationTable{
    UITableViewCell *resultCell;
	JobmineApplicationDetail* aDetailedApplication = aApplicationInfo.refreToApplication;
	NSNumber* jobSectionNumber = aApplicationInfo.applicationListing;
    jobmineGroupedInterviewCell *cell = [aTableView dequeueReusableCellWithIdentifier:[aTranslationTable objectForKey:[jobSectionNumber stringValue]]];
    cell.jobApplicationName.text = aDetailedApplication.jobTitle;
    cell.jobEmployeerName.text = aDetailedApplication.employer;
	cell.jobNumberOfOpenningVSNumberOfApplicant.text = [NSString stringWithFormat:@"%@/%@",
														((aDetailedApplication.numberOfOpennings.intValue == 0)?@"?":aDetailedApplication.numberOfOpennings),
														((aDetailedApplication.numberOfApplications.intValue == 0)?@"?":aDetailedApplication.numberOfApplications)];
	
	NSDateFormatter* aDateFormator = [NSDateFormatter new];
	[aDateFormator setDateStyle:NSDateFormatterShortStyle];
	[aDateFormator setTimeStyle:NSDateFormatterShortStyle];
	cell.jobInterviewStartingTime.text = [aDateFormator stringFromDate:aDetailedApplication.groupInterviewDate];
	cell.jobInterviewRoom.text = aDetailedApplication.groupInterviewRoom;
	//	cell.jobJobStatus.text = aDetailedApplication.jobStatus;
	//	cell.jobApplicationStatus.text = aDetailedApplication.applicationStatus;
	
    resultCell = cell;
    return resultCell;
}


+ (UITableViewCell *)configCancelledInterviewCell:(UITableView *)aTableView
						   forDetailedApplication:(JobmineInfo *)aApplicationInfo
							 withTranslationTable: (NSDictionary*) aTranslationTable{
    UITableViewCell *resultCell;
	JobmineApplicationDetail* aDetailedApplication = aApplicationInfo.refreToApplication;
	NSNumber* jobSectionNumber = aApplicationInfo.applicationListing;
    jobmineCancelledCell *cell = [aTableView dequeueReusableCellWithIdentifier:[aTranslationTable objectForKey:[jobSectionNumber stringValue]]];
    cell.jobApplicationName.text = aDetailedApplication.jobTitle;
    cell.jobEmployeerName.text = aDetailedApplication.employer;
	//	cell.jobJobStatus.text = aDetailedApplication.jobStatus;
	//	cell.jobApplicationStatus.text = aDetailedApplication.applicationStatus;
	
    resultCell = cell;
    return resultCell;
}



+ (UITableViewCell *)configSpecialRequestInterviewCell:(UITableView *)aTableView
						   forDetailedApplication:(JobmineInfo *)aApplicationInfo
							 withTranslationTable: (NSDictionary*) aTranslationTable{
    UITableViewCell *resultCell;
	JobmineApplicationDetail* aDetailedApplication = aApplicationInfo.refreToApplication;
	NSNumber* jobSectionNumber = aApplicationInfo.applicationListing;
    jobmineSpcialRequestInterviewCell *cell = [aTableView dequeueReusableCellWithIdentifier:[aTranslationTable objectForKey:[jobSectionNumber stringValue]]];
    cell.jobApplicationName.text = aDetailedApplication.jobTitle;
    cell.jobEmployeerName.text = aDetailedApplication.employer;
	//	cell.jobJobStatus.text = aDetailedApplication.jobStatus;
	//	cell.jobApplicationStatus.text = aDetailedApplication.applicationStatus;
	
    resultCell = cell;
    return resultCell;
}



+ (UITableViewCell*) configCellForTable: (UITableView*) aTableView forIndexPath: (NSIndexPath *) aIndexPath forDetail: (JobmineInfo*) aApplicationInfo withUICellTranslationTable: (NSDictionary*) aTranslationTable{
	
    switch (aApplicationInfo.applicationListing.intValue) {
		case CategoryListingApplicationShortList:
			return [self configApplicationShortListCell:aTableView
								 forDetailedApplication:aApplicationInfo
								   withTranslationTable:aTranslationTable];
        case CategoryListingAllApplicationList:
			return [self configAllApplicationCell:aTableView
						   forDetailedApplication:aApplicationInfo
							 withTranslationTable:aTranslationTable];
        case CategoryListingSinglePersonInterview:
			return [self configSingleInterviewCell:aTableView
							forDetailedApplication:aApplicationInfo
							  withTranslationTable:aTranslationTable];
        case CategoryListingGroupInterview:
			return [self configGroupedInterviewCell:aTableView
							 forDetailedApplication:aApplicationInfo
							  withTranslationTable:aTranslationTable];
        case CategoryListingCencelledInterview:
			return [self configCancelledInterviewCell:aTableView
							   forDetailedApplication:aApplicationInfo
								 withTranslationTable:aTranslationTable];
        case CategoryListingSpecialRequestInterview:
			return [self configCancelledInterviewCell:aTableView
							   forDetailedApplication:aApplicationInfo
								 withTranslationTable:aTranslationTable];
        default:
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Failed"];
    }
}


@end
