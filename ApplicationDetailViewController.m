//
//  ApplicationDetailViewController.m
//  Jobmine Mobile
//
//  Created by edwin on 10/8/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "ApplicationDetailViewController.h"
#import "JobmineApplicationDetail.h"
#import "JobDescriptionViewController.h"

@interface ApplicationDetailViewController ()

@property (nonatomic, weak) NSArray* ApplicationDetailDictionary;





@end

@implementation ApplicationDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UITableViewCell* aDescriptionButton = [self.tableView dequeueReusableCellWithIdentifier:@"header"];
	aDescriptionButton.textLabel.text = [[self jobInfo] refreToApplication].jobTitle;
	self.tableView.tableHeaderView = aDescriptionButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	[super prepareForSegue:segue sender:sender];
	if ([segue.destinationViewController isKindOfClass:[JobDescriptionViewController class]]) {
//		.jobmine = self.jobmine;
		[((JobDescriptionViewController*) segue.destinationViewController) setJobmine:self.jobmine];
		[((JobDescriptionViewController*) segue.destinationViewController) setJobInfo:self.jobInfo];
		
	}
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    // Return the number of rows in the section.
    return [[self ApplicationDetailArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"standardDisplayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	NSString* stringTitle = [[[self ApplicationDetailArray] objectAtIndex:[indexPath row]] name];
	
	id answerToTitle = [[[self jobInfo] refreToApplication] valueForKey:stringTitle];
    
	cell.textLabel.text = stringTitle;
	cell.detailTextLabel.text = [answerToTitle description];
	
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
	NSString* stringTitle = [[[self ApplicationDetailArray] objectAtIndex:[indexPath row]] name];
	id answerToTitle = [[[self jobInfo] refreToApplication] valueForKey:stringTitle];
	[[[UIAlertView alloc] initWithTitle:stringTitle message:[answerToTitle description] delegate:nil cancelButtonTitle:@"kk" otherButtonTitles: nil] show];
	
}


#pragma mark - getter & setter

- (NSArray* ) ApplicationDetailArray{
	if (!_ApplicationDetailDictionary) {
		_ApplicationDetailDictionary = [[[[self jobInfo] refreToApplication] entity] properties];
	}
	return _ApplicationDetailDictionary;
}


@end
