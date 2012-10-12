//
//  JobDescriptionViewController.m
//  Jobmine Mobile
//
//  Created by edwin on 10/8/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "JobDescriptionViewController.h"

@interface JobDescriptionViewController () <jobmineNetworkDelegate>

@end

@implementation JobDescriptionViewController



- (void) viewDidLoad{
	[super viewDidLoad];
	[self.jobmine updateApplicationDetailWithAppInfo:self.JobInfo withResponser:self];
}

- (void) viewWillAppear:(BOOL)animated{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController setToolbarHidden:YES animated:YES];
	[super viewWillAppear:animated];
}


- (void) viewWillDisappear:(BOOL)animated{
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[self.navigationController setToolbarHidden:NO animated:YES];
	[super viewWillDisappear:animated];
	
}

- (void)viewDidUnload {
	[self setJobDescriptionViewer:nil];
	[super viewDidUnload];
}


#pragma marks - jobmineNetworkDelegate



- (void) jobmineLoadDataReachEndState: (jobmineApi*) jobmine withHTMLString: (NSString* ) aHTMLString{
	[self.jobDescriptionViewer loadHTMLString:aHTMLString baseURL:nil];
}



@end
