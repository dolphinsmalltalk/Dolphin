"Filed out from Dolphin Smalltalk"!

DBStatement subclass: #DBParameterizedStatement
	instanceVariableNames: 'values parameters paramCols isPrepared'
	classVariableNames: ''
	poolDictionaries: 'ODBCCTypes'
	classInstanceVariableNames: ''!

DBParameterizedStatement guid: (GUID fromString: '{87b4c549-026e-11d3-9fd7-00a0cc3e4a32}')!

DBParameterizedStatement comment: 'A DBParameterizedStatement is used to represent a parameterized (prepared) SQL statement to be executed by a <DBConnection>.

In general one does not create DBParameterizedStatements directly but rather by the use of DBConnection>>prepare:. The statement can later be parameterized with the appropriate column attributes using #paramCols: and the parameter values using #values:. The statement must then executed using #exec to perform the actual database query. If any results are expected then a <DBResultSet> can be retrieved by sending it a #results message.

Instance Variables:
	values		<Array> of <Object>. The current parameter values.
	parameters	<Array> of <DBField>. Buffers to hold the parameter values for the query.
	paramCols		<Array> of DBColAttr>. Metadata about the parameters.
	isPrepared		<Boolean>. Flag to indicate whether the statement has been prepared.
'!

!DBParameterizedStatement categoriesForClass!ODBC Interface! !

!DBParameterizedStatement methodsFor!

bindParams
	"Private - Bind parameter columns for a prepared SQL statement so that when we 
	subsequently fill the buffer fields the statement is ready to exec. Normally only done 
	just before first exec (from #parameters)."

	1 to: parameters size do: [:i | (parameters at: i) bindAsParameter: i of: self]!

exec
	"(Re)Execute a prepared statement."

	| ret hStmt odbc32 function |
	self close.
	isPrepared ifFalse: [self prepare].
	paramCols notNil ifTrue: [self setValues].
	hStmt := self allocatedHandle.
	odbc32 := ODBCLibrary default.
	function := 'SQLExecute'.
	ret := odbc32 sqlExecute: hStmt.
	ret == SQL_NEED_DATA
		ifTrue: 
			[| paramDataBuf |
			function := 'SQLParamData'.
			paramDataBuf := ByteArray newFixed: 4.
			[(ret := odbc32 sqlParamData: hStmt valuePtrPtr: paramDataBuf) == SQL_NEED_DATA]
				whileTrue: [(parameters at: (paramDataBuf dwordAtOffset: 0)) putData: self]].
	self dbCheckException: ret function: function.
	executed := true!

free
	"Release external resources held by the receiver,
	remaining in a consistent state in order that
	the result set could be regenerated."

	isPrepared := false.
	super free.
	parameters := nil!

paramCols
	"Answer the receiver's parameter columns"

	^paramCols!

paramCols: anArrayOfColAttrs
	"Set the receiver's parameter columns to anArrayOfColAttrs"

	paramCols := anArrayOfColAttrs asArray!

parameters
	"Private - Answer the receivers bound parameter fields. On first receipt (usually from 
	#exec) completes lazy evaluation by causing allocation of a statement handle, preparing 
	the statement, creating the array of parameter fields and binding them."

	^parameters
		ifNil: 
			[parameters := paramCols collect: [:col | col newBoundField].
			self bindParams.
			parameters]!

prepare
	"Private - Prepare the receiver for later execution when the parameter values have 
	been set. N.B. This should only be sent once unless closed in the interm."

	isPrepared := false.
	parameters := nil.
	self dbCheckException: (ODBCLibrary default
				sqlPrepare: self allocatedHandle
				statementText: self sqlString
				textLength: SQL_NTS)
		function: 'SQLPrepare'.
	isPrepared := true!

prepare: aString
	"Private - Prepare the receiver for later execution when the parameter values have 
	been set."

	self sqlString: aString; prepare!

reset
	"Private - Initialize the receiver."

	super reset.
	isPrepared := false.
	parameters := nil.!

setValues
	"Private - Copy object values to the bound fields for the parameters of the prepared SQL
	statement. On first receipt this will cause the parameter fields to be created and bound 	(via #parameters)."

	1 to: self parameters size do: [:i |
		(parameters at: i) value: (values at: i)]
!

values
	"Answer the array of parameter values."

	^values!

values: anArrayOfValues
	"Set the receiver's parameter values prior to a future #exec."

	self close.
	values := anArrayOfValues! !

!DBParameterizedStatement categoriesForMethods!
bindParams!operations!private! !
exec!operations!public! !
free!public!realizing/unrealizing! !
paramCols!accessing!public! !
paramCols:!accessing!public! !
parameters!accessing!private! !
prepare!operations!private! !
prepare:!operations!private! !
reset!initializing!private! !
setValues!operations!private! !
values!accessing!public! !
values:!accessing!public! !
!

