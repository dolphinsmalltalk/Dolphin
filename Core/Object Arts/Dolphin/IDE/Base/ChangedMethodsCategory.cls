"Filed out from Dolphin Smalltalk X6"!

VirtualMethodCategory subclass: #ChangedMethodsCategory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChangedMethodsCategory guid: (GUID fromString: '{51AB4605-0AB6-4CC3-B886-E2C90022EC0A}')!
ChangedMethodsCategory comment: 'ChangedMethodsCategory is a virtual method category membership of which is limited to those methods which have unsaved changes (i.e. they are a method of a changed class with source residing in the change log).

Although this class is strictly redundant (it being implementable as a PluggableVirtualMethodCategory), a specialised implemenation is much faster when enumerating the entire contents because the set of candidate behaviours can be limited.'!
!ChangedMethodsCategory categoriesForClass!Development! !
!ChangedMethodsCategory methodsFor!

behaviorsDo: aMonadicValuable 
	self class environment allClassesDo: 
			[:each | 
			each isChanged 
				ifTrue: 
					[aMonadicValuable
						value: each;
						value: each class]]!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument.
	The 'All' methods category includes all methods!!"

	^aCompiledMethod isChanged! !
!ChangedMethodsCategory categoriesFor: #behaviorsDo:!enumerating!private! !
!ChangedMethodsCategory categoriesFor: #includesMethod:!public!testing! !

!ChangedMethodsCategory class methodsFor!

initialize
	"Private - Initialize the receiver.
		self  initialize.
	The '*-changed' category contains only those methods that have been changed. In the basic system
	this means that the source of the method is held in the change log, indicating it has been loaded or
	modified since the last time the sources were consolidated with the compress sources command"

	self addPseud: (self newNamed: self pseudPrefix , 'changed')!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self removePseud: self pseudPrefix , 'changed'! !
!ChangedMethodsCategory class categoriesFor: #initialize!initializing!private! !
!ChangedMethodsCategory class categoriesFor: #uninitialize!class hierarchy-removing!private! !

