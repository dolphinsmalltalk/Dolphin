"Filed out from Dolphin Smalltalk"!

VirtualTreeModel subclass: #RegTreeModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RegTreeModel guid: (GUID fromString: '{87b4c674-026e-11d3-9fd7-00a0cc3e4a32}')!

RegTreeModel comment: 'RegTreeModel implements a <treeModel> representing the hierarchy of <RegKey>s in the Windows system registry. For an example of its use, see the RegEdit sample application.'!

!RegTreeModel categoriesForClass!MVP-Models! !

!RegTreeModel methodsFor!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: This does not have to be accurate, but it should be fast
	(i.e. don't calculate it by counting the receiver's elements)."

	^5000!

defaultGetChildrenBlock
	^[:each | each asSortedCollection: [:a :b | a name < b name]]!

defaultGetParentBlock
	^[:aRegKey | aRegKey parentKey]!

defaultHasChildrenBlock
	^[:aRegKey | aRegKey notEmpty]! !

!RegTreeModel categoriesForMethods!
approxSize!accessing!private! !
defaultGetChildrenBlock!initializing!private! !
defaultGetParentBlock!initializing!private! !
defaultHasChildrenBlock!initializing!private! !
!

!RegTreeModel class methodsFor!

defaultSearchPolicy
	"Answer the <searchPolicy> used to compare and search for elements in the receiver's
	instances."

	"Implementation Note: As we are fronting an externally represented tree (i.e the Registry)
	the nodes are created to represent the external keys and values, and are not, therefore,
	identical."

	^SearchPolicy equality! !

!RegTreeModel class categoriesForMethods!
defaultSearchPolicy!accessing!public! !
!

