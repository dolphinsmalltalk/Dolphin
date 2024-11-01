"Filed out from Dolphin Smalltalk"!

Object subclass: #DBAbstractStatement
	instanceVariableNames: 'handle parent executed cursorType'
	classVariableNames: 'CursorTypes'
	poolDictionaries: 'ODBCConstants ODBCRetCodes'
	classInstanceVariableNames: ''!

DBAbstractStatement guid: (GUID fromString: '{f63fc993-6a18-49de-a8d2-07b192c69097}')!

DBAbstractStatement isAbstract: true!

DBAbstractStatement comment: 'A DBAbstractStatements represent commands that can be executed by against a <DBConnection>. DBAbstractStatement is itself abstract. Its most commonly used concrete subclass is <DBStatement>, which can be used to execute SQL statements. Other subclasses represent individual queries that can be performed against the metadata in the database schema using the specific functions provided for this purpose in ODBC. Whatever the form of the command the subclass of statement represents, all yield a <DBResultSet>.

Instance Variables:
	handle		<ExternalHandle>. ODBC statement handle.
	parent		<DBConnection>. The connection on which the statement was (or will be) executed
	executed		<Boolean>. Indicates if the command has been executed yet.
	cursorType	<Symbol>. The symbolic name of the cursor type, e.g. #forwardOnly'!

!DBAbstractStatement categoriesForClass!ODBC Interface! !

!DBAbstractStatement methodsFor!

allocatedHandle
	"Private - Answer the receiver's ODBC statement handle, which is lazily 
	allocated if necessary."

	handle isNull ifTrue: [self allocateHandle].
	^handle!

allocateHandle
	executed := false.
	handle := parent allocStmtHandle: self.
	self
		beFinalizable;
		setDefaultAttributes!

asParameter
	"Answer the receiver in a form suitable for passing to an external function
	primitive method (see ExternalLibrary and subclasses)."

	^self executedHandle!

basicFree
	"Private - Free up all ODBC resources."

	parent freeStmtHandle: self!

cancel
	"Cancel any outstanding asynchronous request."

	executed
		ifTrue: 
			[handle isNull
				ifTrue: [executed := false]
				ifFalse: [self dbCheckException: (ODBCLibrary default sqlCancel: handle) function: 'SQLCancel']]!

close
	"Private - Close the cursor, but keep the handle.
	Implementation Note: Use SQLFreeStmt(,SQL_CLOSE), rather than SQLCloseCursor, since the latter
	treats the cursor not actually being open as an error condition, and we don't care about that."

	executed
		ifTrue: 
			[executed := false.
			handle isNull
				ifFalse: 
					[self dbCheckException: (ODBCLibrary default sqlFreeStmt: handle option: SQL_CLOSE)
						function: 'SQLFreeStmt']]!

columnLength: anInteger
	"Answer the length (bytes) of column number anInteger in the Result Set."

	| len |
	len := ByteArray newFixed: 4.
	self dbCheckException: (ODBCLibrary default
				sqlColAttribute: self executedHandle
				columnNumber: anInteger
				fieldIdentifier: SQL_COLUMN_LENGTH
				characterAttributePtr: nil
				bufferLength: 0
				stringLengthPtr: nil
				numericAttributePtr: len)
		function: 'SQLColAttribute'.
	^len sdwordAtOffset: 0!

cursorType
	"Answer the symbolic cursor type name (one of #dynamic, #forwardOnly, #keysetDriven or #static)."

	^cursorType!

cursorType: aSymbol 
	(CursorTypes includesKey: aSymbol) 
		ifFalse: [self error: 'Invalid cursor type ' , aSymbol].
	cursorType := aSymbol.
	"Attempting to change the cursorType once the statement has been executed will raise an error"
	handle isNull ifFalse: [self setCursorType]!

