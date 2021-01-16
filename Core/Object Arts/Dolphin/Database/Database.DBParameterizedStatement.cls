"Filed out from Dolphin Smalltalk 7"!

Database.DBStatement subclass: #'Database.DBParameterizedStatement'
	instanceVariableNames: 'values parameters paramCols isPrepared'
	classVariableNames: ''
	imports: #(#{OS.ODBCCTypes})
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBParameterizedStatement guid: (Core.GUID fromString: '{87b4c549-026e-11d3-9fd7-00a0cc3e4a32}')!
Database.DBParameterizedStatement comment: 'A DBParameterizedStatement is used to represent a parameterized (prepared) SQL statement to be executed by a <DBConnection>.

In general one does not create DBParameterizedStatements directly but rather by the use of DBConnection>>prepare:. The statement can later be parameterized with the appropriate column attributes using #paramCols: and the parameter values using #values:. The statement must then executed using #exec to perform the actual database query. If any results are expected then a <DBResultSet> can be retrieved by sending it a #results message.

Instance Variables:
	values		<Array> of <Object>. The current parameter values.
	parameters	<Array> of <DBField>. Buffers to hold the parameter values for the query.
	paramCols		<Array> of DBColAttr>. Metadata about the parameters.
	isPrepared		<Boolean>. Flag to indicate whether the statement has been prepared.
'!
!Database.DBParameterizedStatement categoriesForClass!ODBC Interface! !
!Database.DBParameterizedStatement methodsFor!

bindParams
	"Private - Bind parameter columns for a prepared SQL statement so that when we 
	subsequently fill the buffer fields the statement is ready to exec. Normally only done 
	just before first exec (from #parameters)."

	| odbc hstmt |
	odbc := OS.ODBCLibrary default.
	hstmt := self allocatedHandle.
	parameters keysAndValuesDo: 
			[:i :eachField |
			| buf column |
			buf := eachField fieldBuf.
			column := eachField column.
			self dbCheckException: (odbc
						sqlBindParameter: hstmt
						parameterNumber: i
						inputOutputType: column parameterType
						valueType: column cType
						parameterType: column type
						columnSize: column precision
						decimalDigits: column scale
						parameterValuePtr: buf
						bufferLength: buf byteSize
						strLenOrIndPtr: eachField lengthBuf)]!

exec
	"(Re)Execute a prepared statement."

	| ret |
	self close.
	isPrepared
		ifFalse: [self prepare].
	paramCols notNil
		ifTrue: [self setValues].
	ret := OS.ODBCLibrary default sqlExecute: self allocatedHandle.
	self dbCheckException: ret.
	executed := true.
!

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
			[parameters := paramCols collect: [:col | DBField newForCol: col].
			self bindParams.
			parameters]!

prepare
	"Private - Prepare the receiver for later execution when the parameter values have 
	been set. N.B. This should only be sent once unless closed in the interm."

	| ret |
	isPrepared := false.
	parameters := nil.
	ret := OS.ODBCLibrary default 
				sqlPrepare: self allocatedHandle
				statementText: self sqlString
				textLength: SQL_NTS.
	self dbCheckException: ret.
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
!Database.DBParameterizedStatement categoriesFor: #bindParams!operations!private! !
!Database.DBParameterizedStatement categoriesFor: #exec!operations!public! !
!Database.DBParameterizedStatement categoriesFor: #free!public!realizing/unrealizing! !
!Database.DBParameterizedStatement categoriesFor: #paramCols!accessing!public! !
!Database.DBParameterizedStatement categoriesFor: #paramCols:!accessing!public! !
!Database.DBParameterizedStatement categoriesFor: #parameters!accessing!private! !
!Database.DBParameterizedStatement categoriesFor: #prepare!operations!private! !
!Database.DBParameterizedStatement categoriesFor: #prepare:!operations!private! !
!Database.DBParameterizedStatement categoriesFor: #reset!initializing!private! !
!Database.DBParameterizedStatement categoriesFor: #setValues!operations!private! !
!Database.DBParameterizedStatement categoriesFor: #values!accessing!public! !
!Database.DBParameterizedStatement categoriesFor: #values:!accessing!public! !

