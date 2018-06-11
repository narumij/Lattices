#import "CIFLexer.h"
#include "lex.cif.h"
#if defined(SWIFT_CLASS)
#import "CIF-Swift.h"
#endif

@protocol CIFParser <NSObject>
-(void)nextLexeme:(void*)scanner tag:(CIFLexemeTag)tag text:(NSString*)text;
@end

@interface TestObject : NSObject<NSObject,CIFParser>
@end

CIFLexerExtra *getExtra( yyscan_t scanner )
{
    return cifget_extra(scanner);
}

TestObject *getObjc( yyscan_t scanner )
{
    return (__bridge TestObject*)getExtra(scanner)->ctx;
}

void setObjc( yyscan_t scanner, id obj )
{
    getExtra(scanner)->ctx = (__bridge_retained void *)obj;
}

void IssueLexeme(yyscan_t scanner,CIFLexemeTag tag,const char *textBytes,size_t len)
{
    id<CIFParser> obj = getObjc(scanner);
    NSString *text = CIFLexemeText(tag,textBytes,len);
    tag = CIFLexemeTagCheck(tag,text);
    [obj nextLexeme:scanner tag:tag text:text];
}

int CIFLexerWithFILE( FILE *fp, id obj ) {
    yyscan_t scanner;
    CIFLexerExtra extra;
    ciflex_init_extra( &extra, &scanner );
    cifset_in(fp,scanner);
#ifndef NDEBUG
    cifset_debug(1,scanner);
#endif
    setObjc(scanner,obj);
    int result = ciflex( scanner );
    setObjc(scanner,nil);
    ciflex_destroy ( scanner );
    return result;
}

int CIFLexer( const char *filepath, id obj )
{
#if 1
    FILE *fp = fopen( filepath, "r" );
    int result = CIFLexerWithFILE( fp, obj );
    fclose(fp);
    return result;
#else
    FILE *fp = fopen( filepath, "r" );
    yyscan_t scanner;
    CIFLexerExtra extra;
    ciflex_init_extra( &extra, &scanner );
    cifset_in(fp,scanner);
    cifset_debug(1,scanner);
    setObjc(scanner,obj);
    int result = ciflex( scanner );
    setObjc(scanner,nil);
    ciflex_destroy ( scanner );
    fclose(fp);
    return result;
#endif
}

size_t CIFLine( void *scanner )
{
    return cifget_lineno(scanner);
}

size_t CIFColumn( void *scanner )
{
    return cifget_column(scanner);
}

#if MAIN
int main ( int argc, char * argv[] )
{
    TestObject *obj = [[TestObject alloc] init];

    FILE *fp = NULL;
    yyscan_t scanner;
    CIFLexerExtra extra;
    ciflex_init_extra( &extra, &scanner );

    setObjc(scanner,obj);

    if ( argc == 2 )
    {
        fp = fopen(argv[1],"r");
        cifset_in(fp,scanner);
    }

    cifset_debug(1,scanner);

    ciflex( scanner );

    setObjc(scanner,nil);
    ciflex_destroy ( scanner );

    if ( fp != NULL )
    {
        fclose(fp);
    }
    
    return 0;
}
#endif

#define TAGSTRING(TAG) @#TAG

NSString *CIFLexemeTagName( CIFLexemeTag tag )
{
    NSString *tagName = @"";
    switch (tag) {
            case LexerError:
            tagName = TAGSTRING(LexerError);
            break;
            case LData_:
            tagName = TAGSTRING(LData_);
            break;
            case LLoop_:
            tagName = TAGSTRING(LLoop_);
            break;
            case LSaveBegin:
            tagName = TAGSTRING(LSaveBegin);
            break;
            case LSaveEnd:
            tagName = TAGSTRING(LSaveEnd);
            break;
            case LTag:
            tagName = TAGSTRING(LTag);
            break;
            case LNumeric:
            tagName = TAGSTRING(LNumeric);
            break;
            case LQuoteString:
            tagName = TAGSTRING(LQuoteString);
            break;
            case LUnquoteString:
            tagName = TAGSTRING(LUnquoteString);
            break;
            case LTextField:
            tagName = TAGSTRING(LTextField);
            break;
            case LDot:
            tagName = TAGSTRING(LDot);
            break;
            case LQue:
            tagName = TAGSTRING(LQue);
            break;
        default:
            break;
    }
    return tagName;
}

NSString *CIFLexemeText( CIFLexemeTag tag, const char * textBytes, size_t length )
{
    NSString *text = [[NSString alloc] initWithBytes:textBytes length:length encoding:NSUTF8StringEncoding];

    while ( [text characterAtIndex:0] == ' ' ) {
        text = [text substringFromIndex:1];
    }

    while ( [text characterAtIndex:0] == 10 ||
           [text characterAtIndex:0] == 13 ) {
        text = [text substringFromIndex:1];
    }

    while ( [text characterAtIndex:text.length-1] == 10
           || [text characterAtIndex:text.length-1] == 13 ) {
        text = [text substringToIndex:text.length-1];
    }

    switch (tag) {
            case LQuoteString:
            case LTextField:
            text = [text substringWithRange:NSMakeRange(1,text.length-2)];
            break;
            case LData_:
            case LSaveBegin:
            text = [text substringFromIndex:5];
            break;
        default:
            break;
    }
    return text;
}

CIFLexemeTag CIFLexemeTagCheck( CIFLexemeTag tag, NSString *text )
{
    if ( [text isEqualToString:@"."] )
    return LDot;
    if ( [text isEqualToString:@"?"] )
    return LQue;
    return tag;
}


@implementation TestObject

-(void)nextLexeme:(void*)scanner tag:(CIFLexemeTag)tag text:(NSString*)text
{
    NSLog(@"[line:%d column:%d] Token (%@) -> (%@) ",cifget_lineno(scanner),cifget_column(scanner),CIFLexemeTagName(tag),text);
}

@end




















