//
//  jobmineGroupedInterviewCell.h
//  Jobmine Mobile
//
//  Created by edwin on 10/17/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jobmineGroupedInterviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobApplicationName;
@property (weak, nonatomic) IBOutlet UILabel *jobEmployeerName;
@property (weak, nonatomic) IBOutlet UILabel *jobNumberOfOpenningVSNumberOfApplicant;
@property (weak, nonatomic) IBOutlet UILabel *jobInterviewRoom;
@property (weak, nonatomic) IBOutlet UILabel *jobInterviewStartingTime;
//@property (weak, nonatomic) IBOutlet UILabel *jobInterviewDuriection;
//@property (weak, nonatomic) IBOutlet UILabel *jobInterviewer;

@end
