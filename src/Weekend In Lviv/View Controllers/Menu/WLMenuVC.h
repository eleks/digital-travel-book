//
//  WLMenuVC.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/13/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLMenuVC : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *filteredSource;
@property (strong, nonatomic) WLHomeVC *detailView;
@end
