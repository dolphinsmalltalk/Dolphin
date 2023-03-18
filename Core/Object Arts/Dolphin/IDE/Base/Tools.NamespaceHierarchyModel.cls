"Filed out from Dolphin Smalltalk"!

Tools.AbstractClassHierarchyModel
	subclass: #'Tools.NamespaceHierarchyModel'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.NamespaceHierarchyModel guid: (Core.GUID fromString: '{24515790-10ef-4bb6-a362-781555212ac9}')!
Tools.NamespaceHierarchyModel comment: '`NamespaceHierarchyModel` implements a virtual <treeModel> representing some subset of the <Class>es in the system organised within their enclosing namespaces. The subset included would depend on the Namespace classes added as roots. By default there is a single root, the namespace Root, so all classes in the system are included because all namespaces are reachable from Root.

Note that this is a fairly flat organisation, since all classes in (for example) the Core namespace, will be direct children.  In theory ordinary (non-Namespace) classes can defined nested classes, but this has not been exercised extensively in practice.
'!
!Tools.NamespaceHierarchyModel categoriesForClass!MVP-Models! !
!Tools.NamespaceHierarchyModel methodsFor!

defaultGetChildrenBlock
	^[:aClass | aClass nestedClasses sort]!

defaultGetParentBlock
	^[:aClass | aClass environment]!

defaultHasChildrenBlock
	^[:aClass | aClass nestedClasses anySatisfy: filter]!

onClassAdded: aClass
	self add: aClass asChildOf: aClass environment!

onClassUpdated: aClass
	"Note that we only trigger #item:movedToParent: events if the updated class
	is a <Class>, not if it is a <Metaclass>."

	aClass isMeta ifFalse: [self move: aClass asChildOf: aClass environment].
	self refresh: aClass ifAbsent: []! !
!Tools.NamespaceHierarchyModel categoriesForMethods!
defaultGetChildrenBlock!initializing!private! !
defaultGetParentBlock!initializing!private! !
defaultHasChildrenBlock!constants!private! !
onClassAdded:!event handling!public! !
onClassUpdated:!event handling!public! !
!

!Tools.NamespaceHierarchyModel class methodsFor!

new
	"Answer an instance of the receiver on the entire namespace hierarchy."

	^self withRoots: {Root}! !
!Tools.NamespaceHierarchyModel class categoriesForMethods!
new!instance creation!public! !
!

