//
//  ViewController.m
//  testWebView
//
//  Created by onskyline on 14-11-12.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import "ViewController.h"
#import "EpubController.h"

@interface ViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIWebView *aview;
    UIWebView *newView;
    UIWebView *pagewebView;
    CGFloat contentWidth;
    CGFloat pageCount;
    UILabel *pageLab;
    NSArray *bookArray;
    NSInteger pageNum;
    CGFloat startContentOffsetX;
    CGFloat endContentOffsetX;
    CGFloat willEndContentOffsetX;
}
@property (assign, nonatomic) CGPoint touchBeginPoint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ceil:%f",ceilf(12/8.0));
    
    bookArray=[NSArray arrayWithObjects:@"http://localhost:8080/page/page.html?d23sx",
               @"http://localhost:8080/page/column.html",
               nil];
    
    pageNum=1;
    // Do any additional setup after loading the view.
    CGRect rect=[UIScreen mainScreen].bounds;
    pagewebView=[[UIWebView alloc]initWithFrame:rect];
   
//    UIScrollView *webView=[[UIScrollView alloc]initWithFrame:rect];
//    webView.pagingEnabled=YES;
//    webView.alwaysBounceHorizontal=YES;
//    webView.showsHorizontalScrollIndicator=NO;
//    webView.showsVerticalScrollIndicator=NO;
    
    aview=[[UIWebView alloc]initWithFrame:CGRectMake(8, 20, rect.size.width-8, rect.size.height-30)];
//    UIWebView *webview=[[UIWebView alloc ]initWithFrame:[UIScreen mainScreen].bounds];
    NSURL *url=[NSURL URLWithString:[bookArray objectAtIndex:0]];
    aview.scrollView.alwaysBounceHorizontal = YES;
    aview.scrollView.alwaysBounceVertical = NO;
    aview.scrollView.bounces = YES;
    aview.scrollView.showsVerticalScrollIndicator = NO;
    aview.scrollView.showsHorizontalScrollIndicator = NO;
//    aview.scrollView.clipsToBounds = NO; //这样超出范围scrollView.frame 也会显示，即整个webView还是会正常显示
    aview.scrollView.delegate = self;
    aview.paginationMode = UIWebPaginationModeLeftToRight; //设置以后就可以水平滑动
//    aview.paginationMode=UIWebPaginationModeRightToLeft;
//    aview.paginationBreakingMode = UIWebPaginationBreakingModeColumn;
//    aview.paginationBreakingMode=UIWebPaginationBreakingModePage;
    aview.scrollView.pagingEnabled = YES;
    aview.delegate=self;
    
    newView=[[UIWebView alloc]initWithFrame:CGRectMake(rect.size.width+8, 20, rect.size.width-8, rect.size.height-30)];
//    newView.scrollView.pagingEnabled=YES;
    [pagewebView addSubview:newView];

    
        //    aview.scrollView.pagingEnabled=YES;
    
    [aview loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:pagewebView];
    [pagewebView addSubview:aview];
    
    NSLog(@"contentWidth=%f",contentWidth);
    
    pageLab=[[UILabel alloc]initWithFrame:CGRectMake(rect.size.width-50, rect.size.height-20, 50, 30)];
    [self.view addSubview:pageLab];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(50, rect.size.height-20, 50, 30);
    btn.backgroundColor=[UIColor yellowColor];
    [btn addTarget:self action:@selector(clickPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    _next=YES;

}

-(void)clickPage
{
    EpubController *epubVc=[[EpubController alloc]init];
    [self presentViewController:epubVc animated:YES completion:nil];
}

- (void)gotoPage:(int)pageIndex
{
    NSLog(@"gotoPage");
    _currentPageIndex = pageIndex;
    float pageOffset = pageIndex * aview.bounds.size.width;
    [aview.scrollView setContentOffset:CGPointMake(pageOffset, 0) animated:NO];;
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Start");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
        //    CGFloat viewWidth=webView.bounds.size.width;
    NSUInteger count1=webView.pageCount;
    pageCount=count1;
    
    int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
    NSLog(@"scrollWidth %d",totalWidth);
        contentWidth=webView.scrollView.contentSize.width;
    NSLog(@"totalWidth=%f",contentWidth);
    [self gotoPage:0];

    //aview.scrollView.contentSize=CGSizeMake(totalWidth, aview.frame.size.height);
}

#pragma mark - ScrollView Delegate Method

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.touchBeginPoint = scrollView.contentOffset;
//    NSLog(@"scrollViewWillBeginDecelerating %f",self.touchBeginPoint.x );
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     //拖动前的起始坐标
    startContentOffsetX = scrollView.contentOffset.x;
    
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
        //将要停止前的坐标
    willEndContentOffsetX = scrollView.contentOffset.x;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat   pageWidth   = scrollView.frame.size.width;
    _currentPageIndex = ceil(scrollView.contentOffset.x / pageWidth);
    
    CGPoint touchEndPoint = scrollView.contentOffset;
    _next = self.touchBeginPoint.x > touchEndPoint.x + 5;
    NSLog(@"进入scrollViewDidEndDecelerating");
//     [self gotoPage:(++_currentPageIndex)];
    if (!self.next)
    {
        if (_currentPageIndex == 0)
        {
           NSLog(@"向前");
            [self gotoPage:0];
        }
    }
    else
    {
        if(_currentPageIndex + 1 == pageCount)
        {
            NSLog(@"向后");
//             NSURL *url=[NSURL URLWithString:[bookArray objectAtIndex:1]];
//            [aview loadRequest:[NSURLRequest requestWithURL:url]];
            [pagewebView.scrollView scrollRectToVisible:newView.frame animated:NO];
            
        }
    }
    
    endContentOffsetX = scrollView.contentOffset.x;
    
    if (endContentOffsetX < willEndContentOffsetX && endContentOffsetX < startContentOffsetX) {
            //画面从右往左移动，前一页
        
        
    } else if (endContentOffsetX > willEndContentOffsetX && endContentOffsetX > startContentOffsetX) {
            //画面从左往右移动，后一页
        
    }
    
//    NSLog(@"即将偏移 %f",willEndContentOffsetX);
////    NSLog(@"最后偏移 %f",endContentOffsetX);
//    NSLog(@"起始偏移 %f",startContentOffsetX);
//    NSLog(@"结束偏移 %f",endContentOffsetX);
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    CGFloat halfWidth=contentWidth/pageCount;

    CGFloat offsetWidth=scrollView.contentOffset.x;

    int num=ceil((offsetWidth+aview.frame.size.width/2)/halfWidth);

    NSLog(@"当前页=%d,总页数=%d",num,aview.pageCount);
}


- (void)didReceiveMemoryWarning
{
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
