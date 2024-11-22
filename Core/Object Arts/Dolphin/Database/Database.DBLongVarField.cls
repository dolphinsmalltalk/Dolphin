"Filed out from Dolphin Smalltalk"!

Database.DBField
	subclass: #'Database.DBLongVarField'
	instanceVariableNames: 'value'
	classVariableNames: 'BufferSize'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBLongVarField guid: (Core.GUID fromString: '{7b8fe6e8-5081-461c-aafb-631a9371c63c}')!

Database.DBLongVarField comment: '`DBLongVarField` is the class of `DBField`s that provide data transfer to/from the driver for long binary and char columns. These are used primarily for SQL_LONGVARBINARY, SQL_LONGVARCHAR colums of "unlimited" width, but are also be used for any binary/char column with a maximum size greater than a threshold to save the memory that would otherwise be required for allocating very large buffers. Transfer data types other than SQL_C_CHAR, SQL_C_WCHAR, and SQL_C_BINARY are not supported.'!

!Database.DBLongVarField categoriesForClass!ODBC Interface! !

!Database.DBLongVarField methodsFor!

bindAsParameter: anInteger of: aDBParameterizedStatement
	"Private - Bind the receiver as the supplier of data for the parameter numbered, anInteger, of aDBParameterizedStatement. For long variable fields, the partial buffer is not used for output, rather the interchange value is passed directly with a call to SQLPutData after exec. Here we instruct the driver to request the data, using the column number as the correlation value."

	self length: SQL_DATA_AT_EXEC.
	aDBParameterizedStatement dbCheckException: (OS.ODBCLibrary default
				sqlBindParameter: aDBParameterizedStatement allocatedHandle
				parameterNumber: anInteger
				inputOutputType: column parameterType
				valueType: buffer dbInterchangeType
				parameterType: column type
				columnSize: column precision
				decimalDigits: column scale
				parameterValuePtr: anInteger
				bufferLength: 0
				strLenOrIndPtr: lengthBuf)
		function: 'SQLBindParameter'!

getData: aDBStatement
	"Private - Retrieve the receiver's associated column data from the ODBC result set immediately following a fetch. A String or ByteArray representing the data is stored into the 'value' instance variable for subsequent use. The value will be nil for nullable columns with no data."

	"We could potentially retrieve the data lazily (i.e. mark the value as unretrieved here, and query later only if the the value is accessed), but the documentation states 'within a row of data, the value of the Col_or_Param_Num argument in each call to SQLGetData must be greater than or equal to the value of Col_or_Param_Num in the previous call; that is, data must be retrieved in increasing column number order.' Drivers are allowed to relax this restriction, and whether or not that applies can be determined using the SQLGetInfo api and checking for the SQL_GD_ANY_ORDER extension. It doesn't seem worth the complexity of doing this. There is also a restriction that SQLGetData cannot necessarily be called for columns appearing before the last bound column in the query. Since we need to support the use of unbound columns with SQLGetData for varchar(max), etc, we assume that either the driver does not enforce this restriction, or that the SQL query is coded to ensure that the columns are ordered to place the unlimited length ones after all the others. If you run into a problem with this call failing due to column order issues, it should be possible to just reorder the columns in the query to meet the constraint. As one data point, SQL Server doesn't care about the ordering of the bound and unbound columns."

	| ret odbc32 hStmt stream targetType |
	hStmt := aDBStatement executedHandle.
	odbc32 := OS.ODBCLibrary default.
	"Optimise for the case where the first read succeeds because the data fits in the buffer anyway."
	ret := odbc32
				sqlGetData: hStmt
				columnNumber: column columnNumber
				targetType: (targetType := buffer dbInterchangeType)
				targetValuePtr: buffer
				bufferLength: DBVarFieldBuffer.BlockTransferOctetLength
				strLenOrIndPtr: lengthBuf.
	ret == SQL_SUCCESS
		ifTrue: 
			[| length |
			length := self length.
			value := length == SQL_NULL_DATA ifFalse: [buffer dbUnmarshal: self].
			^self].
	"There was either an error, or it didn't fit and we need to go into the read loop."
	value := nil.
	stream := buffer valueClass writeStream.
	[ret == SQL_SUCCESS_WITH_INFO] whileTrue: 
			[stream nextPutAll: buffer bytes.
			"Read the next block"
			ret := odbc32
						sqlGetData: hStmt
						columnNumber: column columnNumber
						targetType: targetType
						targetValuePtr: buffer
						bufferLength: DBVarFieldBuffer.BlockTransferOctetLength
						strLenOrIndPtr: lengthBuf].
	ret == SQL_SUCCESS
		ifTrue: 
			[stream nextPutAll: (buffer dbUnmarshal: self).
			value := stream grabContents]
		ifFalse: [aDBStatement dbCheckException: ret function: 'SQLGetData']!

putData: aDBStatement
	"Private - Set the data for this long variable length field when used in a parameterised query. The interchange data is not buffered for output. We use the value directly, as for all long column types the data is a byte value (String or ByteArray), or nil for nullable columns. If nil, then SQL_NULL_DATA is passed as the strLenOrInd parameter, which should be interpreted by the driver as indicating a null value."

	aDBStatement dbCheckException: (OS.ODBCLibrary default
				sqlPutData: aDBStatement allocatedHandle
				dataPtr: value
				strLenOrInd: value dbOctetTransferSize)
		function: 'SQLPutData'!

value
	"Answer the contents of the receiver as a suitable Smalltalk object."

	^value!

value: anObject
	"Marshal the argument into a suitable binary representation in the receiver's buffers for transfer to the database."

	"For unlimited parameters, the data is supplied to the driver after exec using SQLPutData, so for now we just store it. However, some drivers needs to know at `SQLExecute` how much data will be sent through `SQLPutData` for long columns (see https://learn.microsoft.com/en-us/sql/odbc/reference/develop-app/sending-long-data). Such drivers return 'Y' to a `SQLGetInfo` query for `SQL_NEED_LONG_DATA_LEN`, although note that SQLServer returns 'Y' for this info attribute but in practice but works fine if the length is not provided. Mimer wants to know the length, and really does need it. It expects that the value in the length buf is `SQL_LEN_DATA_AT_EXEC(length)`. If that value is left as `SQL_DATA_AT_EXEC`, this is equivalent to `SQL_LEN_DATA_AT_EXEC(0)`, so it sets the blob to empty, effectively ignoring the length passed to `SQLPutData` and truncating the data without raising the expected 22001/'String data, right truncation' error that is documented for this case](https://learn.microsoft.com/en-us/sql/odbc/reference/syntax/sqlputdata-function) error. For most DB's we don't need to provided the length at exec, but the cost is very small so it is probably not worth the extra complexity of specialising for `SQL_NEED_LONG_DATA_LEN` drivers."

	anObject
		ifNil: 
			[value := nil.
			self length: SQL_NULL_DATA]
		ifNotNil: 
			[value := buffer dbConvert: anObject for: self.
			self length: 0 - value dbOctetTransferSize + SQL_LEN_DATA_AT_EXEC_OFFSET]! !

!Database.DBLongVarField categoriesForMethods!
bindAsParameter:of:!operations!private! !
getData:!accessing!private! !
putData:!accessing!private! !
value!accessing!public! !
value:!accessing!public! !
!

