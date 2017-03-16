"Filed out from Dolphin Smalltalk 7"!

ProtoObject subclass: #ItcProtoObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: '_InstanceBehaviorMasks'
	classInstanceVariableNames: ''!
ItcProtoObject guid: (GUID fromString: '{02137ae8-01db-41fe-97f6-c6b5141957cd}')!
ItcProtoObject comment: ''!
!ItcProtoObject categoriesForClass!Unclassified! !
!ItcProtoObject methodsFor!

addToBeFinalized
	self beFinalizable!

beFinalizable
	"Mark the receiver as an object requiring finalization.
	Answers the previous value of the special behavior mask."

	^self setSpecialBehavior: ##(_GetSpecialMask bitOr: _FinalizeMask)!

ifNil: aBlock
	"If the receiver is the nil object, then answer the result of evaluating
	the <niladicValuable>, aBlock, otherwise answer the receiver."

	"Implementation Note: This message is normally inlined by the compiler and so
	is never sent unless #perform'd. The inline form of the bytecodes is:

			dup
			jmp ifNotNil @notNil
			pop
			[...]
		@notNil
	"

	^self!

isImmediate
	^false!

perform: selector 
	"If this wasn't here, then the proxy could never catch messages sent via #perform: ..."

	"Send the receiver the unary message indicated by the <selector> argument,
	answering the result. 

	Primitive failure reasons:
		0 -	The number of arguments expected with the selector is not zero."

	<primitive: 83>
	^Error 
		perform: selector
		failedFor: self
		withArgs: Array new!

setSpecialBehavior: anInteger
	"Private - Set the special behavior bits of the receiver according to the
	low order word of the argument, anInteger. The high order byte of that word
	specifies the AND (or 'keep') mask, used to specify what bits to leave as they
	are, and the low order byte of that word specifies the OR (or 'add') mask, used
	to specify what bits to set. To query the current value, use the mask 16rFF00.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	the receiver is an immediate object."

	<primitive: 69>
	^self primitiveFailed! !
!ItcProtoObject categoriesFor: #addToBeFinalized!comparing!public! !
!ItcProtoObject categoriesFor: #beFinalizable!accessing!public! !
!ItcProtoObject categoriesFor: #ifNil:!accessing!public! !
!ItcProtoObject categoriesFor: #isImmediate!comparing!public! !
!ItcProtoObject categoriesFor: #perform:!accessing!public! !
!ItcProtoObject categoriesFor: #setSpecialBehavior:!accessing!private! !

