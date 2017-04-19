
//
//  RandomMaze.m
//  Random Maze
//
//  Created by Coach Roebuck on 4/18/17.
//  Copyright © 2017 Coach Roebuck. All rights reserved.
//

@import UIKit;
#import "RandomMaze.h"
#import "MazeCell.h"
#import "MazeEdge.h"
#include <stdlib.h>

typedef enum : NSUInteger {
    North,
    South,
    East,
    West
} DirectionType;

@interface RandomMaze ()

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) NSInteger columns;
@property (nonatomic, assign) NSInteger rows;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSMutableArray * stack;
@property (nonatomic, strong) NSMutableArray * ma;
@property (nonatomic, strong) NSMutableArray * directions;
@property (nonatomic, strong) MazeCell * maze;

@end

@implementation RandomMaze

- (UIImage *) mazeWithRect:(CGRect)rect
                   columns:(NSInteger)columns
                      rows:(NSInteger)rows {
    
    self.rect = rect;
    self.width = self.rect.size.width / columns;
    self.height = self.rect.size.height / rows;
    self.columns = columns;
    self.rows = rows;
    self.ma = [NSMutableArray new];
    for(NSInteger i = 0; i < rows; i++) {
        for(NSInteger j = 0; j < columns; j++) {
            MazeCell * cell = [MazeCell instanceAtRow:i column:j width:self.width height:self.height totalRows:rows];
            [self.ma addObject:cell];
        }
    }
    
    //Choose a random cell
    self.stack = [NSMutableArray new];
    NSInteger index = arc4random()%self.ma.count;
    [self.stack addObject:@(index)];
    self.directions = @[@(North), @(South), @(East), @(West)].mutableCopy;
    NSNumber * number = self.stack.firstObject;
    MazeCell * cell = self.ma[number.integerValue];
    self.maze = [MazeCell instanceWithIndices:@[cell.indices.lastObject]
                                        edges:cell.edges];
    
    return [self draw];
}

- (UIImage *) run {
    while(self.stack.count > 0) {
        [self runCycle];
    }
    return [self draw];
}

- (UIImage *) step {
    [self runCycle];
    return [self draw];
}

