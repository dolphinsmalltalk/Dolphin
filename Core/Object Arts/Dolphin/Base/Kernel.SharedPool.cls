"Filed out from Dolphin Smalltalk"!

Kernel.Namespace subclass: #'Kernel.SharedPool'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.SharedPool guid: (Core.GUID fromString: '{bcc094b0-f447-4e0c-a96b-884f8324757d}')!
Kernel.SharedPool isNonInstantiable: true!
Kernel.SharedPool comment: '`SharedPool` is the abstract base class of the special `Namespace`s that contain only shared pool constants. These classes replace `PoolConstantsDictionary` instances.

Shared pool variables that are _not_ constant are no longer explicitly supported. Public class or namespace variables are recommended for this purpose, although mutable variables can be added to SharedPools from the class `initialize` method (for example).

In most cases, the shared pool constants will have a literal form (or at least a self-evaluating form), so they can be represented directly in the pool class definition and will therefore be re-initialized to the correct value when the pool class is loaded. Where this is not the case, the constants must be added and initialized from the class `initialize` method. If this is not done, the values will not be preserved by file-out/file-in.

Aside from class initialization (when required, as mentioned above), `SharedPool` subclasses do not normally define any behavior. Like all other `Namespace` classes, `SharedPool`s are not instantiable.'!
!Kernel.SharedPool categoriesForClass!System-Namespaces! !
!Kernel.SharedPool class methodsFor!

at: aString ifAbsentPut: operation
	"Answer the value of the receiver's named binding. If aString does not name one of the receiver's bindings, then a new constant binding of that name with the value that is the result of evaluating the <niladicValuable>, operation, and answer the value."

	| keyString |
	keyString := self keyString: aString.
	^classPool at: keyString
		ifAbsent: [(self addClassConstant: keyString value: operation value) value]!

at: aString put: anObject
	"Add or update a constant binding in the receiver with the specified name and value."

	self addClassConstant: (self keyString: aString) value: anObject.
	^anObject!

baseEnvironment
	"Private - Answer the default environment for new subclasses of the receiver that the ClassBuilder should use when the provided subclass name is unqualified."

	^Smalltalk!

classesReferencing
	| ref |
	ref := self instanceClass asQualifiedReference.
	^Smalltalk allClasses select: [:c | c allImports includes: ref]!

isValidKey: aString
	^aString notEmpty and: 
			[| initial |
			initial := aString first.
			(initial == $_ or: [initial isEnglishLetter]) and: 
					[aString
						allSatisfy: [:each | '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz' includes: each]]]!

keyString: anObject
	| answer |
	answer := anObject asString.
	(self isValidKey: answer) ifFalse: [^self error: ('Invalid key: <1p>' expandMacrosWith: answer)].
	^answer!

subclass: aSymbol
	^self
		subclass: aSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		imports: #()!

variableAdded: aVariableBinding
	aVariableBinding isImmutable: true.
	super variableAdded: aVariableBinding! !
!Kernel.SharedPool class categoriesForMethods!
at:ifAbsentPut:!accessing!development!public! !
at:put:!adding!development!public! !
baseEnvironment!constants!private! !
classesReferencing!development!private! !
isValidKey:!adding!private! !
keyString:!adding!private! !
subclass:!class hierarchy-adding!public! !
variableAdded:!class hierarchy-mutating!class variables!private! !
!

