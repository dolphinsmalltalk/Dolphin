"Filed out from Dolphin Smalltalk 7"!

Kernel.Namespace subclass: #'Kernel.SharedPool'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.SharedPool guid: (Core.GUID fromString: '{bcc094b0-f447-4e0c-a96b-884f8324757d}')!
Kernel.SharedPool isNonInstantiable: true!
Kernel.SharedPool comment: 'Abstract base for the special `Namespace`s that contain only shared pool constants. These classes replace `PoolConstantsDictionary` instances.

Shared pool variables that are not constant are no longer explicitly supported. Public class variables are recommended for this purpose, although mutable variables can be added to SharedPools from the class initialize method (for example).

In most cases, the shared pool constants will have a literal form (or at least a self-evaluating form), so they can be represented directly in the pool class definition. Where this is not the case, the constants must be added and initialized from the class initialize method. If this is not done, the values will not be preserved by file-out/file-in.'!
!Kernel.SharedPool categoriesForClass!Kernel-Objects! !
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
			(initial == $_ or: [initial isLetter])
				and: [aString allSatisfy: [:each | each == $_ or: [each isAlphaNumeric]]]]!

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
!Kernel.SharedPool class categoriesFor: #at:ifAbsentPut:!accessing!development!public! !
!Kernel.SharedPool class categoriesFor: #at:put:!adding!development!public! !
!Kernel.SharedPool class categoriesFor: #baseEnvironment!constants!private! !
!Kernel.SharedPool class categoriesFor: #classesReferencing!development!private! !
!Kernel.SharedPool class categoriesFor: #isValidKey:!adding!private! !
!Kernel.SharedPool class categoriesFor: #keyString:!adding!private! !
!Kernel.SharedPool class categoriesFor: #subclass:!class hierarchy-adding!public! !
!Kernel.SharedPool class categoriesFor: #variableAdded:!class hierarchy-mutating!class variables!private! !

