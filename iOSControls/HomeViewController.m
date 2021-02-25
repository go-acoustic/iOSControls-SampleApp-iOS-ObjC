//
//  HomeViewController.m
//  iOSAutomationTestApp
//
//  Created by Chanikya Mandapathi on 8/8/16.
//  Copyright © 2016 CanNMobile. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [NSArray arrayWithObjects:@"Texts and Buttons", @"Time and Date Picker", @"Alerts", @"ProgressBar and Activity Indicator", @"Gestures", @"Swift controls - Camera", @"Page Controller", @"Images", nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    
    //[locationManager requestWhenInUseAuthorization];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Select the suitable option";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.data[indexPath.row];
    cell.accessibilityLabel = self.data[indexPath.row];
    
    if (indexPath.row == 1) {
        cell.tag = 9007;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"textBtnSegue" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"pickersSegue" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"alertsSegue" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"progressSegue" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"gesturesSegue" sender:self];
            break;
        case 5:
            [self performSegueWithIdentifier:@"cameraSegue" sender:self];
            break;
        case 6:
            [self performSegueWithIdentifier:@"pageControllerSegue" sender:self];
            break;
        case 7:
            [self performSegueWithIdentifier:@"imagesSegue" sender:self];
            break;
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
