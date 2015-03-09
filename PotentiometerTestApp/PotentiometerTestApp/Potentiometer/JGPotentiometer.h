//
//  Potentiometer.h
//  potentiometer
//
//  Created by Jacek Grygiel on 05/05/14.
//  Copyright (c) 2014 Jacek Grygiel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PotentiometerCallback)(float currentValue);


@interface JGPotentiometerCirle : UIView
@end

@interface JGPotentiometer : UIView
@property(nonatomic, retain) JGPotentiometerCirle *pot;
@property(nonatomic, assign) NSUInteger steps;
@property(nonatomic, assign) float maxValue;
@property(nonatomic, assign) float minValue;
@property(nonatomic, assign) float currentValue;
@property(nonatomic, copy) PotentiometerCallback callback;


@property(nonatomic, retain) UILabel *minValueLabel;
@property(nonatomic, retain) UILabel *maxValueLabel;
- (void) addChangeValueCallback:(PotentiometerCallback) potentiometerCallback;

@end
