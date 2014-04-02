//
//  WLMenuCell.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/14/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WLMenuCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgFavoriteFlag;
@end
