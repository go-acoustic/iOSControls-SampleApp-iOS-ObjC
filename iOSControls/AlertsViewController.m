//
//  AlertsViewController.m
//  iOSAutomationTestApp
//
//  Created by Chanikya Mandapathi on 8/9/16.
//  Copyright © 2016 CanNMobile. All rights reserved.
//

#import "AlertsViewController.h"

@interface AlertsViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *alertBtn1;
@end

@implementation AlertsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeRoundedView:self.alertBtn1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeRoundedView: (UIView *) vi
{
    vi.layer.cornerRadius = 2;
    vi.layer.borderWidth = 1;
    vi.layer.borderColor = [UIColor grayColor].CGColor;
}

- (IBAction)showAlert1:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"AlertController"
                                  message:@"Example UIAlertController"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [[TLFCustomEvent sharedInstance] logScreenLayoutWithViewController:self andDelay:50];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [[TLFCustomEvent sharedInstance] logScreenLayoutWithViewController:self andDelay:50];
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    alert.view.tag = 9008;
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
