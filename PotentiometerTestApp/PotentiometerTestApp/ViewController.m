//
//  ViewController.m
//  PotentiometerTestApp
//
//  Created by Jacek Grygiel on 09/03/15.
//  Copyright (c) 2015 Jacek Grygiel Software Engineer. All rights reserved.
//

#import "ViewController.h"
#import "JGPotentiometer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JGPotentiometer *knob = [[JGPotentiometer alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    [knob addChangeValueCallback:^(float currentValue) {
       
        NSLog(@"knob value has changed %f", currentValue);
        
    }];
    
    [self.view addSubview:knob];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
