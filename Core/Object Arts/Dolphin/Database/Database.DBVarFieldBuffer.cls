"Filed out from Dolphin Smalltalk"!

Database.DBUnstructuredFieldBuffer
	subclass: #'Database.DBVarFieldBuffer'
	instanceVariableNames: ''
	classVariableNames: 'BlockTransferOctetLength MaxBoundOctetLength'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBVarFieldBuffer guid: (Core.GUID fromString: '{6a913ba0-0d23-4749-b30d-a3f6e2b5e8b4}')!

Database.DBVarFieldBuffer isNonInstantiable: true!

Database.DBVarFieldBuffer comment: ''!

!Database.DBVarFieldBuffer categoriesForClass!Kernel-Objects! !

!Database.DBVarFieldBuffer methodsFor!

blockTransferOctetSize
	"Private - Answer the size of indexable byte object to be allocated as the buffer used for transferring blocks of data when reading column values via SQLGetData."

	^self subclassResponsibility!

dbMarshal: anObject into: aDBField
	"Populate the receiver, as buffer of the <DBField> 2nd argument, with appropriate the SQL_C_TYPE_XXXX representation of the 1st argument."

	self subclassResponsibility!

dbUnmarshal: aDBField
	"Answer Smalltalk object equivalent to the value in the receiver, assumed to be the buffer of DBField."

	^self subclassResponsibility!

initializeForColumn: aDBColAttr
	bytes := self valueClass newFixed: ((self class isLongColumn: aDBColAttr)
						ifTrue: [self blockTransferOctetSize]
						ifFalse: [self bufferSizeForColumn: aDBColAttr])! !

!Database.DBVarFieldBuffer categoriesForMethods!
blockTransferOctetSize!constants!private! !
dbMarshal:into:!operations!public! !
dbUnmarshal:!operations!public! !
initializeForColumn:!initializing!private! !
!

Database.DBVarFieldBuffer methodProtocol: #dbFieldBuffer attributes: #() selectors: #(#byteSize #dbConvert:for: #dbInterchangeType #dbMarshal:into: #dbUnmarshal: #valueClass)!

!Database.DBVarFieldBuffer class methodsFor!

blockTransferOctetLength
	"Answer the number of bytes to transfer per SQLGetData call when performing block transfer for long columns."

	^BlockTransferOctetLength!

blockTransferOctetLength: anInteger
	anInteger even ifFalse: [self error: 'Block transfer octet length must be even'].
	BlockTransferOctetLength := anInteger!

dbBoundFieldClassForColumn: aDBColAttr
	^(self isLongColumn: aDBColAttr) ifTrue: [DBLongVarField] ifFalse: [DBBoundField]!

dbHasVariableTransferOctetLength
	"Answer whether the marshalled type supports variable length columns."

	^true!

dbTransferOctetLengthForColumn: aDBColAttr
	"Return the transfer octet length (size in bytes of the buffer necessary to receive data for this column) based on the column type, if fixed, else 0 for variable width columns.
		The transfer octet length of a column is the maximum number of bytes returned to the application when data is transferred to its default C data type. For character data, the transfer octet length does not include space for the null-termination character. The transfer octet length of a column may be different than the number of bytes required to store the data on the data source.
	From https://docs.microsoft.com/en-us/sql/odbc/reference/appendixes/transfer-octet-length"

	^aDBColAttr precision ?? 0!

defaultBlockTransferOctetLength
	"The default block size for unbound data transfers. This is a performance vs memory usage trade-off, and needs to be a balance between allocating an excessively large buffer for reading data and the number of SQLGetData calls that will be required in the read loop. There isn't really an ideal choice, as the best trade-off will depend on the application. If a lot of large blobs are being transferred, you may want to set a larger value for #blockTransferOctetLength than 256Kb. Note that this does not affect data transfer to the DB as SQLPutData is called once to transfer the entire data value."

	^##(256 * 1024)!

defaultMaxBoundOctetLength
	"In most DBMSs fixed length columns are limited to a relatively small maximum column length. 64Kb will usually cover it, but if not we just use unbound data access (i.e. SQLGetData, SQLPutData)."

	^##(64 * 1024)!

initialize
	"
		self initialize
	"

	BlockTransferOctetLength := self defaultBlockTransferOctetLength.
	MaxBoundOctetLength := self defaultMaxBoundOctetLength!

isLongColumn: aDBColAttr
	| octetLength |
	octetLength := aDBColAttr length.
	^octetLength <= 0 or: [octetLength > MaxBoundOctetLength]!

maxBoundOctetLength
	^MaxBoundOctetLength!

maxBoundOctetLength: anInteger
	MaxBoundOctetLength := anInteger! !

!Database.DBVarFieldBuffer class categoriesForMethods!
blockTransferOctetLength!accessing!public! !
blockTransferOctetLength:!accessing!public! !
dbBoundFieldClassForColumn:!helpers!private! !
dbHasVariableTransferOctetLength!private!testing! !
dbTransferOctetLengthForColumn:!enquiries!public! !
defaultBlockTransferOctetLength!constants!public! !
defaultMaxBoundOctetLength!constants!public! !
initialize!class initialization!public! !
isLongColumn:!helpers!private! !
maxBoundOctetLength!accessing!public! !
maxBoundOctetLength:!accessing!public! !
!

