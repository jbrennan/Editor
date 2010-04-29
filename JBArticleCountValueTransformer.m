//
//  JBArticleCountValueTransformer.m
//  Editor
//
//  Created by Jason Brennan on 10-04-29.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import "JBArticleCountValueTransformer.h"


@implementation JBArticleCountValueTransformer

+ (Class)transformedValueClass { 
	return [NSString class];
}


+ (BOOL)allowsReverseTransformation {
	return NO;
}


- (id)transformedValue:(id)value {
    return (value == nil) ? nil : [NSString stringWithFormat:@"%d articles", [(NSNumber *)value intValue]];
}


@end
