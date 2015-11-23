//
//  ViewController.m
//  simpleNetwork
//
//  Created by wangxin on 15/11/23.
//  Copyright © 2015年 wangxin. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //AFNetworking
    [[NetworkService sharedNetworkService] getIndexDataWithBlock:^(id responseObject, NSError *error) {
        if (responseObject)
        {
            
        }
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
