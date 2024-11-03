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

bytes
	^bytes!

byteSize
	"Answer the number of bytes that can be written to the buffer. For strings, this does include the null terminator."

	^bytes byteSize!

dbConvert: anObject for: aDBField
	"Convert the argument to the type required for marshalling as the value of the <DBField> 2nd argument. Throw an error if this is not possible."

	(anObject isKindOf: self valueClass) ifTrue: [^anObject].
	HRESULTError
		signal: '<3d> expected, not <1s> (<2d>)' << {anObject basicPrintString. anObject. self valueClass}
		withFailureCode: _PrimitiveFailureCode.ObjectTypeMismatch.
	^nil!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver. This is a value from the SQL_C_XXXX enumeration."

	"Only specific subclasses are supported"

	^self shouldNotImplement!

dbMarshal: anObject into: aDBField
	"Populate the receiver, as buffer of the <DBField> 2nd argument, with appropriate the SQL_C_TYPE_XXXX representation of the 1st argument."

	self subclassResponsibility!

dbUnmarshal: aDBField
	"Answer Smalltalk object equivalent to the value in the receiver, assumed to be the buffer of DBField."

	^self subclassResponsibility!

initializeForColumn: aDBColAttr
	bytes := ByteArray newFixed: aDBColAttr length!

valueClass
	"The class of unmarshalled values."

	^self subclassResponsibility! !

!DBUnstructuredFieldBuffer categoriesForMethods!
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
	"Return the transfer octet length (size in bytes of the buffer necessary to receive data for this column) based on the column type.
	https://docs.microsoft.com/en-us/sql/odbc/reference/appendixes/transfer-octet-length"

	^aDBColAttr length! !

!DBUnstructuredFieldBuffer class categoriesForMethods!
dbBoundFieldClassForColumn:!helpers!private! !
dbHasVariableTransferOctetLength!private!testing! !
dbNewForColumn:!helpers!private! !
dbTransferOctetLengthForColumn:!enquiries!public! !
!

DBUnstructuredFieldBuffer class methodProtocol: #dbFieldBufferFactory attributes: #() selectors: #(#dbBoundFieldClassForColumn: #dbHasVariableTransferOctetLength #dbNewForColumn: #dbTransferOctetLengthForColumn:)!

