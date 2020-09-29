"Filed out from Dolphin Smalltalk 7"!

Core.SharedLookupTable variableSubclass: #'Core.WeakLookupTable'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.WeakLookupTable guid: (Core.GUID fromString: '{87b4c532-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.WeakLookupTable comment: ''!
!Core.WeakLookupTable categoriesForClass!Collections-Unordered!Collections-Weak! !
!Core.WeakLookupTable methodsFor!

copyEmpty: anInteger
	"Private - Answer an empty copy of the receiver, with enough space for anInteger
	number of elements. 
	Implementation Note: We must override in order to copy the weak/strong state of 
	the receiver and its values."

	| answer |
	answer := super copyEmpty: anInteger.
	answer setSpecialBehavior: self getSpecialBehavior.
	answer basicValues setSpecialBehavior: self basicValues getSpecialBehavior.
	^answer!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	"Generally when copying part of a weak collection we don't want a weak result."

	^LookupTable!

do: operation
	"Evaluate monadic value argument, operation, for each of the elements (values) of the 
	receiver. Answers the receiver.
	Implementation Note: Override in order to revoke the weak status of the receiver	
	for the duration of the enumeration."

	mutex critical: [ | keysMask valuesMask |
		keysMask := self beStrong.
		valuesMask := self basicValues beStrong.
		[super do: operation]
			ensure: [
				self setSpecialBehavior: keysMask.
				self basicValues setSpecialBehavior: valuesMask]]!

elementsExpired: losses
	"Private - Handle the loss of <integer>, losses, keys from the receiver. We must repair the hash 
	table to maintain the set invariants, and we also nil out the corresponding values to allow them 
	to expire if they've no other references. Similar to WeakSet>>elementsExpired:.
	N.B. It is possible for the receiver to lose values AND keys during the same finalization cycle. It 
	is even possible that the key corresponding to a value may be lost at the same time as that 
	value. This means we cannot rely on the argument telling us the correct number of losses, since 
	some of these may overlap with value losses (which might already have been dealt with)."

	mutex critical: 
			[| deathAt capacity corpse |
			corpse := DeadObject current.
			capacity := self basicSize.
			deathAt := self
						basicIdentityIndexOf: corpse
						from: 1
						to: capacity.
			losses > (self size // 4)
				ifTrue: 
					["Rehash the collection if a large number of losses (don't need to nil values)..."
					[deathAt > 0] whileTrue: 
							[tally := tally - 1.
							self basicAt: deathAt put: nil.
							deathAt := self
										basicIdentityIndexOf: corpse
										from: deathAt + 1
										to: capacity].
					self rehash]
				ifFalse: 
					["... otherwise remove the losses individually"
					[deathAt > 0] whileTrue: 
							[tally := tally - 1.
							self basicAt: deathAt put: nil.
							values basicAt: deathAt put: nil.	"nil the corresponding value too"
							self fixCollisionsIgnoringCorpsesFrom: deathAt.
							deathAt := self
										basicIdentityIndexOf: corpse
										from: deathAt + 1
										to: capacity]]]!

elementsExpired: losses of: aWeakArray 
	"Private - Handle the loss of <integer>, losses, values from the receiver (values are stored 
	externally). We must remove the corresponding keys and repair the hash table to maintain the 
	set invariants. Similar to WeakSet>>elementsExpired:.
	N.B. It is possible for the receiver to lose values AND keys during the same finalization cycle, so 
	aWeakArray may no longer be the receiver's value array (if the #elementsExpired: message 
	informing of the loss of keys was received first). It is even possible that the key corresponding to 
	a value may be lost at the same time as that value. This means we cannot rely on either 
	argument to be terribly useful."

	mutex critical: 
			[losses > (self size // 4) 
				ifTrue: 
					["Rehash the collection if a large number of losses (don't need to nil values)..."

					self basicValues nilCorpsesAndDo: 
							[:deathAt | 
							tally := tally - 1.
							self basicAt: deathAt put: nil].
					self rehash]
				ifFalse: 
					["... otherwise remove the losses individually"

					self basicValues nilCorpsesAndDo: 
							[:deathAt | 
							tally := tally - 1.
							self basicAt: deathAt put: nil.
							self fixCollisionsIgnoringCorpsesFrom: deathAt]]]!

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
						hashIndex := self findKeyOrNil: element.
						(self basicAt: hashIndex) isNil ifTrue: [self moveFrom: slotIndex to: hashIndex]]]!

hasWeakKeys
	"Answer whether the receiver has weak references to its keys (the default)."

	^self isWeak!

hasWeakValues
	"Answer whether the receiver has weak references to its values (the default)."

	^self basicValues isWeak!

haveStrongKeys
	"Mark the receiver as having strong references to its keys. Answer the receiver."

	self beStrong!

