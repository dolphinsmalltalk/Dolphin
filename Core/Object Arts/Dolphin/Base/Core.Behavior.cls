"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Behavior'
	instanceVariableNames: 'superclass methodDictionary instanceSpec'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_BasicSpecMask' -> 16r7FFF.
			'_BytesSubMask' -> 16r4800.
			'_FundamentalShapeMask' -> 16r30FF.
			'_GetSpecialMask' -> 16rFF00.
			'_IndirectMask' -> 16r800.
			'_IsFinalizableMask' -> 16r8.
			'_IsPointersMask' -> 16r2.
			'_IsWeakMask' -> 16r12.
			'_MournerMask' -> 16r400.
			'_NonInstantiableMask' -> 16r200.
			'_NullMethodDictionary' -> MethodDictionary new.
			'_NullTermMask' -> 16r4000.
			'_PointersMask' -> 16r2000.
			'_ShapeMask' -> 16r70FF.
			'_SizeMask' -> 16rFF.
			'_VariableMask' -> 16r1000
		}!
Core.Behavior guid: (Core.GUID fromString: '{87b4c459-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Behavior comment: 'Class `Behavior` is the abstract class which defines the minimum state necessary for objects that have instances, providing the basic information about those instances to the Compiler and the VM.

Instance Variables:

  `superclass`		`Behavior` object of the instance''''s superclass
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
!Core.Behavior categoriesForClass!Kernel-Classes! !
!Core.Behavior methodsFor!

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

addToSuper
	"Private - Add the receiver to its superclasses' subclass collection."

	"Nothing to do at this level"!

allInstanceVariableNames
	"Answer an <Array> of the <readableString> names of the receiver's instance variables, 
	those specified in the receiver and in all of its superclasses. The array ordering is the order 
	in which the variables are stored and accessed by the interpreter."

	^self instSize == 0
		ifTrue: [#()]
		ifFalse: 
			[superclass isNil
				ifTrue: [self instanceVariableNames]
				ifFalse: [superclass allInstanceVariableNames , self instanceVariableNames]]!

allSuperclasses
	"Answer a <collection> of the receiver's superclass and the receiver's ancestor's 
	superclasses. The first element is the receiver's immediate superclass, followed by its
	superclass, and so on; the last element is always Object.

	Note that we actually return a <sequencedReadableCollection> but that sequenceability
	cannot be relied upon in portable code because the ANSI standard specifies
	only <collection>."

	| supers |
	supers := WriteStream on: (Array new: 4).
	self allSuperclassesDo: [:each | supers nextPut: each].
	^supers contents!

allSuperclassesDo: aMonadicValuable
	"Private - Evaluate the monadic valuable argument for each of the receiver's 
	superclasses."

	| class current |
	class := self.
	
	[current := class superclass.
	class := current.
	current isNil] 
			whileFalse: [aMonadicValuable value: current]!

annotatedMethodRemoved: aCompiledMethod
	"Annotations are being removed as a consequence of the removal of an annotated method. This is an opportunity to update any metadata that might be based on method annotations."

	"By default, do nothing"

	!

annotationsUpdated: aCompilationResult 
	"Annotations may have been added or removed in the receiver's methods. This is an opportunity to update any metadata that might be based on method annotations."
	
	"By default, do nothing"!

basicCompile: aString
	^self basicCompile: aString environment: nil!

basicCompile: aString environment: aNamespace
	^self
		basicCompile: aString
		flags: self defaultCompilationFlags
		environment: aNamespace!

basicCompile: aString flags: anInteger environment: aNamespace
	| error result stubMethod |
	result := error := stubMethod := nil.
	
	[result := self compilerClass
				compile: aString
				in: self
				environment: aNamespace
				flags: anInteger]
			on: self compilerClass errorClass
			do: 
				[:n |
				error := n.
				stubMethod := (MethodCompileFailed error: n environment: aNamespace) signal: n description.
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
				beImmutableObject].
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

	^self hierarchyBindingFor: aString!

canUnderstand: aSymbol
	"Answer whether the receiver can respond to the message whose selector is the argument, aSymbol.
	The selector can be in the method dictionary of the receiver's class or any of its superclasses."

	^(self lookupMethod: aSymbol) notNil!

compile: aString
	"Compile the source code in the <String> argument in the context of the receiver.
	If the method is successfully compiled, then 
		- enter the result into the receiver's method dictionary
		- trigger a #methodAdded: event, and 
		- answer the new <CompiledMethod> or nil.
	If a compilation error occurs:
		- a CompilerNotification is signalled
		- answer nil"

	^self compile: aString environment: nil!

compile: aString environment: aNamespace
	"Compile the source code in the <String> argument in the context of the receiver, but overriding the receiver's own <Namespace> with the specified one for binding static variables that are not defined in the receiver's own hierarchy, or imported into it.
	If the method is successfully compiled, then 
		- enter the result into the receiver's method dictionary
		- trigger a #method[Added|Updated]: event, and 
		- answer the new <CompiledMethod> or nil.
	If a compilation error occurs:
		- a CompilerNotification is signalled
		- answer nil"

	^(self basicCompile: aString environment: aNamespace)
		ifNotNil: 
			[:result |
			result fireSystemUpdateEvent.
			result method]!

compileAll
	"Compile all the methods for which the receiver has selectors. We install stub methods for all
	compilation failures"

	[self selectors do: [:each | self recompile: each]] on: MethodCompileFailed
		do: 
			[:ex |
			"If we get a method compilation error then we install 
			a stub method so we'll be able to see the source."
			ex
				beep;
				resumeWithStubMethod]!

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

elementSize
	^self isPointers ifTrue: [VMConstants.IntPtrSize] ifFalse: [self extraInstanceSpec]!

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

hasImmediateInstances
	"Answer whether the receiver's instances are immutable objects encoded entirely 
	in an Oop (e.g. SmallIntegers).
	Implementation Note: Included for compatibility with VisualWorks."

	^false!

hasMethods
	"Answer whether the receiver has any methods in its local method dictionary."

	^methodDictionary notNil and: [methodDictionary size > 0]!

hasSpecialBehavior
	^instanceSpec anyMask: ##(_IndirectMask | _NullTermMask | _NonInstantiableMask | _MournerMask)!

hierarchyBindingFor: aString 
	"Answer a variable binding for the named variable in the scope of this class. If there is no such variable, then answer nil."

	^superclass ifNotNil: [superclass hierarchyBindingFor: aString]!

includesBehavior: aBehavior
	"Answer whether the receiver includes the behavior, aBehavior (i.e. is aBehavior the receiver or a superclass of the receiver)."

	| current |
	current := self.
	
	[current == aBehavior ifTrue: [^true].
	current isNil] whileFalse: [current := current superclass].
	^false!

includesSelector: aSymbol
	"Answer whether the local method dictionary contains a method whose
	selector is the argument, aSymbol."

	^methodDictionary notNil and: [methodDictionary includesKey: aSymbol]!

inheritsFrom: aBehavior
	"Answer whether the receiver is a subclass of the argument. This is the same as #includesBehavior:, but starts from the superclass of the receiver."

	"An iterative solution is not as elegant as recursion, but has a small performance advantage."

	| current |
	current := superclass.
	
	[aBehavior == current ifTrue: [^true].
	current isNil] whileFalse: [current := current superclass].
	^false!

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

instanceVariableNames
	"Answer a <sequencedReadableCollection> of the receiver's instance variable 
	names."

	^#()!

instSize
	"Answer the number of fixed fields (named instance variables) in instances of the receiver."

	^instanceSpec bitAnd: _SizeMask!

isBehavior
	"Answer whether the receiver is a <Behavior>."

	^true!

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

	^instanceSpec anyMask: _IndirectMask!

isIndirection: aBoolean
	"Set/reset the receiver's status as an indirect reference (i.e. an
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

	^instanceSpec anyMask: _MournerMask!

isMourner: aBoolean
	"Set the receiver's status as an mourner. This only affects the
	weak instances of such classes, which will receive a #elementsExpired:
	message from the Undertaker process soon after they have suffered the loss
	of an object they are weakly referencing. This gives the mourner the opportunity
	to put its house in order. By default this behaviour is disabled, as its use
	can extend the life of an object (a weak object which would otherwise be
	garbage collected has to be rescued in order that it can perform its
	mourning process, as the mourning process may be important for releasing
	external resources, etc."

	self setShapeFlags: _MournerMask to: aBoolean!

isNonInstantiable
	"Answer whether the receiver should not be instantiated, e.g. it is abstract."

	^instanceSpec anyMask: _NonInstantiableMask!

isNonInstantiable: aBoolean
	"Set whether the receiver should not be instantiated, e.g. it is abstract."

	self setShapeFlags: _NonInstantiableMask to: aBoolean!

isNullTerminated
	"Answer true if the instances of the receiver are Null Terminated (that is they include 
	an extra byte with the value zero at their end, which is not included in the reported size). 
	Only meaningful for variable byte classes (e.g. String)."

	^instanceSpec allMask: _NullTermMask!

isNullTerminated: aBoolean
	"Set the receiver's status as a class of Null Terminated objects
	(i.e. its instances have an additional byte, not included in the reported size, 
	which is always zero). Only meaningful for variable byte classes"

	self setSpecialBehavior: _NullTermMask to: aBoolean!

isPointers
	"Answer whether the variables of instances of the receiver contain object pointers (as
	opposed to uninterpreted bytes)."

	^instanceSpec anyMask: _PointersMask!

isVariable
	"Answer whether instances of the receiver can have indexed instance variables."

	^instanceSpec anyMask: _VariableMask!

isWords
	"Answer whether the variables of instances of the receiver are stored as words."

	"OBSOLETE"

	^false!

kindOfSubclass
	"Private - Answer a string describing the kind of subclassing method used to create the receiver 
	(part of its definition)."

	^self isVariable
		ifTrue: [self isPointers ifTrue: ['variableSubclass:'] ifFalse: ['variableByteSubclass:']]
		ifFalse: ['subclass:']!

lookupMethod: aSymbol
	"Answer the method of the receiver, or inherited by the receiver, corresponding
	to the selector, aSymbol."

	<primitive: 148>
	^self primitiveFailed: _failureCode!

methodDictionary
	"Private - Answer the receiver's <MethodDictionary>."

	^methodDictionary ?? _NullMethodDictionary!

methodDictionary: aMethodDictionary
	"Private - Store the <MethodDictionary> argument as the method dictionary of the receiver.
	Incorrect use of this method (e.g. with an argument which is not a <MethodDictionary>)
	can cause unexpected behavior of the VM)."

	methodDictionary := (aMethodDictionary isNil or: [aMethodDictionary isEmpty])
				ifFalse: [aMethodDictionary]!

methodRemoved: aCompiledMethod 
	"React to the removal of the specified method from this class. This is before the system update event with selector #methodRemoved: is triggered."

	aCompiledMethod isAnnotated ifTrue: [self annotatedMethodRemoved: aCompiledMethod]
	"Do nothing at this level - this is an override point for classes"!

methodsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each method defined directly in the receiver."

	methodDictionary ifNotNil: [methodDictionary do: aMonadicValuable]!

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
	Report an error if the receiver is not indexable (and the argument ~= 0), or the argument is invalid.

	This is the fundamental method by which new instances of indexable classes are are created.
	It is inherited by class objects (Metaclass instance instances) through the route:
		MyClass class -> MyClass class superclass -> ... 
			-> Object class -> Class -> ClassDescription -> Behavior"

	"Primitive failure reasons:
		InvalidParameter1		- the argument is not a positive <SmallInteger>.
		NonInstantiable		- the receiver is non-instantiable (abstract).
		ObjectTypeMismatch	- the receiver's instances are not indexable and arg ~= 0."

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

notifyMethodRemoved: aCompiledMethod
	self methodRemoved: aCompiledMethod.
	Smalltalk trigger: #methodRemoved: with: aCompiledMethod!

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

recompile: aSymbol
	"Compile the method associated with the message selector, aSymbol, answering the CompilationResult method. If there is no method with the specified selector in the receiver's method dictionary, then answer nil.
	The method is not logged to the change log, rather the source is re-used from the original"

	^(self compiledMethodAt: aSymbol ifAbsent: nil)
		ifNotNil: [:method | self recompileMethod: method environment: method customEnvironment]!

recompileMethod: aCompiledMethod environment: aNamespace
	^self
		recompileMethod: aCompiledMethod
		environment: aNamespace
		flags: self defaultCompilationFlags!

recompileMethod: aCompiledMethod environment: aNamespace flags: anInteger
	| result stubMethodResult |
	stubMethodResult := nil.
	result := 
			[self compilerClass
				compile: aCompiledMethod getSource
				in: self
				environment: aNamespace
				flags: anInteger]
					on: self compilerClass errorClass
					do: 
						[:ex |
						stubMethodResult := (MethodCompileFailed error: ex environment: aNamespace) signal: ex description.
						ex pass].

	"Was a stub method installed? If so the CompilationResult for it is used."
	result := stubMethodResult ?? result.
	"If the compilation succeeded, or a stub method was installed, then the result will hold a non-nil method to be installed into the class."
	result method
		ifNotNil: 
			[:method |
			| selector |
			"Add the selector and copy across the old source descriptor and privacy, as we haven't don't want to change either"
			selector := aCompiledMethod selector.
			method selector: selector.
			self addSelector: selector withMethod: method.
			"We don't issue a methodUpdated: event at this level, but return the CompilationResult so that the caller may do so if appropriate."
			method
				sourceDescriptor: aCompiledMethod sourceDescriptor;
				isPrivate: aCompiledMethod isPrivate;
				beImmutableObject;
				yourself].
	^result!

recompileReferencesToLiteral: aVariableBinding
	"Private - Recompile any of the receiver's methods that reference the specified object from their literal frame."

	methodDictionary ifNil: [^self].
	methodDictionary do: 
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
			index := VM indexOfSpecialSelector: anObject ifAbsent: nil.
			index notNil
				ifTrue: 
					[| dispatcher |
					dispatcher := ByteCodeDispatcher new.
					^
					[:eachMethod |
					(eachMethod refersToLiteral: anObject) or: 
							[dispatcher method: eachMethod.
							dispatcher sendsSpecialSelector: index]]]].
	^[:eachMethod | eachMethod refersToLiteral: anObject]!

removeFromSuper
	"Private - Remove the receiver from its superclasses' subclass collection and answer the old superclass.
	Root classes will have a superclass of nil - we do not put such classes into any subclass collection."

	"Nothing to do at this level"!

removeFromSystem
	"Private - Remove the receiver from the system (completely remove a class)."

	ClassBuilder removeClass: self!

removeSelector: selector
	"Remove the argument, selector (which is a Symbol representing a message selector), 
	from the receiver's message dictionary."

	^self removeSelector: selector ifAbsent: [self errorNotFound: selector]!

removeSelector: aSymbol ifAbsent: aNiladicValuable
	"Remove the method with the selector specified by the argument, aSymbol, 
	from the receiver's message dictionary. Answer the <CompiledMethod> that
	as removed, or, if the selector is not in the method dictionary, the result of evaluating 
	the niladic valuable argument.
	Implementation Note: Flush the VM method cache in case the method is cached. 
	The #methodRemoved: event is triggered to inform interested parties."

	| method |
	(methodDictionary isNil or: [(method := methodDictionary removeKey: aSymbol ifAbsent: nil) isNil])
		ifTrue: [^aNiladicValuable value].
	methodDictionary isEmpty ifTrue: [methodDictionary := nil].
	self flushMethodCache.
	self notifyMethodRemoved: method.
	^method!

removeSelectors: aCollection
	"Remove each of the <Symbol> selectors in the <collection> argument from the 
	receiver's message dictionary. If any of the selectors are not present, they are 
	simply ignored. Answer a <collection> of the <CompiledMethod>s which were actually
	removed."

	| methods |
	methodDictionary ifNil: [^#()].
	methods := methodDictionary removeSelectors: aCollection.
	methodDictionary isEmpty ifTrue: [methodDictionary := nil].
	self flushMethodCache.
	methods do: [:each | self notifyMethodRemoved: each].
	^methods!

requiresInstallation
	"Answer whether the receiver requires 'installing' into its environment."

	^false!

selectMethods: aMonadicValuable
	"Private - Answer a <Set> of the <CompiledMethod>s of the receiver 
	for which the monadic valuable, discriminator, evaluates to true."

	| answer |
	methodDictionary ifNil: [^##(IdentitySet new)].
	answer := IdentitySet new.
	methodDictionary do: [:each | (aMonadicValuable value: each) ifTrue: [answer add: each]].
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
	"Private - Set/Reset the receiver's shape/structure flags (as defined by anIntegerMask)
	according to the argument aBoolean."

	instanceSpec := instanceSpec mask: anIntegerMask set: aBoolean!

setSpecialBehavior: anIntegerMask to: aBoolean
	"Private - Set/Reset the receiver's special behavior (as defined by anIntegerMask)
	according to the argument aBoolean. Only meaningful for variable byte classes"

	self isPointers 
		ifFalse: [self setShapeFlags: anIntegerMask to: aBoolean]
		ifTrue: [self error: 'Must be byte class']!

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

superclass
	"Answer a <classDescription> which is the receiver's immediate 
	superclass (or <nil> if none)."

	^superclass!

superclass: aClass
	"Set the superclass of the receiver to be the argument, aClass"

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
		at: (self allInstanceVariableNames indexOf: aString)!

whichMethodsAccess: aString at: anInteger
	"Private - Answer a <Set> of selectors from the receiver's local method dictionary whose 
	methods access the instance variable with the specified index."

	^self 
		selectMethods: [:method | method accessesInstVar: aString at: anInteger]!

whichMethodsAssign: aString
	"Answer a <collection> of <CompiledMethod>s that write to the instance variable
	named by the <readableString> argument."

	^self whichMethodsAssign: aString
		at: (self allInstanceVariableNames indexOf: aString)!

whichMethodsAssign: aString at: anInteger
	^self 
		selectMethods: [:method | method writesInstVar: aString at: anInteger]!

whichMethodsRead: aString
	"Answer a <collection> of <CompiledMethod>s that read the instance variable
	named by the <readableString> argument."

	^self whichMethodsRead: aString at: (self allInstanceVariableNames indexOf: aString)!

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
	index := self allInstanceVariableNames indexOf: aString.
	^(self selectMethods: [:each | each writesInstVar: aString at: index]) 
		collect: [:each | each selector]!

withAllSuperclasses
	"Answer an <sequencedReadableCollection> starting with the receiver, and then all of the receiver''s superclasses in sequence up to a root class."

	| classes |
	classes := WriteStream on: (Array new: 4).
	classes nextPut: self.
	self allSuperclassesDo: [:each | classes nextPut: each].
	^classes contents!

withAllSuperclassesDo: aMonadicValuable
	"Evaluate the monadic valuable argument for the receiver and each 
	of its superclasses in reverse order of hierarchy."

	aMonadicValuable value: self.
	self allSuperclassesDo: aMonadicValuable! !
!Core.Behavior categoriesForMethods!
addSelector:withMethod:!methods-accessing!private! !
addToSuper!class hierarchy-adding!private! !
allInstanceVariableNames!instance variables!public! !
allSuperclasses!class hierarchy-accessing!public! !
allSuperclassesDo:!class hierarchy-accessing!enumerating!private! !
annotatedMethodRemoved:!event handling!public! !
annotationsUpdated:!event handling!public! !
basicCompile:!compiling!private! !
basicCompile:environment:!compiling!private! !
basicCompile:flags:environment:!compiling!private! !
basicNew!instance creation!private! !
basicNew:!instance creation!private! !
basicNewFixed:!instance creation!private! !
bindingFor:!bindings!public! !
canUnderstand:!methods-testing!public! !
compile:!compiling!public! !
compile:environment:!compiling!public! !
compileAll!compiling!development!public! !
compiledMethodAt:!methods-accessing!public! !
compiledMethodAt:ifAbsent:!methods-accessing!public! !
compilerClass!constants!public! !
decompile:!compiling!development!public! !
defaultCompilationFlags!compiling!constants!public! !
definitionOf:!methods-testing!public! !
dynamicSelectors!methods-accessing!public! !
dynamicSelectorsDo:!methods-accessing!public! !
elementSize!instance specification-accessing!public! !
environment!accessing!public! !
errorNonInstantiable!error handling!private! !
errorNotPinnable!error handling!private! !
extraInstanceSpec!instance specification-accessing!private! !
extraInstanceSpec:!instance specification-accessing!private! !
flushMethodCache!methods-removing!private! !
hasImmediateInstances!public!testing! !
hasMethods!methods-testing!public! !
hasSpecialBehavior!instance specification-testing!public! !
hierarchyBindingFor:!bindings!public! !
includesBehavior:!class hierarchy-testing!public! !
includesSelector:!methods-testing!public! !
inheritsFrom:!class hierarchy-testing!public! !
instanceCount!accessing!public! !
instanceSpec!instance specification-accessing!private! !
instanceSpec:!instance specification-accessing!private! !
instanceVariableNames!instance variables!public! !
instSize!instance specification-accessing!public! !
isBehavior!public!testing! !
isBits!instance specification-testing!public! !
isBytes!instance specification-testing!public! !
isFixed!instance specification-testing!public! !
isIndirection!instance specification-testing!public! !
isIndirection:!instance specification-accessing!public! !
isMeta!public!testing! !
isMetaclass!public!testing! !
isMourner!instance specification-testing!public! !
isMourner:!instance specification-accessing!public! !
isNonInstantiable!instance specification-testing!public! !
isNonInstantiable:!instance specification-accessing!public! !
isNullTerminated!instance specification-testing!public! !
isNullTerminated:!instance specification-accessing!public! !
isPointers!instance specification-testing!public! !
isVariable!instance specification-testing!public! !
isWords!instance specification-testing!public! !
kindOfSubclass!class hierarchy-testing!private! !
lookupMethod:!methods-accessing!public! !
methodDictionary!methods-accessing!private! !
methodDictionary:!methods-accessing!private! !
methodRemoved:!public! !
methodsDo:!enumerating!public! !
new!instance creation!public! !
new:!instance creation!public! !
new:max:!instance creation!private! !
newFixed:!instance creation!public! !
notifyMethodRemoved:!methods-removing!private! !
primAllInstances!instances!private! !
primAllSubinstances!instances!private! !
recompile:!compiling!development!public! !
recompileMethod:environment:!compiling!development!private! !
recompileMethod:environment:flags:!compiling!development!private! !
recompileReferencesToLiteral:!development!private! !
referenceFilterFor:!development!methods-testing!private! !
removeFromSuper!operations!private! !
removeFromSystem!class hierarchy-removing!private! !
removeSelector:!methods-removing!public! !
removeSelector:ifAbsent:!methods-removing!public! !
removeSelectors:!methods-removing!public! !
requiresInstallation!public!testing! !
selectMethods:!methods-testing!private! !
selectors!methods-accessing!public! !
selectorsDo:!enumerating!public! !
setInstSize:!instance specification-accessing!private! !
setShapeFlags:to:!instance specification-accessing!private! !
setSpecialBehavior:to:!instance specification-accessing!private! !
setSuperclass:!class hierarchy-mutating!private! !
shallowCopy!copying!public! !
sourceCodeAt:!development!methods-accessing!public! !
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
withAllSuperclasses!class hierarchy-accessing!public! !
withAllSuperclassesDo:!enumerating!public! !
!

Core.Behavior methodProtocol: #instantiator attributes: #(#ansi #readOnly) selectors: #(#new)!

!Core.Behavior class methodsFor!

initialize
	self addClassConstant: '_NullMethodDictionary' value: MethodDictionary new! !
!Core.Behavior class categoriesForMethods!
initialize!development!initializing!public! !
!

