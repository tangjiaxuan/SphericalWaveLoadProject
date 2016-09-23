//
//  SphericalWaveView.m
//  SphericalWaveLoadProject
//
//  Created by tjx on 16/9/21.
//  Copyright © 2016年 tjx. All rights reserved.
//

#import "SphericalWaveView.h"

@interface SphericalWaveView()
{
    CGFloat process;
    CGFloat currentPercent;
    CGFloat a;
}

@end

@implementation SphericalWaveView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yellowColor];
        [self setNeedsDisplay];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame process:(CGFloat)precent
{
    if (self = [self initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        process = precent;
        currentPercent = 0;
        a = M_PI / 8;
        [self setNeedsDisplay];
        [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawScale:context];
    [self drawProcessScale:context];
    [self drawBackground:context];
//    [self drawWaveByLine:context];
    [self drawWaveByFill:context];
    [self drawLabel:context];
    }

/**
 *  刻度尺及圈
 *
 *  @param context
 */
- (void)drawScale:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    
    CGContextTranslateCTM(context, self.frame.size.width / 2, self.frame.size.height/2);
    
    //绘制刻度圈
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.655 green:0.710 blue:0.859 alpha:1.00].CGColor);
    for(int i = 0; i < 100; i++)
    {
        CGContextMoveToPoint(context, self.frame.size.width / 2 - 40, 0);
        CGContextAddLineToPoint(context, self.frame.size.width / 2 - 30, 0);
        
        CGContextStrokePath(context);
        CGContextRotateCTM(context, 2 * M_PI / 100);
    }
    
    //绘制刻度尺外的一个圈
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00].CGColor);//线框颜色
    CGContextSetLineWidth(context, 0.5);
    CGContextAddArc (context, 0, 0, self.frame.size.width / 2 - 40 - 3, 0, M_PI* 2 , 0);
    CGContextStrokePath(context);
    
    //复原参照点
    CGContextTranslateCTM(context, -self.frame.size.width / 2, -self.frame.size.width / 2);
}

/**
 *  刻度尺进度
 *
 *  @param context
 */
- (void)drawProcessScale:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextTranslateCTM(context, self.frame.size.width / 2, self.frame.size.width / 2);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.969 green:0.937 blue:0.227 alpha:1.00].CGColor);
    int count = roundf(51 * currentPercent);
    CGFloat scaleAngle = 2 * M_PI / 100;
    
    //绘制左边刻度进度
    for (int i = 0; i < count; i++)
    {
        CGContextMoveToPoint(context, 0, self.frame.size.width / 2 - 40);
        CGContextAddLineToPoint(context, 0, self.frame.size.width / 2 - 30);
        //    CGContextScaleCTM(ctx, 0.5, 0.5);
        // 渲染
        CGContextStrokePath(context);
        CGContextRotateCTM(context, scaleAngle);
    }
    //绘制右边刻度进度
    CGContextRotateCTM(context, -count * scaleAngle);
    
    for (int i = 0; i < count; i++)
    {
        CGContextMoveToPoint(context, 0, self.frame.size.width / 2 - 40);
        CGContextAddLineToPoint(context, 0, self.frame.size.width / 2 - 30);
        //    CGContextScaleCTM(ctx, 0.5, 0.5);
        // 渲染
        CGContextStrokePath(context);
        CGContextRotateCTM(context, -scaleAngle);
    }
    CGContextRotateCTM(context, count * scaleAngle);
    CGContextTranslateCTM(context,  -self.frame.size.width / 2, -self.frame.size.width / 2);
}

/**
 *  通过画线实现波浪动画
 *
 *  @param context
 */
