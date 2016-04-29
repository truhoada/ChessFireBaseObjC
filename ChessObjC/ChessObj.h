//
//  ChessObj.h
//  ChessObjC
//
//  Created by hoangdangtrung on 4/19/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChessObj : NSObject
@property(nonatomic, strong) NSArray *chessPosition;
@property(nonatomic, strong) NSString *playerMove;
@property(nonatomic, strong) NSString *nameChess;
@property(nonatomic, strong) NSArray *previousChessPosition;

- (instancetype)initWithNameChess: (NSString*)name withChessPosition: (NSArray*)chessPosition withPreviousChessPosition: (NSArray*)prePosition withPlayerMove: (NSString*)playerMove andFlagArray: (NSArray*)flagArray;

@end
