"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Examples.VideoLibrary'
	instanceVariableNames: 'owner tapes'
	classVariableNames: 'DefaultInstance'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.VideoLibrary guid: (Core.GUID fromString: '{e07e20a9-89d7-4f84-941a-7c3365cf6112}')!

UI.Examples.VideoLibrary comment: 'VideoLibrary is represents a collection of VideoTapes that belong to a particular owner. This class is part of the Video Library sample package. Please see the package comment for more details.'!

!UI.Examples.VideoLibrary categoriesForClass!Samples! !

!UI.Examples.VideoLibrary methodsFor!

defaultOwner	
	"Private - Answer a <readableString> to use as the owner identifier for a default instance.

	Illustrated Patterns:
	Constant Access Method
	Private Method
	"

	^'My Video Collection'!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: self owner;
		nextPutAll: ', ';
		display: self tapes size;
		nextPutAll: ' tapes'!

initialize
	"Private - Initialize the receiver to contain default values.

	Illustrated Patterns
	Instance Initialization
	"

	tapes := OrderedCollection new.
	owner := self defaultOwner.!

owner
	"Answer the <readableString> owner name of the receiver.

	Illustrated Patterns:
	Accessor Method"

	^owner!

owner: ownerName
	"Initialize the receiver with the <readableString> ownerName

	Illustrated Patterns:
	Accessor Method"

	owner :=  ownerName.
!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	self basicPrintOn: aStream.
	aStream
		nextPut: $(;
		display: self;
		nextPut: $)
!

tapes
	"Answer the <collection> of tapes held by the receiver.

	Illustrated Patterns
	Accessor Method
	"

	^tapes! !

!UI.Examples.VideoLibrary categoriesForMethods!
defaultOwner!constants!private! !
displayOn:!printing!public! !
initialize!initializing!private! !
owner!accessing!public! !
owner:!initializing!public! !
printOn:!printing!public! !
tapes!accessing!public! !
!

!UI.Examples.VideoLibrary class methodsFor!

default
	"Answer the default instance of the receiver."

	DefaultInstance isNil ifTrue: [
		DefaultInstance := self new ].
	^DefaultInstance !

icon
	^##((TextTileIcon
		text: $\xE714
		fontName: 'Segoe Fluent Icons'
		color: Color darkSlateBlue)
		margin: 1;
		yourself)!

new
	"Answer a new, initialised, instance of the receiver.

	Illustrated Patterns:
	Instance Initialization
	"

	^super new initialize!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	DefaultInstance := nil! !

!UI.Examples.VideoLibrary class categoriesForMethods!
default!accessing!public! !
icon!constants!public! !
new!instance creation!public! !
uninitialize!class hierarchy!class hierarchy-removing!private! !
!

