"Filed out from Dolphin Smalltalk 7"!

Object variableSubclass: #CompiledCode
	instanceVariableNames: 'header methodClass selector sourceDescriptor byteCodes'
	classVariableNames: 'InfoCacheKeys InfoCacheValues'
	poolDictionaries: 'OpcodePool'
	classInstanceVariableNames: ''
	classConstants: {
		'PrivateMask' -> 16r1
	}!
CompiledCode guid: (GUID fromString: '{87b4c46f-026e-11d3-9fd7-00a0cc3e4a32}')!
CompiledCode isAbstract: true!
CompiledCode comment: 'CompiledCode is the class of executable objects containing an array of instructions (bytecodes) and an array of literals (the literal frame).

The method header of the receiver is a SmallInteger containing a set of flags containing information such as the number of arguments, the number of temporaries, etc, is layed out as follows (subject to change):

	Bits:	Use:
	0	SmallInteger flag (not visible in Smalltalk)
	1	Private flag
	2..7	0 for no context, otherwise context Temp count + 1, so up to 63 context temps supported. 
	8..15	Stack Temp count	(i.e. maximum of 256 temps)
	16..23	Arg count		(i.e. maximum of 256 args)
	24..31	Primitive index

Primitive indices 0 thru 8 describe the method type as follows:
	0	Normal method requiring activation
	1	Return self
	2	Return true
	3	Return false
	4	Return nil
	5	Return literal zero
	6	Return an instance variable (see the bytecodes to determine which)
	7	Set an instance variable
	8	Reserved for future use.

Note: These are implementation details, and should not be relied upon as they may be changed in future versions.'!
!CompiledCode categoriesForClass!Kernel-Methods! !
!CompiledCode methodsFor!