dbCheckException: anIntegerRetCode function: aString
	"Private - Checks anIntegerRetCode to see if a DBError or DBWarning should be signalled. 
	Note that as of Dolphin 4.0, DBWarning is actually a notification, which is a more appropriate level of reporting for SQL_SUCCESS_WITH_INFO."

	anIntegerRetCode == SQL_SUCCESS
		ifFalse: 
			["Signal an error or warning - decide which"
			((anIntegerRetCode == SQL_SUCCESS_WITH_INFO or: [anIntegerRetCode == SQL_NO_DATA])
				ifTrue: [DBWarning]
				ifFalse: [DBError]) signal: aString with: (self newExceptionDetails: anIntegerRetCode)].
	^anIntegerRetCode!

defaultCursorType
	"Answer the <Symbol>ic name of the default cursor type to be used for statements
	(one of #dynamic, #forwardOnly, #keysetDriven, #static)."

	^#forwardOnly
!

describeCol: anInteger
	"Answer a DBColAttr object which describes the column with the specified
	<integer> index in the receiver's result set."

	^(self describeCols: {anInteger}) first!

describeCols: columnNumbers
	"Answer an array of <DBColAttr>s describing each of the columns of the receiver's results with indices in the <sequencedReadableCollection> argument."

	| name nameBufSize hStmt lib buf base |
	"Allocate a buffer sufficient to hold any column name, that we will re-use for all the columns"
	nameBufSize := self parent maxColumnNameLength + 1.
	name := Utf16String newFixed: nameBufSize.
	"Single buffer for all the output parameters, organised as follows:
		0..1: 16-bit column name length (nameLengthPtr)
		2..3: 16-bit data type (dataTypePtr)
		4..7: 32-bit column size (columnSizePtr)
		8..9: 16-bit decimal digits count (decimalDigitsPtr)
		10..11: 16-bit nullable enum (nullablePtr)"
	buf := ByteArray newFixed: 12.
	base := buf yourAddress.
	hStmt := self executedHandle.
	lib := ODBCLibrary default.
	^columnNumbers collect: 
			[:each |
			| column |
			self dbCheckException: (lib
						sqlDescribeCol: hStmt
						columnNumber: each
						columnName: name
						bufferLength: nameBufSize
						nameLengthPtr: base
						dataTypePtr: base + 2
						columnSizePtr: base + 4
						decimalDigitsPtr: base + 8
						nullablePtr: base + 10)
				function: 'SQLDescribeCol'.
			column := DBColAttr new
						columnNumber: each;
						name: (name copyFrom: 1 to: (buf swordAtOffset: 0));
						precision: (buf dwordAtOffset: 4);
						scale: (buf swordAtOffset: 8);
						type: (buf swordAtOffset: 2);
						yourself.
			column length == 0
				ifTrue: 
					[buf dwordAtOffset: 0 put: 0.
					self dbCheckException: (lib
								sqlColAttribute: hStmt
								columnNumber: each
								fieldIdentifier: SQL_DESC_OCTET_LENGTH
								characterAttributePtr: nil
								bufferLength: nil
								stringLengthPtr: nil
								numericAttributePtr: base)
						function: 'SQLColAttribute'.
					column length: (buf sdwordAtOffset: 0)].
			column]!

driverHStmt
	"Private - Answer the handle to the driver statement"

	| value |
	value := ExternalHandle new.
	self dbCheckException: (ODBCLibrary default
				sqlGetInfo: self asParameter
				infoType: SQL_DRIVER_HSTMT
				infoValuePtr: value
				bufferLength: VMConstants.IntPtrSize
				stringLengthPtr: nil)
		function: 'SQLGetInfo'.
	^value!

exec
	"Private - Execute the tables query the receiver represents."

	self executeStatement.
	executed := true!

executedHandle
	"Private - Answer the receiver's ODBC statement handle having lazily
	executed the SQL statement associated with the receiver."
	
	| answer |
	answer := self allocatedHandle.
	executed ifFalse: [self exec].
	^answer
!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^self subclassResponsibility!

finalize
	"Private - Free any external resources held by the receiver. 
	Should any error occur we print it to trace but otherwise ignore it."

	[self free] on: DBError do: [ :e | e toTrace]!

free
	"Free up all resources leaving the receiver in a re-usable state."

	handle isNull ifFalse: [[self basicFree] ensure: [self reset]]!

getStringAttribute: anInteger
	"Private - Answer a <String> containing the value of the statement attribute identified by the <integer> argument."

	| buffer |
	buffer := Utf16String newFixed: SQL_MAX_OPTION_STRING_LENGTH.
	self dbCheckException: (ODBCLibrary default
				sqlGetStmtAttr: self allocatedHandle
				attribute: anInteger
				valuePtr: buffer
				bufferLength: ##((SQL_MAX_OPTION_STRING_LENGTH + 1) * 2)
				stringLengthPtr: nil)
		function: 'SQLGetStmtAttr'.	"Byte size including implicit null terminator"
	"N.B. We assume that as with SqlGetConnectAttr that the SQL server driver will not populate the stringLengthPtr argument. There do not seem to be any string options to test this against currently."
	^buffer trimNulls!

handle
	^handle!

initialize
	"Private - Initialize a new instance of the receiver."

	self reset.
	cursorType := self defaultCursorType!

initialize: aDBConnection
	"Private - Initialize the receiver as a new statement of the
	<DBConnection>, aDBConnection."

	parent := aDBConnection.
	self initialize!

moveTo: anIntegerRow
	"Private - Position the cursor at the specified
	row so that it is read on a subsequent Fetch (requires
	extended fetch)"

	self dbCheckException: (ODBCLibrary default
				sqlSetPos: self executedHandle
				rowNumber: anIntegerRow
				operation: SQL_POSITION
				lockType: SQL_LOCK_NO_CHANGE)
		function: 'SQLSetPos'!

newExceptionDetails: anIntegerRetCode
	"Private - Answer a DBExceptionDetails instance that describes the state of the
	receiver following an exception. This will be available as the tag of a subsequent 
	signalled DBError or DBWarning."

	^(self parent newExceptionDetails: anIntegerRetCode)
		hStmt: handle;
		yourself!

numColumns
	"Answer the number of columns in the receiver's result set."

	| ccol |
	ccol := ByteArray newFixed: 2.
	self dbCheckException: (ODBCLibrary default sqlNumResultCols: self executedHandle pccol: ccol)
		function: 'SQLNumResultCols'.
	^ccol swordAtOffset: 0!

numRows
	"Answer the number of rows affected by an UPDATE, DELETE or INSERT command exec'd on
	the receiver. May also work for some SELECTs, although often the answer will be -1
	indicating that the driver does not know."

	| rowCount |
	rowCount := ByteArray newFixed: 4.
	self dbCheckException: (ODBCLibrary default sqlRowCount: self executedHandle rowCountPtr: rowCount)
		function: 'SQLRowCount'.
	^rowCount sdwordAtOffset: 0!

parent
	"Answer the statement's parent <DBConnection> object."

	^parent!

reset
	handle := nil.
	executed := false!

results
	"Answer a <DBResultSet> that manages the results for the receiver.
	The result set will cause the receiver to be lazily executed when
	any attempt is made to access its contents."

	^(self cursorType == #forwardOnly 
		ifTrue: [DBForwardOnlyResultSet]
		ifFalse: [DBResultSet]) statement: self!

setAttribute: attributeInteger value: anIntegerOrStringOrBytes size: sizeInteger
	^self dbCheckException: (ODBCLibrary default
				sqlSetStmtAttr: self allocatedHandle
				attribute: attributeInteger
				valuePtr: anIntegerOrStringOrBytes
				stringLength: sizeInteger)
		function: 'SQLSetStmtAttr'!

setCursorType
	"Private - Set the cursor type of the statement to one of: #static, #dynamic, #keysetDriven or #forwardOnly. 
	See the ODBC documentation for details of the different cursor types."

	^self 
		setAttribute: SQL_ATTR_CURSOR_TYPE
		value: (CursorTypes at: self cursorType)
		size: SQL_IS_UINTEGER!

setDefaultAttributes
	"Private - Set the default attributes of the statement that need to be set before the statement is prepared."

	self suppressErrorsDo: [self setCursorType]!

statusArray: anArrayOfWORDs 
	"Private - Set the argument to be the receiver's status array attribute."

	self 
		setAttribute: SQL_ATTR_ROW_STATUS_PTR
		value: anArrayOfWORDs
		size: SQL_IS_POINTER!

suppressErrorsDo: aNiladicBlock 
	aNiladicBlock on: DBError do: [:e | e toTrace]! !

!DBAbstractStatement categoriesForMethods!
allocatedHandle!accessing!private! !
allocateHandle!helpers!private! !
asParameter!accessing!public! !
basicFree!private!realizing/unrealizing! !
cancel!operations!public! !
close!operations!private! !
columnLength:!accessing!public! !
cursorType!accessing!public! !
cursorType:!accessing!public! !
dbCheckException:function:!exceptions!private! !
defaultCursorType!constants!public! !
describeCol:!accessing!public! !
describeCols:!accessing!public! !
driverHStmt!accessing!private! !
exec!operations!private! !
executedHandle!accessing!private! !
executeStatement!operations!private! !
finalize!finalizing!private! !
free!public!realizing/unrealizing! !
getStringAttribute:!accessing!private! !
handle!accessing!private! !
initialize!initializing!private! !
initialize:!initializing!private! !
moveTo:!accessing!private! !
newExceptionDetails:!exceptions!private! !
numColumns!accessing!public! !
numRows!accessing!public! !
parent!accessing!public! !
reset!initializing!private! !
results!accessing!public! !
setAttribute:value:size:!accessing!private! !
setCursorType!helpers!private! !
setDefaultAttributes!initializing!private! !
statusArray:!accessing!private! !
suppressErrorsDo:!accessing!private! !
!

!DBAbstractStatement class methodsFor!

initialize
	"
		self initialize
	"

	CursorTypes := IdentityDictionary new.
	CursorTypes
		at: #static put: SQL_CURSOR_STATIC;
		at: #forwardOnly put: SQL_CURSOR_FORWARD_ONLY;
		at: #keysetDriven put: SQL_CURSOR_KEYSET_DRIVEN;
		at: #dynamic put: SQL_CURSOR_DYNAMIC;
		shrink!

new
	"Private - Should not implement. Use #parent:"

	^self shouldNotImplement!

parent: aDBConnection
	"Answer an initialized instance of the receiver."

	^super new
		initialize: aDBConnection;
		yourself!

parent: aDBConnection cursorType: aSymbol 
	"Answer an initialized instance of the receiver."

	^(self parent: aDBConnection)
		cursorType: aSymbol;
		yourself!

stbConvertFrom: anSTBClassFormat 
	"Answer a <monadicValuable> to convert from older STB formats. 
		1: Adds 'executed' inst. var."

	^
	[:data | 
	| converted ver newInstance |
	converted := data.
	ver := anSTBClassFormat version.
	ver < 1 ifTrue: [converted := self stbConvertToVersion1: converted].
	ver < 2 ifTrue: [converted := self stbConvertToVersion2: converted].
	newInstance := self basicNew.
	1 to: converted size
		do: [:i | newInstance instVarAt: i put: (converted at: i)].
	newInstance onStartup.
	newInstance]!

stbConvertToVersion1: data 
	"Private - 1: executed inst. var. added to superclass (which is new for v1 too)"

	| instSize |
	instSize := data size + 1.
	^(Array new: instSize)
		replaceFrom: 1
			to: 2
			with: data
			startingAt: 1;
		replaceFrom: 4
			to: instSize
			with: data
			startingAt: 3;
		yourself!

stbConvertToVersion2: data 
	"Private - 2: cursorType and _reserved inst. vars. added"
	| instSize |
	instSize := data size + 1.
	^(Array new: instSize)
		replaceFrom: 1
			to: 3
			with: data
			startingAt: 1;
		replaceFrom: 5
			to: instSize
			with: data
			startingAt: 4;
		at: 4 put: #keysetDriven;		"4 = cursorType"
		yourself!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^2! !

!DBAbstractStatement class categoriesForMethods!
initialize!initializing!public! !
new!instance creation!private! !
parent:!instance creation!public! !
parent:cursorType:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbConvertToVersion1:!binary filing!private! !
stbConvertToVersion2:!binary filing!private! !
stbVersion!binary filing!public! !
!

