//
//  MazeEdge.h
//  Random Maze
//
//  Created by Coach Roebuck on 4/18/17.
//  Copyright © 2017 Coach Roebuck. All rights reserved.
//

@import UIKit;
#import <Foundation/Foundation.h>

@interface MazeEdge : NSObject

@property (nonatomic, assign) CGPoint from;
@property (nonatomic, assign) CGPoint to;

+ (instancetype) instanceFrom:(CGPoint)from to:(CGPoint)to;

@end
