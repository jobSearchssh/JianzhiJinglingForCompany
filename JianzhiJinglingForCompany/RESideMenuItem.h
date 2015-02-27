//
// RESideMenuItem.h
// RESideMenu
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static int USRCELL = 1;
static int NORMALCELL = 2;
static int LOGINCELL = 3;
static int DEFAULTCELL = 4;

static int ACTION_NONFLAG = 0;
static int ACTION_REGISTERFLAG = 1;
static int ACTION_LOGINFLAG = 2;

@class RESideMenu;

@interface RESideMenuItem : NSObject{
    int cellflag;
    int tapFlag;
    BOOL isClick;
}

-(void)setTapFlag:(int)getFlag;
-(int)getTapFlag;
-(void)setCellFlag:(int)getFlag;
-(int)getCellFlag;
-(void)setIsClick:(BOOL)click;
-(BOOL)getIsClick;

@property (copy,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *subtitle;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) UIImage *highlightedImage;
@property (assign,nonatomic) NSInteger tag;
@property (strong, nonatomic)NSString *imageUrl;
@property (copy,nonatomic) void (^action)(RESideMenu *menu, RESideMenuItem *item);

@property (strong, readwrite, nonatomic) NSArray *subItems;

@property (strong, nonatomic)NSString *badgeText;

- (id)initWithTitle:(NSString *)title setFlag:(int)getFlag action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action;
- (id)initWithTitle:(NSString *)title setFlag:(int)getFlag setSubtitle:(NSString *)subtitle action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action;
- (id)initWithTitle:(NSString *)title setFlag:(int)getFlag image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action;
- (id)initWithTitle:(NSString *)title setFlag:(int)getFlag setSubtitle:(NSString *)subtitle image:(UIImage *)image imageUrl:(NSString*)url highlightedImage:(UIImage *)highlightedImage action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action;
- (void)setTitle:(NSString*)title Subtitle:(NSString*)subtitle Url:(NSString*)url;



@end
