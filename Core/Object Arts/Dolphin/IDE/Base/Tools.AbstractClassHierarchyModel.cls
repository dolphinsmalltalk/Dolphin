"Filed out from Dolphin Smalltalk"!

UI.VirtualTreeModel
	subclass: #'Tools.AbstractClassHierarchyModel'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.AbstractClassHierarchyModel guid: (Core.GUID fromString: '{2e07298b-d593-406d-b0d2-fb1248ebb196}')!

Tools.AbstractClassHierarchyModel comment: ''!

!Tools.AbstractClassHierarchyModel categoriesForClass!MVP-Models! !

!Tools.AbstractClassHierarchyModel methodsFor!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: This does not have to be accurate, but it should be fast
	(i.e. don't calculate it by counting the receiver's elements)."

	^500!

observeEnvironment
	Smalltalk
		when: #classAdded:
			send: #onClassAdded:
			to: self;
		when: #classUpdated:
			send: #onClassUpdated:
			to: self;
		when: #classRemoved:
			send: #onClassRemoved:
			to: self!

onClassAdded: aClass
	self subclassResponsibility!

onClassRemoved: aClass
	self remove: aClass
!

onClassUpdated: aClass
	self subclassResponsibility!

setRoots: aCollection 
	"Private - Initialize the receiver with the roots in aCollection"

	super setRoots: aCollection.
	self observeEnvironment! !

!Tools.AbstractClassHierarchyModel categoriesForMethods!
approxSize!accessing!private! !
observeEnvironment!initializing!private! !
onClassAdded:!event handling!public! !
onClassRemoved:!event handling!public! !
onClassUpdated:!event handling!public! !
setRoots:!initializing!private! !
!

