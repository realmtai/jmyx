//
//  JobmineListingViewController.m
//  jobmineM
//
//  Created by edwin on 8/27/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

#import "JobmineListingViewController.h"
#import "JobmineInfo.h"
#import "jobmineApplicationShortListCell.h"
#import "JobmineApplicationDetail.h"
#import "jobmineCellConfigetor.h"

#import "ApplicationDetailViewController.h"

@interface JobmineListingViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *jobmineTableView;
@property (weak, nonatomic) UIButton* reportBugButton;
@property (weak, nonatomic) MFMailComposeViewController* reportABugController;

@property (strong, nonatomic) NSDictionary* sectionHeaderTianslationDictionary;
@property (strong, nonatomic) NSDictionary* jobmineSectionNumberToUICellIDTranslationTable;


@end

@implementation JobmineListingViewController


#pragma mark - Life cycle

- (void) awakeFromNib{
    [super awakeFromNib];
    _jobmine = [[jobmineApi alloc] init];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jobmineAcceptingRequest:) name:JobmineNotificationAccpetingRequest object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNSFetchRequestController) name:JobmineNotificationDocumentIsReady object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(askUserForUserNameAndPassWord) name:JobmineNotificationLoginInfoIncorrect object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.jobmine updateLoginInfo];
    self.tableView.tableFooterView = [self.tableView dequeueReusableCellWithIdentifier:@"footerView"];
	
	
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	__block UIWindow* mainWindow = nil;
	[[[UIApplication sharedApplication] windows] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (obj == self.view.window) {
			mainWindow = obj;
		}
	}];
	[self addReportBugButtonForWindow:mainWindow withActionResponseObject:self withSelector:@selector(reportBugButtonPressed:)];
//	[[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.reportBugButton];
}

- (void)viewDidUnload
{
	[self setJobmineTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL) shouldAutorotate{
	return YES;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
	return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations{
	return UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	CGFloat shouldRoateToDegee = 0;
	switch (toInterfaceOrientation) {
		case UIInterfaceOrientationPortrait:
			shouldRoateToDegee = 0;
			break;
			
		case UIInterfaceOrientationPortraitUpsideDown:
			shouldRoateToDegee = M_PI;
			break;
			
		case UIInterfaceOrientationLandscapeLeft:
			
			shouldRoateToDegee = -M_PI_2;
			break;
			
		case UIInterfaceOrientationLandscapeRight:
			
			shouldRoateToDegee = M_PI_2;
			break;
			
		default:
			break;
	}
	
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		[self.reportBugButton setTransform:CGAffineTransformMakeRotation(shouldRoateToDegee)];
	} completion:^(BOOL finished) {
		
	}];
	
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.fetchedResultsController.sections objectAtIndex:section] count];
}
*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	JobmineInfo* aCellReq= [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSString* cellID = [self.jobmineSectionNumberToUICellIDTranslationTable objectForKey:aCellReq.applicationListing.stringValue];
	UITableViewCell* aTableCell = [tableView dequeueReusableCellWithIdentifier:cellID];
	return aTableCell.frame.size.height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSString* Header = [super tableView:tableView titleForHeaderInSection:section];
	return [self.sectionHeaderTianslationDictionary objectForKey:Header];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    return [jobmineCellConfigetor configCellForTable:tableView
										forIndexPath:indexPath
										   forDetail:[self.fetchedResultsController objectAtIndexPath:indexPath]
						  withUICellTranslationTable:self.jobmineSectionNumberToUICellIDTranslationTable];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	 if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}






#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
		case 0:
			[self.jobmine updateLoginInfo];
			break;
        case 1:
            [self.jobmine updateSessionsWithListing:CategoryListingApplicationShortList];
            break;
        case 2:
            [self.jobmine updateSessionsWithListing:CategoryListingAllApplicationList];
            break;
            
        default:
            break;
    }
}


#pragma mark - UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView alertViewStyle] == UIAlertViewStyleLoginAndPasswordInput) {
        [self.jobmine loginToJobmineWithUserName:[alertView textFieldAtIndex:0].text
									 andPassWord:[alertView textFieldAtIndex:1].text];
    }else if ([alertView alertViewStyle] == UIAlertViewStyleDefault){
		if (buttonIndex == 1) {
			[self.jobmine removeUserInfo];
		}
	}
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[self.navigationController setToolbarHidden:YES animated:YES];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (!decelerate) {
		[self.navigationController setToolbarHidden:NO animated:YES];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	[self.navigationController setToolbarHidden:NO animated:YES];
	
}


#pragma mark - MFMailComposeViewControllerDelegate


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissModalViewControllerAnimated:YES];
	self.reportBugButton.hidden = NO;
}


#pragma mark - setter & getter


- (jobmineApi* ) jobmine{
    if (!_jobmine) {
        _jobmine = [[jobmineApi alloc] init];
    }
    return _jobmine;
}


- (void) setupNSFetchRequestController{
    
    NSFetchRequest* fetchAllListing = [NSFetchRequest fetchRequestWithEntityName:@"JobmineInfo"];
    fetchAllListing.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"applicationListing" ascending:NO]];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchAllListing managedObjectContext:[self jobmine].jobmineDoc.managedObjectContext sectionNameKeyPath:@"applicationListing" cacheName:nil];
    
    
}

