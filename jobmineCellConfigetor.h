//
//  jobmineCellConfigetor.h
//  jobmineM
//
//  Created by edwin on 9/23/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JobmineInfo.h"

@interface jobmineCellConfigetor : NSObject



+ (UITableViewCell*) configCellForTable: (UITableView*) aTableView forIndexPath: (NSIndexPath *) aIndexPath forDetail: (JobmineInfo*) aApplicationInfo withUICellTranslationTable: (NSDictionary*) aTranslationTable;


@end
