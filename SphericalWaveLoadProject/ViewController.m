//
//  ViewController.m
//  SphericalWaveLoadProject
//
//  Created by tjx on 16/9/21.
//  Copyright © 2016年 tjx. All rights reserved.
//

#import "ViewController.h"
#import "SphericalWaveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    bgImageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bgImageView];
    
    SphericalWaveView *sphericalWaveView = [[SphericalWaveView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, 70, self.view.frame.size.width * 0.8, self.view.frame.size.width * 0.8) process:0.6];
    [self.view addSubview:sphericalWaveView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
