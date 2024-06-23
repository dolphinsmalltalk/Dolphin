"Filed out from Dolphin Smalltalk"!

Kernel.StVariable
	subclass: #'Kernel.StLocalVariable'
	instanceVariableNames: 'node storage reads index'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StLocalVariable guid: (Core.GUID fromString: '{0a285b01-fe92-41ca-97c5-99914ab50746}')!

Kernel.StLocalVariable isNonInstantiable: true!

Kernel.StLocalVariable comment: '<StlocalVariable> is an abstract class of <StVariable> with concrete subclasses to describe local variables, either temporaries or arguments. '!

!Kernel.StLocalVariable categoriesForClass!Kernel-Objects! !

!Kernel.StLocalVariable methodsFor!

addRead: aStVariableNode fromScope: aStSemanticScope
	reads addLast: aStVariableNode.
	aStSemanticScope realScope == self scope realScope
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

index
	^index!

index: anInteger
	index := anInteger!

isLocalVariable
	"Answer whether the receiver describes a local variable, i.e. a temp or argument."

	^true!

isRead
	"Answer whether the variable described by the receiver is read from anywhere within the method under semantic analysis."

	^reads notEmpty!

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

reads
	"Answer the <sequencedReadableCollection> of <StVariableNode>'s that describe reads from the variable described by the receiver."

	^reads!

setNode: aStVariableNode
	node := aStVariableNode.
	reads := OrderedCollection new!

storage
	^storage! !

!Kernel.StLocalVariable categoriesForMethods!
addRead:fromScope:!public! !
index!accessing!public! !
index:!accessing!public! !
isLocalVariable!public!testing! !
isRead!public!testing! !
markNestedRead!private! !
name!accessing!public! !
node!accessing!public! !
reads!accessing!public! !
setNode:!accessing!initializing!private! !
storage!accessing!private! !
!

!Kernel.StLocalVariable class methodsFor!

node: aStTempDecl
	^self new setNode: aStTempDecl! !

!Kernel.StLocalVariable class categoriesForMethods!
node:!public! !
!

