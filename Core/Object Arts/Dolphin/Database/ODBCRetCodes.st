"Filed out from Dolphin Smalltalk"!

Smalltalk at: #ODBCRetCodes put: (PoolConstantsDictionary named: #ODBCRetCodes)!
ODBCRetCodes at: 'SQL_ERROR' put: -16r1!
ODBCRetCodes at: 'SQL_INVALID_HANDLE' put: -16r2!
ODBCRetCodes at: 'SQL_NEED_DATA' put: 16r63!
ODBCRetCodes at: 'SQL_NO_DATA' put: 16r64!
ODBCRetCodes at: 'SQL_SUCCESS' put: 16r0!
ODBCRetCodes at: 'SQL_SUCCESS_WITH_INFO' put: 16r1!
ODBCRetCodes shrink!
