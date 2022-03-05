"Filed out from Dolphin Smalltalk"!

Object subclass: #Behavior
	instanceVariableNames: 'superclass methodDictionary instanceSpec subclasses'
	classVariableNames: '_BasicSpecMask _BytesSubMask _FundamentalShapeMask _IndirectMask _MournerMask _NonInstantiableMask _NullMethodDictionary _NullTermMask _PointersMask _ShapeMask _SizeMask _VariableMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Behavior guid: (GUID fromString: '{87b4c459-026e-11d3-9fd7-00a0cc3e4a32}')!
Behavior addClassConstant: '_BasicSpecMask' value: 16r7FFF!
Behavior addClassConstant: '_BytesSubMask' value: 16r4800!
Behavior addClassConstant: '_FundamentalShapeMask' value: 16r30FF!
Behavior addClassConstant: '_IndirectMask' value: 16r800!
Behavior addClassConstant: '_MournerMask' value: 16r400!
Behavior addClassConstant: '_NonInstantiableMask' value: 16r200!
Behavior addClassConstant: '_NullTermMask' value: 16r4000!
Behavior addClassConstant: '_PointersMask' value: 16r2000!
Behavior addClassConstant: '_ShapeMask' value: 16r70FF!
Behavior addClassConstant: '_SizeMask' value: 16rFF!
Behavior addClassConstant: '_VariableMask' value: 16r1000!
Behavior comment: 'Class `Behavior` is the abstract class which defines the minimum state necessary for objects that have instances, providing the basic information about those instances to the Compiler and the VM.