- (void)drawWaveByLine:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.325 green:0.392 blue:0.729 alpha:1.00].CGColor);
    
    CGFloat radius = (self.frame.size.width - 100) / 2;
    CGFloat angle = roundf(51 * currentPercent) * 2 * M_PI / 100;
    CGFloat offset = 50;
    int count = self.frame.size.width - 100;
    for (int i = 0; i < count; i++)
    {
        CGFloat startPointY = radius + sqrt(pow(radius, 2) - pow(radius - i, 2)) + offset;
        CGContextMoveToPoint(context, i + offset, startPointY);
        CGFloat endPointY = (radius * (1 + cos(angle)) + offset) + 10 * sin(i / 50.0 + a);
        endPointY = endPointY > (radius - sqrt(pow(radius, 2) - pow(radius - i, 2)) + offset) ? endPointY : (radius - sqrt(pow(radius, 2) - pow(radius - i, 2)) + offset);
        
        endPointY = endPointY < (radius + sqrt(pow(radius, 2) - pow(radius - i, 2)) + offset) ? endPointY : (radius + sqrt(pow(radius, 2) - pow(radius - i, 2)) + offset);
        CGContextAddLineToPoint(context, i + offset, endPointY);
        CGContextStrokePath(context);
    }
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.322 green:0.514 blue:0.831 alpha:1.00].CGColor);
    for (int i = 0; i < count; i++)
    {
        CGFloat startPointY = radius + sqrt(pow(radius, 2) - pow(radius - i, 2)) + offset;
        CGContextMoveToPoint(context, i + offset, startPointY);
        CGFloat endPointY = (radius * (1 + cos(angle)) + offset) + 10 * cos(i / 60.0 + a + M_PI / 8);
        endPointY = endPointY > (radius - sqrt(pow(radius, 2) - pow(radius - i, 2)) + offset) ? endPointY : (radius - sqrt(pow(radius, 2) - pow(radius - i, 2)) + offset);
        
        endPointY = endPointY < (radius + sqrt(pow(radius, 2) - pow(radius - i, 2)) + offset) ? endPointY : (radius + sqrt(pow(radius, 2) - pow(radius - i, 2)) + offset);
        CGContextAddLineToPoint(context, i + offset, endPointY);
        CGContextStrokePath(context);
    }
}

/**
 *  通过填充实现波浪动画
 *
 *  @param context
 */
