//
//  TextBtnViewController.m
//  iOSAutomationTestApp
//
//  Created by Chanikya Mandapathi on 8/9/16.
//  Copyright © 2016 CanNMobile. All rights reserved.
//

#import "TextBtnViewController.h"

@interface TextBtnViewController ()

@property (weak) NSException *customException;

@end

@implementation TextBtnViewController

- (void)viewDidLoad {
    
    self.textField.accessibilityIdentifier = @"textField1";
    self.sdkSwitchOutlet.accessibilityIdentifier = @"sdkSwitch";
    self.view.accessibilityIdentifier = @"view";
    //    self.btnOutlet.accessibilityIdentifier = @"customEventBtn";
    //    self.locationBtn.accessibilityIdentifier = @"locationEventBtn";
    
    [self makeRoundedView:self.btnOutlet];
    [self makeRoundedView:self.textView];
    [self makeRoundedView:self.btnImage];
    [self makeRoundedView:self.locationBtn];
    
    [self.sdkSwitchOutlet setOn:YES];
    
    [super viewDidLoad];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)btnTapped:(id)sender {
    NSDictionary *dict = @{ @"CustomEvent Test" : @"testKey1"};
    [[TLFCustomEvent sharedInstance] logEvent:@"calabash-customEvent" values:dict];
}

- (IBAction)logLocation:(id)sender {
    CLLocationDegrees myLatitude= 37.7888024;
    CLLocationDegrees myLongitude= -122.40031809;
    CLLocation *myLocation=[[CLLocation alloc] initWithLatitude:myLatitude
                                                      longitude:myLongitude];
    [[TLFCustomEvent sharedInstance] logLocation:myLocation];
}

- (IBAction)crashBtn:(id)sender {
    @try {
//        self.customException = [NSException
//                                    exceptionWithName:@"Custom Exception"
//                                    reason:@"Raising exception for logging"
//                                    userInfo:nil];
//        @throw self.customException;  //myException;
        @throw [NSException
                       exceptionWithName:@"Custom Exception"
                       reason:@"Raising exception for logging"
                       userInfo:nil];   // [NSException raise:@"Custom Exception" format:@"Raising exception for logging"];
    }
    @catch(NSException *exception) {
        [[TLFCustomEvent sharedInstance] logNSExceptionEvent:exception];
        //@throw exception;
    }
}

- (IBAction)toggleSDKSwitch:(id)sender {
}

@end
