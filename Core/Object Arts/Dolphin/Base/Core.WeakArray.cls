﻿"Filed out from Dolphin Smalltalk"!

Core.ArrayedCollection
	variableSubclass: #'Core.WeakArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.WeakArray guid: (Core.GUID fromString: '{87b4c515-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.WeakArray comment: ''!

!Core.WeakArray categoriesForClass!Collections-Arrayed!Collections-Weak! !

!Core.WeakArray methodsFor!

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

	^self replaceIdentity: DeadObject.Current with: newElement!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	"Generally when copying part of a weak collection we don't want a weak result."

	^Array!

corpsesDo: aBlock
	"Locate each indexable variable of the receiver which formally housed an Object
	which has sadly expired, and pass its index to aBlock for evaluation. This
	method is non-destructive and may be evaluated repeatedly. Should you require
	to clear the slots formerly occupied by corpses so that they are not
	subsequently treated as deaths, use the #nilCorpsesAndDo: message"

	| deathAt size |
	size := self basicSize.
	deathAt := self
				basicIdentityIndexOf: DeadObject.Current
				from: 1
				to: size.
	[deathAt == 0] whileFalse: 
			[aBlock value: deathAt.
			deathAt := self
						basicIdentityIndexOf: DeadObject.Current
						from: deathAt + 1
						to: size]!

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
	corpse := DeadObject.Current.
	deathAt := self
				basicIdentityIndexOf: corpse
				from: 1
				to: size.
	[deathAt > 0] whileTrue: 
			[self at: deathAt put: nil.
			aBlock value: deathAt.
			deathAt := self
						basicIdentityIndexOf: corpse
						from: deathAt
						to: size]!

nonCorpsesDo: aBlock
	"Evaluate aBlock for all non-Corpse elements of the receiver. Answer the receiver."

	| corpse |
	corpse := DeadObject.Current.
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
	index := self
				basicIdentityIndexOf: oldElement
				from: 1
				to: self basicSize.
	^index == 0
		ifTrue: [exceptionHandler value]
		ifFalse: 
			[self basicAt: index put: DeadObject.Current.
			oldElement]!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail)."

	^Array! !

!Core.WeakArray categoriesForMethods!
add:!adding!public! !
addAnsweringIndex:!adding!public! !
copyingClass!copying!private! !
corpsesDo:!enumerating!public! !
initialize!initializing!public! !
nilCorpsesAndDo:!enumerating!public! !
nonCorpsesDo:!enumerating!public! !
remove:ifAbsent:!private!removing! !
species!accessing!public! !
!

!Core.WeakArray class methodsFor!

new: anInteger
	"Answer a new instance of the receiver with anInteger indexed instance variables
	The new instance is registered with the memory manager as a weakling"

	^(super new: anInteger) initialize!

new: anInteger withAll: anObject
	"Answer a new instance of the receiver with <integer>, anInteger, elements, each of which is initialized to the <Object>, anObject."

	^(super new: anInteger withAll: anObject) initialize! !

!Core.WeakArray class categoriesForMethods!
new:!instance creation!public! !
new:withAll:!instance creation!public! !
!

