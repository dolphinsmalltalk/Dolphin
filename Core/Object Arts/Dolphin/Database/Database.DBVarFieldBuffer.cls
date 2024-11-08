﻿"Filed out from Dolphin Smalltalk"!

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

bufferSizeForColumn: aDBColAttr
	^aDBColAttr length!

initializeForColumn: aDBColAttr
	bytes := self valueClass newFixed: ((self class isLongColumn: aDBColAttr)
						ifTrue: [self blockTransferOctetSize]
						ifFalse: [self bufferSizeForColumn: aDBColAttr])! !

!Database.DBVarFieldBuffer categoriesForMethods!
blockTransferOctetSize!constants!private! !
bufferSizeForColumn:!initializing!private! !
initializeForColumn:!initializing!private! !
!

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

initialize
	"
		self initialize
	"

	BlockTransferOctetLength := 256 * 1024.
	MaxBoundOctetLength := 256 * 1024!

isLongColumn: aDBColAttr
	| octetLength |
	octetLength := aDBColAttr length.
	^octetLength == SQL_SS_LENGTH_UNLIMITED or: [octetLength > MaxBoundOctetLength]!

maxBoundOctetLength
	^MaxBoundOctetLength!

maxBoundOctetLength: anInteger
	MaxBoundOctetLength := anInteger! !

!Database.DBVarFieldBuffer class categoriesForMethods!
blockTransferOctetLength!accessing!public! !
blockTransferOctetLength:!accessing!public! !
dbBoundFieldClassForColumn:!helpers!private! !
dbHasVariableTransferOctetLength!private!testing! !
initialize!class initialization!public! !
isLongColumn:!helpers!private! !
maxBoundOctetLength!accessing!public! !
maxBoundOctetLength:!accessing!public! !
!

