//
//  JobDescriptionViewController.h
//  Jobmine Mobile
//
//  Created by edwin on 10/8/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobmineApi.h"
#import "JobmineInfo.h"

@interface JobDescriptionViewController : UIViewController


@property (strong, nonatomic) jobmineApi* jobmine;


@property (weak, nonatomic) IBOutlet UIWebView *jobDescriptionViewer;
@property (weak, nonatomic) UIButton* bugButton;
@property (weak, nonatomic) JobmineInfo* JobInfo;

@end
