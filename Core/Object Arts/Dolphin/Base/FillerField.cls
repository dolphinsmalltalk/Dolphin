"Filed out from Dolphin Smalltalk X6.1"!

ExternalField subclass: #FillerField
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FillerField guid: (GUID fromString: '{87B4C4DB-026E-11D3-9FD7-00A0CC3E4A32}')!
FillerField comment: ''!
!FillerField categoriesForClass!External-Data-Types! !
!FillerField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	FillerFields pad to a specified number of bytes, so no further alignment
	is required."

	^1!

byteSize
	"Private - Answer the byte size of the filler data the receiver represents"

	^byteSize!

byteSize: anInteger
	"Private - Set the byte size of the filler data the receiver represents"

	byteSize := anInteger!

canGenerateAccessors
	^false!

initialize
	"Private - Initialize the receiver."
	
	super initialize.
	self beInaccessible!

printAccessorExpression: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will read the value of this field from an instance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	^self shouldNotImplement!

printMutatorBody: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will write the value of this field into an isntance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	^self shouldNotImplement!

readFrom: anExternal
	"Private - Answer the embedded object at the receiver's offset 
	in anExternal."

	^self shouldNotImplement!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the appropriate offset and in the 
	appropriate format for the receiver"

	^self shouldNotImplement! !
!FillerField categoriesFor: #alignment!constants!public! !
!FillerField categoriesFor: #byteSize!accessing!private! !
!FillerField categoriesFor: #byteSize:!accessing!private! !
!FillerField categoriesFor: #canGenerateAccessors!private!testing! !
!FillerField categoriesFor: #initialize!initializing!private! !
!FillerField categoriesFor: #printAccessorExpression:on:!automatic generation!development!private! !
!FillerField categoriesFor: #printMutatorBody:on:!automatic generation!development!private! !
!FillerField categoriesFor: #readFrom:!indirect accessing!private! !
!FillerField categoriesFor: #writeInto:value:!indirect accessing!private! !

!FillerField class methodsFor!

byteSize: anInteger
	"Answer a FillerField of the specified number of bytes"

	^(self new) byteSize: anInteger; yourself! !
!FillerField class categoriesFor: #byteSize:!instance creation!public! !

