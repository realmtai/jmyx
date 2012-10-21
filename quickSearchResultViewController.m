//
//  quickSearchResultViewController.m
//  Jobmine Mobile
//
//  Created by edwin on 10/20/12.
//  Copyright (c) 2012 edwin. All rights reserved.
//

#import "quickSearchResultViewController.h"
#import "jobmineCellConfigetor.h"

@interface quickSearchResultViewController ()

@property (strong, nonatomic) NSDictionary* jobmineSectionNumberToUICellIDTranslationTable;
@property (strong, nonatomic) NSFetchRequest* quickSearch;

@end

@implementation quickSearchResultViewController

NSString*const tempNotificationRequestContext = @"tempNotificationRequestContext";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UISearchDisplayDelegate

- (void)setupFetchedRequestController {
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.quickSearch managedObjectContext:self.applicationListingController.jobmine.jobmineDoc.managedObjectContext sectionNameKeyPath:@"applicationListing" cacheName:nil];
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
	
	if (!self.applicationListingController) {
		[self requestSearchContext];
	}else{
		
	}
	
}

#pragma mark - temp NScontext fix
- (void) requestSearchContext{
	[[NSNotificationCenter defaultCenter] postNotificationName:tempNotificationRequestContext object:self];
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
	//self.quickSearch.predicate = [NSPredicate predicateWithFormat:@"refreToApplication.jobTitle contains %@", searchString];
	[self performFetch];
	return YES;
}

/*
 
 
 @protocol UISearchDisplayDelegate <NSObject>
 
 @optional
 
 // when we start/end showing the search UI
 - (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller;
 - (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller;
 - (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller;
 
 // called when the table is created destroyed, shown or hidden. configure as necessary.
 - (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView;
 - (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
 
 // called when table is shown/hidden
 - (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView;
 - (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView;
 - (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView;
 - (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView;
 
 // return YES to reload table. called when search string/option changes. convenience methods on top UISearchBar delegate methods
 - (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption;
 
 @end
 
 */



- (UITableViewCell* ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [jobmineCellConfigetor configCellForTable:self.applicationListingController.tableView
										forIndexPath:indexPath
										   forDetail:[self.fetchedResultsController objectAtIndexPath:indexPath]
						  withUICellTranslationTable:self.jobmineSectionNumberToUICellIDTranslationTable];
}




#pragma mark - getter & setter

- (NSDictionary* ) jobmineSectionNumberToUICellIDTranslationTable{
	if (!_jobmineSectionNumberToUICellIDTranslationTable) {
		_jobmineSectionNumberToUICellIDTranslationTable = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jobmineSectionNumberToUICellID" ofType:@"plist"]];
	}
	return _jobmineSectionNumberToUICellIDTranslationTable;
}

- (void) setApplicationListingController:(JobmineListingViewController *)applicationDetail{
	_applicationListingController = applicationDetail;
	
	if (!_applicationListingController.jobmine.jobmineDoc.managedObjectContext) {
		[self setupFetchedRequestController];
	}
}


- (NSFetchRequest*) quickSearch{
	if (!_quickSearch) {
		_quickSearch = [NSFetchRequest fetchRequestWithEntityName:@"JobmineInfo"];
		_quickSearch.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"applicationListing" ascending:NO]];
	}
	return _quickSearch;
}

@end
