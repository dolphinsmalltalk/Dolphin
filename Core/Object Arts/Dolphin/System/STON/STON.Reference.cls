﻿"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'STON.Reference'
	instanceVariableNames: 'index refCount'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

STON.Reference guid: (Core.GUID fromString: '{be937146-c626-437a-b2f6-097eef5bedc0}')!

STON.Reference comment: 'STONReference holds a forward reference to another object during materialization.
'!

!STON.Reference categoriesForClass!STON-Core-Utilities! !

!STON.Reference methodsFor!

= anObject
	^ self class == anObject class and: [ self index = anObject index ]!

addReference
	refCount := refCount + 1!

hash
	^ index hash!

index
	^ index!

index: integer
	index := integer.
	refCount := 0!

isStonReference
	^ true!

printOn: stream
	super printOn: stream.
	stream nextPut: $(; print: index; nextPut: $)!

refCount
	^refCount! !

!STON.Reference categoriesForMethods!
=!comparing!public! !
addReference!public! !
hash!comparing!public! !
index!accessing!public! !
index:!accessing!public! !
isStonReference!public!testing! !
printOn:!printing!public! !
refCount!accessing!public! !
!

!STON.Reference class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^STON icon!

index: integer
	^ self new
		index: integer;
		yourself! !

!STON.Reference class categoriesForMethods!
icon!constants!public! !
index:!instance creation!public! !
!

