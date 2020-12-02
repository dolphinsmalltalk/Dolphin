"Filed out from Dolphin Smalltalk 7"!

ArrayedCollection variableSubclass: #WeakArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WeakArray guid: (GUID fromString: '{87b4c515-026e-11d3-9fd7-00a0cc3e4a32}')!
WeakArray comment: ''!
!WeakArray categoriesForClass!Collections-Arrayed!Collections-Weak! !
!WeakArray methodsFor!

add: newElement
	"Add newElement to the receiver by replacing any available Corpses, or failing that by
	appending it."

	self addAnsweringIndex: newElement.
	^newElement
!

addAnsweringIndex: newElement
	"Add newElement to the receiver by overwriting the first corpse. If there are no corpses
	then append it. This is a very useful method in many system support tasks (e.g. the Dependency 
	mechanism)."

	^self replaceIdentity: DeadObject current with: newElement
!

corpsesDo: aBlock 
	"Locate each indexable variable of the receiver which formally housed an Object
	which has sadly expired, and pass its index to aBlock for evaluation. This
	method is non-destructive and may be evaluated repeatedly. Should you require
	to clear the slots formerly occuppied by corpses so that they are not
	subsequently treated as deaths, use the #nilCorpsesAndDo: message"


	| deathAt size corpse |
	size := self basicSize.
	corpse := DeadObject current.
	deathAt := self basicIdentityIndexOf: corpse from: 1 to: size.
	[deathAt > 0] whileTrue: [
		aBlock value: deathAt.
		deathAt := self basicIdentityIndexOf: corpse from: deathAt+1 to: size]!

initialize
	"Initialize the receiver's state.
	By default the receiver only weakly references its elements."

	self beWeak!

nilCorpsesAndDo: aBlock 
	"Locate each indexable variable of the receiver which formally housed an Object
	which has sadly expired, nil the slot, and pass its index to aBlock for evaluation.
	This is destructive, and is suitable for use where each death is to be processed only
	once. Should you not wish to nil out the corpses, use #corpsesDo:.
	N.B. We allow for aBlock to modify the contents of the receiver by continuing the search
	from position of the Corpse we've just nilled, just in case aBlock moves a Corpse
	there. This can be useful behavior and has negligible effect on performance."

	| deathAt size corpse |
	size := self basicSize.
	corpse := DeadObject current.
	deathAt := self basicIdentityIndexOf: corpse from: 1 to: size.
	[deathAt > 0] whileTrue: [
		self at: deathAt put: nil.
		aBlock value: deathAt.
		deathAt := self basicIdentityIndexOf: corpse from: deathAt to: size]!

nonCorpsesDo: aBlock 
	"Evaluate aBlock for all non-Corpse elements of the receiver. Answer the receiver."

	| corpse |
	corpse := DeadObject current.
	1 to: self basicSize
		do: 
			[:index | 
			| element |
			element := self at: index.
			element == corpse ifFalse: [aBlock value: element]]!

remove: oldElement ifAbsent: exceptionHandler
	"Private - Remove the argument, oldElement, as an element of the receiver by overwriting it with 
	the Corpse object, and answer oldElement. If oldElement is not an element of the receiver, then 
	answer the result of evaluating the niladic valuable, exceptionHandler."

	| index |
	index := self basicIdentityIndexOf: oldElement from: 1 to: self basicSize.
	^index == 0 
		ifTrue: [exceptionHandler value]
		ifFalse: [self basicAt: index put: DeadObject current. oldElement]!

species
	"Answer the kind of Collection that should result from enumerations such as #collect:
	and #select: when applied against the receiver"

	^Array! !
!WeakArray categoriesFor: #add:!adding!public! !
!WeakArray categoriesFor: #addAnsweringIndex:!adding!public! !
!WeakArray categoriesFor: #corpsesDo:!enumerating!public! !
!WeakArray categoriesFor: #initialize!initializing!public! !
!WeakArray categoriesFor: #nilCorpsesAndDo:!enumerating!public! !
!WeakArray categoriesFor: #nonCorpsesDo:!enumerating!public! !
!WeakArray categoriesFor: #remove:ifAbsent:!private!removing! !
!WeakArray categoriesFor: #species!accessing!public! !

!WeakArray class methodsFor!

new: anInteger
	"Answer a new instance of the receiver with anInteger indexed instance variables
	The new instance is registered with the memory manager as a weakling"

	^(super new: anInteger) initialize! !
!WeakArray class categoriesFor: #new:!instance creation!public! !

