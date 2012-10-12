//
//  applicationShortListCell.h
//  jobmineM
//
//  Created by edwin on 9/23/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jobmineApplicationShortListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobApplicationName;
@property (weak, nonatomic) IBOutlet UILabel *jobEmployeerName;
@property (weak, nonatomic) IBOutlet UILabel *jobNumberOfOpenningVSNumberOfApplicant;
@property (weak, nonatomic) IBOutlet UILabel *jobLastDayToApply;


@end
