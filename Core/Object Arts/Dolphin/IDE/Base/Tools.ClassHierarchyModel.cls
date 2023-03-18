"Filed out from Dolphin Smalltalk"!

Tools.AbstractClassHierarchyModel
	subclass: #'Tools.ClassHierarchyModel'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ClassHierarchyModel guid: (Core.GUID fromString: '{87b4c673-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.ClassHierarchyModel comment: 'ClassHierarchyModel implements a <treeModel> representing the hierarchy (or a subset of it) of <Class>es in the system.'!
!Tools.ClassHierarchyModel categoriesForClass!MVP-Models! !
!Tools.ClassHierarchyModel methodsFor!

defaultGetChildrenBlock
	^[:aClass | aClass subclasses asSortedArray]!

defaultGetParentBlock
	^[:aClass | aClass superclass]!

defaultHasChildrenBlock
	^[:aClass | aClass subclasses anySatisfy: filter]!

onClassAdded: aClass
	self add: aClass asChildOf: aClass superclass!

onClassUpdated: aClass
	"Note that we only trigger #item:movedToParent: events if the updated class
	is a <Class>, not if it is a <Metaclass>."

	aClass isMeta ifFalse: [self move: aClass asChildOf: aClass superclass].
	self refresh: aClass ifAbsent: []! !
!Tools.ClassHierarchyModel categoriesForMethods!
defaultGetChildrenBlock!initializing!private! !
defaultGetParentBlock!initializing!private! !
defaultHasChildrenBlock!constants!private! !
onClassAdded:!event handling!public! !
onClassUpdated:!event handling!public! !
!

!Tools.ClassHierarchyModel class methodsFor!

withAllClasses
	"Answer an instance of the receiver on the entire class hiearchy"

	^self withRoots: Smalltalk allRoots! !
!Tools.ClassHierarchyModel class categoriesForMethods!
withAllClasses!instance creation!public! !
!

