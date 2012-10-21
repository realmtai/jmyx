//
//  quickSearchResultViewController.h
//  Jobmine Mobile
//
//  Created by edwin on 10/20/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "JobmineListingViewController.h"
#import "jobmineApi.h"

@interface quickSearchResultViewController : CoreDataTableViewController <UISearchDisplayDelegate>

extern NSString*const tempNotificationRequestContext;

@property (nonatomic, weak) JobmineListingViewController* applicationListingController;

@end