= aMethod 
	"Answer whether the argument, aMethod, is considered exactly equivalent to 
	the receiver.
	Two CompiledMethods are considered equal iff they are of the same class
	(we can't compare non-CompiledMethods), they have the same selector, and
	the same byte codes and literal frame."

	| count |
	self == aMethod ifTrue: [^true].
	(self class == aMethod class and: 
			[self methodClass == aMethod methodClass 
				and: [self selector = aMethod selector and: [self byteCodes = aMethod byteCodes]]]) 
		ifFalse: [^false].
	count := self literalCount.
	aMethod literalCount = count ifFalse: [^false].
	"We need to special case static blocks in the literal frame to avoid infinite recursion"
	1 to: count
		do: 
			[:i | 
			| a b |
			a := self basicAt: i.
			b := aMethod basicAt: i.
			"The static blocks must be equal if they are implemented by this method and
			the bytecodes and all other literals are identical"
			(a class == BlockClosure and: [a method == self]) 
				ifTrue: [(b class == BlockClosure and: [b method == aMethod]) ifFalse: [^false]]
				ifFalse: [a = b ifFalse: [^false]]].
	^true!

accessesInstVar: instVarName
	"Answer whether the receiver accesses the named instance variable in its method class."

	^self accessesInstVar: instVarName at: (self methodClass indexOfInstVar: instVarName)!

accessesInstVar: aString at: anInteger 
	"Answer whether the receiver accesses the instance variable named, aString, which
	is the instance variable of its method class with the specified <integer> index."

	^(self extraIndex between: 1 and: 5) not 
		and: [self byteCodeDispatcher accessesInstVarAt: anInteger]!

allLiteralsDo: operation 
	"Answer an array of the literals in the receiver."

	"Implementation Note: As Dolphin does not have separate methods for blocks (to save space), this is the
	same as #literalsDo:, but we inline it for speed"

	1 to: self literalCount do: [:i | operation value: (self basicAt: i)]!

allSymbolLiterals
	"Answer a  <collection> of all the symbols referred to from the literal
	frame of this method, either directly or embedded in arrays. Special
	selectors (i.e. those encoded in the bytecodes) are also included."

	| messages |
	messages := IdentitySet new: 6.
	self allSymbolLiteralsDo: [:symbol | messages add: symbol].
	^messages addAll: self specialMessages; yourself!

allSymbolLiteralsDo: operation 
	"Private - Evaluate the <monadicValuable>, operation, for each of the literal symbols 
	in the receiver's literal frame, including those embedded in arrays."

	self literalReferencesDo: [:each | each class == Symbol ifTrue: [operation value: each]]!

argumentCount
	"Answer the number of arguments expected by the receiver.
	This method is part of the ANSI <valuable> protocol, but CompiledCode
	does not conform to the whole protocol."

	^(header bitShift: -15) bitAnd: 255!

argumentCount: anInteger 
	"Private - Set the number of arguments expected by the receiver."

	header := (header bitAnd: ##((255 << 15) bitInvert)) 
				bitOr: ((anInteger bitAnd: 255) bitShift: 15)!

basicByteCodes
	^byteCodes!

byteCodeDispatcher
	"Private - Answer a <ByteCodeDispatcher> on the receiver."

	^self byteCodeDispatcherClass on: self!

byteCodeDispatcherClass
	"Private - Answer the class to be used for dispatching the receiver's bytecodes."

	^ByteCodeDispatcher!

byteCodes
	"Private - Answer the byte codes (a ByteArray) for the receiver"

	| bytes remaining size firstByte |
	self isPacked ifFalse: [^byteCodes].
	"This code is slightly more complex than needed, but avoids LargeInteger arithmetic for
	speed. It assumes there is at least one bytecode (which there must be)."
	firstByte := ((byteCodes bitAnd: 16r7F) bitShift: 1) bitOr: 1.
	remaining := byteCodes bitShift: -7.
	remaining == 0 ifTrue: [^ByteArray with: firstByte].
	size := remaining digitLength + 1.
	bytes := ByteArray new: size.
	bytes at: 1 put: firstByte.
	2 to: size
		do: 
			[:i | 
			bytes at: i put: (remaining bitAnd: 16rFF).
			remaining := remaining bitShift: -8].
	^bytes!

byteCodes: anObject
	"Private - Set the value of the receiver's ''byteCodes'' instance variable to the argument,
	anObject. anObject must be either a ByteArray, or a SmallInteger containing the packed
	representation of the bytecodes. If a ByteArray is passed that is suitable for packing (it
	must be for 4 bytecodes or fewer and the first must be odd) then it is stored in the packed
	format."

	| codes |
	codes := (anObject isInteger or: [anObject size > 4 or: [anObject first even]])
				ifTrue: [anObject]
				ifFalse: [self class packByteCodes: anObject].
	codes isImmutable: true.
	self setByteCodes: codes!

byteCodeSegments
	^self byteCodeDispatcher segments!

clear
	"Private - Clear down temporary information cached in the receiver.
	The default is to do nothing."!

compilerClass
	"Private - Answer the class of compiler to be used for compiling instances of the receiver."

	^methodClass compilerClass!

containsSource: aString
	"Answer whether the receiver contains the specified source string."

	| src |
	src := self getSource.
	^src notNil and: [src contains: aString]!

debugInfo
	"Private - Answer a compilation result containing a recompilation of the receiver, a
	map between IP ranges and expressions in the source, and a map between IP ranges
	and an OrderedCollection of Associations between IP positions and temporaries 
	up to that position in the receiver, ordered by IP."

	| i method |
	i := self identityHash \\ InfoCacheKeys size + 1.
	method := InfoCacheKeys at: i.
	(method isNil or: [method == DeadObject current or: [method ~~ self]]) 
		ifTrue: 
			[| info |
			info := self getDebugInfo.
			"			method := info method.
			method isNil 
				ifFalse: 
					[method
						selector: self selector;
						sourceDescriptor: self sourceDescriptor]."
			info method: nil.
			InfoCacheKeys at: i put: self.
			InfoCacheValues at: i put: info].
	^InfoCacheValues at: i!

envInfo
	^(header bitShift: -1) bitAnd: 63!

environment
	"Answer the <Namespace> in whose scope this method was compiled."

	^methodClass environment!

envTempCount
	"Answer the number of environment temporaries used by the receiver."

	| info |
	info := self envInfo.
	^info == 0 ifTrue: [0] ifFalse: [info - 1]!

evaluationPools
	"Answer the evaluation pools used when compiling the receiver."

	^#()!

extraIndex
	"Private - Answer the 'extra' index of the receiver. This is the primitive index
	See class comment for further details."

	^(header bitShift: -23) bitAnd: 255!

extraIndex: anInteger
	"Private - Set the extraIndex in the method header - used as the primitive index."

	"The header value must be a SmallInteger, but holds a 31-bit value so may be negative - asStackPointer is not well named, but ensures that the full 31-bits can be held in the SmallInteger range."

	header := ((header bitAnd: 16r7FFFFF) bitOr: ((anInteger bitAnd: 255) bitShift: 23)) asStackPointer!

getDebugInfo
	"Private - Invoke the compiler to answer a compilation result containing a 
	recompilation of the receiver, a map between IP ranges and expressions 
	in the source, and a map between IP ranges and an <OrderedCollection> of 
	<Association>s between IP positions and temporaries up to that position in 
	the receiver, ordered by IP."

	^self subclassResponsibility!

getSource
	"Answer the source of the receiver.
	This task is delegated to the SourceManager."

	^self subclassResponsibility!

hash
	"Answer the <SmallInteger> hash value for the receiver."

	^selector identityHash bitXor: methodClass basicIdentityHash!

header
	^header!

header: aSmallInteger 
	header := aSmallInteger!

isCompilationFailure
	^false!

isDebugMethod
	"Private - Answer whether the receiver is a debug method."

	"Implementation Note: There is no longer a header flag for this, so we must search for break bytecodes."

	| size i |
	self isPacked ifTrue: [^false].
	size := byteCodes size.
	i := 1.
	[i > size] whileFalse: 
			[(byteCodes at: i) == Break ifTrue: [^true].
			i := i + (ByteCodeDispatcher lengthOfInstruction: (byteCodes at: i))].
	^false!

isExpression
	"Private - Answer whether the receiver is a standalone (unbound) expression as opposed to 
	a method."

	^self subclassResponsibility!

isOverride
	"Answer whether the receiver is overriding a method in a superclass."

	^false!

isPacked
	"Private - Answer whether the receiver's byte codes are packed into a SmallInteger rather than being stored in a separate ByteArray."
	
	^byteCodes isImmediate!

isPrimitive
	^self primitiveIndex ~= 0!

isPrivate
	"Private - Answer whether the receiver is a debug method."

	^header anyMask: PrivateMask!

isPrivate: aBoolean 
	"Private - Set whether the receiver is a private method."

	self whileMutableDo: [header := header mask: PrivateMask set: aBoolean]!

isPublic
	"Private - Answer whether the receiver is a public method."

	^self isPrivate not!

isUnbound
	"Answer whether the receiver is unbound (i.e. not linked into a class' method dictionary).
	Only CompiledMethod subinstances can be bound."

	^true!

literalArray: literalArray do: operation
	"Private - Evaluate the <monadicValuable>, operation, for each of the elements of
	the <Array>, literalArray, recursively drilling down into any embedded arrays too.
	Note that it is a pre-order traversal."

	1 to: literalArray size
		do: 
			[:i |
			| literal |
			operation value: (literal := literalArray at: i).
			(literal class == Array and: [literal isImmutable])
				ifTrue: [self literalArray: literal do: operation]]!

literalAt: anInteger 
	"Private - Answer the literal at the specified one-based <integer> index."

	"Implementation Note: Compiled methods are standard pointer objects in Dolphin, with the
	literal frame stored in the indexable part, therefore #at: and #literalAt: are synonms."

	^self basicAt: anInteger!

literalAt: anInteger put: aValue
	"Private - Replace the literal of the receiver at index, anInteger, with aValue."

	self at: anInteger put: aValue!

literalCount
	"Private - Answer the number of literals contained in the literal frame of the receiver (0..255)"

	^self size!

literalReferencesDo: operation
	"Private - Evaluate the <monadicValuable>, operation, for each of the literals of the
	receiver, and each of the elements of any Array literals recursing down through any
	intermediate literal arrays."

	1 to: self literalCount
		do: 
			[:i |
			| each |
			operation value: (each := self basicAt: i).
			(each class == Array and: [each isImmutable]) ifTrue: [self literalArray: each do: operation]]!

literals
	"Private - Answer an array of the literals in the receiver."

	| count |
	count := self size.
	^self
		replaceElementsOf: (Array new: count)
		from: 1
		to: count
		startingAt: 1!

literalsDetect: discriminator ifNone: exceptionHandler
	"Evaluate the <monadicValuable> argument, discriminator, for each of the 
	objects in the receiver's literal frame. If the literal is an <Array>, then 
	the discriminator is also evaluated for each of its elements. The first matching
	element, at the top level or embedded in an array, is answered. If no matching
	element is found, then the result of evaluating the <niladicValuable>, exceptionHandler,
	is answered."

	1 to: self literalCount
		do: 
			[:i |
			| literal |
			literal := self at: i.
			(discriminator value: literal) ifTrue: [^literal].
			literal class == Array
				ifTrue: 
					[1 to: literal size
						do: 
							[:j |
							| elem |
							elem := literal at: j.
							(discriminator value: elem) ifTrue: [^elem]]]].
	^exceptionHandler value!

literalsDo: operation 
	"Private - Evaluate the monadic valuable, operation, for each of the receivers
	literals."

	1 to: self literalCount do: [:i | operation value: (self basicAt: i)]!

localCount
	"Private - Answer the total number of stack temporaries (including arguments) used by the receiver."

	^self argumentCount + self stackTempCount!

localEnvironment
	"Private - Answer the nearest <Namespace> scope."

	^self environment
!

messages
	"Answer the set of messages sent by the receiver."

	| answer |
	answer := IdentitySet new: 10.
	self messagesDo: [:sel | answer add: sel].
	^answer!

messagesDo: aBlock
	"Evaluate the <monadicValuable> argument, aBlock, for each of the messages 
	actually sent by the receiver, including any special selectors."

	self extraIndex == 0
		ifTrue: [(MessageSendCollector dispatcher: self byteCodeDispatcher) messagesDo: aBlock]!

methodClass
	"Answer the Class to which this method belongs (as opposed to the class of CompiledMethods)"

	^methodClass
!

methodClass: aClass
	"Private - Set the class to which the method belongs (i.e. that class for which it 
	implements part of the protocol) to aClass"

	(aClass isKindOf: Behavior) ifFalse: [ ^self error: 'Must be class' ].
	methodClass := aClass!

needsContext
	"Private - Answer whether the receiver needs a context to be allocated for it when it
	is activated. The context is needed to hold shared, closed-over, variables, and/or to
	support ^-returns from blocks. 
	Note that if a method answers true to #needsContext, but its #envTempCount is zero,
	then that implies that it contains a far return in a nested block. To eliminate the
	requirement for a context (perhaps for efficient reasons), it will be necessary to
	refactor the method to remove the far return, perhaps. by relocating it so that it is
	ouside a block. For example:
		(aCollection at: aKey ifAbsent: [^self]) blahBlah
	Could be written without the far return as:
		(aCollection at: aKey ifAbsent: []) ifNotNil: [:aValue | aValue blah blah]"

	^self envInfo - 1 >= 0!

owningPackage
	^self subclassResponsibility!

primitiveIndex
	"Private - Answer the primitive index of the method, or zero if none"

	| idx |
	^(idx := self extraIndex) > 8
		ifTrue: [idx]
		ifFalse: [0]!

readsInstVar: instVarName
	"Answer whether the receiver reads the named instance variable in its method class."

	^self readsInstVar: instVarName
		at: (self methodClass indexOfInstVar: instVarName)!

readsInstVar: aString at: anInteger 
	"Answer whether the receiver accesses the instance variable named, aString, which
	is the instance variable of its method class with the specified <integer> index."

	| extra |
	extra := self extraIndex.
	^((extra between: 1 and: 5) or: [extra == 7]) not 
		and: [self byteCodeDispatcher readsInstVarAt: anInteger]!

refersToLiteral: anObject
	"Private - Answer whether the receiver refers directly from its literal frame (or indirectly as an 
	element of an array in the literal frame) to the argument, anObject. Named for compatibility 
	with VisualWorks."

	"Implementation Note: This deliberately does not take account of special selectors and is open
	coded for speed."

	1 to: self size do: [:i | ((self basicAt: i) refersToLiteral: anObject) ifTrue: [^true]].
	^false!

