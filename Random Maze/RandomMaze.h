//
//  RandomMaze.h
//  Random Maze
//
//  Created by Coach Roebuck on 4/18/17.
//  Copyright © 2017 Coach Roebuck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomMaze : NSObject

- (UIImage *) mazeWithRect:(CGRect)rect
                   columns:(NSInteger)columns
                      rows:(NSInteger)rows;

- (UIImage *) step;

- (UIImage *) run;

@end
