"Filed out from Dolphin Smalltalk 7"!

StProgramNode subclass: #StExternalArgTypeNode
	instanceVariableNames: 'typeOrdinal structClass indirections start stop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StExternalArgTypeNode categoriesFor: #acceptVisitor:!public!visitor! !
!StExternalArgTypeNode categoriesFor: #indirections!accessing!private! !
!StExternalArgTypeNode categoriesFor: #indirections:!accessing!private! !
!StExternalArgTypeNode categoriesFor: #start!accessing!public! !
!StExternalArgTypeNode categoriesFor: #start:!accessing!private! !
!StExternalArgTypeNode categoriesFor: #stop!accessing!public! !
!StExternalArgTypeNode categoriesFor: #stop:!accessing!private! !
!StExternalArgTypeNode categoriesFor: #structClass!accessing!private! !
!StExternalArgTypeNode categoriesFor: #structClass:!accessing!private! !
!StExternalArgTypeNode categoriesFor: #typeOrdinal!accessing!private! !
!StExternalArgTypeNode categoriesFor: #typeOrdinal:!accessing!private! !

