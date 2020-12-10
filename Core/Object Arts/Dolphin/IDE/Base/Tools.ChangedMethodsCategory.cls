"Filed out from Dolphin Smalltalk 7"!

Tools.VirtualMethodCategory subclass: #'Tools.ChangedMethodsCategory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ChangedMethodsCategory guid: (Core.GUID fromString: '{51ab4605-0ab6-4cc3-b886-e2c90022ec0a}')!
Tools.ChangedMethodsCategory comment: 'ChangedMethodsCategory is a virtual method category membership of which is limited to those methods which have unsaved changes (i.e. they are a method of a changed class with source residing in the change log).

Although this class is strictly redundant (it being implementable as a PluggableVirtualMethodCategory), a specialised implemenation is much faster when enumerating the entire contents because the set of candidate behaviours can be limited.'!
!Tools.ChangedMethodsCategory categoriesForClass!System-Support! !
!Tools.ChangedMethodsCategory methodsFor!

behaviorsDo: aMonadicValuable
	Smalltalk allClasses do: 
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
!Tools.ChangedMethodsCategory categoriesFor: #behaviorsDo:!enumerating!private! !
!Tools.ChangedMethodsCategory categoriesFor: #includesMethod:!public!testing! !

!Tools.ChangedMethodsCategory class methodsFor!

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
!Tools.ChangedMethodsCategory class categoriesFor: #initialize!initializing!private! !
!Tools.ChangedMethodsCategory class categoriesFor: #uninitialize!class hierarchy-removing!private! !

