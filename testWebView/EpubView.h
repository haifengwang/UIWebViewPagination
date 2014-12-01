//
//  EpubView.h
//  testWebView
//
//  Created by onskyline on 14-11-19.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EPubViewDelegate <NSObject>

@required
- (void)gotoPrevSpine;
- (void)gotoNextSpine;

@optional
- (void)epubViewLoadFinished;

@end

@interface EpubView : UIWebView

@property (nonatomic, weak) id <EPubViewDelegate> delegate;
    //用来承载文本
@property (nonatomic, readonly) UIWebView *webView;
    //当前显示的章节
@property (nonatomic, readonly) NSArray   *chapter;

    //当前页在当前章节的索引值，从0开始
@property (nonatomic, readonly) int currentPageIndex;
    //当前章节的页数
@property (nonatomic, readonly) NSUInteger pageToCount;
    //文字字号大小
@property (nonatomic, assign)   int fontSize;

    //判断手势是上一章还是下一章，默认为YES，即为下一章。
@property (nonatomic, readonly, getter = isNext) BOOL next;


    //装载章节
- (void)loadChapter:(NSString *)chapter;
- (void)gotoPage:(int)pageIndex;
- (void)setFontSize:(int)fontSize;

@end
