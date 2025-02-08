"Filed out from Dolphin Smalltalk"!

Database.DBFixedSizeField
	subclass: #'Database.DBBoundField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBBoundField guid: (Core.GUID fromString: '{d5c24a9c-ecd9-44bd-a7da-2bfad35a59e0}')!

Database.DBBoundField comment: '`DBBoundField` is the class of `DBField`s that provide a pre-bound buffer of fixed size, providing the most efficient means of data transfer for fixed width columns, and for variable length columns of relatively small fixed maximum size (i.e. other than the long binary and char columns that can hold data up to 2Gb).'!

!Database.DBBoundField categoriesForClass!ODBC Interface! !

!Database.DBBoundField methodsFor!

bindColumnOf: aDBStatement
	"Private - Bind the receiver's buffers (data and length) for the <DBStatement> argument, which is assumed to have been executed already."

	^aDBStatement dbCheckException: (OS.Odbc32
				sqlBindCol: aDBStatement handle
				columnNumber: column columnNumber
				targetType: buffer dbInterchangeType
				targetValuePtr: buffer
				bufferLength: buffer byteSize
				strLenOrInd: lengthBuf)
		function: 'SQLBindCol'!

getData: aDBStatement
	"Private - Retrieve the receiver's associated column data from the ODBC result set following a fetch (into the receiver's buffer)."

	"Found bound fields there is nothing to do, as the data will already be in the buffer."

	! !

!Database.DBBoundField categoriesForMethods!
bindColumnOf:!operations!private! !
getData:!accessing!private! !
!