- (void)drawWaveByFill:(CGContextRef)context
{
    CGMutablePathRef frontPath = CGPathCreateMutable();
    CGMutablePathRef backPath = CGPathCreateMutable();
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.325 green:0.392 blue:0.729 alpha:1.00].CGColor);
    
    CGFloat radius = (self.frame.size.width - 100) / 2;
    CGFloat angle = roundf(51 * currentPercent) * 2 * M_PI / 100;
    CGFloat offset = 50;
    
    int count = radius * 2 * sin(angle);
    int pointY;
    CGFloat startPointY = radius * (1 + cos(angle)) + offset;
    CGFloat endPointY;
    CGPoint startPoint;

    for (float i = 0; i < count; i++) {
        
        if (angle > M_PI / 2)
        {
            if (i < count / 2)
            {
                pointY = radius - sqrt(pow(radius, 2) - pow(radius * sin(angle) - i, 2)) + offset;
            }else
            {
                pointY = radius - sqrt(pow(radius, 2) - pow(i - radius * sin(angle), 2)) + offset;
            }
            
            endPointY = startPointY - fabs(14 * sin(i / 200.0 + a));
            endPointY = endPointY > pointY ? endPointY : pointY;
            if (fabs(i - 0) < 0.001) {
                startPoint = CGPointMake(radius * (1 - sin(angle)) + offset + i, endPointY);
                CGPathMoveToPoint(frontPath, nil, startPoint.x, startPoint.y);
            }
        }else
        {
            if (i < count / 2)
            {
                pointY = radius + sqrt(pow(radius, 2) - pow(radius * sin(angle) - i, 2)) + offset;
            }else
            {
                pointY = radius + sqrt(pow(radius, 2) - pow(i - radius * sin(angle), 2)) + offset;
            }
            
            endPointY = startPointY + fabs(12 * sin(i / 200.0 + a));
            endPointY = endPointY < pointY ? endPointY : pointY;
            if (fabs(i - 0) < 0.001)
            {
                startPoint = CGPointMake(radius * (1 - sin(angle)) + offset + i, endPointY);
                CGPathMoveToPoint(frontPath, nil, startPoint.x, startPoint.y);
            }
        }
        
        CGPathAddLineToPoint(frontPath, nil, startPoint.x + i, endPointY);
    }
    
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGPathAddArc(frontPath, nil, centerPoint.x, centerPoint.y, radius, angle > M_PI / 2 ? (M_PI * 5 / 2 - angle) : (M_PI / 2 - angle), M_PI / 2 + angle, 0);
    CGContextAddPath(context, frontPath);
    CGContextFillPath(context);
    //推入
    CGContextSaveGState(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(frontPath);
    
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.322 green:0.514 blue:0.831 alpha:1.00].CGColor);
    
    for (float i = 0; i < count; i++)
    {
       
        if (angle > M_PI / 2)
        {
            if (i < count / 2)
            {
                pointY = radius - sqrt(pow(radius, 2) - pow(radius * sin(angle) - i, 2)) + offset;
            }else
            {
                pointY = radius - sqrt(pow(radius, 2) - pow(i - radius * sin(angle), 2)) + offset;
            }
            
            endPointY = startPointY - fabs(10 * sin(i / 200.0 + a + M_PI / 4));
            endPointY = endPointY > pointY ? endPointY : pointY;
            if (fabs(i - 0) < 0.001) {
                startPoint = CGPointMake(radius * (1 - sin(angle)) + offset + i, endPointY);
                CGPathMoveToPoint(backPath, nil, startPoint.x, startPoint.y);
            }
        }else
        {
            if (i < count / 2)
            {
                pointY = radius + sqrt(pow(radius, 2) - pow(radius * sin(angle) - i, 2)) + offset;
            }else
            {
                pointY = radius + sqrt(pow(radius, 2) - pow(i - radius * sin(angle), 2)) + offset;
            }
            
            endPointY = startPointY + fabs(10 * sin(i / 200.0 + a + M_PI / 4));
            endPointY = endPointY < pointY ? endPointY : pointY;
            if (fabs(i - 0) < 0.001)
            {
                startPoint = CGPointMake(radius * (1 - sin(angle)) + offset + i, endPointY);
                CGPathMoveToPoint(backPath, nil, startPoint.x, startPoint.y);
            }
        }
        
        CGPathAddLineToPoint(backPath, nil, startPoint.x + i, endPointY);

    }
    
    CGPathAddArc(backPath, nil, centerPoint.x, centerPoint.y, radius, angle > M_PI / 2 ? (M_PI * 5 / 2 - angle) : (M_PI / 2 - angle), M_PI / 2 + angle, 0);
    CGContextAddPath(context, backPath);
    CGContextFillPath(context);
    //推入
    CGContextSaveGState(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(backPath);


}

/**
 *  画背景界面
 *
 *  @param context 全局context
 */
