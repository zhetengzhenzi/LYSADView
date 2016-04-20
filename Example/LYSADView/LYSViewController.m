//
//  LYSViewController.m
//  LYSADView
//
//  Created by liuyushuang@duia.com on 04/20/2016.
//  Copyright (c) 2016 liuyushuang@duia.com. All rights reserved.
//

#import "LYSViewController.h"
#import "ADView.h"

@interface LYSViewController ()

@end

@implementation LYSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    /*
     1、通过图片名创建ADView
     
     */
    //多张图片r
    NSArray * imagesArray = @[[self p_setImagesWithImageName:@"1.jpg"],[self p_setImagesWithImageName:@"2.jpg"],[self p_setImagesWithImageName:@"3.jpg"],[self p_setImagesWithImageName:@"4.jpg"]];
    //单张图片
    //        NSArray * imagesArray = @[[self p_setImagesWithImageName:@"2.jpg"]];
    ADView * adview = [[ADView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 200) imageUrlArray:nil imageNameArray:imagesArray duration:4];
    /*
     2、通过图片URL，从网络下载图片，创建ADView
     */
    //        NSURL * url1 = [NSURL URLWithString:@"http://tu.duia.com/questionpic/20150206075901588360.png"];
    //        NSURL * url2 = [NSURL URLWithString:@"http://tu.duia.com/questionpic/20150206075936822642.png"];
    //        NSURL * url3 = [NSURL URLWithString:@"http://tu.duia.com/questionpic/20150206075945832942.png"];
    //        NSURL * url4 = [NSURL URLWithString:@"http://tu.duia.com/questionpic/20150417024213707929.png"];
    //        NSArray * imagesUrlArray = @[url1,url2,url3,url4];
    //    NSArray * imagesUrlArray = @[url4];
    
    //    ADView * adview = [[ADView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 200) imageUrlArray:imagesUrlArray imageNameArray:nil];
    
    [self.view addSubview:adview];
    
}

- (UIImage *)p_setImagesWithImageName:(NSString *)imageName
{
    UIImage * image = [UIImage imageNamed:imageName];
    return image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
