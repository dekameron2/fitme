//
//  ProfileTableViewCell.h
//  FitMe
//
//  Created by Softheme iMac on 12/22/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *changePhotoButton;


@end
