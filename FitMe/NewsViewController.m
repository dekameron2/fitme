//
//  NewsViewController.m
//  FitMe
//
//  Created by Softheme iMac on 12/22/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "NewsViewController.h"
#import <SlideNavigationController.h>
#import <SlideNavigationController.h>
#import <QuartzCore/QuartzCore.h>
#import <SlideNavigationContorllerAnimatorSlideAndFade.h>
#import "MainMenuViewcontroller.h"
#import "RefreshController+DeviceMethods.h"

@interface NewsViewController () <SlideNavigationControllerDelegate>

@property (nonatomic) UIView *shadowView;
@property (nonatomic) NSObject *slideOpenNotification, *slideCloseNotification;

@end

@implementation NewsViewController

-(void)viewWillAppear:(BOOL)animated {
    [self prefersStatusBarHidden];
}

-(void)viewDidLoad {
    [self setupSlideController];
}

#pragma mark - SlideNavigationController setup and delegate
- (void) setupSlideController
{
    MainMenuViewcontroller *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MainMenuViewcontroller class])];
//    mainMenu.delegate = self;
    [SlideNavigationController sharedInstance].leftMenu = mainMenu;
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    [SlideNavigationController sharedInstance].leftBarButtonItem = self.menuBarButtonItem;
    [SlideNavigationController sharedInstance].enableShadow = NO;
    id <SlideNavigationContorllerAnimator> animator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andSlideMovement:100];
    [SlideNavigationController sharedInstance].menuRevealAnimator = animator;
    self.shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.alpha = 0.0;
    UITapGestureRecognizer *tapToHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideMenus)];
    [self.shadowView addGestureRecognizer:tapToHide];
    
    __weak typeof(self) weakSelf = self;
    self.slideCloseNotification = [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.shadowView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [weakSelf.shadowView removeFromSuperview];
        }];
        
        [self showStatusBar];
        [self showStatusBar];
    }];
    self.slideOpenNotification = [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        [weakSelf.view addSubview:weakSelf.shadowView];
        [[RefreshController sharedController] hideStatusBarAnimated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.shadowView.alpha = 0.5;
        }];
        
        [self hideStatusBar];
    }];
}

- (void) closeSideMenus{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        [self.shadowView removeFromSuperview];
    }];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL) shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutomaticallyForwardAppearanceMethods{
    return YES;
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self.slideOpenNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.slideCloseNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) showStatusBar {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    float animationDuration;
    if(statusBarFrame.size.height > 20) { // in-call
        animationDuration = 0.5;
    } else { // normal status bar
        animationDuration = 0.6;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationSlide];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UIView animateWithDuration:animationDuration animations:^{
        navBar.frame = CGRectMake(navBar.frame.origin.x,
                                  statusBarFrame.size.height,
                                  navBar.frame.size.width,
                                  navBar.frame.size.height);
    } completion:^(BOOL finished) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
    }];
}

-(void) hideStatusBar {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    float animationDuration;
    if(statusBarFrame.size.height > 20) { // in-call
        animationDuration = 0.5;
    } else { // normal status bar
        animationDuration = 0.6;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationSlide];
}

@end