replaceElementsOf: anIndexableObject from: startInteger to: stopInteger startingAt: startAtInteger
	"Private - Replace the indexable instance variables of the variable pointer object,
	anIndexableObject, between startInteger and stopInteger inclusive with literals from the
	receiver starting from startAtInteger. Answers anIndexableObject."

	<primitive: 188>
	| offset |
	offset := startAtInteger - startInteger.
	(anIndexableObject == self and: [startAtInteger < startInteger])
		ifTrue: 
			[stopInteger to: startInteger
				by: -1
				do: [:i | anIndexableObject basicAt: i put: (self basicAt: offset + i)]]
		ifFalse: 
			[startInteger to: stopInteger do: [:i | anIndexableObject basicAt: i put: (self basicAt: offset + i)]].
	^anIndexableObject!

selector
	"Answer the message selector under which the receiver is entered in its class' method
	dictionary."

	^selector
!

selector: aSymbol
	"Private - Set the message selector under which the receiver is entered in its class' method
	dictionary."

	selector := aSymbol asSymbol!

sendsSelector: aSymbol 
	"Answer whether the receiver sends the specified selector. This is done by enumerating
	the byte codes, so simple references to the same symbol will not be counted."

	self messagesDo: [:sel | sel == aSymbol ifTrue: [^true]].
	^false!

