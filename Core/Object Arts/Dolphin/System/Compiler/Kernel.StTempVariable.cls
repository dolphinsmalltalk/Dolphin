"Filed out from Dolphin Smalltalk"!

Kernel.StLocalVariable
	subclass: #'Kernel.StTempVariable'
	instanceVariableNames: 'writes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StTempVariable guid: (Core.GUID fromString: '{2e234643-1178-4555-82a1-edb3c4317d7a}')!
Kernel.StTempVariable comment: '<StTempVariable> is a specialised class of <StLocalVariable> to describe method and block temporary definitions.'!
!Kernel.StTempVariable categoriesForClass!Kernel-Objects! !
!Kernel.StTempVariable methodsFor!

addAssignment: aStVariableNode fromScope: aStSemanticScope
	writes addLast: aStVariableNode.
	aStSemanticScope realScope == self scope realScope
		ifTrue: 
			["Write to the temp from within its defining scope"
			storage isNil
				ifTrue: 
					["Previously unaccessed temp has been initialised in
					 defining scope - promote to stack var"
					storage := #stack]
				ifFalse: 
					["Previously accessed temp written again in defining scope"
					storage == #copied
						ifTrue: 
							["... but is read from nested scope, so promote to shared"
							storage := #shared]]]
		ifFalse: 
			["Write from a nested scope - promote to shared."
			storage := #shared]!

isTempVariable
	"Answer whether the receiver describes a temporary variable."

	^true!

isWritten
	"Answer whether the variable described by the receiver is written to anywhere within the method under semantic analysis."

	^writes notEmpty!

setNode: aStVariableNode
	super setNode: aStVariableNode.
	writes := OrderedCollection new!

writes
	"Answer the <sequencedReadableCollection> of <StVariableNode>'s that describe writes into
	the variable described by the receiver."

	^writes! !
!Kernel.StTempVariable categoriesForMethods!
addAssignment:fromScope:!public! !
isTempVariable!public!testing! !
isWritten!public!testing! !
setNode:!accessing!initializing!private! !
writes!accessing!public! !
!

