//
//  MazeCell.m
//  Random Maze
//
//  Created by Coach Roebuck on 4/18/17.
//  Copyright © 2017 Coach Roebuck. All rights reserved.
//

@import UIKit;
#import "MazeCell.h"
#import "MazeEdge.h"

@implementation MazeCell

+ (instancetype) instanceAtRow:(NSInteger)row
                        column:(NSInteger)column
                         width:(NSInteger)width
                        height:(NSInteger)height
                     totalRows:(NSInteger)totalRows {
    
    MazeCell * instance = [MazeCell new];
    
    CGPoint topLeft = CGPointMake(width * column,
                                  height * row);
    CGPoint topRight = CGPointMake(width * (column + 1),
                                  height * row);
    CGPoint bottomLeft = CGPointMake(width * column,
                                  height * (row + 1));
    CGPoint bottomRight = CGPointMake(width * (column + 1),
                                  height * (row + 1));
    
    instance.indices = @[@((totalRows * row) + column)];
    instance.vertices = @[
                          [NSValue valueWithCGPoint:topLeft],
                          [NSValue valueWithCGPoint:topRight],
                          [NSValue valueWithCGPoint:bottomLeft],
                          [NSValue valueWithCGPoint:bottomRight],
                          ];
    NSMutableArray * mutableArray = [NSMutableArray new];
    [mutableArray addObject:[MazeEdge instanceFrom:topLeft to:topRight]];
    [mutableArray addObject:[MazeEdge instanceFrom:topRight to:bottomRight]];
    [mutableArray addObject:[MazeEdge instanceFrom:bottomRight to:bottomLeft]];
    [mutableArray addObject:[MazeEdge instanceFrom:bottomLeft to:topLeft]];
    instance.edges = mutableArray.copy;
    
    return instance;
}

+ (instancetype) instanceWithIndices:(NSArray *)indices
                               edges:(NSArray *)edges {
    
    MazeCell * instance = [MazeCell new];
    
    instance.indices = indices;
    instance.edges = edges;
    
    return instance;
}

- (BOOL) isEqual:(id)object {
    if([object isMemberOfClass:[self class]]) {
        MazeCell * otherCell = object;
        BOOL result = [self.indices.lastObject isEqual:otherCell.indices.lastObject];
        return result;
    }
    
    return false;
}

- (NSString *) description {
    
    NSMutableString * ms = [NSMutableString new];
    
    [ms appendFormat:@"indices=["];
    [self.indices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber * index = obj;
        [ms appendFormat:@"%@, ", index];
    }];
    
    [ms appendFormat:@"] edges=[\n"];
    [self.edges enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MazeEdge * value = obj;
        [ms appendFormat:@"\t%@\n", [value description]];
    }];
    [ms appendFormat:@"]"];
    
    return ms.copy;
}

@end
