//
//  GesturesViewController.m
//  iOSAutomationTestApp
//
//  Created by Chanikya Mandapathi on 8/9/16.
//  Copyright © 2016 CanNMobile. All rights reserved.
//

#import "GesturesViewController.h"

@interface GesturesViewController ()

@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UIView *swipeView;
@property (weak, nonatomic) IBOutlet UIView *pinchView;

@property (strong, nonatomic) IBOutlet UIView *leftSwipeView;
@property (strong, nonatomic) IBOutlet UIView *rightSwipeView;

@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;


@end

@implementation GesturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tapView.accessibilityIdentifier = @"tapView";
    self.swipeView.accessibilityIdentifier = @"swipeView";
    self.pinchView.accessibilityIdentifier = @"pinchView";
    
    self.leftSwipeView.accessibilityIdentifier = @"leftSwipeView";
    self.rightSwipeView.accessibilityIdentifier = @"rightSwipeView";
    
    self.leftSwipeView = [[UIView alloc] initWithFrame:CGRectMake(self.swipeView.frame.origin.x - self.view.frame.size.width, self.swipeView.frame.origin.y + 44.0, self.view.frame.size.width, self.swipeView.frame.size.height)];
    self.leftSwipeView.backgroundColor = [UIColor greenColor];
    
    self.rightSwipeView = [[UIView alloc] initWithFrame:CGRectMake(self.swipeView.frame.origin.x + self.view.frame.size.width, self.swipeView.frame.origin.y + 44.0, self.view.frame.size.width, self.swipeView.frame.size.height)];
    self.rightSwipeView.backgroundColor = [UIColor blackColor];
    
    // Registering single tap
    self.singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.tapView addGestureRecognizer:self.singleTapGestureRecognizer];
    
    // Registering double tap
    self.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    self.doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    //[self.tapView addGestureRecognizer:self.doubleTapGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightOrange.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *swipeLeftOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftOrange.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.swipeView addGestureRecognizer:swipeRightOrange];
    [self.swipeView addGestureRecognizer:swipeLeftOrange];
    
    UISwipeGestureRecognizer *swipeRightBlack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightBlack.direction = UISwipeGestureRecognizerDirectionRight;
    [self.rightSwipeView addGestureRecognizer:swipeRightBlack];
    
    UISwipeGestureRecognizer *swipeLeftGreen = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftGreen.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.leftSwipeView addGestureRecognizer:swipeLeftGreen];
    
    //pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchWithGestureRecognizer:)];
    pinchGestureRecognizer.delegate = self;
    [self.pinchView addGestureRecognizer:pinchGestureRecognizer];
}
//Commentout this code .. This will make GesturesViewController class to have a gesture recognizer delegate; but Not have shouldRecognizeSimultaneouslyWithGestureRecognizer method present. When Tealeaf SDK notices this; it will inject this method for the app, like its in the documentation.
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
//{
 //  return YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [self.view addSubview:self.rightSwipeView];
    [self.view addSubview:self.leftSwipeView];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [self.leftSwipeView removeFromSuperview];
    [self.rightSwipeView removeFromSuperview];
}

#pragma mark - Gesture handling methods

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
    CGFloat newWidth = 100.0;
    if (self.tapView.frame.size.width == 100.0) {
        newWidth = 200.0;
    }
    
    CGPoint currentCenter = self.tapView.center;
    
    self.tapView.frame = CGRectMake(self.tapView.frame.origin.x, self.tapView.frame.origin.y, newWidth, self.tapView.frame.size.height);
    self.tapView.center = currentCenter;
}

-(void)handleDoubleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
    CGSize newSize = CGSizeMake(100.0, 60.0);
    if (self.tapView.frame.size.width == 100.0) {
        newSize.width = 200.0;
        newSize.height = 100.0;
    }
    
    CGPoint currentCenter = self.tapView.center;
    
    self.tapView.frame = CGRectMake(self.tapView.frame.origin.x, self.tapView.frame.origin.y, newSize.width, newSize.height);
    self.tapView.center = currentCenter;
}

-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        self.swipeView.frame = CGRectOffset(self.swipeView.frame, self.view.frame.size.width, 0.0);
        self.rightSwipeView.frame = CGRectOffset(self.rightSwipeView.frame, self.view.frame.size.width, 0.0);
        self.leftSwipeView.frame = CGRectOffset(self.leftSwipeView.frame, self.view.frame.size.width, 0.0);
    }];
}

-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        self.swipeView.frame = CGRectOffset(self.swipeView.frame, - self.view.frame.size.width, 0.0);
        self.rightSwipeView.frame = CGRectOffset(self.rightSwipeView.frame, - self.view.frame.size.width, 0.0);
        self.leftSwipeView.frame = CGRectOffset(self.leftSwipeView.frame, - self.view.frame.size.width, 0.0);
    }];
}

-(void)handlePinchWithGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    self.pinchView.transform = CGAffineTransformScale(self.pinchView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    pinchGestureRecognizer.scale = 1.0;
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        [self.tapView removeGestureRecognizer:self.doubleTapGestureRecognizer];
        [self.tapView addGestureRecognizer:self.singleTapGestureRecognizer];
    }
    else{
        [self.tapView removeGestureRecognizer:self.singleTapGestureRecognizer];
        [self.tapView addGestureRecognizer:self.doubleTapGestureRecognizer];
    }
}

@end
