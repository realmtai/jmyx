//
//  jobmineAllApplicationCell.h
//  jobmineM
//
//  Created by edwin on 10/5/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jobmineAllApplicationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobApplicationName;
@property (weak, nonatomic) IBOutlet UILabel *jobEmployeerName;
@property (weak, nonatomic) IBOutlet UILabel *jobNumberOfOpenningVSNumberOfApplicant;
@property (weak, nonatomic) IBOutlet UILabel *jobLastDayToApply;
@property (weak, nonatomic) IBOutlet UILabel *jobApplyStatus;
@property (weak, nonatomic) IBOutlet UILabel *jobJobStatus;
@property (weak, nonatomic) IBOutlet UILabel *jobApplicationStatus;


@end
