﻿"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.MoenContour'
	instanceVariableNames: 'lowerHead lowerTail upperHead upperTail'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.MoenContour guid: (Core.GUID fromString: '{68f4ac01-2f95-11d3-93ba-00a024ca708a}')!

UI.MoenContour comment: 'MoenContour is a private helper class which is part of the implementation of the <MoenTreeView>

Instance Variables:
	lowerHead	<MoenLink>
	lowerTail		<MoenLink>
	upperHead	<MoenLink>
	upperTail		<MoenLink>
'!

!UI.MoenContour categoriesForClass!MVP-Views-Support! !

!UI.MoenContour methodsFor!

lowerHead
	^lowerHead!

lowerHead: aMoenLink
	lowerHead := aMoenLink!

lowerTail
	^lowerTail!

lowerTail: aMoenLink
	lowerTail := aMoenLink!

printOn: aStream
	"Append a textual representation of the receiver to the <puttableStream> argument
	as a developer might want to see it."

	aStream 
		basicPrint: self; cr;
		nextPutAll: 'upperHead=';
		print: self upperHead; cr;
		nextPutAll: 'upperTail=';
		print: self upperTail; cr;
		nextPutAll: 'lowerHead=';
		print: self lowerHead; cr;
		nextPutAll: 'lowerTail=';
		print: self lowerTail; 
		nextPut: $);cr!

upperHead
	^upperHead!

upperHead: aMoenLink
	upperHead := aMoenLink!

upperTail
	^upperTail!

upperTail: aMoenLink
	upperTail := aMoenLink! !

!UI.MoenContour categoriesForMethods!
lowerHead!accessing!private! !
lowerHead:!accessing!private! !
lowerTail!accessing!private! !
lowerTail:!accessing!private! !
printOn:!development!printing!public! !
upperHead!accessing!private! !
upperHead:!accessing!private! !
upperTail!accessing!private! !
upperTail:!accessing!private! !
!

