"Filed out from Dolphin Smalltalk"!

Object subclass: #DBField
	instanceVariableNames: 'column buffer lengthBuf'
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants ODBCCTypes ODBCRetCodes ODBCTypes'
	classInstanceVariableNames: ''!

DBField guid: (GUID fromString: '{d08e99fa-5317-4859-b605-350ea25e758f}')!

DBField isAbstract: true!

DBField comment: '`DBField` is the abstract class of objects responsible for data transfer for the individual columns of a `DBRowBuffer`. There are concrete subclasses representing bound buffers, unbound buffers, and partially buffered fields for long variable length binary and char types that are read (for select statements) with SQLGetData and written (for query parameters) with SQLPutData.'!

!DBField categoriesForClass!Unclassified! !

!DBField methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent."

	^comparand species == self species and: [
		column = comparand column and: [self value = comparand value]]!

allocateBuffer
	"Private - Allocate a buffer for the column. For most columns this is the fixed, or maximum, width required for the 'C' representation of the data that we request for interchange with the driver."

	^self bufferClass dbNewForColumn: column!

beNull
	"Set the receiver to be a null valued field. ODBC represents this by a special indicator value in the length buffer."

	self length: ODBCConstants.SQL_NULL_DATA!

bind: aDBStatement
	"Private - Bind the receiver's buffers (data and length) for the <DBStatement> argument, which is assumed to have been executed already."

	"Unbound by default, so do nothing"

	!

bindAsParameter: anInteger of: aDBParameterizedStatement
	"Private - Bind the receiver as the supplier of data for the parameter numbered, anInteger, of aDBParameterizedStatement."

	self subclassResponsibility!

bufferClass
	^column bufferClass!

column
	^column!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver. This is a value from the SQL_C_XXXX enumeration."

	^buffer dbInterchangeType!

fieldBuf
	"Private - Answer the buffer for passing to the ODBC DLL for data transfer."

	^buffer!

getData: aDBStatement
	"Private - Retrieve the receiver's associated column data from the ODBC result set following a fetch (into the receiver's buffer)."

	self subclassResponsibility

	!

hash
	"Answer the <integer> hash value for the receiver. Must be the same for any two DBField's that compare equal."

	^column hash bitXor: self value hash!

initializeForColumn: aDBColAttr
	"Private - Initialize the receiver to represent a value from the database column described by the <DBColAttr> argument. Answer the receiver."

	lengthBuf := ByteArray newFixed: 4.
	self beNull.
	column := aDBColAttr.
	buffer := self allocateBuffer.
	^self!

isNull
	"Answer whether the receiver currently holds a null value."

	^self length == ODBCConstants.SQL_NULL_DATA!

length
	"Private - Answer the octet length of the interchange data in this field, or -1 if NULL."

	^lengthBuf sdwordAtOffset: 0!

length: anInteger
	"Private - Set the octet length of the data in this field. If anInteger is -1, then the field is considered NULL."

	lengthBuf sdwordAtOffset: 0 put: anInteger!

printOn: aStream
	"Append, to the <puttableStream>, aStream, a string representation of the receiver in a form that a developer might want to see."

	super printOn: aStream.
	aStream
		nextPut: $(;
		display: column name;
		nextPut: $=;
		print: self value;
		nextPut: $)!

scale
	"Answer the 'scale' of the column. This can mean different things for different column types but is some kind of sub-length of the overall length of the field, for example for a numeric field it is the number of decimal places."

	^self column scale!

type
	"Answer the SQL type of the column associated with the receiver."

	^column type!

value
	"Answer an object of a suitable type unmarshalled from the database value in the receiver's buffer."

	^self isNull ifFalse: [buffer dbUnmarshal: self]!

value: anObject
	"Marshal the argument into a suitable binary representation in the receiver's buffer for transfer to the database."

	^anObject ifNil: [self beNull] ifNotNil: [buffer dbMarshal: anObject into: self]! !

!DBField categoriesForMethods!
=!comparing!public! !
allocateBuffer!accessing!private! !
beNull!accessing!public! !
bind:!operations!private! !
bindAsParameter:of:!operations!private! !
bufferClass!accessing!public! !
column!accessing!private! !
dbInterchangeType!constants!public! !
fieldBuf!accessing!private! !
getData:!accessing!private! !
hash!comparing!public! !
initializeForColumn:!initializing!private! !
isNull!public!testing! !
length!accessing!private! !
length:!accessing!private! !
printOn:!printing!public! !
scale!accessing!public! !
type!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
!

!DBField class methodsFor!

new
	"Use #newForCol:"

	^self shouldNotImplement!

newForCol: aDBColAttr
	"Answer a new instance of the receiver for the column described by aColAttr."

	^self basicNew initializeForColumn: aDBColAttr! !

!DBField class categoriesForMethods!
new!instance creation!public! !
newForCol:!instance creation!public! !
!

