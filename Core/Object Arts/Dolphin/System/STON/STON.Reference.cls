"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'STON.Reference'
	instanceVariableNames: 'index'
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
!STON.Reference categoriesFor: #=!comparing!public! !
!STON.Reference categoriesFor: #hash!comparing!public! !
!STON.Reference categoriesFor: #index!accessing!public! !
!STON.Reference categoriesFor: #index:!accessing!public! !
!STON.Reference categoriesFor: #isStonReference!public!testing! !
!STON.Reference categoriesFor: #printOn:!printing!public! !

!STON.Reference class methodsFor!

index: integer
	^ self new
		index: integer;
		yourself! !
!STON.Reference class categoriesFor: #index:!instance creation!public! !

