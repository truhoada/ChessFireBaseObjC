//
//  ChessView.m
//  ChessObjC
//
//  Created by hoangdangtrung on 4/19/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

#import "ChessView.h"
#import "ChessObj.h"



@implementation ChessView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubviews];
    }
    
    return self;
}


- (void)addSubviews {
    if (self.imageView == nil) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
        self.imageView.layer.borderColor = self.tintColor.CGColor;
        [self addSubview:self.imageView];
    }
}

//- (BOOL)calculatePositionWithCurrentPosition:(NSArray*)curPos andDestinationPosition:(NSArray*)desPos {
//    NSString *tempName = self.nameChess;
//    NSRange textRange = [tempName rangeOfString:@"white"];
//    tempName = [tempName substringFromIndex:textRange.length];//???
//}

//- (NSArray*)calculateDiagonalWithPosition:(NSArray*)pos isMaxPosition:(BOOL)isMax {
//    bool leftUp = false;
//    bool leftDown = false;
//    bool rightUp = false;
//    bool rightDown = false;
//
//    if ((int)[pos objectAtIndex:1] - 1 >= 0) {
//        if ((int)[pos objectAtIndex:0] - 1 >= 0) {
//            leftUp = true;
//        }
//        if (((int)[pos objectAtIndex:0] + 1 >= 0) && ((int)[pos objectAtIndex:0] + 1 < 8)) {
//            leftDown = true;
//        }
//    }
//    if ((int)[pos objectAtIndex:1] + 1 >= 0) {
//        if ((int)[pos objectAtIndex:0] - 1 >= 0) {
//            rightUp = true;
//        }
//        if (((int)[pos objectAtIndex:0] + 1 >= 0) && ((int)[pos objectAtIndex:0] + 1 < 8)) {
//            rightDown = true;
//        }
//    }
//    return @[[NSNumber numberWithBool:leftUp], [NSNumber numberWithBool:leftDown], [NSNumber numberWithBool:rightUp], [NSNumber numberWithBool:rightDown]];
//}

- (BOOL)checkDiagonalWithCurrentPosition:(NSArray*)curPos andDestinationPosition:(NSArray*)desPos {
    //0:rightUp
    //1:rightDown
    //2:leftUp
    //3:leftDown
    
    if (abs((int)curPos[0] - (int)desPos[0]) == 1 && abs((int)curPos[1] - (int)desPos[1]) == 1) {
        //
        return true;
    }
    if (desPos[0] < curPos[0]) {
        if (desPos[1] > curPos[1]) {
            //rightup
            return [self loopCheckDiagonalWithPointA:curPos withPointB:desPos andWayToCheck:0];
        }
        if (desPos[1] < curPos[1]) {
            //leftUp
            return [self loopCheckDiagonalWithPointA:curPos withPointB:desPos andWayToCheck:2];
        }
    }
    if (desPos[0] > curPos[0]) {
        if (desPos[1] > curPos[1]) {
            return [self loopCheckDiagonalWithPointA:curPos withPointB:desPos andWayToCheck:1];
        }
    }
}




- (BOOL)loopCheckStraightWithPointA: (NSArray*)pointA withPointB: (NSArray*)pointB andWayToCheck:(int)wayToCheck {
    int row = (int)pointA[0];
    int col = (int)pointA[1];
    //Up,Down,Right,Left
    
    switch (wayToCheck) {
        case 0:
            //Up
            for (int i=row-1; i>(int)pointB[0]; i--) {
                if (self.baseArray[i][col] != 0) {
                    return false;
                }
            }
            break;
        case 1:
            //Down
            for (int i=row+1; i<(int)pointB[0]; i++) {
                if (self.baseArray[i][col] != 0) {
                    return false;
                }
            }
            break;
        case 2:
            //Right
            for (int i=col+1; i<(int)pointB[1]; i++) {
                if (self.baseArray[row][i] != 0) {
                    return false;
                }
            }
            break;
        case 3:
            //Left
            for (int i=col-1; i>(int)pointB[1]; i--) {
                if (self.baseArray[row][i] != 0) {
                    return false;
                }
            }
            break;
            
        default: {
            return true;
            break;
        }
    }
    return true;
}


- (BOOL)loopCheckDiagonalWithPointA: (NSArray*)pointA withPointB: (NSArray*)pointB andWayToCheck:(int)wayToCheck {
    //
    int row = (int)pointA[0];
    int col = (int)pointA[1];
    //Up,Down,Right,Left
    
    switch (wayToCheck) {
        case 0:
            //rightUp
            for (int i=1; row - i >(int)pointB[0]; i++) {
                if (self.baseArray[row-i][col+i] != 0) {
                    return false;
                }
            }
            break;
        case 1:
            //rightDown
            for (int i=1; i+row<(int)pointB[0]; i++) {
                if (self.baseArray[row+i][col+i] != 0) {
                    return false;
                }
            }
            break;
        case 2:
            //leftUp
            for (int i=1; row-i>(int)pointB[0]; i++) {
                if (self.baseArray[row-i][col-i] != 0) {
                    return false;
                }
            }
            break;
        case 3:
            //leftDown
            for (int i=1; i+row<(int)pointB[0]; i++) {
                if (self.baseArray[row+i][col-i] != 0) {
                    return false;
                }
            }
            break;
            
        default: {
            return true;
            break;
        }
    }
    return true;
}







@end


























