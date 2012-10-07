//
//  jobmineDictionary.m
//  jobmineApi
//
//  Created by edwin on 8/19/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "jobmineDictionary.h"

@implementation jobmineDictionary


NSString*const jobmineDomainURL = @"https://jobmine.ccol.uwaterloo.ca";
NSString*const jobmineLoginURL = @"https://jobmine.ccol.uwaterloo.ca/psp/SS/?cmd=login&languageCd=ENG&sessionId=";
NSString*const jobmineApplicationDetailURL = @"https://jobmine.ccol.uwaterloo.ca/psc/SS/EMPLOYEE/WORK/c/UW_CO_STUDENTS.UW_CO_JOBDTLS.GBL";

NSString*const jobmineResumeURL = @"https://jobmine.ccol.uwaterloo.ca/psc/SS/EMPLOYEE/WORK/c/UW_CO_STUDENTS.UW_CO_STUDDOCS.GBL";
NSString*const jobmineSearchURL = @"https://jobmine.ccol.uwaterloo.ca/psc/SS/EMPLOYEE/WORK/c/UW_CO_STUDENTS.UW_CO_JOBSRCH.GBL";
NSString*const jobmineApplicationShortListURL = @"https://jobmine.ccol.uwaterloo.ca/psc/SS/EMPLOYEE/WORK/c/UW_CO_STUDENTS.UW_CO_JOB_SLIST.GBL";
NSString*const jobmineApplicationListURL = @"https://jobmine.ccol.uwaterloo.ca/psc/SS/EMPLOYEE/WORK/c/UW_CO_STUDENTS.UW_CO_APP_SUMMARY.GBL";
NSString*const jobmineInterviewURL = @"https://jobmine.ccol.uwaterloo.ca/psc/SS/EMPLOYEE/WORK/c/UW_CO_STUDENTS.UW_CO_STU_INTVS.GBL";
NSString*const jobmineRankingURL = @"https://jobmine.ccol.uwaterloo.ca/psc/SS/EMPLOYEE/WORK/c/UW_CO_STUDENTS.UW_CO_STU_RNK2.GBL";





NSString*const jobminePostICActionSearchButtonPressed = @"UW_CO_JOBSRCHDW_UW_CO_DW_SRCHBTN";
NSString*const jobminePostICActionSearchExport= @"UW_CO_JOBRES_VW$hexcel$0";

//TODO: need to add sort request that sort entry, but for now just dont sort
NSString*const jobminePostICActionApplicationSort0ShortList= @"UW_CO_STUJOBLST$srt0$0";
NSString*const jobminePostICActionApplicationShortList= @"UW_CO_STUJOBLST$hexcel$0";

NSString*const jobminePostICActionAllApplication= @"UW_CO_APPS_VW2$hexcel$0";
NSString*const jobminePostICActionActiveApplication= @"UW_CO_STU_APPSV$hexcel$0";

NSString*const jobminePostICActionInterview= @"UW_CO_STUD_INTV$hexcel$0";
NSString*const jobminePostICActionGroupedInterview= @"UW_CO_GRP_STU_V$hexcel$0";
NSString*const jobminePostICActionSpcialRequestInterview= @"UW_CO_NSCHD_JOB$hexcel$0";
NSString*const jobminePostICActionCanceledInterview= @"UW_CO_SINT_CANC$hexcel$0";

NSString*const jobminePostICActionRanking= @"UW_CO_STU_RNKV2$hexcel$0";







@end
