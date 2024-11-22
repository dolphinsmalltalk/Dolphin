"Filed out from Dolphin Smalltalk"!

Object subclass: #DBUnstructuredFieldBuffer
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants ODBCCTypes ODBCRetCodes ODBCTypes'
	classInstanceVariableNames: ''!

DBUnstructuredFieldBuffer guid: (GUID fromString: '{2460e923-ce24-43db-90da-e92c0bd7a961}')!

DBUnstructuredFieldBuffer isAbstract: true!

DBUnstructuredFieldBuffer comment: '`DBSpecialFieldBuffer` is an abstract class of objects that provide services for interchange from Smalltalk objects to C representations that can be used to transmit data to a database through ODBC for certain special column types.

Concrete subclasses exist for the long variable length columns, and specific other column types with non-standard marshalling. Most column types are buffered using `ExternalStructure` classes, and these are extended by the database connection base package with the necessary behaviour.'!

!DBUnstructuredFieldBuffer categoriesForClass!Kernel-Objects! !

!DBUnstructuredFieldBuffer methodsFor!

bufferSizeForColumn: aDBColAttr
	^aDBColAttr length!

bytes
	^bytes!

byteSize
	"Answer the number of bytes that can be written to the buffer. For strings, this does include the null terminator."

	^bytes byteSize!

dbConvert: anObject for: aDBField
	"Convert the argument to the type required for marshalling as the value of the <DBField> 2nd argument. Throw an error if this is not possible."

	(anObject isKindOf: self valueClass) ifTrue: [^anObject].
	HRESULTError
		signal: '<3d> expected, not <1s> (<2d>)' << { anObject basicPrintString. anObject. self valueClass }
		with: Win32Errors.STATUS_OBJECT_TYPE_MISMATCH.
	^nil!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver. This is a value from the SQL_C_XXXX enumeration."

	"Only specific subclasses are supported"

	^self shouldNotImplement!

dbMarshal: anObject into: aDBField
	"Populate the receiver, as buffer of the <DBField> 2nd argument, with the SQL_C_BINARY (e.g. ByteArray) representation of the 1st argument."

	| byteArray byteCount |
	byteArray := self dbConvert: anObject for: aDBField.
	byteCount := byteArray size.
	bytes
		replaceFrom: 1
		to: byteCount
		with: byteArray
		startingAt: 1.
	aDBField length: byteCount!

dbUnmarshal: aDBField
	"Answer a <Utf16String> read from the receiver, assumed to be the buffer of the <DBField> argument containing a SQL_C_WCHAR value."

	^bytes copy!

initializeForColumn: aDBColAttr
	bytes := self valueClass newFixed: (self bufferSizeForColumn: aDBColAttr)!

valueClass
	^self class valueClass! !

!DBUnstructuredFieldBuffer categoriesForMethods!
bufferSizeForColumn:!initializing!private! !
bytes!accessing!private! !
byteSize!accessing!public! !
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
dbUnmarshal:!operations!public! !
initializeForColumn:!initializing!private! !
valueClass!constants!public! !
!

DBUnstructuredFieldBuffer methodProtocol: #dbFieldBuffer attributes: #() selectors: #(#byteSize #dbConvert:for: #dbInterchangeType #dbMarshal:into: #dbUnmarshal: #valueClass)!

!DBUnstructuredFieldBuffer class methodsFor!

dbBoundFieldClassForColumn: aDBColAttr
	^DBBoundField!

dbHasVariableTransferOctetLength
	"Answer whether the marshalled type supports variable length columns."

	^false!

dbNewForColumn: aDBColAttr
	^self new initializeForColumn: aDBColAttr!

dbTransferOctetLengthForColumn: aDBColAttr
	"Return the transfer octet length (size in bytes of the buffer necessary to receive data for this column) based on the column type, if fixed, else 0 for variable width columns.
		The transfer octet length of a column is the maximum number of bytes returned to the application when data is transferred to its default C data type. For character data, the transfer octet length does not include space for the null-termination character. The transfer octet length of a column may be different than the number of bytes required to store the data on the data source.
	From https://docs.microsoft.com/en-us/sql/odbc/reference/appendixes/transfer-octet-length"

	^aDBColAttr precision ?? 0!

valueClass
	"The class of unmarshalled values."

	^self subclassResponsibility! !

!DBUnstructuredFieldBuffer class categoriesForMethods!
dbBoundFieldClassForColumn:!helpers!private! !
dbHasVariableTransferOctetLength!private!testing! !
dbNewForColumn:!helpers!private! !
dbTransferOctetLengthForColumn:!enquiries!public! !
valueClass!constants!public! !
!

DBUnstructuredFieldBuffer class methodProtocol: #dbFieldBufferFactory attributes: #() selectors: #(#dbBoundFieldClassForColumn: #dbHasVariableTransferOctetLength #dbNewForColumn: #dbTransferOctetLengthForColumn:)!

