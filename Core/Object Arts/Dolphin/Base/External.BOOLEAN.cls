﻿"Filed out from Dolphin Smalltalk"!

External.UInt8
	subclass: #'External.BOOLEAN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_BOOLEAN_Size' -> 16r1 }!

External.BOOLEAN guid: (Core.GUID fromString: '{35efc105-16f9-425a-94d7-298ebbb17d36}')!

External.BOOLEAN comment: ''!

!External.BOOLEAN categoriesForClass!External-Data-Unstructured! !

!External.BOOLEAN methodsFor!

printOn: aWriteStream
	"Append a textual representation of the receiver to aStream."

	aWriteStream
		basicPrint: self;
		nextPut: $(.
	self isNull
		ifTrue: [aWriteStream nextPutAll: 'NULL']
		ifFalse: [aWriteStream nextPutAll: self value printString titleCased].
	aWriteStream nextPut: $)!

value
	"Answer the <Boolean> value of the receiver's 'value' field."

	^(bytes uint8AtOffset: _OffsetOf_value) asBoolean!

value: aBoolean
	"Set the receiver's 'value' field to the value of the argument, aBoolean"

	bytes uint8AtOffset: _OffsetOf_value put: aBoolean asParameter! !

!External.BOOLEAN categoriesForMethods!
printOn:!printing!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.BOOLEAN class methodsFor!

byteSize
	^_BOOLEAN_Size!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: BOOLEANField new beOverride! !

!External.BOOLEAN class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

