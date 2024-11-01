"Filed out from Dolphin Smalltalk"!

DBFixedSizeField subclass: #DBUnboundField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBUnboundField guid: (GUID fromString: '{e8c752b6-3e1a-493c-ac36-9c0ad1c656cd}')!

DBUnboundField comment: '`DBBoundField` is the class of `DBField`s that provide a unbounds buffer of fixed size allow for data transfer to/from the driver after query execution through SQLGetData/SQLPutData calls rather than pre-binding.'!

!DBUnboundField categoriesForClass!ODBC Interface! !

!DBUnboundField methodsFor!

getData: aDBStatement
	"Private - Retrieve the receiver's associated column data from the ODBC result set immediately following a fetch (into the receiver's buffer)."

	aDBStatement dbCheckException: (ODBCLibrary default
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
	aDBStatement dbCheckException: (ODBCLibrary default
				sqlPutData: aDBStatement allocatedHandle
				dataPtr: data
				strLenOrInd: data dbOctetTransferSize)
		function: 'SQLPutData'! !

!DBUnboundField categoriesForMethods!
getData:!accessing!private! !
putData:!accessing!private! !
!

