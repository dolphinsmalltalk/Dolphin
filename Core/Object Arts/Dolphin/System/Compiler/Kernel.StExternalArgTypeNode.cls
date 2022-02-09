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

= anObject
	self == anObject ifTrue: [^true].
	self class == anObject class ifFalse: [^false].
	^typeOrdinal == anObject typeOrdinal
		and: [structClass = anObject structClass and: [indirections == anObject indirections]]!

acceptVisitor: aProgramNodeVisitor
	aProgramNodeVisitor visitExternalArgTypeNode: self!

bestNodeFor: anInterval
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval)
		ifTrue: [^(structClass notNil and: [indirections == 0]) ifTrue: [structClass] ifFalse: [self]].
	^(structClass notNil and: [structClass intersectsInterval: anInterval])
		ifTrue: [structClass]
		ifFalse: [self]!

childrenDo: aMonadicValuable
	structClass ifNotNil: [aMonadicValuable value: structClass]!

indirections
	^indirections!

indirections: anInteger 
	indirections := anInteger!

postCopy
	super postCopy.
	structClass ifNotNil: [self structClass: structClass copy].
	^self!

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
=!comparing!public! !
acceptVisitor:!public!visitor! !
bestNodeFor:!public!querying! !
childrenDo:!accessing!public! !
indirections!accessing!private! !
indirections:!accessing!private! !
postCopy!copying!public! !
start!accessing!public! !
start:!accessing!private! !
stop!accessing!public! !
stop:!accessing!private! !
structClass!accessing!private! !
structClass:!accessing!private! !
typeOrdinal!accessing!private! !
typeOrdinal:!accessing!private! !
!

