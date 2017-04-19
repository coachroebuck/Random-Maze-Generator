//
//  MazeEdge.m
//  Random Maze
//
//  Created by Coach Roebuck on 4/18/17.
//  Copyright © 2017 Coach Roebuck. All rights reserved.
//

#import "MazeEdge.h"

@implementation MazeEdge

+ (instancetype) instanceFrom:(CGPoint)from to:(CGPoint)to {
    MazeEdge * instance = [MazeEdge new];
    
    //from left to right, top to bottom
    if(from.x < to.x
       || from.y < to.y) {
        instance.from = from;
        instance.to = to;
    }
    else {
        instance.from = to;
        instance.to = from;
    }

    return instance;
}

- (BOOL) isEqual:(id)object {
    if([object isMemberOfClass:[self class]]) {
        MazeEdge * otherEdge = object;
        BOOL result = (CGPointEqualToPoint(self.from, otherEdge.from)
                || CGPointEqualToPoint(self.from, otherEdge.to))
        && (CGPointEqualToPoint(self.to, otherEdge.from)
            || CGPointEqualToPoint(self.to, otherEdge.to));
        return result;
    }
    
    return false;
}

- (NSString *) description {
    NSMutableString * ms = [NSMutableString new];
    
    [ms appendFormat:@" from=[%@] to=[%@] ",
     NSStringFromCGPoint(self.from),
     NSStringFromCGPoint(self.to)];
    return ms.copy;
}

@end
