"Filed out from Dolphin Smalltalk 7"!

Object subclass: #MoenContour
	instanceVariableNames: 'lowerHead lowerTail upperHead upperTail'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MoenContour guid: (GUID fromString: '{68f4ac01-2f95-11d3-93ba-00a024ca708a}')!
MoenContour comment: 'MoenContour is a private helper class which is part of the implementation of the <MoenTreeView>

Instance Variables:
	lowerHead	<MoenLink>
	lowerTail		<MoenLink>
	upperHead	<MoenLink>
	upperTail		<MoenLink>
'!
!MoenContour categoriesForClass!MVP-Views-Support! !
!MoenContour methodsFor!

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
!MoenContour categoriesFor: #lowerHead!accessing!private! !
!MoenContour categoriesFor: #lowerHead:!accessing!private! !
!MoenContour categoriesFor: #lowerTail!accessing!private! !
!MoenContour categoriesFor: #lowerTail:!accessing!private! !
!MoenContour categoriesFor: #printOn:!development!printing!public! !
!MoenContour categoriesFor: #upperHead!accessing!private! !
!MoenContour categoriesFor: #upperHead:!accessing!private! !
!MoenContour categoriesFor: #upperTail!accessing!private! !
!MoenContour categoriesFor: #upperTail:!accessing!private! !

