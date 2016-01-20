//
//  UIView+WCategory.m
//  demo
//
//  Created by wwinter on 14/1/16.
//  Copyright © 2014年 d. All rights reserved.
//

#import "UIView+WCategory.h"

@implementation UIView (WCategory)

- (CGFloat)w_width
{
    return self.bounds.size.width;
}

- (void)setW_width:(CGFloat)w_width
{
    CGRect temp = self.frame;
    temp.size.width = w_width;
    self.frame = temp;
    return;
}

- (CGFloat)w_height
{
    return  self.bounds.size.height;
}

- (void)setW_height:(CGFloat)w_height
{
    CGRect temp = self.frame;
    temp.size.height = w_height;
    self.frame = temp;
    return;
}

- (CGFloat)w_originX
{
    return self.frame.origin.x;
}

- (void)setW_originX:(CGFloat)w_originX
{
    CGRect temp = self.frame;
    temp.origin.x = w_originX;
    self.frame = temp;
    return;
}

- (CGFloat)w_rightX
{
    return [self w_originX] + [self w_width];
}

- (void)setW_rightX:(CGFloat)w_rightX
{
    CGRect temp = self.frame;
    temp.origin.x = w_rightX - [self w_originX];
    self.frame = temp;
    return;
}

- (CGFloat)w_originY
{
    return self.frame.origin.y;
}

- (void)setW_originY:(CGFloat)w_originY
{
    CGRect temp = self.frame;
    temp.origin.y = w_originY;
    self.frame = temp;
    return;
}

- (CGFloat)w_bottomY
{
    return [self w_originY] + [self w_height];
}

- (void)setW_bottomY:(CGFloat)w_bottomY
{
    CGRect temp = self.frame;
    temp.origin.y = w_bottomY - [self w_height];
    self.frame = temp;
    return;
}

- (CGFloat)w_centerX
{
    return self.center.x;
}

- (void)setW_centerX:(CGFloat)w_centerX
{
    CGPoint temp = self.center;
    temp.x = w_centerX;
    self.center = temp;
}

- (CGFloat)w_centerY
{
    return self.center.y;
}

- (void)setW_centerY:(CGFloat)w_centerY
{
    CGPoint temp = self.center;
    temp.y = w_centerY;
    self.center = temp;
    return;
}

- (CGSize)w_size
{
    return self.bounds.size;
}

- (void)setW_size:(CGSize)w_size
{
    CGRect temp = self.frame;
    temp.size = w_size;
    self.frame = temp;
    return;
}

- (CGPoint)w_origin
{
    return self.frame.origin;
}

- (void)setW_origin:(CGPoint)w_origin
{
    CGRect temp = self.frame;
    temp.origin = w_origin;
    self.frame = temp;
    return;
}

@end
