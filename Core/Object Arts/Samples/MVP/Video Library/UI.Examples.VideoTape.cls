"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Examples.VideoTape'
	instanceVariableNames: 'name length recordings'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.VideoTape guid: (Core.GUID fromString: '{fd390a77-8643-49ee-be26-397fbec58430}')!

UI.Examples.VideoTape comment: 'A VideoTape represents a collection of VideoRecordings recorded on a named video cassette. This class is part of the Video Library sample package. Please see the package comment for more details.'!

!UI.Examples.VideoTape categoriesForClass!Samples! !

!UI.Examples.VideoTape methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: self name;
		nextPutAll: ' E';
		display: self length!

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

!UI.Examples.VideoTape categoriesForMethods!
displayOn:!printing!public! !
length!accessing!public! !
name!accessing!public! !
name:length:!initializing!private! !
printOn:!printing!public! !
recordings!accessing!public! !
!

!UI.Examples.VideoTape class methodsFor!

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

!UI.Examples.VideoTape class categoriesForMethods!
defaultTapeLength!constants!private! !
icon!constants!public! !
name:!instance creation!public! !
name:length:!instance creation!public! !
!

