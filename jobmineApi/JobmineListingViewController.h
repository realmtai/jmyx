//
//  JobmineListingViewController.h
//  jobmineM
//
//  Created by edwin on 8/27/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "jobmineApi.h"


@interface JobmineListingViewController : CoreDataTableViewController <UIActionSheetDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) jobmineApi* jobmine;
- (IBAction) updateListing:(id)sender;
- (IBAction)refreshButtomPressed:(UIBarButtonItem *)sender;
- (IBAction)logoutButtom:(UIBarButtonItem *)sender;

@end
