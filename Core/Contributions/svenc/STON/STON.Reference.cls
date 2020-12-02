"Filed out from Dolphin Smalltalk 7"!

Object subclass: #STONReference
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!STONReference categoriesFor: #=!comparing!public! !
!STONReference categoriesFor: #hash!comparing!public! !
!STONReference categoriesFor: #index!accessing!public! !
!STONReference categoriesFor: #index:!accessing!public! !
!STONReference categoriesFor: #isStonReference!public!testing! !
!STONReference categoriesFor: #printOn:!printing!public! !

!STONReference class methodsFor!

index: integer
	^ self new
		index: integer;
		yourself! !
!STONReference class categoriesFor: #index:!instance creation!public! !

