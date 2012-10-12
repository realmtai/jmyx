//
//  ApplicationDetailViewController.h
//  Jobmine Mobile
//
//  Created by edwin on 10/8/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobmineApi.h"
#import "JobmineInfo.h"

@interface ApplicationDetailViewController : UITableViewController

@property (nonatomic, strong) JobmineInfo* jobInfo;
@property (nonatomic, strong) jobmineApi* jobmine;

@property (weak, nonatomic) UIButton* bugButton;


@end
