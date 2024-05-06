"Filed out from Dolphin Smalltalk"!

Object subclass: #STONReference
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

STONReference guid: (GUID fromString: '{be937146-c626-437a-b2f6-097eef5bedc0}')!

STONReference comment: 'STONReference holds a forward reference to another object during materialization.
'!

!STONReference categoriesForClass!STON-Core-Utilities! !

!STONReference methodsFor!

= anObject
	^ self class == anObject class and: [ self index = anObject index ]!

hash
	^ index hash!

index
	^ index!

index: integer
	index := integer!

isStonReference
	^ true!

printOn: stream
	super printOn: stream.
	stream nextPut: $(; print: index; nextPut: $)! !

!STONReference categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
index!accessing!public! !
index:!accessing!public! !
isStonReference!public!testing! !
printOn:!printing!public! !
!

!STONReference class methodsFor!

index: integer
	^ self new
		index: integer;
		yourself! !

!STONReference class categoriesForMethods!
index:!instance creation!public! !
!

