//
//  MainMenuViewcontroller.m
//  FitMe
//
//  Created by Softheme iMac on 12/22/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "MainMenuViewcontroller.h"
#import "ProfileTableViewCell.h"
#import "UserManipulationsTableViewCell.h"
#import "RefreshController+UserMethods.h"

@interface MainMenuViewcontroller () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainMenuViewcontroller

#pragma mark - UITableView Delegate & Data Source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"";
    if (indexPath.row == 0) {
        cellIdentifier = @"ProfileTableViewCell identifier";
        ProfileTableViewCell *resultCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [self setUpProfileCell:resultCell];
        
        return resultCell;
    }else{
        cellIdentifier = @"UserManipulationsTableViewCell identifier";
        UserManipulationsTableViewCell *resultCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [self setUpNewsCell:resultCell];
        
        return resultCell;
    }
    
    return nil;
}

- (void) setUpProfileCell:(ProfileTableViewCell *) cell {
    cell.userNameLabel.text = [[RefreshController sharedController] currentUser].firstName;
}

- (void) setUpNewsCell:(UserManipulationsTableViewCell *) cell {

}


@end
