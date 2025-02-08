"Filed out from Dolphin Smalltalk"!

Database.DBFixedSizeField
	subclass: #'Database.DBUnboundField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBUnboundField guid: (Core.GUID fromString: '{e8c752b6-3e1a-493c-ac36-9c0ad1c656cd}')!

Database.DBUnboundField comment: '`DBBoundField` is the class of `DBField`s that provide a unbounds buffer of fixed size allow for data transfer to/from the driver after query execution through SQLGetData/SQLPutData calls rather than pre-binding.'!

!Database.DBUnboundField categoriesForClass!ODBC Interface! !

!Database.DBUnboundField methodsFor!

getData: aDBStatement
	"Private - Retrieve the receiver's associated column data from the ODBC result set immediately following a fetch (into the receiver's buffer)."

	aDBStatement dbCheckException: (OS.Odbc32
				sqlGetData: aDBStatement executedHandle
				columnNumber: column columnNumber
				targetType: buffer dbInterchangeType
				targetValuePtr: buffer
				bufferLength: buffer byteSize
				strLenOrIndPtr: lengthBuf)
		function: 'SQLGetData'!

putData: aDBStatement
	"Private - Set the data for this field when used in a parameterised query."

	| data |
	data := buffer bytes.
	aDBStatement dbCheckException: (OS.Odbc32
				sqlPutData: aDBStatement allocatedHandle
				dataPtr: data
				strLenOrInd: data dbOctetTransferSize)
		function: 'SQLPutData'! !

!Database.DBUnboundField categoriesForMethods!
getData:!accessing!private! !
putData:!accessing!private! !
!