- (void)drawBackground:(CGContextRef)context
{
    
    //画背景圆
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.259 green:0.329 blue:0.506 alpha:1.00] CGColor]);
    
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGPathAddArc(path, nil, centerPoint.x, centerPoint.y, (self.frame.size.width - 100) / 2, 0, 2 * M_PI, 0);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    
    //绘制背景的线
    //======================= 矩阵操作 ============================
    CGContextTranslateCTM(context, self.frame.size.width / 2, self.frame.size.width / 2);
    CGContextRotateCTM(context, - M_PI / 4);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00].CGColor);//线框颜色
    CGContextSetLineWidth(context, 1);
    CGContextAddArc (context, 0, 0, self.frame.size.width/2 - 4, -M_PI / 4, M_PI / 4, 0);
    CGContextStrokePath(context);
    
    CGContextRotateCTM(context, M_PI / 4);
    CGContextMoveToPoint(context, self.frame.size.width/2 - 4, 0);
    CGContextAddLineToPoint(context, self.frame.size.width/2, 0);
    // 3. 渲染
    CGContextStrokePath(context);
    CGContextRotateCTM(context, -M_PI / 4);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00].CGColor);//线框颜色
    CGContextSetLineWidth(context, 1);
    CGContextAddArc (context, 0, 0, self.frame.size.width/2 - 4, M_PI * 3 / 4, M_PI * 5 / 4, 0);
    CGContextStrokePath(context);
    
    CGContextRotateCTM(context, M_PI * 5 / 4);
    CGContextMoveToPoint(context, self.frame.size.width/2 - 4, 0);
    CGContextAddLineToPoint(context, self.frame.size.width/2, 0);
    // 3. 渲染
    CGContextStrokePath(context);
    CGContextRotateCTM(context, -M_PI * 5 / 4);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00].CGColor);//线框颜色
    CGContextSetLineWidth(context, 6);
    CGContextAddArc (context, 0, 0, self.frame.size.width/2 - 30 / 2, M_PI * 4 / 10, M_PI * 6 / 10, 0);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00].CGColor);//线框颜色
    CGContextSetLineWidth(context, 6);
    CGContextAddArc (context, 0, 0, self.frame.size.width/2 - 30 / 2, M_PI * 14 / 10, M_PI * 16 / 10, 0);
    CGContextStrokePath(context);
    CGContextRotateCTM(context, M_PI / 4);
    
    CGContextTranslateCTM(context, -self.frame.size.width / 2, -self.frame.size.width / 2);
}

/**
 *  绘制显示百分比的label
 *
 *  @param context
 */
- (void)drawLabel:(CGContextRef)context
{
    NSMutableAttributedString *attrString = [self formatProcess:currentPercent];
    CGRect textSize = [attrString boundingRectWithSize:CGSizeMake(400, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGPoint textPoint = CGPointMake(self.frame.size.width / 2 - textSize.size.width / 2, self.frame.size.height / 2 - textSize.size.height / 2);
    
    [attrString drawAtPoint:textPoint];
    
    //推入
    CGContextSaveGState(context);

}

/**
 *  设置显示的百分比属性
 *
 *  @param cPercent
 *
 *  @return
 */
- (NSMutableAttributedString *)formatProcess:(CGFloat)cPercent
{
    NSMutableAttributedString *attrString;
    UIColor *strColor = [UIColor whiteColor];
    NSInteger percent = (long)(cPercent * 100);
    NSString *percentString = [NSString stringWithFormat:@"%ld%%", percent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    attrString = [[NSMutableAttributedString alloc] initWithString:percentString];
    UIFont *numberFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:60];
    UIFont *percentFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    if (percent < 10) {
        [attrString addAttribute:NSFontAttributeName value:numberFont range:NSMakeRange(0, 1)];
        [attrString addAttribute:NSFontAttributeName value:percentFont range:NSMakeRange(1, 1)];
        [attrString addAttribute:NSForegroundColorAttributeName value:strColor range:NSMakeRange(0, 2)];
        [attrString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 2)];
    } else if(percent >=100)
    {
        [attrString addAttribute:NSFontAttributeName value:numberFont range:NSMakeRange(0, 3)];
        [attrString addAttribute:NSFontAttributeName value:percentFont range:NSMakeRange(3, 1)];
        [attrString addAttribute:NSForegroundColorAttributeName value:strColor range:NSMakeRange(0, 4)];
        [attrString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 4)];
    }else
    {
        [attrString addAttribute:NSFontAttributeName value:numberFont range:NSMakeRange(0, 2)];
        [attrString addAttribute:NSFontAttributeName value:percentFont range:NSMakeRange(2, 1)];
        [attrString addAttribute:NSForegroundColorAttributeName value:strColor range:NSMakeRange(0, 3)];
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 3)];
    }
    return attrString;
}

/**
 *  实时调用产生波浪的动画效果
 */
-(void)animateWave
{
    currentPercent += 0.008;
    if (currentPercent >= process) {
        currentPercent = process;
    }
    
    if (a == M_PI * 15 / 16 ) {
        a = M_PI / 8;
    }else
    {
       a += M_PI / 160;
    }
    [self setNeedsDisplay];
}

@end
