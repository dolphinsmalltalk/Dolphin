"Filed out from Dolphin Smalltalk"!

StVariable subclass: #StLocalVariable
	instanceVariableNames: 'node storage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StLocalVariable guid: (GUID fromString: '{0a285b01-fe92-41ca-97c5-99914ab50746}')!

StLocalVariable comment: '<StlocalVariable> is an abstract class of <StVariable> with concrete subclasses to describe local variables, either temporaries or arguments. '!

!StLocalVariable categoriesForClass!Kernel-Objects! !

!StLocalVariable methodsFor!

addAssignment: anStVariableNode fromScope: anStSemanticScope
	super addAssignment: anStVariableNode fromScope: anStSemanticScope.
	anStSemanticScope realScope == self scope realScope
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

addRead: anStVariableNode fromScope: anStSemanticScope
	super addRead: anStVariableNode fromScope: anStSemanticScope.
	anStSemanticScope realScope == self scope realScope
		ifTrue: 
			["Temp is read in its defining scope"
			storage isNil
				ifTrue: 
					["Previously unaccessed, promote to stack var (though read before
				written)"
					storage := #stack]]
		ifFalse: 
			["Temp read in nested scope"
			storage == #shared
				ifFalse: 
					["Not already shared, so promote to copied"
					storage := #copied]]!

isLocalVariable
	"Answer whether the receiver describes a local variable, i.e. a temp or argument."

	^true!

markNestedRead
	storage == #shared ifFalse: [storage := #copied]!

name
	"Answer the <readableString> identifier of the variable described by the receiver, i.e. the
	name of the temporary or argument."

	^node name!

node
	"Answer the <StParameterNode> or <StTempDeclNode> describing the definition of the variable
	described by the receiver."

	^node!

setNode: anStVariableNode
	node := anStVariableNode!

storage
	^storage! !

!StLocalVariable categoriesForMethods!
addAssignment:fromScope:!public! !
addRead:fromScope:!public! !
isLocalVariable!public!testing! !
markNestedRead!private! !
name!accessing!public! !
node!accessing!public! !
setNode:!accessing!initializing!private! !
storage!accessing!private! !
!

!StLocalVariable class methodsFor!

node: anStTempDecl
	^self new setNode: anStTempDecl! !

!StLocalVariable class categoriesForMethods!
node:!public! !
!

