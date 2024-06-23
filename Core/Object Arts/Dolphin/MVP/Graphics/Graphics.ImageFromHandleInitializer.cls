"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer
	subclass: #'Graphics.ImageFromHandleInitializer'
	instanceVariableNames: 'handle'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.ImageFromHandleInitializer guid: (Core.GUID fromString: '{d019573c-ce12-419d-ab3d-f8bafb3540b0}')!

Graphics.ImageFromHandleInitializer comment: ''!

!Graphics.ImageFromHandleInitializer methodsFor!

createImage: anImage extent: aPoint
	^handle!

extent: aPoint 
	"Ignore the request. We have an extent dictated by the image supplied as a handle."!

handle: anExternalhandle
	handle := anExternalhandle.
	^self!

image: anIcon valueWithHandle: aMonadicValuable extent: aPoint 
	^aMonadicValuable value: handle!

isPersistent
	^false!

printImage: anImage on: aWriteStream
	"Private - Print a representation of the <Image> initialized by the receiver onto the <puttableStream> argument in the form a developer might want to see."

	aWriteStream
		basicPrint: anImage;
		nextPut: $(;
		print: handle;
		nextPut: $)! !

!Graphics.ImageFromHandleInitializer categoriesForMethods!
createImage:extent:!private!realizing/unrealizing! !
extent:!accessing!public! !
handle:!initializing!private! !
image:valueWithHandle:extent:!private!realizing/unrealizing! !
isPersistent!public!testing! !
printImage:on:!public! !
!

!Graphics.ImageFromHandleInitializer class methodsFor!

handle: anExternalhandle
	<primitive: 157>
	^self new
		handle: anExternalhandle;
		yourself! !

!Graphics.ImageFromHandleInitializer class categoriesForMethods!
handle:!public! !
!

