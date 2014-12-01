//
//  ViewController.h
//  testWebView
//
//  Created by onskyline on 14-11-12.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

    //当前页在当前章节的索引值，从0开始
@property (nonatomic, readonly) int currentPageIndex;
    //当前章节的页数
//@property (nonatomic, readonly) int pageCount;

@property(nonatomic)BOOL next;

@end
