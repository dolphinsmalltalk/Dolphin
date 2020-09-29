"Filed out from Dolphin Smalltalk 7"!

Core.SharedSet variableSubclass: #'Core.WeakSet'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.WeakSet guid: (Core.GUID fromString: '{87b4c538-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.WeakSet comment: 'A WeakSet is a <Set> which only weakly references the elements that it contains. That is, subject to the <MemoryManager>s intervention, if any of a weak set''s elements have only weak references remaining, then they may be garbage collected, in which case that weak set will receive a bereavement notification, and be given a chance to adjust to it''s loss(es), which it does by nilling out the corpses
and rehashing. Bereavement notification is performed asynchronously by separate (high priority) process, and WeakSet is accordingly a subclass of <SharedSet>.'!
!Core.WeakSet categoriesForClass!Collections-Unordered!Collections-Weak! !
!Core.WeakSet methodsFor!

copyEmpty: anInteger
	"Private - Answer an empty copy of the receiver, with enough space for anInteger
	number of elements. 
	Implementation Note: We must override in order to copy the weak/strong state of 
	the receiver."

	^(super copyEmpty: anInteger)
		setSpecialBehavior: self getSpecialBehavior;
		yourself!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	"Generally when copying part of a weak collection we don't want a weak result."

	^Set!

do: operation 
	"Evaluate monadic value argument, operation, for each of the element of the 
	receiver. Answers the receiver.
	Implementation Note: We override this message because if the user supplied operation
	puts the active process to sleep (i.e. wait on some Semaphore) a GC may occur, losses may be 
	suffered, and because the mutex prevents the undertaker from entering the critical section in 
	#elementsExpired: we may subsequently enumerate over Corpses and treat them as elements. 
	In order to guard against this we temporarily revoke the receiver's status as a weak
	object. Note that GC's which nil weak references can only be initiated from idle time, so
	there is no danger of corpses appearing in the receiver if operation does not put the active
	process to sleep."

	mutex critical: 
			[| mask |
			mask := self beStrong.
			[super do: operation] ensure: [self setSpecialBehavior: mask]]!

elementsExpired: anInteger
	"Private - Handle the bereavement(s) that the receiver suffered by maintaing 
	the <Set> invariants (mainly that collision chains are terminated by nils)."

	mutex critical: 
			[| deathAt capacity corpse |
			corpse := DeadObject current.
			capacity := self basicSize.
			tally := tally - anInteger.
			deathAt := self
						basicIdentityIndexOf: corpse
						from: 1
						to: capacity.
			anInteger > (self size // 4)
				ifTrue: 
					["Rehash the collection if a large number of losses..."
					[deathAt > 0] whileTrue: 
							[self basicAt: deathAt put: nil.
							deathAt := self
										basicIdentityIndexOf: corpse
										from: deathAt + 1
										to: capacity].
					self rehash]
				ifFalse: 
					["... otherwise remove the losses individually"
					[deathAt > 0] whileTrue: 
							[self basicAt: deathAt put: nil.
							self fixCollisionsIgnoringCorpsesFrom: deathAt.
							deathAt := self
										basicIdentityIndexOf: corpse
										from: deathAt + 1
										to: capacity]]].

	"Inform any dependents"
	self trigger: #elementsExpired: with: anInteger!

fixCollisionsIgnoringCorpsesFrom: index
	"Private - Rehashes objects in the collection after index to see if any of
	them hash to index.  If so, that object is copied to index, and the
	process repeats with that object's index, until a nil is encountered.
	Corpse objects are not relocated, on the assumption that these will
	be nilled and fixed up later themselves."

	| slotIndex capacity element corpse |
	slotIndex := index.
	capacity := self basicSize.
	corpse := DeadObject current.
	
	[slotIndex := slotIndex \\ capacity + 1.
	(element := self basicAt: slotIndex) isNil] whileFalse: 
				[element == corpse
					ifFalse: 
						[| hashIndex |
						hashIndex := self findElementOrNil: element.
						(self basicAt: hashIndex) isNil ifTrue: [self moveFrom: slotIndex to: hashIndex]]]!

initialize
	"Private - Instance variable initialization. Ensure the receiver is weak."

	super initialize.
	self beWeak!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types.
	Weak types are generally considered as of the same species as their equivalent strong type."

	^Set! !
!Core.WeakSet categoriesFor: #copyEmpty:!copying!private! !
!Core.WeakSet categoriesFor: #copyingClass!copying!private! !
!Core.WeakSet categoriesFor: #do:!enumerating!public! !
!Core.WeakSet categoriesFor: #elementsExpired:!finalizing!private! !
!Core.WeakSet categoriesFor: #fixCollisionsIgnoringCorpsesFrom:!private!removing! !
!Core.WeakSet categoriesFor: #initialize!initializing!private! !
!Core.WeakSet categoriesFor: #species!accessing!public! !

!Core.WeakSet class methodsFor!

initialize
	"Initialize the receiver.
	Bereavement notifications are required by the receiver's instances to
	effect repairs."

	self makeMourner! !
!Core.WeakSet class categoriesFor: #initialize!development!initializing!public! !

