"Filed out from Dolphin Smalltalk 7"!

Object subclass: #VideoTape
	instanceVariableNames: 'name length recordings'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
VideoTape guid: (GUID fromString: '{fd390a77-8643-49ee-be26-397fbec58430}')!
VideoTape comment: 'A VideoTape represents a collection of VideoRecordings recorded on a named video cassette. This class is part of the Video Library sample package. Please see the package comment for more details.'!
!VideoTape categoriesForClass!Samples! !
!VideoTape methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a user
	would want to see it."

	aStream
		display: self name;
		nextPutAll: ' E';
		display: self length
!

length
	"Answer the <Integer> length in minutes of the receiver.

	Illustrated Patterns
	Accessor Method
	"

	^length!

name
	"Answer the <readableString> name of the receiver.

	Illustrated Patterns
	Accessor Method
	"

	^name!

name: tapeName length: tapeLength
	"Private - Initialize the receiver with the <readableString> tapeName and
	the <Integer> length in minutes. 

	Illustrated Patterns:
	Instance Variable Role
	Private Method
	"
	name :=  tapeName.
	length := tapeLength.
	recordings := OrderedCollection new.!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	self basicPrintOn: aStream.
	aStream
		nextPut: $(;
		display: self;
		nextPut: $)
!

recordings
	"Answer the <collection> of recordings held by the receiver.

	Illustrated Patterns
	Accessor Method
	"

	^recordings! !
!VideoTape categoriesFor: #displayOn:!printing!public! !
!VideoTape categoriesFor: #length!accessing!public! !
!VideoTape categoriesFor: #name!accessing!public! !
!VideoTape categoriesFor: #name:length:!initializing!private! !
!VideoTape categoriesFor: #printOn:!printing!public! !
!VideoTape categoriesFor: #recordings!accessing!public! !

!VideoTape class methodsFor!

defaultTapeLength
	"Private - Answer a default length (in minutes) to use for instances of the receiver.

	Illustrated Patterns:
	Constant Access Method
	Private Method
	"

	^240!

icon
	"There is actually a codepoint for VHS video tape!! The MS emoji is unclear at small icon
	size, however, so the symbol representation is preferable."

	^##(TextTileIcon text: $\x1F4FC)!

name: tapeName
	"Answers an instance of the receiver with the <readableString> tapeName and
	a default tape length.

	Illustrated Patterns:
	Instance Creation Method"

	^self name: tapeName length: self defaultTapeLength
!

name: tapeName length: tapeLength
	"Answers an instance of the receiver with the <readableString> tapeName and
	the <Integer> length in minutes.

	Illustrated Patterns:
	Instance Creation Method"

	^self new name: tapeName length: tapeLength
! !
!VideoTape class categoriesFor: #defaultTapeLength!constants!private! !
!VideoTape class categoriesFor: #icon!constants!public! !
!VideoTape class categoriesFor: #name:!instance creation!public! !
!VideoTape class categoriesFor: #name:length:!instance creation!public! !

