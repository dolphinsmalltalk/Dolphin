"Filed out from Dolphin Smalltalk"!

ArrayField subclass: #StringField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StringField guid: (GUID fromString: '{87b4c4e0-026e-11d3-9fd7-00a0cc3e4a32}')!
StringField comment: '<StringField> is an <ExternalField> class which can be used to represent embedded null-terminated string fields in <ExternalStructure>s.

StringField can be used for both <String>s and <UnicodeString>s.'!
!StringField categoriesForClass!External-Data-Types! !
!StringField methodsFor!

allocationLength
	"Private - Answer the size of object of the receivers fieldClass required to hold the
	number of elements in the field."

	^super allocationLength - 1!

printElementSizeExpressionBodyOn: aWriteStream 
	aWriteStream display: self arrayClass elementSize!

printFieldSizeExpressionOn: aWriteStream
	| charSize |
	charSize := self arrayClass elementSize.
	charSize > 1
		ifTrue: 
			[self emitStaticExpression: 
					[:stream |
					stream
						display: self allocationLength;
						nextPutAll: ' * ';
						display: charSize]
				on: aWriteStream]
		ifFalse: [aWriteStream display: self allocationLength]!

printStaticElementSizeExpressionOn: aWriteStream
	self printElementSizeExpressionBodyOn: aWriteStream!

readFrom: anExternalStructure
	"Private - Answer a <String> which is a copy of the null-terminated string embedded in the
	<ExternalStructure> argument at the receiver's offset."

	^self arrayClass fromAddress: anExternalStructure yourAddress + offset!

writeInto: bytes value: anObject
	"Private - Write the bytes of anObject into anExternal. Don't forget the Null Terminator"

	| size elemSize |
	elemSize := self elementSize.
	size := anObject byteSize - elemSize min: self allocationLength * elemSize.
	bytes
		replaceFrom: offset + 1
		to: offset + size
		with: anObject
		startingAt: 1.
	"We need 2 null-terminator bytes for a wide-char string of course"
	1 to: elemSize do: [:i | bytes at: offset + size + i put: 0]! !
!StringField categoriesForMethods!
allocationLength!accessing!private! !
printElementSizeExpressionBodyOn:!automatic generation!private! !
printFieldSizeExpressionOn:!automatic generation!private! !
printStaticElementSizeExpressionOn:!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!StringField class methodsFor!

length: anInteger
	"Answer a new instance of the receiver which is used for describing
	embedded arrays of type aClass, and of byte size anInteger"

	^self type: AnsiString length: anInteger! !
!StringField class categoriesForMethods!
length:!instance creation!public! !
!

