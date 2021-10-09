class ExceptionWithExitCode( Exception ):
    error_code = None


class InfiniteRoots( Exception ):
    pass


class NoRoots( ExceptionWithExitCode ):
    exit_code = 1


class CmdParamsError( Exception ):
    pass