/*
- (void) jobmineAcceptingRequest: (NSNotification*) aNotification {
    
    [self.jobmine updateSessionsWithListing:CategoryListingApplicationShortList];
}
*/
- (NSDictionary*) sectionHeaderTianslationDictionary{
	if (!_sectionHeaderTianslationDictionary) {
		_sectionHeaderTianslationDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sectionHeaderTranslationDictionary" ofType:@"plist"]];
	}
	return _sectionHeaderTianslationDictionary;
}


- (NSDictionary* ) jobmineSectionNumberToUICellIDTranslationTable{
	if (!_jobmineSectionNumberToUICellIDTranslationTable) {
		_jobmineSectionNumberToUICellIDTranslationTable = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jobmineSectionNumberToUICellID" ofType:@"plist"]];
	}
	return _jobmineSectionNumberToUICellIDTranslationTable;
}


- (void) addReportBugButtonForWindow:(UIWindow*) aWindow withActionResponseObject: (id) anObject withSelector:(SEL) aSelector{
	if (!_reportBugButton) {
		UIButton* aReportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		
		CGFloat buttonWidth = 45;
		CGFloat buttonHeight = 30;
		aReportButton.frame = CGRectMake(aWindow.frame.size.width - buttonWidth - 10,
										 30,
										 buttonWidth, buttonHeight);
		[aReportButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
		[aReportButton setBackgroundImage:[UIImage imageNamed:@"bug.jpg"]
								 forState:UIControlStateNormal];
		
		[aReportButton.layer setCornerRadius:5.0f];
		[aReportButton setAlpha:0.8];
		[aReportButton setClipsToBounds:YES];
		[aReportButton addTarget:anObject action:aSelector forControlEvents:UIControlEventTouchUpInside];
		
		[aWindow addSubview:aReportButton];
		
		_reportBugButton = aReportButton;
	}
}

- (UIImage*)screenshot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
			
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
			
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
	
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return image;
}

- (MFMailComposeViewController* ) reportABugController{
	
	MFMailComposeViewController* atempController = nil;
	
	if (!_reportABugController) {
		UIImage* screenShoot = [self screenshot];
		
		atempController = [[MFMailComposeViewController alloc] init];
		atempController.mailComposeDelegate = self;
		[atempController setSubject:[NSString stringWithFormat:@"Bug - "]];
		[atempController setToRecipients:[NSArray arrayWithObjects:@"bugsjobmine1@gmail.com", nil]];
		[atempController addAttachmentData:UIImagePNGRepresentation(screenShoot) mimeType:@"image/png" fileName:@"Screen Shoot Of A Bug"];
		[atempController setMessageBody:@"Please describe the bug" isHTML:NO];
		_reportABugController = atempController;
	}
	
	return _reportABugController;
}


#pragma mark - UI Action Responses

//
//- (IBAction) updateListing:(id)sender{
//    [self.jobmine insertDummyEntry];
//}

- (IBAction)refreshButtomPressed:(UIBarButtonItem *)sender {
    UIActionSheet* refeshSheet = [[UIActionSheet alloc] initWithTitle:@"Category To Refresh" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:@"re-login",
								  @"Applocation Short List",
								  @"All Applocation",
								  nil];
    [refeshSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [refeshSheet showInView:self.view];
}

- (IBAction)logoutButtom:(UIBarButtonItem *)sender {
	
	UIAlertView* logoutAlertView = [[UIAlertView alloc] initWithTitle:@"Logout out of current device?"
								message:@""
							   delegate:nil
					  cancelButtonTitle:@"No"
					  otherButtonTitles:@"Yes", nil];
	logoutAlertView.delegate = self;
	[logoutAlertView show];
}

- (void) reportBugButtonPressed: (id) aSender{
	if ([MFMailComposeViewController canSendMail]) {
		self.reportBugButton.hidden = YES;
		MFMailComposeViewController* mailABug = [self reportABugController];
		[self.navigationController presentModalViewController:mailABug animated:YES];
//		[self presentModalViewController:mailABug animated:YES];
	}else{
		[[[UIAlertView alloc] initWithTitle:@"Your Device Can't Send Mail"
									message:@""
								   delegate:nil
						  cancelButtonTitle:@"ok?!"
						  otherButtonTitles: nil] show];
	}
	
}



- (void) askUserForUserNameAndPassWord{
    
    UIAlertView* askToLogin = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Please Enter Jobmine Login Info" delegate:self cancelButtonTitle:@"Login" otherButtonTitles: nil];
    [askToLogin setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [askToLogin show];
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	[super prepareForSegue:segue sender:sender];
	if ([sender isKindOfClass:[UITableViewCell class]] &&
		[[segue destinationViewController] respondsToSelector:@selector(setJobInfo:)]) {
		
	 	JobmineInfo* aJobInfo = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
		[[segue destinationViewController] setJobInfo:aJobInfo];
		[[segue destinationViewController] setJobmine:self.jobmine];
		
	}
}



@end
