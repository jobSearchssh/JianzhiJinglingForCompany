//
//  jobListTableViewCell.h
//  JianzhiJinglingForCompany
//
//  Created by Mac on 1/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    CELLSELECTED,
    CELLUNSELECTED
} CellStatus;

@interface jobListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

@property (weak, nonatomic) IBOutlet UIImageView *checkIconView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jobImageView;


@property int selectedFlag;
@end
