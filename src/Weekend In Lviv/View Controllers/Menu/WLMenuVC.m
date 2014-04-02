//
//  WLMenuVC.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/13/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "WLHomeVC.h"
#import "WLMenuVC.h"
#import "WLMenuCell.h"
#import "WLMenuHeaderView.h"
#import "WLAboutVC.h"
#import "WLDataManager.h"
#import "WLPlace.h"
#import "WLTextBlock.h"


NS_ENUM(NSUInteger, WLMenuSection) {
    WLMenuSectionHome = 0,
    WLMenuSectionArticles,
    WLMenuSectionAbout,
    WLMenuSectionNumberOfSection
};


@interface WLMenuVC ()


@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic) BOOL searchActive;

@end


@implementation WLMenuVC


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.filteredSource = [[NSMutableArray alloc] init];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)]; // frame has no effect.
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;

    [self.searchDisplayController setActive:NO animated:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:@"ArticleStatusChanged" object:nil];

    for (UIView *subview in self.searchDisplayController.searchBar.subviews) {
        if ([subview conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *) subview setClearButtonMode:UITextFieldViewModeNever];
        }
    }

    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = RGB(48, 23, 0);
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        self.searchActive = YES;
        [self.filteredSource removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText];
        for (WLPlace *place in [WLDataManager sharedManager].placesList) {
            if ([predicate evaluateWithObject:place.title]) {
                [self.filteredSource addObject:place];
            }
            else {
                for (WLTextBlock *block in place.placesTextBlocks) {
                    if ([predicate evaluateWithObject:block.blockTitle]) {
                        [self.filteredSource addObject:place];
                        break;
                    }
                }
            }
        }
    }
    else {
        self.searchActive = NO;
    }
    [self.tableView reloadData];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

}


#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return WLMenuSectionNumberOfSection;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == WLMenuSectionHome) {
        return 1;
    }
    if (section == WLMenuSectionAbout) {
        return 1;
    }
    if (self.searchActive) {
        return [self.filteredSource count];
    }
    return [[WLDataManager sharedManager].placesList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"Cell";
    WLMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WLMenuCell" owner:nil options:nil][0];
    }
    if (indexPath.section == WLMenuSectionHome) {
        cell.imgFavoriteFlag.hidden = YES;
        cell.imgIcon.image = [UIImage imageNamed:@"FakeMenuItem"];
        cell.lblTitle.text = @"Home";
    }
    else if (indexPath.section == WLMenuSectionAbout) {
        cell.imgFavoriteFlag.hidden = YES;
        cell.imgIcon.image = [UIImage imageNamed:@"image_about"];
        cell.lblTitle.text = @"About";
    }
    else {
        WLPlace *place = nil;
        if (self.searchActive) {
            place = (self.filteredSource)[(NSUInteger) indexPath.row];
        }
        else {
            place = ([WLDataManager sharedManager].placesList)[(NSUInteger) indexPath.row];
        }
        cell.lblTitle.text = [place.title capitalizedString];
        [cell.imgIcon setImage:[[WLDataManager sharedManager] imageWithPath:place.placeMenuImagePath]];
        cell.imgFavoriteFlag.hidden = !place.placeFavourite;
    }

    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = RGB(58, 33, 10);
    cell.selectedBackgroundView = selectedView;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == WLMenuSectionHome) {
        return 0;
    }
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WLMenuHeaderView *headerView = nil;

    switch (section) {
        case WLMenuSectionArticles:
            headerView = [[NSBundle mainBundle] loadNibNamed:@"WLMenuHeaderView" owner:nil options:nil][0];
            [headerView setTitle:@"Architecture"];
            break;
        case WLMenuSectionAbout:
            headerView = [[NSBundle mainBundle] loadNibNamed:@"WLMenuHeaderView" owner:nil options:nil][0];
            [headerView setTitle:@"About"];
            break;
        case WLMenuSectionHome:

            break;
        default:
            break;
    }

    return headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    WLPlace *newPlace = nil;
    switch (indexPath.section) {
        case WLMenuSectionArticles:
            if (self.searchActive) {
                newPlace = (self.filteredSource)[(NSUInteger) indexPath.row];
                NSUInteger index = [[WLDataManager sharedManager].placesList indexOfObject:newPlace];
                [self.detailView switchToViewControllerWithIndex:index animated:YES];
            }
            else {
                [self.detailView switchToViewControllerWithIndex:(NSUInteger) indexPath.row animated:YES];
            }
            break;
        case WLMenuSectionHome:
            [self.detailView popToRootAnimated:YES];
            break;
        case WLMenuSectionAbout:
            if (![[self.detailView.navigationController topViewController] isMemberOfClass:[WLAboutVC class]]) {
                WLAboutVC *aboutVC = [[WLAboutVC alloc] initWithNibName:@"WLAboutVC" bundle:nil];
                [self.detailView.navigationController pushViewController:aboutVC animated:YES];
            }
            break;
        default:
            break;
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