- (void) runCycle {
    
    if(self.stack.count > 0) {
        NSNumber * number = self.stack.firstObject;
        MazeCell * cell = self.ma[number.integerValue];
        MazeCell * adjacentCell = nil;
        NSInteger indexOfAdjacentCell = -1;
        __block NSInteger indexOfCell = -1;
        
        if(self.directions.count > 0) {
            NSInteger indexOfDirection = arc4random()%self.directions.count;
            NSNumber * direction = self.directions[indexOfDirection];
            [self.directions removeObjectAtIndex:indexOfDirection];
            indexOfCell = [self.ma indexOfObject:cell];
            
            switch (direction.unsignedIntegerValue) {
                case North:
                    indexOfAdjacentCell = indexOfCell - self.rows;
                    if(indexOfAdjacentCell > -1) {
                        adjacentCell = self.ma[indexOfAdjacentCell];
                        NSLog(@"from=[%ld] NORTH to=[%ld]", indexOfCell, indexOfAdjacentCell);
                    }
                    break;
                case South:
                    indexOfAdjacentCell = indexOfCell + self.rows;
                    if(indexOfAdjacentCell < self.ma.count) {
                        adjacentCell = self.ma[indexOfAdjacentCell];
                        NSLog(@"from=[%ld] South to=[%ld]", indexOfCell, indexOfAdjacentCell);
                    }
                    break;
                case East:
                    indexOfAdjacentCell = indexOfCell + 1;
                    if(indexOfAdjacentCell%self.columns != 0) {
                        adjacentCell = self.ma[indexOfAdjacentCell];
                        NSLog(@"from=[%ld] East to=[%ld]", indexOfCell, indexOfAdjacentCell);
                    }
                    break;
                case West:
                    indexOfAdjacentCell = indexOfCell - 1;
                    if(indexOfAdjacentCell > -1
                       && indexOfAdjacentCell%self.columns != self.columns - 1) {
                        adjacentCell = self.ma[indexOfAdjacentCell];
                        NSLog(@"from=[%ld] West to=[%ld]", indexOfCell, indexOfAdjacentCell);
                    }
                    break;
                    
                default:
                    break;
            }
        }
        
        //Were we inbounds?
        if(adjacentCell) {
            if([self.stack containsObject:@(indexOfAdjacentCell)]
               || [self.maze.indices containsObject:@(indexOfAdjacentCell)]) {
                if(self.directions.count == 0) {
                    [self.stack removeObjectAtIndex:0];
                    self.directions = @[@(North), @(South), @(East), @(West)].mutableCopy;
                }
            }
            else if(!self.maze) {
                NSMutableArray * intersection = [NSMutableArray new];
                [cell.edges enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MazeEdge * edge = obj;
                    [adjacentCell.edges enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                        MazeEdge * otherEdge = obj1;
                        
                        if((CGPointEqualToPoint(edge.from, otherEdge.from) || CGPointEqualToPoint(edge.from, otherEdge.to))
                           && (CGPointEqualToPoint(edge.to, otherEdge.from) || CGPointEqualToPoint(edge.to, otherEdge.to))) {
                            [intersection addObject:edge];
                        }
                    }];
                }];
                NSMutableArray * cellEdges = cell.edges.mutableCopy;
                NSMutableArray * adjacentCellEdges = adjacentCell.edges.mutableCopy;
                [cellEdges removeObjectsInArray:intersection];
                [adjacentCellEdges removeObjectsInArray:intersection];
                self.maze = [MazeCell instanceWithIndices:@[cell.indices.lastObject,
                                                            adjacentCell.indices.lastObject]
                                                    edges:[cellEdges arrayByAddingObjectsFromArray:adjacentCellEdges]];
                [self.stack insertObject:@(indexOfAdjacentCell) atIndex:0];
                self.directions = @[@(North), @(South), @(East), @(West)].mutableCopy;
            }
            else {
                NSMutableArray * indices = self.maze.indices.mutableCopy;
                [indices addObject:adjacentCell.indices.lastObject];
                self.maze.indices = indices.copy;
                
                NSMutableArray * intersection = [NSMutableArray new];
                [cell.edges enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MazeEdge * edge = obj;
                    [adjacentCell.edges enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                        MazeEdge * otherEdge = obj1;
                        
                        if((CGPointEqualToPoint(edge.from, otherEdge.from) || CGPointEqualToPoint(edge.from, otherEdge.to))
                           && (CGPointEqualToPoint(edge.to, otherEdge.from) || CGPointEqualToPoint(edge.to, otherEdge.to))) {
                            [intersection addObject:edge];
                        }
                    }];
                }];
                
                NSMutableArray * cellEdges = self.maze.edges.mutableCopy;
                NSMutableArray * adjacentCellEdges = adjacentCell.edges.mutableCopy;
                [cellEdges removeObjectsInArray:intersection];
                [adjacentCellEdges removeObjectsInArray:intersection];
                NSArray * array = [cellEdges arrayByAddingObjectsFromArray:adjacentCellEdges];
                self.maze.edges = array;
                [self.stack insertObject:@(indexOfAdjacentCell) atIndex:0];
                self.directions = @[@(North), @(South), @(East), @(West)].mutableCopy;
            }
        }
        else if(self.directions.count == 0) {
            [self.stack removeObjectAtIndex:0];
            self.directions = @[@(North), @(South), @(East), @(West)].mutableCopy;
        }
        
        NSLog(@"total in stack=[%ld]", self.stack.count);
    }
}

- (UIImage *) draw {
    UIGraphicsBeginImageContext(self.rect.size);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    
    [self.maze.edges enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MazeEdge * edge = obj;
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), edge.from.x, edge.from.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), edge.to.x, edge.to.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    }];
    
    UIImage * img =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