haveStrongValues
	"Mark the receiver as having strong references to its values. Answer the receiver."

	self basicValues beStrong!

haveWeakKeys
	"Mark the receiver as having weak references to its keys (the default).
	Answer the receiver."

	self beWeak!

haveWeakValues
	"Mark the receiver as having weak references to its values (the default).
	Answer the receiver."

	self basicValues beWeak!

initialize
	"Private - Initialize the receiver's state."

	super initialize.
	self basicValues pathologist: self!

keysAndValuesDo: operation
	"Evaluate the dyadic valuable, operation, for each key/value pair in the receiver,
	to the exclusion of other threads.
	Implementation Note: Override in order to revoke the weak status of the receiver	
	for the duration of the enumeration."

	mutex critical: [ | keysMask valuesMask |
		keysMask := self beStrong.
		valuesMask := self basicValues beStrong.
		[super keysAndValuesDo: operation]
			ensure: [
				self setSpecialBehavior: keysMask.
				self basicValues setSpecialBehavior: valuesMask]]!

keysDo: operation
	"Evaluate the <monadicValuable>, operation, for each of the receiver's keys."

	self keysAndValuesDo: [:key :value | operation value: key]!

postResize: oldMe
	"Private - This message is sent by the receiver when resizing, after the receiver's elements have 
	been added to a new Collection and the receiver has become that collection. It is a chance for the 
	receiver to perform any final state changes needed. In this case we must ensure that the new value
	array has the correct pathologist - because of the use of a two way become:, it would otherwise keep
	the oldMe as it's pathologist."

	self basicValues pathologist: self!

valuesClass
	"Answer the class of Collection to use to hold the values of the receiver's elements
	(N.B. This is a different concept from #keysClass, which is used for copying the keys of 
	the receiver). For a WeakIdentityDictionary we always use a MourningWeakArray to hold the values,
	but we may turn off its weakness if the dictionary only has weak values. The MourningWeakArray
	is configured to inform the receiver when it suffers losses."

	^MourningWeakArray! !
!Core.WeakLookupTable categoriesFor: #copyEmpty:!copying!private! !
!Core.WeakLookupTable categoriesFor: #copyingClass!copying!private! !
!Core.WeakLookupTable categoriesFor: #do:!enumerating!public! !
!Core.WeakLookupTable categoriesFor: #elementsExpired:!finalizing!private! !
!Core.WeakLookupTable categoriesFor: #elementsExpired:of:!finalizing!private! !
!Core.WeakLookupTable categoriesFor: #fixCollisionsIgnoringCorpsesFrom:!private!removing! !
!Core.WeakLookupTable categoriesFor: #hasWeakKeys!public!testing! !
!Core.WeakLookupTable categoriesFor: #hasWeakValues!public!testing! !
!Core.WeakLookupTable categoriesFor: #haveStrongKeys!accessing!public! !
!Core.WeakLookupTable categoriesFor: #haveStrongValues!accessing!public! !
!Core.WeakLookupTable categoriesFor: #haveWeakKeys!accessing!public! !
!Core.WeakLookupTable categoriesFor: #haveWeakValues!accessing!public! !
!Core.WeakLookupTable categoriesFor: #initialize!initializing!private! !
!Core.WeakLookupTable categoriesFor: #keysAndValuesDo:!enumerating!public! !
!Core.WeakLookupTable categoriesFor: #keysDo:!enumerating!public! !
!Core.WeakLookupTable categoriesFor: #postResize:!adding!private! !
!Core.WeakLookupTable categoriesFor: #valuesClass!constants!public! !

!Core.WeakLookupTable class methodsFor!

initialize
	"Initialize the receiver.
	The receiver's instances need bereavement notifications to repair themselves."

	self makeMourner!

new: anInteger
	"Answer a new instance of the receiver sufficient capacity for anInteger elements. Both keys and values
	can be weakly referenced. By default instances of the receiver have strong key and weak value references."

	^self newWithWeakValues: anInteger!

newWithWeakKeys: anInteger
	"Answer a new instance of the receiver sufficient capacity for anInteger elements. The keys are weakly
	referenced, but the values have normal strong references. This can be changed later by sending the instance
	a message."

	^(super new: anInteger)
		haveWeakKeys;
		haveStrongValues;
		yourself
!

newWithWeakValues: anInteger
	"Answer a new instance of the receiver sufficient capacity for anInteger elements. The values are weakly
	referenced, but the keys have normal strong references. This can be changed later by sending the instance
	a message."

	^super new: anInteger
! !
!Core.WeakLookupTable class categoriesFor: #initialize!development!initializing!public! !
!Core.WeakLookupTable class categoriesFor: #new:!instance creation!public! !
!Core.WeakLookupTable class categoriesFor: #newWithWeakKeys:!instance creation!public! !
!Core.WeakLookupTable class categoriesFor: #newWithWeakValues:!instance creation!public! !