sendsSpecialSelector: anInteger 
	"Answer whether the method which the receiver is interpreting sends the special
	selector with the specified index (one based)."

	^self byteCodeDispatcher sendsSpecialSelector: anInteger!

setByteCodes: anIntegerOrByteArray
	<mutable>
	byteCodes := anIntegerOrByteArray!

sourceDescriptor
	"Private - Answer the receiver's sourceDescriptor (an object, usually an Integer which
	describes the location of the receiver's source, but may be a String). The source descriptor
	is managed by the receiver's source manager, and is opaque to the receiver."

	^sourceDescriptor!

sourceDescriptor: anObject
	"Private - Set the receiver's source descriptor to anObject. This should normally only be sent by the receiver's source manager."

	<mutable>
	sourceDescriptor := anObject!

specialMessages
	"Private - Answer a Collection of all the special message selectors which
	the receiver sends."

	^self byteCodeDispatcher specialMessages!

stackTempCount
	"Private - Answer the number of stack temporaries (excluding arguments) used by the receiver."

	^(header bitShift: -7) bitAnd: 255!

stackTempCount: anInteger 
	"Private - Set the number of stack temporaries (excluding arguments) used by the receiver."

	header := (header bitAnd: ##((255 << 7) bitInvert)) 
				bitOr: ((anInteger bitAnd: 255) bitShift: 7)!

storeCategories
	"Private - Record the categories of the receiver."

	"Ignored unless dev system is loaded"
!

storeSourceString: aString
	"Private - Record aString as the source for the receiver."

	self sourceDescriptor: aString
!

superMessages
	"Answer a <Set> of all the message selectors super-sent by this method."

	| answer |
	answer := IdentitySet new.
	(MessageSendCollector dispatcher: self byteCodeDispatcher) 
		superMessagesDo: [:each | answer add: each].
	^answer!

tempCount
	"Private - Answer the number of temporaries (local variables and arguments) of the receiver.
	This is the total number of temps, regardless of where allocated."

	^self localCount + self envTempCount!

tempsMap
	"Private - Answer a map between IP's and source ranges in the receiver."

	^self debugInfo tempsMap!

textMap
	"Private - Answer a map between IP's and source ranges in the receiver."

	^self debugInfo textMap!

value: anObject withArguments: anArray
	"Evaluate the receiver with the argument, anObject, as its receiver, and with the argument, anArray, as the arguments to the message.

	Primitive failure reasons:
		InvalidParameter1			- anObject is not a subinstance of the method class of the receiver.
		InvalidParameter2			- anArray is not an Array
		WrongNumberOfArguments	- anArray contains the wrong number of arguments"

	<primitive: 116>
	^self primitiveFailed: _failureCode!

writesInstVar: instVarName
	"Answer whether the receiver assigns to the named instance variable in its method class."

	^self writesInstVar: instVarName
		at: (self methodClass indexOfInstVar: instVarName)!

writesInstVar: aString at: anInteger 
	"Answer whether the receiver accesses the instance variable named, aString, which
	is the instance variable of its method class with the specified <integer> index."

	^(self extraIndex between: 1 and: 6) not 
		and: [self byteCodeDispatcher writesInstVarAt: anInteger]! !
!CompiledCode categoriesFor: #=!comparing!public! !
!CompiledCode categoriesFor: #accessesInstVar:!development!public!testing! !
!CompiledCode categoriesFor: #accessesInstVar:at:!development!public!testing! !
!CompiledCode categoriesFor: #allLiteralsDo:!enumerating!private! !
!CompiledCode categoriesFor: #allSymbolLiterals!enumerating!private! !
!CompiledCode categoriesFor: #allSymbolLiteralsDo:!enumerating!private! !
!CompiledCode categoriesFor: #argumentCount!method header!public! !
!CompiledCode categoriesFor: #argumentCount:!accessing!method header!private! !
!CompiledCode categoriesFor: #basicByteCodes!accessing!private! !
!CompiledCode categoriesFor: #byteCodeDispatcher!private!testing! !
!CompiledCode categoriesFor: #byteCodeDispatcherClass!constants!private! !
!CompiledCode categoriesFor: #byteCodes!accessing!private! !
!CompiledCode categoriesFor: #byteCodes:!accessing!private! !
!CompiledCode categoriesFor: #byteCodeSegments!accessing!private! !
!CompiledCode categoriesFor: #clear!operations!private! !
!CompiledCode categoriesFor: #compilerClass!constants!private! !
!CompiledCode categoriesFor: #containsSource:!development!public!testing! !
!CompiledCode categoriesFor: #debugInfo!development!private! !
!CompiledCode categoriesFor: #envInfo!accessing!private! !
!CompiledCode categoriesFor: #environment!accessing!public! !
!CompiledCode categoriesFor: #envTempCount!accessing!development!public! !
!CompiledCode categoriesFor: #evaluationPools!accessing!development!public! !
!CompiledCode categoriesFor: #extraIndex!method header!private! !
!CompiledCode categoriesFor: #extraIndex:!method header!private! !
!CompiledCode categoriesFor: #getDebugInfo!development!private! !
!CompiledCode categoriesFor: #getSource!accessing!development!public! !
!CompiledCode categoriesFor: #hash!comparing!public! !
!CompiledCode categoriesFor: #header!accessing!private! !
!CompiledCode categoriesFor: #header:!accessing!private! !
!CompiledCode categoriesFor: #isCompilationFailure!public!testing! !
!CompiledCode categoriesFor: #isDebugMethod!development!private!testing! !
!CompiledCode categoriesFor: #isExpression!private!testing! !
!CompiledCode categoriesFor: #isOverride!public!testing! !
!CompiledCode categoriesFor: #isPacked!private!testing! !
!CompiledCode categoriesFor: #isPrimitive!private!testing! !
!CompiledCode categoriesFor: #isPrivate!private!testing! !
!CompiledCode categoriesFor: #isPrivate:!accessing!private! !
!CompiledCode categoriesFor: #isPublic!private!testing! !
!CompiledCode categoriesFor: #isUnbound!public!testing! !
!CompiledCode categoriesFor: #literalArray:do:!enumerating!private! !
!CompiledCode categoriesFor: #literalAt:!accessing!private! !
!CompiledCode categoriesFor: #literalAt:put:!accessing!private! !
!CompiledCode categoriesFor: #literalCount!method header!private! !
!CompiledCode categoriesFor: #literalReferencesDo:!enumerating!private! !
!CompiledCode categoriesFor: #literals!accessing!private! !
!CompiledCode categoriesFor: #literalsDetect:ifNone:!private!testing! !
!CompiledCode categoriesFor: #literalsDo:!enumerating!private! !
!CompiledCode categoriesFor: #localCount!accessing!method header!private! !
!CompiledCode categoriesFor: #localEnvironment!accessing!private! !
!CompiledCode categoriesFor: #messages!accessing!development!public! !
!CompiledCode categoriesFor: #messagesDo:!development!enumerating!public! !
!CompiledCode categoriesFor: #methodClass!accessing!public! !
!CompiledCode categoriesFor: #methodClass:!accessing!private! !
!CompiledCode categoriesFor: #needsContext!development!method header!private!testing! !
!CompiledCode categoriesFor: #owningPackage!accessing!public! !
!CompiledCode categoriesFor: #primitiveIndex!method header!private! !
!CompiledCode categoriesFor: #readsInstVar:!development!public!testing! !
!CompiledCode categoriesFor: #readsInstVar:at:!development!public!testing! !
!CompiledCode categoriesFor: #refersToLiteral:!private!testing! !
!CompiledCode categoriesFor: #replaceElementsOf:from:to:startingAt:!private!replacing! !
!CompiledCode categoriesFor: #selector!accessing!public! !
!CompiledCode categoriesFor: #selector:!accessing!private! !
!CompiledCode categoriesFor: #sendsSelector:!development!public!testing! !
!CompiledCode categoriesFor: #sendsSpecialSelector:!development!public!testing! !
!CompiledCode categoriesFor: #setByteCodes:!initializing!private! !
!CompiledCode categoriesFor: #sourceDescriptor!accessing!private! !
!CompiledCode categoriesFor: #sourceDescriptor:!accessing!private! !
!CompiledCode categoriesFor: #specialMessages!development!enumerating!private! !
!CompiledCode categoriesFor: #stackTempCount!method header!private! !
!CompiledCode categoriesFor: #stackTempCount:!accessing!development!method header!private! !
!CompiledCode categoriesFor: #storeCategories!categories!private!source filing-methods! !
!CompiledCode categoriesFor: #storeSourceString:!private!source filing-methods! !
!CompiledCode categoriesFor: #superMessages!accessing!development!public! !
!CompiledCode categoriesFor: #tempCount!method header!private! !
!CompiledCode categoriesFor: #tempsMap!accessing!development!private! !
!CompiledCode categoriesFor: #textMap!accessing!development!private! !
!CompiledCode categoriesFor: #value:withArguments:!evaluating!public! !
!CompiledCode categoriesFor: #writesInstVar:!development!public!testing! !
!CompiledCode categoriesFor: #writesInstVar:at:!development!public!testing! !

CompiledCode methodProtocol: #messageSender attributes: #(#readOnly) selectors: #(#messages)!

!CompiledCode class methodsFor!

elementsExpired: anInteger of: infoCacheKeys
	"Private - Some instances of the receiver with entries in the debug info cache were
	GC'd, so clean out any corresponding debug info from the cache."

	InfoCacheKeys nilCorpsesAndDo: [:i | InfoCacheValues at: i put: nil]!

initialize
	"Private - Initialize the class variables of the receiver.

		CompiledCode initialize
	"

	self initializeInfoCache!

initializeInfoCache
	"Private - Initialize the cache of method information used for debugging.
		CompiledCode initializeInfoCache
	"

	self initializeInfoCache: 100!

initializeInfoCache: capacity 
	"Private - Initialize the cache of method information used for debugging to the
	specified capacity."

	| primeSize |
	InfoCacheKeys isNil ifFalse: [InfoCacheKeys pathologist: nil].
	primeSize := Set sizeFor: capacity.
	InfoCacheKeys := MourningWeakArray new: primeSize.
	InfoCacheKeys pathologist: self.
	InfoCacheValues := Array new: primeSize!

onPreStripImage
	"Private - Clear away the cache of method information used for debugging."

	InfoCacheKeys pathologist: nil.
	InfoCacheKeys := InfoCacheValues := nil!

packByteCodes: anArray
	| bytes codes |
	bytes := anArray asByteArray.
	codes := (bytes size == 4
				ifTrue: [bytes sdwordAtOffset: 0]
				ifFalse: 
					[| packed |
					packed := 0.
					bytes reverseDo: [:each | packed := (packed bitShift: 8) + each].
					packed])
					bitShift: -1.
	self assert: [codes class == SmallInteger].
	^codes! !
!CompiledCode class categoriesFor: #elementsExpired:of:!finalizing!private! !
!CompiledCode class categoriesFor: #initialize!development!initializing!private! !
!CompiledCode class categoriesFor: #initializeInfoCache!development!initializing!private! !
!CompiledCode class categoriesFor: #initializeInfoCache:!development!initializing!private! !
!CompiledCode class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!CompiledCode class categoriesFor: #packByteCodes:!helpers!private! !

