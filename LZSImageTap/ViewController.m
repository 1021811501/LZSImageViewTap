//
//  ViewController.m
//  LZSImageTap
//
//  Created by 李志帅 on 16/7/5.
//  Copyright © 2016年 李志帅. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = @"http://digg-test.qiniudn.com/o_1aleguickviu5pq1udfs02dvqf.png";
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.center = self.view.center;
    imageView.bounds = CGRectMake(0, 0, 200, 300);
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewTapAction)];
    [imageView addGestureRecognizer:gesture];
   
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)ImageViewTapAction{
    ImageTapView *tap = [[ImageTapView alloc] initWithImageTapWithUrl:@"http://digg-test.qiniudn.com/o_1aleguickviu5pq1udfs02dvqf.png"];
    [tap showInView:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
