"Filed out from Dolphin Smalltalk"!

Core.Object
	variableSubclass: #'Kernel.CompiledCode'
	instanceVariableNames: 'header methodClass selector sourceDescriptor byteCodes'
	classVariableNames: 'InfoCacheKeys InfoCacheValues'
	imports: #(#{Kernel.OpcodePool})
	classInstanceVariableNames: ''
	classConstants: {
			'Normal' -> 16r0.
			'PrimitiveIndexShift' -> -16r17.
			'PrivateMask' -> 16r1.
			'ReturnFalse' -> 16r3.
			'ReturnInstanceVariable' -> 16r6.
			'ReturnLiteralConstant0' -> 16r5.
			'ReturnLiteralStatic0' -> 16r8.
			'ReturnNil' -> 16r4.
			'ReturnSelf' -> 16r1.
			'ReturnTrue' -> 16r2.
			'SetInstanceVariable' -> 16r7
		}!
Kernel.CompiledCode guid: (Core.GUID fromString: '{87b4c46f-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.CompiledCode isNonInstantiable: true!
Kernel.CompiledCode comment: 'CompiledCode is the class of executable objects containing an array of instructions (bytecodes) and an array of literals (the literal frame).

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
!Kernel.CompiledCode categoriesForClass!Kernel-Methods! !
!Kernel.CompiledCode methodsFor!

= aMethod
	"Answer whether the argument, aMethod, is considered exactly equivalent to 
	the receiver.
	Two CompiledMethods are considered equal iff they are of the same class
	(we can't compare non-CompiledMethods), they have the same selector, and
	the same byte codes and literal frame."

	| count |
	self == aMethod ifTrue: [^true].
	(self class == aMethod class and: 
			[methodClass == aMethod methodClass
				and: [selector = aMethod selector and: [byteCodes = aMethod basicByteCodes]]])
		ifFalse: [^false].
	aMethod size == (count := self size) ifFalse: [^false].
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

	| extra |
	extra := self extraIndex.
	^(extra == Normal or: 
			[extra == ReturnInstanceVariable
				or: [extra == SetInstanceVariable or: [extra > ReturnLiteralStatic0]]])
		and: [self byteCodeDispatcher accessesInstVarAt: anInteger]!

allLiteralsDo: operation 
	"Answer an array of the literals in the receiver."

	"Implementation Note: As Dolphin does not have separate methods for blocks (to save space), this is the
	same as #literalsDo:, but we inline it for speed"

	1 to: self size do: [:i | operation value: (self basicAt: i)]!

allSymbolLiterals
	"Answer a  <collection> of all the symbols referred to from the literal
	frame of this method, either directly or embedded in arrays. Special
	selectors (i.e. those encoded in the bytecodes) are also included."

	| messages |
	messages := IdentitySet new: 6.
	self allSymbolLiteralsDo: [:symbol | messages add: symbol].
	^messages
		addAll: self specialMessages;
		yourself!

allSymbolLiteralsDo: operation
	"Private - Evaluate the <monadicValuable>, operation, for each of the literal symbols 
	in the receiver's literal frame, including those embedded in arrays."

	self literalReferencesDo: [:each | each basicClass == Symbol ifTrue: [operation value: each]]!

annotations
	"Answer the receiver's <MethodAnnotations>, or nil if none."

	"Implementation Note: If the receiver has any annotations, then these will be stored in a MethodAnnotations object as the last literal."

	| size last |
	(size := self basicSize) == 0 ifTrue: [^nil].
	last := self basicAt: size.
	^last basicClass == MethodAnnotations ifTrue: [last]!

argumentCount
	"Answer the number of arguments expected by the receiver.
	This method is part of the ANSI <valuable> protocol, but CompiledCode
	does not conform to the whole protocol."

	^(header bitShift: -15) bitAnd: 255!

argumentCount: anInteger
	"Private - Set the number of arguments expected by the receiver."

	header := (header bitAnd: ##((255 bitShift: 15) bitInvert))
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

	byteCodes isImmediate ifTrue: [^self unpackBytes].
	^byteCodes!

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
	codes beImmutableObject.
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

customEnvironment
	"Private - Answer the <Namespace> in whose scope this method was compiled, or nil if that namespace is the same as the method's owning class."

	^self annotations ifNotNil: [:annotations | annotations environment]!

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
			info method: nil.
			InfoCacheKeys at: i put: self.
			InfoCacheValues at: i put: info].
	^InfoCacheValues at: i!

envInfo
	^(header bitShift: -1) bitAnd: 63!

environment
	"Answer the <Namespace> in whose scope this method was compiled. Normally this is the environment of the method's owning class, but methods can be explicitly or implicitly annotated with another namespace. Implicit namespace annotations are inserted by the compiler if an alternate environment is provided when compiling the method from source. Explicit namespace annotations are represented by `<namespace: MySpecialNamespace>` tags in the source."

	^self customEnvironment ifNil: [methodClass environment]!

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

	^(header bitShift: PrimitiveIndexShift) bitAnd: 255!

extraIndex: anInteger
	"Private - Set the extraIndex in the method header - used as the primitive index."

	"The header value must be a SmallInteger, but holds a 31-bit value so may be negative - asStackPointer is not well named, but ensures that the full 31-bits can be held in the SmallInteger range."

	header := ((header bitAnd: 16r7FFFFF)
				bitOr: ((anInteger bitAnd: 255) bitShift: ##(-1 * PrimitiveIndexShift))) asStackPointer!

fullBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this method, and failing that in the receiver's environment. If there is no such variable, then answer nil."

	^methodClass fullBindingFor: aString environment: self environment!

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

hasAnnotation: aSymbol
	"Answer whether the receiver has one or more annotations with the specified selector."

	| size annotations |
	size := self basicSize.
	size == 0 ifTrue: [^false].
	annotations := self basicAt: size.
	^annotations basicClass == MethodAnnotations and: [annotations includesSelector: aSymbol]!

hash
	"Answer the <SmallInteger> hash value for the receiver."

	^selector identityHash bitXor: methodClass basicIdentityHash!

header
	^header!

header: aSmallInteger 
	header := aSmallInteger!

isAnnotated
	"Answer whether the method has any annotations."

	| count |
	count := self size.
	^count > 0 and: [(self basicAt: count) basicClass == MethodAnnotations]!

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
			[| bc |
			(bc := byteCodes at: i) == Break ifTrue: [^true].
			i := i + (ByteCodeDispatcher.InstructionLengths at: bc + 1)].
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
			(literal basicClass == Array and: [literal isImmutable])
				ifTrue: [self literalArray: literal do: operation]]!

literalAt: anInteger 
	"Private - Answer the literal at the specified one-based <integer> index."

	"Implementation Note: Compiled methods are standard pointer objects in Dolphin, with the
	literal frame stored in the indexable part, therefore #at: and #literalAt: are synonms."

	^self basicAt: anInteger!

literalAt: anInteger put: aValue
	"Private - Replace the literal of the receiver at index, anInteger, with aValue."

	self basicAt: anInteger put: aValue!

literalCount
	"Private - Answer the number of literals contained in the literal frame of the receiver (0..255)"

	^self size!

literalReferencesDo: operation
	"Private - Evaluate the <monadicValuable>, operation, for each of the literals of the
	receiver, and each of the elements of any Array literals recursing down through any
	intermediate literal arrays."

	| literal |
	1 to: self size
		do: 
			[:i |
			literal := self basicAt: i.
			operation value: literal.
			(literal basicClass == Array and: [literal isImmutable])
				ifTrue: [self literalArray: literal do: operation]].
	"The last literal may hold the annotations. An annotation consists of a literal symbol selector, and then an array of arguments"
	literal basicClass == MethodAnnotations ifFalse: [^self].
	1 to: literal basicSize
		by: 2
		do: 
			[:i |
			"First the annotation selector, definitely a Symbol"
			operation value: (literal basicAt: i).
			"Then the annotation args, definitely an Array"
			self literalArray: (literal basicAt: i + 1) do: operation]!

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

	| literal elem |
	1 to: self size
		do: 
			[:i |
			literal := self at: i.
			(discriminator value: literal) ifTrue: [^literal].
			literal basicClass == Array
				ifTrue: 
					[1 to: literal size
						do: 
							[:j |
							elem := literal at: j.
							(discriminator value: elem) ifTrue: [^elem]]]].
	"The last literal may hold the annotations. An annotation consists of a literal symbol selector, and then an array of arguments"
	literal basicClass == MethodAnnotations
		ifTrue: 
			[1 to: literal basicSize
				by: 2
				do: 
					[:i |
					"First the annotation selector"
					elem := literal basicAt: i.
					(discriminator value: elem) ifTrue: [^elem].
					"Then the annotation args"
					elem := literal basicAt: i + 1.
					1 to: elem size
						do: 
							[:j |
							| arg |
							arg := elem at: j.
							(discriminator value: arg) ifTrue: [^arg]]]].
	^exceptionHandler value!

literalsDo: operation 
	"Private - Evaluate the monadic valuable, operation, for each of the receivers
	literals."

	1 to: self size do: [:i | operation value: (self basicAt: i)]!

localCount
	"Private - Answer the total number of stack temporaries (including arguments) used by the receiver."

	^self argumentCount + self stackTempCount!

localEnvironment
	"Private - Answer the nearest <Namespace> scope."

	^self environment
!

localScope
	"Answer the nearest name scope."

	^methodClass localScope
!

messages
	"Answer a <collection> of the messages sent by the receiver."

	(self extraIndex between: ReturnSelf and: ReturnLiteralStatic0) ifTrue: [^##(IdentitySet new)].
	^(MessageSendCollector dispatcher: self byteCodeDispatcher) messages!

messagesDo: aBlock
	"Evaluate the <monadicValuable> argument, aBlock, for each of the messages 
	actually sent by the receiver, including any special selectors."

	| idx |
	((idx := self extraIndex) == Normal or: [idx > ReturnLiteralStatic0])
		ifTrue: [(MessageSendEnumerator dispatcher: self byteCodeDispatcher) messagesDo: aBlock]!

methodClass
	"Answer the Class to which this method belongs (as opposed to the class of CompiledMethods)"

	^methodClass
!

methodClass: aClass
	"Private - Set the class to which the method belongs (i.e. that class for which it 
	implements part of the protocol) to aClass"

	(aClass isKindOf: Behavior) ifFalse: [^self error: 'Must be class'].
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
	^(idx := self extraIndex) > ReturnLiteralStatic0
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
	^(extra == Normal or: [extra == ReturnInstanceVariable or: [extra > ReturnLiteralStatic0]])
		and: [self byteCodeDispatcher readsInstVarAt: anInteger]!

realMethod
	^self!

refersToLiteral: anObject
	"Private - Answer whether the receiver refers directly from its literal frame (or indirectly as an element of an array in the literal frame) to the argument, anObject."

	"Implementation Note: This deliberately does not take account of special selectors and is open coded for speed."

	1 to: self size
		do: [:i | ((self basicAt: i) refersToLiteral: anObject) ifTrue: [^true]].
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
	(MessageSendEnumerator dispatcher: self byteCodeDispatcher)
		superMessagesDo: [:each | answer add: each].
	^answer!

suppressionId
	^self subclassResponsibility!

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

unpackBytes
	| size firstByte bytes remaining |
	firstByte := ((byteCodes bitAnd: 16r7F) bitShift: 1) bitOr: 1.	"This code is slightly more complex than needed, but avoids LargeInteger arithmetic for
	speed. It assumes there is at least one bytecode (which there must be)."
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

	| extra |
	extra := self extraIndex.
	^(extra == Normal or: [extra == SetInstanceVariable or: [extra > ReturnLiteralStatic0]])
		and: [self byteCodeDispatcher writesInstVarAt: anInteger]! !
!Kernel.CompiledCode categoriesForMethods!
=!comparing!public! !
accessesInstVar:!development!public!testing! !
accessesInstVar:at:!development!public!testing! !
allLiteralsDo:!enumerating!private! !
allSymbolLiterals!enumerating!public! !
allSymbolLiteralsDo:!enumerating!private! !
annotations!accessing!annotations!public! !
argumentCount!method header!public! !
argumentCount:!accessing!method header!private! !
basicByteCodes!accessing!private! !
byteCodeDispatcher!private!testing! !
byteCodeDispatcherClass!constants!private! !
byteCodes!accessing!private! !
byteCodes:!accessing!private! !
byteCodeSegments!accessing!private! !
clear!operations!private! !
compilerClass!constants!private! !
containsSource:!development!public!testing! !
customEnvironment!accessing!annotations!private! !
debugInfo!development!private! !
envInfo!accessing!private! !
environment!accessing!public! !
envTempCount!accessing!development!public! !
evaluationPools!accessing!development!public! !
extraIndex!method header!private! !
extraIndex:!method header!private! !
fullBindingFor:!binding!public! !
getDebugInfo!development!private! !
getSource!accessing!development!public! !
hasAnnotation:!annotations!enquiries!public! !
hash!comparing!public! !
header!accessing!private! !
header:!accessing!private! !
isAnnotated!annotations!public!testing! !
isCompilationFailure!public!testing! !
isDebugMethod!development!private!testing! !
isExpression!private!testing! !
isOverride!public!testing! !
isPacked!private!testing! !
isPrimitive!private!testing! !
isPrivate!private!testing! !
isPrivate:!accessing!private! !
isPublic!private!testing! !
isUnbound!public!testing! !
literalArray:do:!enumerating!private! !
literalAt:!accessing!private! !
literalAt:put:!accessing!private! !
literalCount!method header!private! !
literalReferencesDo:!enumerating!private! !
literals!accessing!private! !
literalsDetect:ifNone:!private!testing! !
literalsDo:!enumerating!private! !
localCount!accessing!method header!private! !
localEnvironment!accessing!private! !
localScope!accessing!public! !
messages!accessing!development!public! !
messagesDo:!development!enumerating!public! !
methodClass!accessing!public! !
methodClass:!accessing!private! !
needsContext!development!method header!private!testing! !
owningPackage!accessing!public! !
primitiveIndex!method header!private! !
readsInstVar:!development!public!testing! !
readsInstVar:at:!development!public!testing! !
realMethod!converting!public! !
refersToLiteral:!private!testing! !
replaceElementsOf:from:to:startingAt:!private!replacing! !
selector!accessing!public! !
selector:!accessing!private! !
sendsSelector:!development!public!testing! !
sendsSpecialSelector:!development!public!testing! !
setByteCodes:!initializing!private! !
sourceDescriptor!accessing!private! !
sourceDescriptor:!accessing!private! !
specialMessages!development!enumerating!private! !
stackTempCount!method header!private! !
storeCategories!categories!private!source filing-methods! !
storeSourceString:!private!source filing-methods! !
superMessages!accessing!development!public! !
suppressionId!accessing!private! !
tempCount!method header!private! !
tempsMap!accessing!development!private! !
textMap!accessing!development!private! !
unpackBytes!accessing!private! !
value:withArguments:!evaluating!public! !
writesInstVar:!development!public!testing! !
writesInstVar:at:!development!public!testing! !
!

Kernel.CompiledCode methodProtocol: #bindingScope attributes: #(#readOnly) selectors: #(#environment #fullBindingFor: #localScope)!
Kernel.CompiledCode methodProtocol: #messageSender attributes: #(#readOnly) selectors: #(#messages)!

!Kernel.CompiledCode class methodsFor!

elementsExpired: anInteger of: infoCacheKeys
	"Private - Some instances of the receiver with entries in the debug info cache were
	GC'd, so clean out any corresponding debug info from the cache."

	InfoCacheKeys nilCorpsesAndDo: [:i | InfoCacheValues at: i put: nil]!

findIp: anInteger inTextMap: aTextMap
	"Private - Answer the index of the source map entry corresponding to the specified <integer> ip. The key of each text map entry identifies the first IP of the code generated for the range
	of source which is held as entry's <interval> value."

	| i end first |
	i := 0.
	end := aTextMap size.
	[i < end and: 
			[first := (aTextMap at: i + 1) key.
			anInteger >= first]]
		whileTrue: [i := i + 1].
	^i!

findIP: anInteger inTextMap: aTextMap
	"Private - Answer the index of the source map entry corresponding to the specified <integer> ip. The key of each text map entry identifies the first IP of the code generated for the range
	of source which is held as entry's <interval> value."

	| i end first |
	i := 1.
	end := aTextMap size - 1.
	[i <= end and: 
			[first := (aTextMap at: i) key.
			anInteger > first]] whileTrue: [i := i + 1].
	"Skip to last entry with same first ip - there may be more than one for the same ip where the optimizer combines bytecodes, e.g. push self; send unary"
	[i < end and: [(aTextMap at: i + 1) key == first]] whileTrue: [i := i + 1].
	^i!

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
	| bytes codes count |
	bytes := anArray asByteArray.
	count := bytes size.
	codes := (count == 4
				ifTrue: [bytes int32AtOffset: 0]
				ifFalse: 
					[| packed |
					packed := 0.
					count to: 1
						by: -1
						do: [:i | packed := (packed bitShift: 8) + (bytes at: i)].
					packed])
					bitShift: -1.
	codes isImmediate ifFalse: [self error: 'Cannot pack byte codes <1p> into a SmallInteger' << bytes].
	^codes! !
!Kernel.CompiledCode class categoriesForMethods!
elementsExpired:of:!development!finalizing!private! !
findIp:inTextMap:!private! !
findIP:inTextMap:!helpers!private! !
initialize!development!initializing!private! !
initializeInfoCache!development!initializing!private! !
initializeInfoCache:!development!initializing!private! !
onPreStripImage!class hierarchy-removing!private! !
packByteCodes:!helpers!private! !
!