Instance Variables:

  `superclass`		`Behavior` object of the instance''''s superclass
  `subclasses`		`Array` of `Behavior`''s which are the subclasses of the instance
  `methodDictionary`	`MethodDictionary` mapping selector Symbols to CompiledMethods
  `instanceSpec`		`<integer>` containg flags which describe the "shape" of the instance (e.g. oops vs bytes)

Behavior defines a number of bit masks which are used to describe objects. These flags are stored as constants in the class pool:
  `_BasicSpecMask` 			`<integer>` bit mask to extract the basic inst. spec (excludes extra spec word).
  `_BytesSubMask` 			`<integer>` bit mask to extract inst. spec. bits relating exclusively to byte objects
  `_FundamentalShapeMask` 	`<integer>` bit mask to extract the fundamental shape of instances from instance spec.
  `_IndirectMask`				`<integer>` bit mask to extract indirection (i.e. memory pointer) flag from inst. spec. flags
  						The indirection bit marks classes whose instances are indirect references to 
  						other objects/memory - e.g. ExternalAddresses. Such objects are automatically
  						dereferenced when passed to appropriate VM primitives.
  `_MournerMask`			`<integer>` bit mask to extract mourner flag from inst. spec. flags
						The mourner bit marks classes who actively grieve for the loss of their constituents. 
						Weak instances of such classes will be notified by the Undertaker process when 
						they suffer bereavements during a GC. This notification is ''''off'''' by default because the
						receipt of such a notifications will delay the death of its receiver, which may result in
						significantly extended life for hierarchies of incestuously referencing weak objects.
  `_NonInstantiableMask`		`<integer>` bit mask to extract the abstract class flag from inst. spec. flags.
						This bit is used to mark classes considered to be abstract (non-instantiable).
  `_NullTermMask`			`<integer>` bit mask to extract null terminated flag from inst. spec. (byte objects only)
						The null term. bit can be used to mark byte classes as having an implicit null terminator
						(e.g. to represent C-style strings).
  `_PointersMask`			`<integer>` bit mask to extract the pointers/bytes flag from inst. spec.
						The pointer bit marks classes whose instances contain pointers (as opposed to bytes).
  `_ShapeMask` 				`<integer>` bit mask to extract the shape flags from inst. spec.
  `_SizeMask`	 			`<Integer>` bit mask to extract the number of named inst. vars. from inst. spec.
						The size bits specify the number of named instance variables (0..255) in instances
						of the receiver.
  `_VariableMask`			`<integer>` bit mask to extract the fixed/variable size flag from inst. spec.
						The variable bit marks classes whose instances include indexable (unnamed) 
						instance variables.

Behavior implements the ANSI protocols `<Object>`, `<classDescription>`, `<instantiator>`, and `<Object class>`.'!
!Behavior categoriesForClass!Kernel-Classes! !
!Behavior methodsFor!

addSelector: aSymbol withMethod: aCompiledMethod
	"Private - Add the message selector, aSymbol, with the corresponding
	CompiledMethod, to the receiver's method dictionary.
	Implementation Note: Clears down the VM method cache in case a previous 
	version of the method is cached, or it overrides a superclass method."

	| selector |
	selector := aSymbol asSymbol.
	aCompiledMethod
		methodClass: self;
		selector: selector.
	(methodDictionary ifNil: [methodDictionary := MethodDictionary new]) at: selector
		put: aCompiledMethod.

	"One might expect to be able to trigger a #methodAdded: event here,
	 to be symetrical with Behavior>>removeSelector:. However, the 
	 method source is not yet set up (logged) so in fact we have to do
	 this later."
	self flushMethodCache!

addSubclass: aClass
	"Private - Include the argument, aClass, as a subclass of the receiver."

	| subs count index |
	aClass superclass == self
		ifFalse: [^self error: ('I am not <1p>''s superclass' expandMacrosWith: aClass)].
	subs := self subclasses.
	count := subs size.
	count == 0
		ifTrue: 
			[subclasses := {aClass}.
			^self].
	"Maintain the array in sorted order as saves sorting on access - speed is important to minimize class creation time"
	index := subs binarySearchFor: aClass using: [:a :b | a name <=> b name <= 0].
	(index > 1 and: [(subs at: index - 1) == aClass]) ifTrue: [^self].
	subclasses := subs copyWith: aClass atIndex: index!

addToSuper
	"Private - Add the receiver to its superclasses' subclass collection."

	superclass addSubclass: self!

allInstances
	"Answer an <Array> of all direct instances of the receiver."

	MemoryManager current collectGarbage.
	^self primAllInstances!

allInstVarNames
	"Answer an <Array> of the <readableString> names of the receiver's instance variables, 
	those specified in the receiver and in all of its superclasses. The array ordering is the order 
	in which the variables are stored and accessed by the interpreter."

	^superclass isNil
		ifTrue: [self instVarNames]
		ifFalse: [superclass allInstVarNames , self instVarNames]!

allMethodsDo: operation
	"Evaluate the monadic valuable, operation, for each and every method defined in the hierarchy rooted in the receiver."

	self withAllSubclassesDo: [:behavior | behavior methodDictionary do: operation]!

allSelectors
	"Answer a <Set> of <Symbol>s, being all the message selectors to which the receiver 
	is able to respond (this includes messages understood by superclasses)."

	| answer accumulate |
	answer := IdentitySet new.
	accumulate := [:s | answer add: s].
	self withAllSuperclassesDo: [:each | each understoodSelectorsDo: accumulate].
	^answer!

allSubclasses
	"Answer a <collection> of the receiver's subclasses in 
	breadth-first order, with the immediate subclasses first. 
	Breadth-first traversal is slightly less efficient, but results 
	in a more useful ordering (the standard does not specify the order). 

	N.B. The original Smalltalk-80 definition specified that this 
	method should answer a Set, and the draft ANSI standard specifies
	only <collection>. The defacto standard (e.g. See IBM 
	Common Base) is now an OrderedCollection, and we follow suit as this
	maintains the ordering, which is often useful."

	| answer |
	answer := OrderedCollection new.
	self allSubclassesBreadthFirstDo: [:each | answer addLast: each].
	^answer!

allSubclassesBreadthFirstDo: aMonadicValuable 
	"Evaluate the monadic valuable argument with each of the receiver's 
	subclasses in breadth-first order. The standard #allSubclassesDo: method 
	performs a depth-first traversal (which is quicker)."

	subclasses ifNotNil: 
			[:classes | 
			classes do: [:each | aMonadicValuable value: each].
			classes do: [:each | each allSubclassesBreadthFirstDo: aMonadicValuable]]!

allSubclassesDo: aMonadicValuable
	"Evaluate the monadic valuable argument for each of the 
	receiver's subclasses using a pre-order depth first traversal."

	self allSubclassesPreOrderDo: aMonadicValuable!

allSubclassesEndOrderDo: aMonadicValuable
	"Private - Evaluate the monadic valuable argument for each 
	of the receiver's subclasses, visiting the receiver AFTER its
	subclasses (i.e. an end-order traversal)."

	subclasses isNil 
		ifFalse: 
			[subclasses do: 
					[:each | 
					each allSubclassesEndOrderDo: aMonadicValuable.
					aMonadicValuable value: each]]!

allSubclassesPreOrderDo: aMonadicValuable
	"Private - Evaluate the monadic valuable argument for each 
	of the receiver's subclasses, visiting the receiver before its
	subclasses (i.e. a pre-order traversal)."

	subclasses isNil 
		ifFalse: 
			[subclasses do: 
					[:each | 
					aMonadicValuable value: each.
					each allSubclassesPreOrderDo: aMonadicValuable]]!

allSubinstances
	"Answer an <Array> containing all instances of the receiver and its subclasses."

	MemoryManager current collectGarbage.
	^self primAllSubinstances!

allSuperclasses
	"Answer a <collection> of the receiver's superclass and the receiver's ancestor's 
	superclasses. The first element is the receiver's immediate superclass, followed by its
	superclass, and so on; the last element is always Object.

	Note that we actually return a <sequencedReadableCollection> but that sequenceability
	cannot be relied upon in portable code because the ANSI standard specifies
	only <collection>."

	| answer |
	answer := OrderedCollection new.
	self allSuperclassesDo: [:each | answer addLast: each].
	^answer!

allSuperclassesDo: aMonadicValuable
	"Private - Evaluate the monadic valuable argument for each of the receiver's 
	superclasses."

	| class current |
	class := self.
	
	[current := class superclass.
	class := current.
	current isNil] 
			whileFalse: [aMonadicValuable value: current]!

basicCompile: aString 
	"Private - Compile the argument, code, and enter the result in the receiver's method dictionary. 
	If a compile error occurs a CompilerNotification is signalled. Answers a new method or nil.
	Note that this method doesn't generate a #methodAdded: trigger, and doesn't do anything
	with categories."

	^self basicCompile: aString flags: self defaultCompilationFlags!

basicCompile: aString flags: anInteger
	| error result stubMethod |
	result := error := stubMethod := nil.
	
	[result := self compilerClass
				compile: aString
				in: self
				flags: anInteger]
			on: self compilerClass errorClass
			do: 
				[:n |
				error := n.
				stubMethod := (MethodCompileFailed with: n) signal: n description.
				n pass].
	error notNil ifTrue: [result := stubMethod].
	result notNil
		ifTrue: 
			[| selector method |
			method := result method.
			selector := method selector asSymbol.
			methodDictionary
				ifNotNil: 
					[| oldMethod |
					oldMethod := methodDictionary lookup: selector.
					result oldMethod: oldMethod.
					oldMethod ifNotNil: [method isPrivate: oldMethod isPrivate]].
			self addSelector: selector withMethod: method.
			method
				storeSourceString: aString asString;
				isImmutable: true].
	^result!

basicNew
	"Private - As #new, but must not be overridden by subclasses."

	"Primitive failure reasons:
		ObjectTypeMismatch	- The receiver is an indexable class, and requires a size.
		NonInstantiable		- The receiver class is non-instantiable (abstract)."

	<primitive: 70>
	_failureCode == _PrimitiveFailureCode.ObjectTypeMismatch ifTrue: [^self basicNew: 0].
	_failureCode == _PrimitiveFailureCode.NonInstantiable ifTrue: [^self errorNonInstantiable].
	^self primitiveFailed: _failureCode!

basicNew: aSmallInteger
	"Private - As #new:, but must not be overridden by subclasses."

	<primitive: 71>
	_failureCode == _PrimitiveFailureCode.ObjectTypeMismatch ifTrue: [^Error notIndexable: self].
	_failureCode == _PrimitiveFailureCode.NonInstantiable ifTrue: [^self errorNonInstantiable].
	^self primitiveFailed: _failureCode!

basicNewFixed: aSmallInteger
	"Private - As #newFixed:, but must not be overridden by subclasses."
	
	"Primitive failure reasons:
		InvalidParameter1	- the argument is not a positive <SmallInteger>.
		NonInstantiable		- the receiver is non-instantiable (abstract).
		ObjectTypeMismatch	- the receiver is not an indexable byte class."

	<primitive: 76>
	_failureCode == _PrimitiveFailureCode.ObjectTypeMismatch ifTrue: [^self errorNotPinnable].
	_failureCode == _PrimitiveFailureCode.NonInstantiable ifTrue: [^self errorNonInstantiable].
	^self primitiveFailed: _failureCode!

bindingFor: aString 
	"Answer a variable binding for the named variable in the scope of this class. 
	If there is no such variable, then answer nil."

	^superclass bindingFor: aString!

canUnderstand: aSymbol
	"Answer whether the receiver can respond to the message whose selector is the argument, aSymbol.
	The selector can be in the method dictionary of the receiver's class or any of its superclasses."

	^(self lookupMethod: aSymbol) notNil!

compile: code
	"Compile the argument, code, and enter the result in the receiver's method dictionary. 
	If a compile error occurs a CompilerNotification is signalled. Answers a new method or nil.
	If the method is successfully compiled, then trigger a #methodAdded: event."

	| method result |
	result := self basicCompile: code.
	result notNil 
		ifTrue: 
			[method := result method.
			result fireSystemUpdateEvent].
	^method!

compileAll
	"Compile all the methods for which the receiver has selectors. We install stub methods for all
	compilation failures"

	[self selectors do: [:each | self recompile: each]] 
		on: MethodCompileFailed
		do: 
			[:ex | 
			"If we get a method compilation error then we install 
			a stub method so we'll be able to see the source."

			ex
				beep;
				resumeWithStubMethod]!

compileAllSubclasses
	"Compile all the methods in the receiver's subclasses' method dictionaries."

	self allSubclassesDo: [:each | each compileAll]!

compiledMethodAt: aSymbol
	"Answer the compiled method associated with the selector argument, aSymbol, in 
	the receiver's local method dictionary. Report an error if the selector cannot be found."

	^methodDictionary ?? _NullMethodDictionary at: aSymbol!

compiledMethodAt: aSymbol ifAbsent: aNiladicValuable
	"Answer the compiled method associated with the selector argument, aSymbol, in 
	the receiver's local method dictionary, or the result of evaluating the niladic
	valuable argument if the selector can not be found."

	^methodDictionary ?? _NullMethodDictionary at: aSymbol ifAbsent: aNiladicValuable!

compilerClass
	"Answer the default Compiler class to use for compiling methods, etc, of the
	receiver."

	^Compiler!

decompile: aSymbol
	"Find the compiled code associated with the selector argument, aSymbol, and decompile it. 
	Answer the resulting source code as a <readableString>. If the selector is not in the method 
	dictionary, report an error."

	| method source |
	method := self compiledMethodAt: aSymbol.
	source := method getSource.
	source isNil 
		ifTrue: 
			[^self error: 'decompiler can''t decompile methods without source (yet)']
		ifFalse: [^source]!

defaultCompilationFlags
	^self compilerClass defaultFlags!

definitionOf: aSymbol
	"Answer the compiled method associated with the selector argument, aSymbol, in 
	the receiver's method dictionary, or that of its superclass, etc. Report an error if the 
	selector is not understood by the receiver."

	self withAllSuperclassesDo: 
			[:each | 
			(each includesSelector: aSymbol) ifTrue: [^each compiledMethodAt: aSymbol]].
	^self errorNotFound: aSymbol!

dynamicSelectors
	"Answer a <collection> of all the extra message selectors understood by the receiver at run time that might not have an associated method."

	| answer |
	answer := IdentitySet new.
	self dynamicSelectorsDo: [:each | answer add: each].
	^answer!

dynamicSelectorsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the extra message selectors understood by the receiver at run time that might not have an associated method."

	"To be overridden by subclasses that handle #doesNotUnderstand: to process additional messages."!

environment
	"Answer the receiver's name space."

	^Smalltalk!

errorNonInstantiable
	"Private - Report an error that an attempt was made to instantiate an abstract class."

	^self error: 'Cannot instantiate abstract class'!

errorNotPinnable
	^self error: 'Pointer objects cannot be pinned'!

extraInstanceSpec
	"Private - Answer the user class instance specification of the receiver (a 16-Bit Integer)."

	<primitive: 151>
	^(self instanceSpec bitShift: -15) bitAnd: 16rFFFF!

extraInstanceSpec: aSmallInteger
	"Private - Set the user class instance specification of the receiver to the <SmallInteger> argument."

	self instanceSpec: ((aSmallInteger lowWord bitShift: 15) 
				maskSet: (self instanceSpec bitAnd: _BasicSpecMask))!

flushMethodCache
	"Private - Ask the VM to completely flush its method cache. The primitive should not fail."

	<primitive: 89>
	^self primitiveFailed: _failureCode!

fullBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, and
	failing that in the receiver's environment. If there is no such variable, then answer nil."

	(aString identityIncludes: $.)
		ifTrue: 
			[| parts env count |
			parts := $. split: aString.
			"Fully qualified name always starts in Smalltalk"
			env := Smalltalk.
			count := parts size.
			1 to: count - 1
				do: [:i | (env bindingFor: (parts at: i)) ifNil: [^nil] ifNotNil: [:assoc | env := assoc value]].
			^env bindingFor: (parts at: count)].
	^(self bindingFor: aString) ifNil: [self environment bindingFor: aString]!

hasCompilationFailures
	"Answer whether any of the methods in the receiver or any of its subclasses have previously failed to compile."

	^(self methodDictionary anySatisfy: [:each | each isCompilationFailure])
		or: [self subclasses anySatisfy: [:each | each hasCompilationFailures]]!

hasImmediateInstances
	"Answer whether the receiver's instances are immutable objects encoded entirely 
	in an Oop (e.g. SmallIntegers).
	Implementation Note: Included for compatibility with VisualWorks."

	^false!

hasMethods
	"Answer whether the receiver has any methods in its local method dictionary."

	^methodDictionary notNil and: [methodDictionary size > 0]!

includesBehavior: aBehavior
	"Answer whether the receiver includes the behavior, aBehavior
	(i.e. is aBehavior the receiver or a superclass of the receiver)."

	^self == aBehavior or: [superclass includesBehavior: aBehavior]
!

includesSelector: aSymbol
	"Answer whether the local method dictionary contains a method whose
	selector is the argument, aSymbol."

	^methodDictionary notNil and: [methodDictionary includesKey: aSymbol]!

inheritsFrom: aClass
	"Answer whether the receiver is a subclass of aClass.
	This is the same as #includesBehavior:, but starts from the
	superclass of the receiver."

	^superclass includesBehavior: aClass!

instanceCount
	"Answer the number of instances of the receiver that currently exist.
	This is a rather expensive method, but it is an original Smalltalk-80 method
	and thus remains. Don't use it in application code though!!"

	^self allInstances size!

instanceSpec
	"Private - Answer the instance specification (shape of instances) of the receiver.
	This may also contain various 'user' specific bits which do not necessarily relate
	to the immediate shape of the class' instances."

	^instanceSpec!

instanceSpec: anInteger
	"Private - Set the instance specification of the receiver to anInteger. 
	WARNING: Improper use of this method may cause the VM to behave unexpectedly"

	instanceSpec := anInteger!

instSize
	"Answer the number of fixed fields (named instance variables) in instances of the receiver."

	^self instanceSpec bitAnd: _SizeMask!

instVarNames
	"Answer a <sequencedReadableCollection> of the receiver's instance variable 
	names."

	^#()!

isBits
	"Answer whether the variables of instances of the receiver contain bits (i.e. not object pointers)."

	^self isPointers not!

isBytes
	"Answer whether the variables of instances of the receiver are stored as bytes (8-bit integers)."

	^self isPointers not!

isFixed
	"Answer whether instances of the receiver are NOT indexable (i.e. they contain only a 
	specified set of named instance variables)."

	^self isVariable not!

isIndirection
	"Answer true if the instances of the receiver are actually indirect references to other 
	objects. In the case of Byte objects this means that they contain the address of an external 
	or internal object. Objects of indirection classes, such as ExternalAddress, behave differently 
	when passed to certain system primitives (e.g. byte replacement primitives)."

	^self instanceSpec anyMask: _IndirectMask!

isIndirection: aBoolean
	"Set/reset the receivers status as an indirect reference (i.e. an
	address/pointer) to some other object (internal or external)."

	self setShapeFlags: _IndirectMask to: aBoolean!

isMeta
	"Answer whether the receiver is a <Metaclass>."

	^false!

isMetaclass
	"Answer whether the receiver is a <Metaclass>."

	^self isMeta!

isMourner
	"Answer whether instances of the receiver like to grieve 
	for the loss of their constituents."

	^self instanceSpec anyMask: _MournerMask!

isNonInstantiable
	"Private - Answer whether the receiver should not be instantiated, e.g. it is abstract."

	^instanceSpec anyMask: _NonInstantiableMask!

isNonInstantiable: aBoolean
	"Private - Set whether the receiver should not be instantiated, e.g. it is abstract."

	self setShapeFlags: _NonInstantiableMask to: aBoolean!

isNullTerminated
	"Answer true if the instances of the receiver are Null Terminated (that is they include 
	an extra byte with the value zero at their end, which is not included in the reported size). 
	Only meaningful for variable byte classes (e.g. String)."

	^self instanceSpec allMask: _NullTermMask!

isNullTerminated: aBoolean
	"Set the receivers status as a class of Null Terminated objects
	(i.e. its instances have an additional byte, not included in the reported size, 
	which is always zero). Only meaningful for variable byte classes"

	self setSpecialBehavior: _NullTermMask to: aBoolean!

isPointers
	"Answer whether the variables of instances of the receiver contain object pointers (as
	opposed to uninterpreted bytes)."

	^self instanceSpec anyMask: _PointersMask!

isVariable
	"Answer whether instances of the receiver can have indexed instance variables."

	^self instanceSpec anyMask: _VariableMask!

isWords
	"Answer whether the variables of instances of the receiver are stored as words."

	"OBSOLETE"

	^false!

kindOfSubclass
	"Private - Answer a string describing the kind of subclassing method used to create the receiver 
	(part of its definition)."

	^self isVariable 
		ifTrue: [self isBytes ifTrue: ['variableByteSubclass:'] ifFalse: ['variableSubclass:']]
		ifFalse: ['subclass:']!

lookupMethod: aSymbol
	"Answer the method of the receiver, or inherited by the receiver, corresponding
	to the selector, aSymbol."

	<primitive: 148>
	^self primitiveFailed: _failureCode!

makeMourner
	"Private - Set the receivers status as an mourner. This only affects the
	weak instances of such classes, which will receive a #elementsExpired:
	message from the Undertaker process soon after they have suffered the loss
	of an object they are weakly referencing. This gives the mourner the opportunity
	to put its house in order. By default this behaviour is disabled, as its use
	can extend the life of an object (a weak object which would otherwise be
	garbage collected has to be rescued in order that it can perform its
	mourning process, as the mourning process may be important for releasing
	external resources, etc."

	self setShapeFlags: _MournerMask to: true!

methodDictionary
	"Private - Answer the receiver's <MethodDictionary>."

	^methodDictionary ?? _NullMethodDictionary!

methodDictionary: aMethodDictionary
	"Private - Store the <MethodDictionary> argument as the method dictionary of the receiver.
	Incorrect use of this method (e.g. with an argument which is not a <MethodDictionary>)
	can cause unexpected behavior of the VM)."

	methodDictionary := (aMethodDictionary isNil or: [aMethodDictionary isEmpty])
				ifFalse: [aMethodDictionary]!

new
	"Answer an instance of the receiver with no indexed variables. Send the receiver the message {new: 0} if the receiver is indexable.

	This is the fundamental method by which new class instances are created. It is inherited
	by class objects (Metaclass instance instances) through the route:
		MyClass class -> MyClass class superclass -> ... 
			-> Object class -> Class -> ClassDescription -> Behavior"

	"Primitive failure reasons:
		ObjectTypeMismatch	- The receiver is an indexable class, and requires a size.
		NonInstantiable		- The receiver class is non-instantiable (abstract)."

	<primitive: 70>
	_failureCode == _PrimitiveFailureCode.ObjectTypeMismatch ifTrue: [^self new: 0].
	_failureCode == _PrimitiveFailureCode.NonInstantiable ifTrue: [^self errorNonInstantiable].
	^self primitiveFailed: _failureCode!

new: aSmallInteger
	"Answer an instance of the receiver with the specified number of indexed instance variables.
	Report an error if the receiver is not indexable, or the argument is invalid.

	This is the fundamental method by which new instances of indexable classes are are created.
	It is inherited by class objects (Metaclass instance instances) through the route:
		MyClass class -> MyClass class superclass -> ... 
			-> Object class -> Class -> ClassDescription -> Behavior"

	"Primitive failure reasons:
		InvalidParameter1	- the argument is not a positive <SmallInteger>.
		NonInstantiable		- the receiver is non-instantiable (abstract).
		ObjectTypeMismatch	- the receiver's instances are not indexable."

	<primitive: 71>
	_failureCode == _PrimitiveFailureCode.ObjectTypeMismatch ifTrue: [^Error notIndexable: self].
	_failureCode == _PrimitiveFailureCode.NonInstantiable ifTrue: [^self errorNonInstantiable].
	^self primitiveFailed: _failureCode!

new: numSmallInteger max: maxSmallInteger
	"Private - Answer an instance of the receiver with numSmallInteger indexed instance variables, 
	which can grow to accommodate maxSmallInteger. Report an error if the receiver is not indexable
	or the arguments are invalid.

	Primitive failure reasons:
		InvalidParameter1	- numSmallInteger is not a positive SmallInteger
		InvalidParameter2	- maxSmallInteger is not a positive SmallInteger
		ObjectTypeMismatch	- The receiver is not an indexable type
		NonInstantiable		- The receiver is non-instantiable
		NoMemory		- There was insufficient virtual address space available to reserve the requested maximum size, or insufficient free memory to commit the initial size"

	<primitive: 90>
	_failureCode == _PrimitiveFailureCode.ObjectTypeMismatch ifTrue: [^Error notIndexable: self].
	_failureCode == _PrimitiveFailureCode.NonInstantiable ifTrue: [^self errorNonInstantiable].
	_failureCode == _PrimitiveFailureCode.NoMemory ifTrue: [^OutOfMemoryError signal].
	self primitiveFailed: _failureCode!

newFixed: aSmallInteger
	"Answer an instance of the receiver of size aSmallInteger bytes (this method is only valid for byte objects). The object is allocated from the fixed memory heap and will not move in memory (objects allocated with primitive 71 are free to move to assist garbage collection, whereas those allocated with primitive 76 are in a traditional fixed heap)."

	"Primitive failure reasons:
		InvalidParameter1	- the argument is not a positive <SmallInteger>.
		NonInstantiable		- the receiver is non-instantiable (abstract).
		ObjecTypeMismatch	- the receiver is not an indexable byte class."

	<primitive: 76>
	_failureCode == _PrimitiveFailureCode.ObjectTypeMismatch ifTrue: [^self errorNotPinnable].
	_failureCode == _PrimitiveFailureCode.NonInstantiable ifTrue: [^self errorNonInstantiable].
	^self primitiveFailed: _failureCode!

primAllInstances
	"Private - Answer an <Array> of all the instances of the receiver which currently exist in the system. 
	This may include currently unreferenced objects, unless a full garbage collection has just been 
	performed - for this reason use #allInstances in preference if speed is not an issue.
	The primitive should not fail."

	<primitive: 77>
	^self primitiveFailed: _failureCode!

primAllSubinstances
	"Private - Answer an <Array> of all the instances of the receiver and its subclasses
	which currently exist in the system. This may include currently unreferenced objects, 
	unless a full garbage collection has just been performed - for this reason use 
	#allSubinstances in preference if speed is not an issue.
	The primitive should not fail."

	<primitive: 58>
	^self primitiveFailed: _failureCode!

recompile: aSelector 
	"Compile the method associated with the message selector, selector.
	The method is not logged to the change log but the source is re-used
	from the original"

	| oldMethod method stubMethod result |
	oldMethod := self compiledMethodAt: aSelector.
	oldMethod isNil ifTrue: [^self].
	
	[result := self compilerClass 
				compile: oldMethod getSource
				in: self
				flags: self defaultCompilationFlags] 
			on: self compilerClass errorClass
			do: 
				[:ex | 
				stubMethod := (MethodCompileFailed with: ex) signal: ex description.
				ex pass].

	"Was a stub method installed?"
	stubMethod notNil ifTrue: [result := stubMethod].
	^(result notNil and: [(method := result method) notNil]) 
		ifTrue: 
			["Add the selector and copy across the old source descriptor and privacy, as we haven't don't want to change either"
			method selector: aSelector.
			self addSelector: aSelector withMethod: method.
			method
				sourceDescriptor: oldMethod sourceDescriptor;
				isPrivate: oldMethod isPrivate;
				isImmutable: true.
			"The method has not actually changed, so it is inappropriate to issue a #methodUpdated: event"
			method]!

recompileAll
	"Recompile this class and all its subclasses. The methods are not logged to the change log,
	but the sources are re-used from the originals. N.B. In order to recompile all methods in
	the system it is necessary to avoid the process being interrupted or the system may crash.
	To achieve this evaluate an expression such as:

	[Object recompileAll] forkAt: Processor userInterruptPriority "

	self withAllSubclassesDo: 
			[:each | 
			each class compileAll.
			each compileAll]!

recompileReferencesToLiteral: aVariableBinding
	"Private - Recompile any of the receiver's methods that reference the specified object from their literal frame."

	self methodDictionary do: 
			[:each |
			(each refersToLiteral: aVariableBinding)
				ifTrue: 
					[Notification signal: 'Recompiling ' , each printString.
					each recompile]]!

referenceFilterFor: anObject
	"Private - Answer a <monadicValuable> that when evaluated for a <CompiledMethod> answers
	true if the method references anObject, or false if not."

	anObject isSymbol
		ifTrue: 
			[| index |
			index := VMLibrary default indexOfSpecialSelector: anObject ifAbsent: [].
			index notNil
				ifTrue: [^[:each | (each refersToLiteral: anObject) or: [each sendsSpecialSelector: index]]]].
	^[:each | each refersToLiteral: anObject]!

removeFromSuper
	"Private - Remove the receiver from its superclasses' subclass collection.
	Root classes will have a superclass of nil - we do not put such
	classes into any subclass collection."

	superclass notNil ifTrue: [superclass removeSubclass: self]!

removeFromSystem
	"Private - Remove the receiver from the system (completely remove a class)."

	ClassBuilder removeClass: self!

removeSelector: selector
	"Remove the argument, selector (which is a Symbol representing a message selector), 
	from the receiver's message dictionary."

	^self removeSelector: selector ifAbsent: [self errorNotFound: selector]!

removeSelector: aSymbol ifAbsent: aNiladicValuable
	"Remove the the method with the selector specified by the argument, aSymbol, 
	from the receiver's message dictionary. Answer the <CompiledMethod> that
	as removed, or, if the selector is not in the method dictionary, the result of evaluating 
	the niladic valuable argument.
	Implementation Note: Flush the VM method cache in case the method is cached. 
	The #methodRemoved: event is triggered to inform interested parties."

	| method |
	(methodDictionary isNil or: [(method := methodDictionary removeKey: aSymbol ifAbsent: []) isNil])
		ifTrue: [^aNiladicValuable value].
	methodDictionary isEmpty ifTrue: [methodDictionary := nil].
	self flushMethodCache.
	self environment trigger: #methodRemoved: with: method.
	^method!

removeSelectors: aCollection
	"Remove each of the <Symbol> selectors in the <collection> argument from the 
	receiver's message dictionary. If any of the selectors are not present, they are 
	simply ignored. Answer a <collection> of the <CompiledMethod>s which were actually
	removed."

	| methods env |
	methodDictionary ifNil: [^#()].
	"Take advantage of the fact that Sets ignores requests to add nil"
	methods := aCollection asSet 
				collect: [:each | methodDictionary removeKey: each ifAbsent: []].
	methodDictionary isEmpty ifTrue: [methodDictionary := nil].
	self flushMethodCache.
	env := self environment.
	methods do: [:each | env trigger: #methodRemoved: with: each].
	^methods!

removeSubclass: aClass
	"Private - Remove the argument, aClass, from the subclasses of the receiver.
	WARNING: This method does not completely remove a class from the system."

	subclasses isNil ifFalse: [
		(subclasses := subclasses copyWithout: aClass) isEmpty
			ifTrue: [ subclasses := nil ]]!

requiresInstallation
	"Answer whether the receiver requires 'installing' into its environment."

	^false!

scopeHas: name ifTrue: operation
	"Answer whether name is in scope in the receiver.
	Compiler support. Not yet implemented."

	^Error notYetImplemented
!

selectMethods: aMonadicValuable
	"Private - Answer a <Set> of the <CompiledMethod>s of the receiver 
	for which the monadic valuable, discriminator, evaluates to true."

	| answer |
	answer := IdentitySet new: 25.
	self methodDictionary 
		do: [:each | (aMonadicValuable value: each) ifTrue: [answer add: each]].
	^answer!

selectors
	"Answer a <collection> of <Symbol>s, being all the selectors of all the methods
	in the receiver."

	^(methodDictionary ifNil: [^#()]) keys!

selectorsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the selectors in the receiver's method
	dictionary."

	^methodDictionary ifNotNil: [methodDictionary keysDo: aMonadicValuable]!

setInstSize: anInteger
	(anInteger between: 0 and: (self isBytes ifTrue: [0] ifFalse: [_SizeMask]))
		ifFalse: [self error: 'Invalid number of fixed fields'].
	instanceSpec := (instanceSpec maskClear: _SizeMask) maskSet: anInteger!

setShapeFlags: anIntegerMask to: aBoolean
	"Private - Set/Reset the receivers shape/structure flags (as defined by anIntegerMask)
	according to the argument aBoolean."

	instanceSpec := instanceSpec mask: anIntegerMask set: aBoolean!

setSpecialBehavior: anIntegerMask to: aBoolean
	"Private - Set/Reset the receivers special behavior (as defined by anIntegerMask)
	according to the argument aBoolean. Only meaningful for variable byte classes"

	self isBytes 
		ifTrue: [self setShapeFlags: anIntegerMask to: aBoolean]
		ifFalse: [self error: 'Must be byte class']!

setSuperclass: aClass
	"Private - Set the superclass of the receiver to aClass, maintaining the hierarchy
	as necessary. This is the correct way to set the superclass of a Behavior"

	self superclass == aClass ifTrue: [^self].
	self
		removeFromSuper;
		superclass: aClass;
		addToSuper!

shallowCopy
	"Answer a copy of the receiver which shares the receiver's instance 
	variables. 
	Implementation Note: Behaviors are unique and cannot be copied."

	^self!

sourceCodeAt: aSymbol
	"Answer a <String> that is the source code of the receiver's method with selector, aSymbol.
	Report an error if the selector cannot be found."

	^(self compiledMethodAt: aSymbol) getSource!

subclasses
	"Answer a <collection> containing the receiver's immediate subclasses.

	Note that the answer is actually a <sequencedReadableCollection>, but that
	sequenceability should not be relied upon in portable code because the draft ANSI
	standard specifies only <collection>."

	^subclasses ifNil: [{}]!

subclasses: aCollection
	"Set the receivers subclasses to the specified collection.
	The subclasses are maintained as a sorted array, but leaf classes store nil to save space."

	subclasses := (aCollection notNil and: [aCollection notEmpty]) 
				ifTrue: [aCollection asSortedCollection asArray]!

subclassInstVarNames
	"Answer a <Set> of the instance variable names specified in the receiver's subclasses"

	| answer |
	answer := Set new.
	self allSubclassesDo: [:each | answer addAll: each instVarNames].
	^answer!

superclass
	"Answer a <classDescription> which is the receiver's immediate 
	superclass (or <nil> if none)."

	^superclass!

superclass: aClass
	"Set the superclass of the receiver to be the argument, aClass"

	(aClass isNil or: [aClass isKindOf: Behavior]) 
		ifFalse: [self error: 'superclass must be a kind of Behavior'].
	superclass := aClass!

understoodSelectors
	"Answer a <collection> of all message selectors understood by the receiver, not including those understood only because they are implemented in superclasses. This should however include those that are not in the method  dictionary but will be understood as a result of #doesNotUnderstand: processing, if that is possible."

	| answer |
	answer := IdentitySet new: 12.
	self understoodSelectorsDo: [:each | answer add: each].
	^answer!

understoodSelectorsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the message selectors understood by the receiver at run time, not necessarily including those understood by superclasses.
	The block may be evaluated more than once for the same selector."

	methodDictionary ifNotNil: [methodDictionary keysDo: aMonadicValuable].
	self dynamicSelectorsDo: aMonadicValuable!

whichClassIncludesSelector: selector
	"Answer the first class on the receiver's superclass chain (including the receiver) where 
	the argument, selector, can be founds as a message selector. Answer nil if no class includes
	the selector."

	^(self includesSelector: selector) 
		ifTrue: [self]
		ifFalse: 
			[superclass notNil 
				ifTrue: [superclass whichClassIncludesSelector: selector]]!

whichClassSatisfies: aBlock
	"Private - Recurse up through the receiver's inheritance chain, starting with the receiver,
	until the <monadicValuable> argument answers true when evaluated against the receiver."

	(aBlock value: self) ifTrue: [^self].
	^superclass isNil ifFalse: [superclass whichClassSatisfies: aBlock]!

whichMethodsAccess: aString
	"Answer a <Set> of methods from the receiver's local method dictionary whose methods access 
	the instance variable of the receiver named by the argument."

	^self whichMethodsAccess: aString
		at: (self allInstVarNames indexOf: aString)!

whichMethodsAccess: aString at: anInteger
	"Private - Answer a <Set> of selectors from the receiver's local method dictionary whose 
	methods access the instance variable with the specified index."

	^self 
		selectMethods: [:method | method accessesInstVar: aString at: anInteger]!

whichMethodsAssign: aString
	"Answer a <collection> of <CompiledMethod>s that write to the instance variable
	named by the <readableString> argument."

	^self whichMethodsAssign: aString
		at: (self allInstVarNames indexOf: aString)!

whichMethodsAssign: aString at: anInteger
	^self 
		selectMethods: [:method | method writesInstVar: aString at: anInteger]!

whichMethodsRead: aString
	"Answer a <collection> of <CompiledMethod>s that read the instance variable
	named by the <readableString> argument."

	^self whichMethodsRead: aString at: (self allInstVarNames indexOf: aString)!

whichMethodsRead: aString at: anInteger
	^self 
		selectMethods: [:method | method readsInstVar: aString at: anInteger]!

whichSelectorsAccess: aString
	"Answer a <collection> of <Symbol>s, being the selectors of methods of the receiver
	that access the instance variable named by the <readableString> argument.
	N.B. Primarily present for Blue Book compatibility, and used by the Refactoring Browser.."

	^(self whichMethodsAccess: aString) collect: [:each | each selector]!

whichSelectorsAssign: aString
	"Answer a <collection> of <Symbol>s, being the selectors of methods of the receiver
	that assign to the instance variable named by the <readableString> argument."

	^(self whichMethodsAssign: aString) collect: [:each | each selector]!

whichSelectorsRead: aString
	"Answer a <collection> of <Symbol>s, being the selectors of methods of the receiver
	that read the instance variable named by the <readableString> argument."

	^(self whichMethodsRead: aString) collect: [:each | each selector]!

whichSelectorsWrite: aString
	"Answer a <Set> of selectors whose methods write to the instance variable
	named by the <readableString> argument."

	| index |
	index := self allInstVarNames indexOf: aString.
	^(self selectMethods: [:each | each writesInstVar: aString at: index]) 
		collect: [:each | each selector]!

withAllSubclasses
	"Answer an <OrderedCollection> containing the receiver, and all of the receiver''s 
	subclasses in breadth-first order, with the immediate subclasses first."

	^(self allSubclasses)
		addFirst: self;
		yourself!

withAllSubclassesDo: aMonadicValuable
	"Evaluate the monadic valuable argument for the receiver and each 
	of its subclasses using a depth-first traversal."

	aMonadicValuable value: self.
	self allSubclassesDo: aMonadicValuable!

withAllSuperclasses
	"Answer an <OrderedCollection> containing the receiver, and all of the receiver''s 
	superclasses in breadth-first order."

	^(self allSuperclasses)
		addFirst: self;
		yourself!

withAllSuperclassesDo: aMonadicValuable
	"Evaluate the monadic valuable argument for the receiver and each 
	of its superclasses in reverse order of hierarchy."

	aMonadicValuable value: self.
	self allSuperclassesDo: aMonadicValuable! !
!Behavior categoriesForMethods!
addSelector:withMethod:!methods-accessing!private! !
addSubclass:!class hierarchy-adding!private! !
addToSuper!class hierarchy-adding!private! !
allInstances!instances!public! !
allInstVarNames!instance variables!public! !
allMethodsDo:!enumerating!public! !
allSelectors!methods-accessing!public! !
allSubclasses!class hierarchy-accessing!public! !
allSubclassesBreadthFirstDo:!class hierarchy-accessing!enumerating!public! !
allSubclassesDo:!class hierarchy-accessing!enumerating!public! !
allSubclassesEndOrderDo:!class hierarchy-accessing!private! !
allSubclassesPreOrderDo:!class hierarchy-accessing!private! !
allSubinstances!instances!public! !
allSuperclasses!class hierarchy-accessing!public! !
allSuperclassesDo:!class hierarchy-accessing!enumerating!private! !
basicCompile:!compiling!private! !
basicCompile:flags:!compiling!private! !
basicNew!instance creation!private! !
basicNew:!instance creation!private! !
basicNewFixed:!instance creation!private! !
bindingFor:!binding!public! !
canUnderstand:!methods-testing!public! !
compile:!compiling!public! !
compileAll!compiling!development!public! !
compileAllSubclasses!compiling!development!public! !
compiledMethodAt:!methods-accessing!public! !
compiledMethodAt:ifAbsent:!methods-accessing!public! !
compilerClass!constants!public! !
decompile:!compiling!development!public! !
defaultCompilationFlags!compiling!constants!public! !
definitionOf:!methods-testing!public! !
dynamicSelectors!methods-accessing!public! !
dynamicSelectorsDo:!methods-accessing!public! !
environment!constants!public! !
errorNonInstantiable!error handling!private! !
errorNotPinnable!error handling!private! !
extraInstanceSpec!instance specification-accessing!private! !
extraInstanceSpec:!instance specification-accessing!private! !
flushMethodCache!methods-removing!private! !
fullBindingFor:!binding!public! !
hasCompilationFailures!public!testing! !
hasImmediateInstances!public!testing! !
hasMethods!methods-testing!public! !
includesBehavior:!class hierarchy-testing!public! !
includesSelector:!methods-testing!public! !
inheritsFrom:!class hierarchy-testing!public! !
instanceCount!accessing!public! !
instanceSpec!instance specification-accessing!private! !
instanceSpec:!instance specification-accessing!private! !
instSize!instance specification-accessing!public! !
instVarNames!instance variables!public! !
isBits!instance specification-testing!public! !
isBytes!instance specification-testing!public! !
isFixed!instance specification-testing!public! !
isIndirection!instance specification-testing!public! !
isIndirection:!instance specification-accessing!public! !
isMeta!public!testing! !
isMetaclass!public!testing! !
isMourner!instance specification-testing!public! !
isNonInstantiable!instance specification-testing!private! !
isNonInstantiable:!instance specification-accessing!private! !
isNullTerminated!instance specification-testing!public! !
isNullTerminated:!instance specification-accessing!public! !
isPointers!instance specification-testing!public! !
isVariable!instance specification-testing!public! !
isWords!instance specification-testing!public! !
kindOfSubclass!class hierarchy-testing!private! !
lookupMethod:!methods-accessing!public! !
makeMourner!instance specification-accessing!private! !
methodDictionary!methods-accessing!private! !
methodDictionary:!methods-accessing!private! !
new!instance creation!public! !
new:!instance creation!public! !
new:max:!instance creation!private! !
newFixed:!instance creation!public! !
primAllInstances!instances!private! !
primAllSubinstances!instances!private! !
recompile:!compiling!development!public! !
recompileAll!compiling!development!public! !
recompileReferencesToLiteral:!development!private! !
referenceFilterFor:!development!methods-testing!private! !
removeFromSuper!class hierarchy-removing!private! !
removeFromSystem!class hierarchy-removing!private! !
removeSelector:!methods-removing!public! !
removeSelector:ifAbsent:!methods-removing!public! !
removeSelectors:!methods-removing!public! !
removeSubclass:!class hierarchy-removing!private! !
requiresInstallation!public!testing! !
scopeHas:ifTrue:!class hierarchy-testing!public! !
selectMethods:!methods-testing!private! !
selectors!methods-accessing!public! !
selectorsDo:!enumerating!public! !
setInstSize:!instance specification-accessing!private! !
setShapeFlags:to:!instance specification-accessing!private! !
setSpecialBehavior:to:!instance specification-accessing!private! !
setSuperclass:!class hierarchy-mutating!private! !
shallowCopy!copying!public! !
sourceCodeAt:!development!methods-accessing!public! !
subclasses!class hierarchy-accessing!public! !
subclasses:!class hierarchy-mutating!public! !
subclassInstVarNames!instance variables!public! !
superclass!class hierarchy-accessing!public! !
superclass:!class hierarchy-mutating!public! !
understoodSelectors!methods-accessing!public! !
understoodSelectorsDo:!methods-accessing!public! !
whichClassIncludesSelector:!methods-testing!public! !
whichClassSatisfies:!helpers!private! !
whichMethodsAccess:!development!methods-testing!public! !
whichMethodsAccess:at:!development!methods-testing!private! !
whichMethodsAssign:!development!methods-testing!public! !
whichMethodsAssign:at:!development!methods-testing!private! !
whichMethodsRead:!development!methods-testing!public! !
whichMethodsRead:at:!development!methods-testing!private! !
whichSelectorsAccess:!development!methods-testing!public! !
whichSelectorsAssign:!development!methods-testing!public! !
whichSelectorsRead:!development!methods-testing!public! !
whichSelectorsWrite:!development!methods-testing!public! !
withAllSubclasses!class hierarchy-accessing!public! !
withAllSubclassesDo:!enumerating!public! !
withAllSuperclasses!class hierarchy-accessing!public! !
withAllSuperclassesDo:!enumerating!public! !
!

Behavior methodProtocol: #instantiator attributes: #(#ansi #readOnly) selectors: #(#new)!

!Behavior class methodsFor!

initialize
	self addClassConstant: '_NullMethodDictionary'
		value: ((MethodDictionary new)
				isImmutable: true;
				yourself)! !
!Behavior class categoriesForMethods!
initialize!development!initializing!public! !
!

