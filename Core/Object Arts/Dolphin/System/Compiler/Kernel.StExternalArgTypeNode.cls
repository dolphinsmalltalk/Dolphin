"Filed out from Dolphin Smalltalk 7"!

Kernel.StProgramNode subclass: #'Kernel.StExternalArgTypeNode'
	instanceVariableNames: 'typeOrdinal structClass indirections start stop'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StExternalArgTypeNode guid: (Core.GUID fromString: '{49763c2e-001b-471d-9f27-1acec000b58d}')!
Kernel.StExternalArgTypeNode comment: ''!
!Kernel.StExternalArgTypeNode categoriesForClass!System-Compiler! !
!Kernel.StExternalArgTypeNode methodsFor!

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

structClass: anStVariableNode
	structClass := anStVariableNode!

typeOrdinal
	^typeOrdinal!

typeOrdinal: anInteger 
	typeOrdinal := anInteger! !
!Kernel.StExternalArgTypeNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StExternalArgTypeNode categoriesFor: #indirections!accessing!private! !
!Kernel.StExternalArgTypeNode categoriesFor: #indirections:!accessing!private! !
!Kernel.StExternalArgTypeNode categoriesFor: #start!accessing!public! !
!Kernel.StExternalArgTypeNode categoriesFor: #start:!accessing!private! !
!Kernel.StExternalArgTypeNode categoriesFor: #stop!accessing!public! !
!Kernel.StExternalArgTypeNode categoriesFor: #stop:!accessing!private! !
!Kernel.StExternalArgTypeNode categoriesFor: #structClass!accessing!private! !
!Kernel.StExternalArgTypeNode categoriesFor: #structClass:!accessing!private! !
!Kernel.StExternalArgTypeNode categoriesFor: #typeOrdinal!accessing!private! !
!Kernel.StExternalArgTypeNode categoriesFor: #typeOrdinal:!accessing!private! !

