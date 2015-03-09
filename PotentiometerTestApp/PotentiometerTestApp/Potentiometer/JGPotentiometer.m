//
//  Potentiometer.m
//  potentiometer
//
//  Created by Jacek Grygiel on 05/05/14.
//  Copyright (c) 2014 Jacek Grygiel. All rights reserved.
//

#import "JGPotentiometer.h"

@implementation JGPotentiometerCirle

- (void)drawRect:(CGRect)rect
{
    
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* gradientColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Shadow Declarations
    UIColor* shadow = strokeColor;
    CGSize shadowOffset = CGSizeMake(1, -1);
    CGFloat shadowBlurRadius = 2.5;
    
    //// Group
    {
        //// potentiometer Drawing
        UIBezierPath* potentiometerPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1.5, 1.5, self.frame.size.width-3, self.frame.size.height-3)];
        [[UIColor whiteColor] setFill];
        [potentiometerPath fill];
        
        ////// potentiometer Inner Shadow
        CGRect potentiometerBorderRect = CGRectInset([potentiometerPath bounds], -shadowBlurRadius, -shadowBlurRadius);
        potentiometerBorderRect = CGRectOffset(potentiometerBorderRect, -shadowOffset.width, -shadowOffset.height);
        potentiometerBorderRect = CGRectInset(CGRectUnion(potentiometerBorderRect, [potentiometerPath bounds]), -1, -1);
        
        UIBezierPath* potentiometerNegativePath = [UIBezierPath bezierPathWithRect: potentiometerBorderRect];
        [potentiometerNegativePath appendPath: potentiometerPath];
        potentiometerNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = shadowOffset.width + round(potentiometerBorderRect.size.width);
            CGFloat yOffset = shadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        shadowBlurRadius,
                                        shadow.CGColor);
            
            [potentiometerPath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(potentiometerBorderRect.size.width), 0);
            [potentiometerNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [potentiometerNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        [gradientColor setStroke];
        potentiometerPath.lineWidth = 1;
        //[potentiometerPath stroke];
        
        
        //// line Drawing
        UIBezierPath* linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint: CGPointMake(self.frame.size.width/2, 3.14)];
        [linePath addCurveToPoint: CGPointMake(self.frame.size.width/2, self.frame.size.width/4) controlPoint1: CGPointMake(self.frame.size.width/2, self.frame.size.width/4) controlPoint2: CGPointMake(self.frame.size.width/2, self.frame.size.width/4)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        [strokeColor setFill];
        [linePath fill];
        
        ////// line Inner Shadow
        CGRect lineBorderRect = CGRectInset([linePath bounds], -shadowBlurRadius, -shadowBlurRadius);
        lineBorderRect = CGRectOffset(lineBorderRect, -shadowOffset.width, -shadowOffset.height);
        lineBorderRect = CGRectInset(CGRectUnion(lineBorderRect, [linePath bounds]), -1, -1);
        
        UIBezierPath* lineNegativePath = [UIBezierPath bezierPathWithRect: lineBorderRect];
        [lineNegativePath appendPath: linePath];
        lineNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = shadowOffset.width + round(lineBorderRect.size.width);
            CGFloat yOffset = shadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        shadowBlurRadius,
                                        shadow.CGColor);
            
            [linePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(lineBorderRect.size.width), 0);
            [lineNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [lineNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);
        
        [strokeColor setStroke];
        linePath.lineWidth = 2;
        [linePath stroke];
    }
    
}

@end

@implementation JGPotentiometer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pot = [[JGPotentiometerCirle alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.pot.backgroundColor = [UIColor clearColor];
        [self addSubview:self.pot];
        
        int i =0;
        self.tag = i;
        
        self.minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width/2, 10)];
        self.maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height, self.frame.size.width/2, 10)];
        
        self.minValueLabel.font = [UIFont systemFontOfSize:6.0];
        self.maxValueLabel.font = [UIFont systemFontOfSize:6.0];
        self.maxValueLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.minValueLabel];
        [self addSubview:self.maxValueLabel];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(potentiometerChanged:)];
        
        [self addGestureRecognizer:panGestureRecognizer];
        
        self.steps = 70;
        self.minValue = 0.0;
        self.maxValue = 1.0;
    }
    return self;
}


- (void)setCurrentValue:(float)currentValue{
    
    int tag  = (currentValue-self.minValue)/(self.maxValue-self.minValue)*self.steps;
    
    self.pot.layer.transform = CATransform3DMakeRotation(M_PI*2/12*10/self.steps*tag + M_PI*2/12*7, 0, 0, 1);
    
    self.tag = tag;
    
    _currentValue = currentValue;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.pot = [[JGPotentiometerCirle alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.pot.backgroundColor = [UIColor clearColor];
        [self addSubview:self.pot];
        
        int i =0;
        self.tag = i;
        
        self.minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width/2, 10)];
        self.maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height, self.frame.size.width/2, 10)];

        self.minValueLabel.font = [UIFont systemFontOfSize:6.0];
        self.maxValueLabel.font = [UIFont systemFontOfSize:6.0];
        self.maxValueLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.minValueLabel];
        [self addSubview:self.maxValueLabel];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(potentiometerChanged:)];
        
        [self addGestureRecognizer:panGestureRecognizer];
        
        self.steps = 70;
        self.minValue = 0.0;
        self.maxValue = 1.0;
    }
    return self;
}

- (void)setMinValue:(float)minValue{
    _minValue = minValue;
    self.minValueLabel.text = [NSString stringWithFormat:@"%.1f", minValue];
}
- (void)setMaxValue:(float)maxValue{
    _maxValue = maxValue;
    self.maxValueLabel.text = [NSString stringWithFormat:@"%.1f", maxValue];
}

- (void) potentiometerChanged:(id) sender{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*) sender;
    
    CGPoint vel = [pan velocityInView:self];
    
    if (vel.x > 0)
    {
        self.tag = self.tag+1;
    }else if(self.currentValue>=(self.maxValue-self.minValue)/2 && vel.y > 0){
        //self.tag = self.tag+1;
    }
    else if(vel.x < 0)
    {
        self.tag = self.tag-1;
    }else if(self.currentValue<(self.maxValue-self.minValue)/2 && vel.y <0){
        //self.tag = self.tag-1;

    }
    
    if (self.tag >= (int)self.steps) {
        self.tag = self.steps;
    }
    
    if (self.tag <= 0) {
        self.tag = 0;
    }
    
    self.pot.layer.transform = CATransform3DMakeRotation(M_PI*2/12*10/self.steps*self.tag + M_PI*2/12*7, 0, 0, 1);
    
    _currentValue = (float)self.tag/(float)self.steps * (self.maxValue-self.minValue) + self.minValue;
    
    switch (pan.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.callback ) {
                self.callback(self.currentValue);
            }
        }
        break;
            
        default:
            break;
    }

}

- (void) addChangeValueCallback:(PotentiometerCallback) potentiometerCallback{
    self.callback = potentiometerCallback;
}




@end
