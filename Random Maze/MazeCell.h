//
//  MazeCell.h
//  Random Maze
//
//  Created by Coach Roebuck on 4/18/17.
//  Copyright © 2017 Coach Roebuck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MazeCell : NSObject

@property (nonatomic, copy) NSArray * indices;
@property (nonatomic, copy) NSArray * vertices;
@property (nonatomic, copy) NSArray * edges;
@property (nonatomic, copy) NSNumber * direction;

+ (instancetype) instanceAtRow:(NSInteger)row
                        column:(NSInteger)column
                         width:(NSInteger)width
                        height:(NSInteger)height
                     totalRows:(NSInteger)totalRows;

+ (instancetype) instanceWithIndices:(NSArray *)indices
                                  edges:(NSArray *)edges;

@end
