"Filed out from Dolphin Smalltalk"!

Link subclass: #MoenLink
	instanceVariableNames: 'x y'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MoenLink guid: (GUID fromString: '{68f4ac02-2f95-11d3-93ba-00a024ca708a}')!

MoenLink comment: 'MoenLink is a private helper class that is part of the implementation of the <MoenTreeView>'!

!MoenLink categoriesForClass!Collections-Support!MVP-Views-Support! !

!MoenLink methodsFor!

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

!MoenLink categoriesForMethods!
printOn:!development!printing!public! !
setX:y:!initializing!private! !
x!accessing!private! !
y!accessing!private! !
!

!MoenLink class methodsFor!

x: x y: y nextLink: aLink
	"Answer a new, initialized, instance of the receiver."

	^(self nextLink: aLink) setX: x y: y! !

!MoenLink class categoriesForMethods!
x:y:nextLink:!instance creation!public! !
!

