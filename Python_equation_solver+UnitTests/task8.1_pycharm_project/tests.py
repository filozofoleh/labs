import unittest

from exceptions import *
from solv_square_equation import discriminant
from solv_square_equation import roots
from solv_square_equation import solv_square


class TestDiscriminant( unittest.TestCase ):
    def test_correct_coefs_1( self ):
        self.assertEqual( discriminant( 2,10,8 ),36 )

    def test_correct_coefs_2( self ):
        self.assertEqual( discriminant( 1,5,3 ),13 )

    def test_correct_coefs_3( self ):
        self.assertEqual( discriminant( 2,16,32 ),0 )

    def test_incorrect_coefs( self ):
        self.assertRaises( NoRoots,discriminant,3,4,5 )


class TestRoots( unittest.TestCase ):
    def test_correct_coefs_1( self ):
        correct_output = (-0.2,-2)  # roots
        function_output = roots( 81,5,11,2 )
        # запишется результат
        self.assertEqual( function_output,correct_output )

    def test_correct_coefs_2( self ):
        correct_output = (-3,)  # discriminant=0 test
        function_output = roots( 0,1,6,9 )
        # запишется результат
        self.assertEqual( function_output,correct_output )

    def test_noroots( self ):
        self.assertRaises( NoRoots,roots,-4,535,2,53 )  # noroots exc


class TestSolvSquere( unittest.TestCase ):
    def test_correct_coefs_1( self ):
        correct_output = (-0.2,-2)  # correct test
        function_output = solv_square( 5,11,2 )
        self.assertEqual( function_output,correct_output )

    def test_no_roots( self ):
        self.assertRaises( NoRoots,roots,-4,535,2,53 )  # noroots exc


if __name__ == '__main__':
    unittest.main( )
