//
//  EpubController.m
//  testWebView
//
//  Created by onskyline on 14-11-19.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import "EpubController.h"
#import "EpubView.h"

@interface EpubController ()<EPubViewDelegate>
{
      NSArray *bookArray;
}
@property (nonatomic) EpubView  *epubView;

@end

@implementation EpubController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bookArray=[NSArray arrayWithObjects:
               @"http://localhost:8080/page/page.html?d1sx",
               @"http://localhost:8080/page/column.html",
               nil];
    
    self.epubView=[[EpubView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        //[bookArray objectAtIndex:0]
//    [self.epubView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com/"]]];
    [self.epubView loadChapter:[bookArray objectAtIndex:0]];
    [self.view addSubview:self.epubView];
    [self.epubView setHidden:NO];
    self.epubView.delegate=self;
}

- (void)epubViewLoadFinished
{
//    [self hideLoadingView];
    
    if (self.epubView.next)
        [self gotoPageInCurrentSpine:0];
    else
        [self gotoPageInCurrentSpine:self.epubView.pageToCount - 1];
}

#pragma mark - Read Control

- (void)gotoPageInCurrentSpine:(int)pageIndex
{
    [self.epubView gotoPage:pageIndex];
}

- (void)gotoPage:(int)pageIndex inSpine:(int)spineIndex
{
   
    NSString *arr=[bookArray objectAtIndex:pageIndex];
    [self.epubView loadChapter:arr];
}

#pragma mark - EPubView Delegate Method

- (void)gotoPrevSpine
{
    NSLog(@"gotoPrevSpine");
     [self gotoPage:0 inSpine:0];
}

- (void)gotoNextSpine
{
    NSLog(@"gotoNextSpine");
    [self gotoPage:1 inSpine:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
