"Filed out from Dolphin Smalltalk"!

UI.VirtualTreeModel
	subclass: #'UI.Examples.RegTreeModel'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.RegTreeModel guid: (Core.GUID fromString: '{87b4c674-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Examples.RegTreeModel comment: 'RegTreeModel implements a <treeModel> representing the hierarchy of <RegKey>s in the Windows system registry. For an example of its use, see the RegEdit sample application.'!

!UI.Examples.RegTreeModel categoriesForClass!MVP-Models! !

!UI.Examples.RegTreeModel methodsFor!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: This does not have to be accurate, but it should be fast
	(i.e. don't calculate it by counting the receiver's elements)."

	^5000!

defaultGetChildrenBlock
	^
	[:each |
	| children |
	children := SortedCollection sortBlock: [:a :b | a name < b name].
	each
		do: [:child | 
			[child asParameter.
			children add: child.
			child free] on: Win32Error do: [:ex | ]].
	children]!

defaultGetParentBlock
	^[:aRegKey | aRegKey parentKey]!

defaultHasChildrenBlock
	^[:aRegKey | aRegKey notEmpty]! !

!UI.Examples.RegTreeModel categoriesForMethods!
approxSize!accessing!private! !
defaultGetChildrenBlock!initializing!private! !
defaultGetParentBlock!initializing!private! !
defaultHasChildrenBlock!initializing!private! !
!

!UI.Examples.RegTreeModel class methodsFor!

defaultSearchPolicy
	"Answer the <searchPolicy> used to compare and search for elements in the receiver's
	instances."

	"Implementation Note: As we are fronting an externally represented tree (i.e the Registry)
	the nodes are created to represent the external keys and values, and are not, therefore,
	identical."

	^SearchPolicy equality! !

!UI.Examples.RegTreeModel class categoriesForMethods!
defaultSearchPolicy!accessing!public! !
!

