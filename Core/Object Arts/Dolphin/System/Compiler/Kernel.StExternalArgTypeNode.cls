"Filed out from Dolphin Smalltalk"!

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
	(structClass := anStVariableNode) ifNotNil: [anStVariableNode parent: self]!

typeOrdinal
	^typeOrdinal!

typeOrdinal: anInteger 
	typeOrdinal := anInteger! !
!Kernel.StExternalArgTypeNode categoriesForMethods!
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

