//
//  UIView+WCategory.h
//  demo
//
//  Created by wwinter on 14/1/16.
//  Copyright © 2014年 d. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WCategory)

/** view width */
@property (nonatomic, assign) CGFloat w_width;
/** view height */
@property (nonatomic, assign) CGFloat w_height;
/** view originX */
@property (nonatomic, assign) CGFloat w_originX;
/** view rightX */
@property (nonatomic, assign) CGFloat w_rightX;
/** view originY */
@property (nonatomic, assign) CGFloat w_originY;
/** view bottomY */
@property (nonatomic, assign) CGFloat w_bottomY;

/** view centerX */
@property (nonatomic, assign) CGFloat w_centerX;
/** view centerY */
@property (nonatomic, assign) CGFloat w_centerY;
/** view size */
@property (nonatomic, assign) CGSize w_size;
/** view origin */
@property (nonatomic, assign) CGPoint w_origin;
@end
