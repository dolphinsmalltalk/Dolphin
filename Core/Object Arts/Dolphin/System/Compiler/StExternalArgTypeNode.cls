"Filed out from Dolphin Smalltalk X6"!

StProgramNode subclass: #StExternalArgTypeNode
	instanceVariableNames: 'typeOrdinal structClass indirections start stop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StExternalArgTypeNode guid: (GUID fromString: '{49763C2E-001B-471D-9F27-1ACEC000B58D}')!
StExternalArgTypeNode comment: ''!
!StExternalArgTypeNode categoriesForClass!System-Compiler! !
!StExternalArgTypeNode methodsFor!

acceptVisitor: aProgramNodeVisitor 
	aProgramNodeVisitor acceptExternalArgTypeNode: self!

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

