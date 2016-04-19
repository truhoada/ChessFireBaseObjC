//
//  ChessObj.m
//  ChessObjC
//
//  Created by hoangdangtrung on 4/19/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

#import "ChessObj.h"

@implementation ChessObj

- (instancetype)initWithNameChess:(NSString *)name withChessPosition:(NSArray *)chessPosition withPreviousChessPosition:(NSArray *)prePosition withPlayerMove:(NSString *)playerMove andBaseArray:(NSArray *)baseArray {
    
    self.chessPosition = chessPosition;
    self.previousChessPosition = prePosition;
    self.playerMove = playerMove;
    self.nameChess = name;
    
    return self;
}

@end
