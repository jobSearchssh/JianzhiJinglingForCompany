//
// RESideMenuItem.m
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

#import "RESideMenuItem.h"

@implementation RESideMenuItem


-(void)setTapFlag:(int)getFlag{
    tapFlag = getFlag;
}
-(int)getTapFlag{
    return tapFlag;
}
-(void)setCellFlag:(int)getFlag{
    cellflag = getFlag;
}
-(int)getCellFlag{
    return cellflag;
}
-(void)setIsClick:(BOOL)click{
    isClick = click;
}
-(BOOL)getIsClick{
    return isClick;
}

- (id)initWithTitle:(NSString *)title setFlag:(int)getFlag action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action
{
    return [self initWithTitle:title setFlag:getFlag setSubtitle:nil image:nil highlightedImage:nil action:action];
}

- (id)initWithTitle:(NSString *)title setFlag:(int)getFlag setSubtitle:(NSString *)subtitle action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action{
    return [self initWithTitle:title setFlag:getFlag setSubtitle:subtitle image:nil highlightedImage:nil action:action];
}

- (id)initWithTitle:(NSString *)title setFlag:(int)getFlag image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action{
    return [self initWithTitle:title setFlag:getFlag setSubtitle:nil image:image highlightedImage:highlightedImage action:action];
}

- (id)initWithTitle:(NSString *)title setFlag:(int)getFlag setSubtitle:(NSString *)subtitle image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action{
    self = [super init];
    if (!self)
        return nil;
    cellflag = getFlag;
    isClick = false;
    self.subtitle = subtitle;
    self.title = title;
    self.action = action;
    self.image = image;
    self.highlightedImage = highlightedImage;
    
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<title: %@ tag: %i>", self.title, self.tag];
}

@end
