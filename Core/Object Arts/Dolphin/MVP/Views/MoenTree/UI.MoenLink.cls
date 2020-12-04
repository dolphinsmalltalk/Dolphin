"Filed out from Dolphin Smalltalk 7"!

Core.Link subclass: #'UI.MoenLink'
	instanceVariableNames: 'x y'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.MoenLink guid: (Core.GUID fromString: '{68f4ac02-2f95-11d3-93ba-00a024ca708a}')!
UI.MoenLink comment: 'MoenLink is a private helper class that is part of the implementation of the <MoenTreeView>'!
!UI.MoenLink categoriesForClass!Collections-Support!MVP-Views-Support! !
!UI.MoenLink methodsFor!

printOn: aStream
	"Append a textual representation of the receiver to the <puttableStream> argument
	as a developer might want to see it."

	aStream 
		nextPut: $[;
		print: x @ y;
		nextPutAll: '] ';
		print: nextLink!

setX: xInteger y: yInteger
	"Private - Initialize the receiver's instance variables.
	Answer the receiver."

	x := xInteger.
	y := yInteger!

x
	"Private - Answer the x-coordinate"

	^x!

y
	"Private - Answer the y-coordinate."

	^y! !
!UI.MoenLink categoriesFor: #printOn:!development!printing!public! !
!UI.MoenLink categoriesFor: #setX:y:!initializing!private! !
!UI.MoenLink categoriesFor: #x!accessing!private! !
!UI.MoenLink categoriesFor: #y!accessing!private! !

!UI.MoenLink class methodsFor!

x: x y: y nextLink: aLink
	"Answer a new, initialized, instance of the receiver."

	^(self nextLink: aLink) setX: x y: y! !
!UI.MoenLink class categoriesFor: #x:y:nextLink:!instance creation!public! !

