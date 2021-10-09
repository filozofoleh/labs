import sys
from math import sqrt

from exceptions import *


def get_cli_args( ):
    try:
        script_name,a,b,c = sys.argv
        for param in a,b,c:
            if not validate_param( param ):
                raise CmdParamsError
    except ValueError:
        raise CmdParamsError
    return (int( a ),int( b ),int( c ))


def validate_param( param: str ):
    return (param.isdigit( ) or (param and param[ 0 ] == '-' and param[ 1: ].isdigit( )))


def get_param( param_name: str ):
    for i in range( 3 ):
        param = input( 'Enter ' + param_name + ':' )
        if validate_param( param ):
            return int( param )
    exit( 1 )


def get_input( ):
    a = get_param( 'a' )
    b = get_param( 'b' )
    c = get_param( 'c' )
    return a,b,c


def discriminant( a: int,b: int,c: int ) -> int:
    d = b * b - 4 * a * c
    if d < 0:
        raise NoRoots
    return d


def roots( d: int,a: int,b: int,c: int ) -> tuple:
    if d > 0:
        x1 = (((-b) + sqrt( d )) / (2 * a))
        x2 = (((-b) - sqrt( d )) / (2 * a))
        result = (x1,x2)
    elif d == 0:
        x = (-b) / 2 * a
        result = (x,)
    else:
        raise NoRoots

    return result


def solv_square( a: int,b: int,c: int ):
    if a == 0 and b != 0:
        linX = -c / b
        return (linX,)
    elif b == 0 and c != 0:
        raise NoRoots
    elif b == 0 and c == 0:
        raise InfiniteRoots
    d = discriminant( a,b,c )
    return roots( d,a,b,c )


def square_print( a: int,b: int,c: int,roots: tuple ):
    print( f'{a}x^2+{b}x+{c}=0' )
    l = len( roots )
    if l == 2:
        print( 'roots: 1st -> {:.3f} *** 2nd -> {:.3f}'.format( roots[ 0 ],roots[ 1 ] ) )
    else:
        print( 'root is: {:.3f}'.format( roots[ 0 ] ) )


def main( ):
    try:
        if len( sys.argv ) > 1:
            a,b,c = get_cli_args( )
        else:
            a,b,c = get_input( )
        roots = solv_square( a,b,c )
        square_print( a,b,c,roots )
    except InfiniteRoots:
        print( 'Infinite roots.....' )
    except NoRoots:
        print( 'No roots...' )
    except ExceptionWithExitCode as error:
        print( error.exit_code )


if __name__ == '__main__':
    main( )
