// Copyright © 2016 zenithgear inc. All rights reserved.

#ifndef CIFLEXER_H_GUARD
#define CIFLEXER_H_GUARD

#define CIF_LEXER_LOG 0

#include <stdlib.h>

enum CIFLexemeTag {
    LexerError,
    LData_,
    LLoop_,
    LSaveBegin,
    LSaveEnd,
    LTag,
    LNumeric,
    LQuoteString,
    LUnquoteString,
    LTextField,
    LDot,
    LQue,
    LEOF
};
typedef enum CIFLexemeTag CIFLexemeTag;

struct CIFLexerExtra {
    void *ctx;
};
typedef struct CIFLexerExtra CIFLexerExtra;

void IssueLexeme(void *scanner,CIFLexemeTag tag,const char *text,size_t len);

#ifdef __OBJC__
#import <Foundation/Foundation.h>
int CIFLexer( const char *filepath, id callbackObject );
int CIFLexerWithFILE( FILE *fp, id obj );
size_t CIFLine( void *scanner );
size_t CIFColumn( void *scanner );

NSString *CIFLexemeTagName( CIFLexemeTag tag );
NSString *CIFLexemeText( CIFLexemeTag tag, const char * textBytes, size_t length );
CIFLexemeTag CIFLexemeTagCheck( CIFLexemeTag tag, NSString *text );
#endif

#endif

