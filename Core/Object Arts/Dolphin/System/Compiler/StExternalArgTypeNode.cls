"Filed out from Dolphin Smalltalk"!

StProgramNode subclass: #StExternalArgTypeNode
	instanceVariableNames: 'typeOrdinal structClass indirections start stop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StExternalArgTypeNode guid: (GUID fromString: '{49763c2e-001b-471d-9f27-1acec000b58d}')!

StExternalArgTypeNode comment: ''!

!StExternalArgTypeNode categoriesForClass!System-Compiler! !

!StExternalArgTypeNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	aProgramNodeVisitor visitExternalArgTypeNode: self!

indirections
	^indirections!

indirections: anInteger 
	indirections := anInteger!

start
	^start!

start: anObject
	start := anObject!

stop
	^stop!

stop: anObject
	stop := anObject!

structClass
	^structClass!

structClass: aClass 
	structClass := aClass!

typeOrdinal
	^typeOrdinal!

typeOrdinal: anInteger 
	typeOrdinal := anInteger! !

!StExternalArgTypeNode categoriesForMethods!
acceptVisitor:!public!visitor! !
indirections!accessing!private! !
indirections:!accessing!private! !
start!accessing!public! !
start:!accessing!private! !
stop!accessing!public! !
stop:!accessing!private! !
structClass!accessing!private! !
structClass:!accessing!private! !
typeOrdinal!accessing!private! !
typeOrdinal:!accessing!private! !
!

