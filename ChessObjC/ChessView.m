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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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

- (BOOL)calculatePositionWithCurrentPosition:(NSArray*)curPos andDestinationPosition:(NSArray*)desPos {
    NSString *tempName = self.nameChess;
    NSRange textRange = [tempName rangeOfString:@"white"];
    tempName = [tempName substringFromIndex:textRange.length];//???
    
    int type = [self jumpTypesWithCurrentPosition:curPos andDestinationPosition:desPos];
    
    ChessPieces chessPieces = Pawn;
    if ([tempName isEqualToString:@"King"]) {
        chessPieces = King;
    }
    if ([tempName isEqualToString:@"Queen"]) {
        chessPieces = Queen;
    }
    if ([tempName isEqualToString:@"Bishop"]) {
        chessPieces = Bishop;
    }
    if ([tempName isEqualToString:@"Knight"]) {
        chessPieces = Knight;
    }
    if ([tempName isEqualToString:@"Rook"]) {
        chessPieces = Rook;
    }
    if ([tempName isEqualToString:@"Pawn"]) {
        chessPieces = Pawn;
    }
    
    switch (chessPieces) {
        case King:
            if ((abs((int)curPos[0] - (int)desPos[0]) > 1) || (((abs((int)curPos[1] - (int)desPos[1]) > 1)))) {
                return false;
            }
            if (type == 2) {
                return [self checkStraightWithCurrentPosition:curPos andDestinationPosition:desPos];
            }
            if (type == 1) {
                return [self checkDiagonalWithCurrentPosition:curPos andDestinationPosition:desPos];
            }
            break;
            
        case Queen:
            if (type == 2) {
                return [self checkStraightWithCurrentPosition:curPos andDestinationPosition:desPos];
            }
            if (type == 1) {
                return [self checkDiagonalWithCurrentPosition:curPos andDestinationPosition:desPos];
            }
            break;
            
        case Rook:
            if (type == 2) {
                return [self checkStraightWithCurrentPosition:curPos andDestinationPosition:desPos];
            }
            break;
            
        case Bishop:
            if (type == 1) {
                return [self checkDiagonalWithCurrentPosition:curPos andDestinationPosition:desPos];
            }
            break;
            
        case Knight:
            if (type == 0) {
                return true;
            }
            break;
            
        case Pawn:
            if ((int)curPos[0] - (int)desPos[0] == 2 && (int)curPos[0] == 6) {
                return true;
            }
            if ((abs((int)curPos[0] - (int)desPos[0]) > 1) || (((abs((int)curPos[1] - (int)desPos[1]) > 1)))) {
                return false;
            }
            if ((int)desPos[0] == 0 && (int)curPos[0] == 1) {
                if (self.nameChess != tempName) {
                    self.nameChess = @"whiteQueen";
                } else {
                    self.nameChess = @"Queen";
                }
                
                self.imageView.image = [UIImage imageNamed:self.nameChess];
            }
            if (type == 1) {
                if (self.baseArray[(int)desPos[0]][(int)desPos[1]] != 0) {
                    return true;
                }
                return false;
            }
            if (type == 2) {
                if (self.baseArray[(int)desPos[0]][(int)desPos[1]] != 0) {
                    return false;
                }
                return [self checkStraightWithCurrentPosition:curPos andDestinationPosition:desPos];
            }
            
            break;
            
        default: false;
            break;
    }
    return false;
    
}

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


- (int)jumpTypesWithCurrentPosition:(NSArray*)curPos andDestinationPosition:(NSArray*)desPos {
    if (((abs((int)curPos[0] - (int)desPos[0]) == 1) && (abs((int)curPos[0] - (int)desPos[0]) == 2)) || (((abs((int)curPos[1] - (int)desPos[1]) == 2) && ((abs((int)curPos[0] - (int)desPos[0]) == 1))))) {
        return 0;
    } else if (curPos[0] != desPos[0] && curPos[1] != desPos[1]) {
        return 1;
    } else {
        return 2;
    }
}

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
        if (desPos[1] < curPos[1]) {
            return [self loopCheckDiagonalWithPointA:curPos withPointB:desPos andWayToCheck:3];
        }
    }
    return false;
}


- (BOOL)checkStraightWithCurrentPosition:(NSArray*)curPos andDestinationPosition:(NSArray*)desPos {
    //0:Up
    //1:Down
    //2:Left
    //3:Right
    if (((abs((int)curPos[0] - (int)desPos[0]) == 1)) && (self.nameChess != [self convertToString:Pawn])) {
        return true;
    }
    if (desPos[0] < curPos[0]) {
        //Up
        return [self loopCheckStraightWithPointA:curPos withPointB:desPos andWayToCheck:0];
    }
    if (desPos[0] > curPos[0]) {
        //Down
        if (self.nameChess == [self convertToString:Pawn]) {
            return false;
        }
        return [self loopCheckStraightWithPointA:curPos withPointB:desPos andWayToCheck:1];
    } else {
        if (self.nameChess == [self convertToString:Pawn]) {
            return false;
        }
        if (desPos[1] < curPos[1]) {
            //Left
            return [self loopCheckStraightWithPointA:curPos withPointB:desPos andWayToCheck:3];
        } else if (desPos[1] > curPos[1]) {
            //Right
            return [self loopCheckStraightWithPointA:curPos withPointB:desPos andWayToCheck:2];
        }
        return false;
    }
}

- (NSString*) convertToString:(ChessPieces) chessPieces {
    NSString *result = nil;
    
    switch(chessPieces) {
        case King:
            result = @"King";
            break;
        case Queen:
            result = @"Queen";
            break;
        case Bishop:
            result = @"Bishop";
            break;
        case Knight:
            result = @"Knight";
        case Rook:
            result = @"Rook";
        case Pawn:
            result = @"Pawn";
        default:
            result = @"unknown";
    }
    
    return result;
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


























