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
    else if ([tempName isEqualToString:@"Queen"]) {
        chessPieces = Queen;
    }
    else if ([tempName isEqualToString:@"Bishop"]) {
        chessPieces = Bishop;
    }
    else if ([tempName isEqualToString:@"Knight"]) {
        chessPieces = Knight;
    }
    else if ([tempName isEqualToString:@"Rook"]) {
        chessPieces = Rook;
    }
    else if ([tempName isEqualToString:@"Pawn"]) {
        chessPieces = Pawn;
    }
    
    switch (chessPieces) {
        case King:
            if ((abs([curPos[0] intValue] - [desPos[0] intValue]) > 1) || (((abs([curPos[1] intValue] - [desPos[1] intValue]) > 1)))) {
                return false; // Di > 1 buoc
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
            if ([curPos[0] intValue] - [desPos[0] intValue] == 2 && [curPos[0] intValue] == 6) {
                return true; // Di 2 buoc tai vi tri ban dau
            }
            if ((abs([curPos[0] intValue] - [desPos[0] intValue]) > 1) || (((abs([curPos[1] intValue] - [desPos[1] intValue]) > 1)))) {
                return false; //Vi tri ko di dc
            }
            if ([desPos[0] intValue] == 0 && [curPos[0] intValue] == 1) { //Phong hau
                if (self.nameChess != tempName) {
                    self.nameChess = @"whiteQueen";
                } else {
                    self.nameChess = @"Queen";
                }
                
                self.imageView.image = [UIImage imageNamed:self.nameChess];
            }
            if (type == 1) {
                if (![self.baseArray[[desPos[0] intValue]][[desPos[1] intValue]]  isEqual: @0]) {
                    return true;
                }
                return false;
            }
            if (type == 2) {
                if (![self.baseArray[[desPos[0] intValue]][[desPos[1] intValue]]  isEqual: @0]) {
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
    if (((abs([curPos[1] intValue] - [desPos[1] intValue]) == 1) && (abs([curPos[0] intValue] - [desPos[0] intValue]) == 2)) || (((abs([curPos[1] intValue] - [desPos[1] intValue]) == 2) && ((abs([curPos[0] intValue] - [desPos[0] intValue]) == 1))))) {
        return 0; // Ma~
    } else if (abs([curPos[0] intValue] - [desPos[0] intValue]) == abs([curPos[1] intValue] - [desPos[1] intValue])) {
        return 1; //Cheo
    } else if ([curPos[0] intValue] == [desPos[0] intValue] || [curPos[1] intValue] == [desPos[1] intValue]) {
        return 2; // Thang
    }
    return 3;
}

- (BOOL)checkDiagonalWithCurrentPosition:(NSArray*)curPos andDestinationPosition:(NSArray*)desPos {
    //0:rightUp
    //1:rightDown
    //2:leftUp
    //3:leftDown
    
    if (abs([curPos[0] intValue] - [desPos[0] intValue]) == 1 && abs([curPos[1] intValue] - [desPos[1] intValue]) == 1 && [self.baseArray[[desPos[0] intValue]][[desPos[1] intValue]] isEqual: @0]) {
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
    if (((abs([curPos[0] intValue] - [desPos[0] intValue]) == 1)) && (![self.nameChess containsString:[self convertToString:Pawn]]) && [self.baseArray[[desPos[0] intValue]][[desPos[1] intValue]] isEqual: @0]) {
        return true; // Tien/Lui 1
    }
    if ([desPos[0] intValue] < [curPos[0] intValue]) {
        //Up
        return [self loopCheckStraightWithPointA:curPos withPointB:desPos andWayToCheck:0];
    }
    if ([desPos[0] intValue] > [curPos[0] intValue]) {
        //Down
        if ([self.nameChess containsString:[self convertToString:Pawn]]) {
            return false;
        }
        return [self loopCheckStraightWithPointA:curPos withPointB:desPos andWayToCheck:1];
    } else {
        if ([self.nameChess containsString:[self convertToString:Pawn]]) {
            return false;
        }
        if ([desPos[1] intValue] < [curPos[1] intValue]) {
            //Left
            return [self loopCheckStraightWithPointA:curPos withPointB:desPos andWayToCheck:3];
        } else if ([desPos[1] intValue] > [curPos[1] intValue]) {
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
            break;
        case Rook:
            result = @"Rook";
            break;
        case Pawn:
            result = @"Pawn";
            break;
        default:
            result = @"unknown";
            break;
    }
    
    return result;
}


- (BOOL)loopCheckStraightWithPointA: (NSArray*)pointA withPointB: (NSArray*)pointB andWayToCheck:(int)wayToCheck {
    int row = [pointA[0] intValue];
    int col = [pointA[1] intValue];
    //Up,Down,Right,Left
    
    switch (wayToCheck) {
        case 0:
            //Up
            for (int i=row-1; i>[pointB[0] intValue]; i--) {
                if (![self.baseArray[i][col]  isEqual: @0]) {
                    return false;
                }
            }
            break;
        case 1:
            //Down
            for (int i=row+1; i<[pointB[0] intValue]; i++) {
                if (![self.baseArray[i][col]  isEqual: @0]) {
                    return false;
                }
            }
            break;
        case 2:
            //Right
            for (int i=col+1; i<[pointB[1] intValue]; i++) {
                if (![self.baseArray[row][i]  isEqual: @0]) {
                    return false;
                }
            }
            break;
        case 3:
            //Left
            for (int i=col-1; i>[pointB[1] intValue]; i--) {
                if (![self.baseArray[row][i]  isEqual: @0]) {
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
    int row = [pointA[0] intValue];
    int col = [pointA[1] intValue];
    //Up,Down,Right,Left
    
    switch (wayToCheck) {
        case 0:
            //rightUp
            for (int i=1; row - i >[pointB[0] intValue]; i++) {
                if (![self.baseArray[row-i][col+i]  isEqual: @0]) {
                    return false;
                }
            }
            break;
        case 1:
            //rightDown
            for (int i=1; i+row<[pointB[0] intValue]; i++) {
                if (![self.baseArray[row+i][col+i]  isEqual: @0]) {
                    return false;
                }
            }
            break;
        case 2:
            //leftUp
            for (int i=1; row-i>[pointB[0] intValue]; i++) {
                if (![self.baseArray[row-i][col-i]  isEqual: @0]) {
                    return false;
                }
            }
            break;
        case 3:
            //leftDown
            for (int i=1; i+row<[pointB[0] intValue]; i++) {
                if (![self.baseArray[row+i][col-i]  isEqual: @0]) {
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


























