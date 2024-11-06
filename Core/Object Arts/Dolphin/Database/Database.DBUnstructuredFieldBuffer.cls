"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Database.DBUnstructuredFieldBuffer'
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	imports: #(#{OS.ODBCConstants} #{OS.ODBCCTypes} #{OS.ODBCRetCodes} #{OS.ODBCTypes})
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBUnstructuredFieldBuffer guid: (Core.GUID fromString: '{2460e923-ce24-43db-90da-e92c0bd7a961}')!

Database.DBUnstructuredFieldBuffer isNonInstantiable: true!

Database.DBUnstructuredFieldBuffer comment: '`DBSpecialFieldBuffer` is an abstract class of objects that provide services for interchange from Smalltalk objects to C representations that can be used to transmit data to a database through ODBC for certain special column types.

Concrete subclasses exist for the long variable length columns, and specific other column types with non-standard marshalling. Most column types are buffered using `ExternalStructure` classes, and these are extended by the database connection base package with the necessary behaviour.'!

!Database.DBUnstructuredFieldBuffer categoriesForClass!Kernel-Objects! !

!Database.DBUnstructuredFieldBuffer methodsFor!

bytes
	^bytes!

byteSize
	"Answer the number of bytes that can be written to the buffer. For strings, this does include the null terminator."

	^bytes byteSize!

dbConvert: anObject for: aDBField
	"Convert the argument to the type required for marshalling as the value of the <DBField> 2nd argument. Throw an error if this is not possible."

	(anObject isKindOf: self valueClass) ifTrue: [^anObject].
	OS.HRESULTError
		signal: '<3d> expected, not <1s> (<2d>)' << {anObject basicPrintString. anObject. self valueClass}
		withFailureCode: Kernel._PrimitiveFailureCode.ObjectTypeMismatch.
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

!Database.DBUnstructuredFieldBuffer categoriesForMethods!
bytes!accessing!private! !
byteSize!accessing!public! !
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
dbUnmarshal:!operations!public! !
initializeForColumn:!initializing!private! !
valueClass!constants!public! !
!

Database.DBUnstructuredFieldBuffer methodProtocol: #dbFieldBuffer attributes: #() selectors: #(#byteSize #dbConvert:for: #dbInterchangeType #dbMarshal:into: #dbUnmarshal: #valueClass)!

!Database.DBUnstructuredFieldBuffer class methodsFor!

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

	^self subclassResponsibility! !

!Database.DBUnstructuredFieldBuffer class categoriesForMethods!
dbBoundFieldClassForColumn:!helpers!private! !
dbHasVariableTransferOctetLength!private!testing! !
dbNewForColumn:!helpers!private! !
dbTransferOctetLengthForColumn:!enquiries!public! !
!

Database.DBUnstructuredFieldBuffer class methodProtocol: #dbFieldBufferFactory attributes: #() selectors: #(#dbBoundFieldClassForColumn: #dbHasVariableTransferOctetLength #dbNewForColumn: #dbTransferOctetLengthForColumn:)!

