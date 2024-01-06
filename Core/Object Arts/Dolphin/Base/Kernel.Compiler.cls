"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.Compiler'
	instanceVariableNames: ''
	classVariableNames: 'CompilerImplementation DefaultFlags DisabledWarnings'
	imports: #(#{Kernel.CompilerFlags} #{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Compiler guid: (Core.GUID fromString: '{87b4c470-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.Compiler comment: 'The Compiler class is responsible for compiling new methods and evaluating expressions.'!
!Kernel.Compiler categoriesForClass!System-Compiler! !
!Kernel.Compiler class methodsFor!

compile: aString in: aClass
	"Compiler the method source, aString, in the context of the class, aClass. <CompilerNotification> subinstances may be thrown for errors/warnings.
	Answers a <CompiledMethod> if successful, or nil if any compilation errors were detected."

	^self
		compile: aString
		in: aClass
		environment: nil!

compile: aString in: aClass environment: aNamespace
	"Compiler the method source, aString, in the context of the class, aClass, and namespace, aNamespaceOrNil. If aNamespace is not nil, then it is used instead of the class' own environment to look up static variables that are not found within the class' own variables or imports, or of any of its superclasses. <CompilerNotification> subinstances may be thrown for errors/warnings.
	Answers a <CompiledMethod> if successful, or nil if any compilation errors were detected."

	^(self
		compileForMethod: aString
		in: aClass
		environment: aNamespace
		flags: aClass defaultCompilationFlags) method!

compile: aString in: aClass environment: aNamespaceOrNil flags: anInteger
	"Compiler the method source, aString, in the context of the class, aClass, and namespace, aNamespaceOrNil, parameterized by the flags, anInteger. If aNamespace is not nil, then it is used instead of the class' own environment to look up static variables that are not found within the class' own variables or imports, or of any of its superclasses. See the class comment for a description of the flags.  <CompilerNotification> subinstances may be thrown for errors/warnings.
	Answers a <CompiledMethod> if successful, or nil if any compilation errors were detected."

	^(self
		compileForMethod: aString
		in: aClass
		environment: aNamespaceOrNil
		flags: anInteger) method!

compileDebugExpression: aString in: aClass environment: aNamespaceOrNil evaluationPools: anArray
	^self
		compileExpression: aString
		in: aClass
		environment: aNamespaceOrNil
		evaluationPools: anArray
		flags: DebugMethod!

compileDebugMethod: aString in: aClass environment: aNamespace
	^(self
		compileForMethod: aString
		in: aClass
		environment: aNamespace
		flags: (aClass defaultCompilationFlags bitOr: DebugMethod)) method!

compileExpression: aString in: aBehaviorOrNil
	"Compile the expression source, aString, in the context of the class, aBehavior. <CompilerNotification> subinstances may be thrown for errors/warnings.
	Answers a <CompiledExpression> if successful, or nil if any compilation errors were detected."

	^self
		compileExpression: aString
		in: aBehaviorOrNil
		environment: nil!

compileExpression: aString in: aBehaviorOrNil environment: aNamespaceOrNil
	"Compile the expression source, aString, in the context of the class, aBehavior, and namespace, aNamespaceOrNil. If aNamespaceOrNil is not nil, then it is used instead of the class' own environment to look up static variables that are not found within the class' own variables or imports, or of any of its superclasses. <CompilerNotification> subinstances may be thrown for errors/warnings. 
	Answers a <CompiledExpression> if successful, or nil if any compilation errors were detected."

	^self
		compileExpression: aString
		in: aBehaviorOrNil
		environment: aNamespaceOrNil
		flags: (aBehaviorOrNil ifNil: [self defaultFlags] ifNotNil: [aBehaviorOrNil defaultCompilationFlags])!

compileExpression: aString in: aBehaviorOrNil environment: aNamespaceOrNil evaluationPools: anArray flags: anInteger
	"Compile the expression source, aString, in the context of the class, aBehavior, and namespace, aNamespaceOrNil, parameterized by the flags, anInteger, notifying, notifier, of any errors or warnings which are detected. 
	If aNamespaceOrNil is not nil, then it is used instead of the class' own environment to look up static variables that are not found within the class' own variables or imports, or of any of its superclasses.
	Additional shared variables are looked up in the <Array> of <PoolDictionary>, anArray. See the class comment for a description of the flags. <CompilerNotification> subinstances may be thrown for errors/warnings. 
	Answers a <CompiledExpression> if successful, or nil if any compilation errors were detected."

	^(self
		compileForEvaluation: aString
		in: aBehaviorOrNil
		environment: aNamespaceOrNil
		evaluationPools: anArray
		flags: anInteger) method!

compileExpression: aString in: aBehaviorOrNil environment: aNamespaceOrNil flags: anInteger
	"Compile the expression source, aString, in the context of the class, aBehavior, and namespace, aNamespaceOrNil, parameterized by the flags, anInteger. Answer the new method, or nil if there was an error.
	If aNamespaceOrNil is not nil, then it is used instead of the class' own environment to look up static variables that are not found within the class' own variables or imports, or of any of its superclasses.
	See the class comment for a description of the flags. <CompilerNotification> subinstances may be thrown for errors/warnings. 
	Answers a <CompiledExpression> if successful, or nil if any compilation errors were detected."

	^self
		compileExpression: aString
		in: aBehaviorOrNil
		environment: aNamespaceOrNil
		evaluationPools: nil
		flags: anInteger!

compileForEvaluation: aString in: aBehaviorOrNil environment: aNamespaceOrNil evaluationPools: anArray flags: anInteger
	^self compilerImplementation
		compileForEvaluation: aString
		in: aBehaviorOrNil
		environment: aNamespaceOrNil
		evaluationPools: anArray
		flags: anInteger!

compileForMethod: aString in: aClass environment: aNamespaceOrNil flags: anInteger
	^self compilerImplementation
		compileForMethod: aString
		in: aClass
		environment: aNamespaceOrNil
		flags: anInteger!

compilerImplementation
	^CompilerImplementation ?? CompilerLibrary!

compilerImplementation: aCompilerImplementation
	CompilerImplementation := aCompilerImplementation!

compilerNotification: aCompilerNotification 
	"Private - Inform user of Compiler error/warning as detailed in the <CompilerNotification> argument."

	^aCompilerNotification signal!

debugInfoFlags: aBoolean 
	^TextMap | TempsMap | (aBoolean ifTrue: [DebugMethod] ifFalse: [0])!

debugInfoFor: aString in: aClass environment: aNamespace debug: aBoolean
	"Answers a CompilationResult with all the information necessary for debugging a method
	in aClass whose sources is aString."

	^self
		compileForMethod: aString
		in: aClass
		environment: aNamespace
		flags: aClass defaultCompilationFlags | (self debugInfoFlags: aBoolean)!

debugInfoForExpression: aString in: aBehaviorOrNil environment: aNamespace evaluationPools: pools debug: aBoolean
	"Answers a CompilationResult with all the information necessary for debugging a method
	in aClass whose sources is aString."

	^self
		compileForEvaluation: aString
		in: aBehaviorOrNil
		environment: aNamespace
		evaluationPools: pools
		flags: (self debugInfoFlags: aBoolean)!

defaultFlags
	^DefaultFlags ?? 0!

defaultFlags: anInteger 
	DefaultFlags := anInteger!

disableWarning: anInteger 
	"Disable the compiler warning with the specified code."

	DisabledWarnings add: anInteger!

enableWarning: anInteger
	"Enable the compiler warning with the specified code."

	DisabledWarnings remove: anInteger ifAbsent: nil!

errorClass
	^CompilerErrorNotification!

evaluate: aString
	"Compile and evaluate the expression, aString, in the context of UndefinedObject.  If the expression compiles, answer the result of  evaluating the expression with nil as the receiver.
	If the compilation fails, signal a CompilerNotification and answer nil. The expression is not written to the change log."

	^self
		evaluate: aString
		for: nil!

evaluate: aString for: anObject
	"Compile and evaluate the expression, aString, with anObject as the receiver. If the expression compiles, answer the result of evaluating the expression. If the compilation fails, signal a CompilerNotification and answer nil."

	^self
		evaluate: aString
		for: anObject
		environment: nil!

evaluate: aString for: anObject environment: aNamespaceOrNil
	"Compile and evaluate the expression, aString, with anObject as the receiver. If aNamespaceOrNil is not nil, then it is used instead of the class' own environment to look up static variables that are not found within the class' own variables or imports, or of any of its superclassesIf the expression compiles, answer the result of evaluating the expression. If the compilation fails, signal a <CompilerNotification> and answer nil."

	^self
		evaluate: aString
		for: anObject
		environment: aNamespaceOrNil
		evaluationPools: nil
		logged: false!

evaluate: aString for: anObject environment: aNamespaceOrNil evaluationPools: anArray logged: aBoolean
	"Compile and evaluate the expression, aString, with anObject as the receiver. If aNamespaceOrNil is not nil, then it is used instead of the class' own environment to look up static variables that are not found within the class' own variables or imports, or of any of its superclassesIf the expression compiles, answer the result of evaluating the expression. If the expression compiles, answer the result of evaluating the expression. If the compilation fails, signal a CompilerNotification and answer nil. Log the expression to the change log as requested by the argument aBoolean."

	^self
		evaluate: aString
		for: anObject
		environment: aNamespaceOrNil
		evaluationPools: anArray
		logged: aBoolean
		ifFail: []!

evaluate: aString for: anObject environment: aNamespaceOrNil evaluationPools: anArray logged: aBoolean ifFail: failBlock
	"Compile and evaluate the expression, aString, with anObject as the receiver. If aNamespaceOrNil is not nil, then it is used instead of the class' own environment to look up static variables that are not found within the class' own variables or imports, or of any of its superclassesIf the expression compiles, answer the result of evaluating the expression. If the expression compiles, answer the result of evaluating the expression. If the compilation fails the <niladicValuable> failBlock is evaluted. Log the expression to the change log as requested by the argument aBoolean."

	^(self
		compileExpression: aString
		in: (anObject ifNotNil: [anObject class])
		environment: aNamespaceOrNil
		evaluationPools: anArray
		flags: 0)
			ifNotNil: 
				[:expr |
				aBoolean ifTrue: [self sourceManager logEvaluate: aString].
				expr value: anObject withArguments: #()]
			ifNil: [failBlock value]!

evaluate: aString for: anObject environment: aNamespaceOrNil logged: aBoolean
	"Compile and evaluate the expression, aString, with anObject as the receiver. If aNamespaceOrNil is not nil, then it is used instead of the class' own environment to look up static variables that are not found within the class' own variables or imports, or of any of its superclassesIf the expression compiles, answer the result of evaluating the expression. If the expression compiles, answer the result of evaluating the expression. If the compilation fails, signal a <CompilerNotification> and answer nil. Log the expression to the change log as requested by the argument aBoolean."

	^self
		evaluate: aString
		for: anObject
		environment: aNamespaceOrNil
		evaluationPools: nil
		logged: aBoolean!

evaluate: aString logged: aBoolean
	"Compile and evaluate the expression, aString, in the context of UndefinedObject, with nil as the receiver.  If the expression compiles, answer the result of evaluating the expression with nil as the receiver. If the compilation fails, signal a <CompilerNotification> and answer nil.  Log the expression to the change log as requested by the argument aBoolean."

	^self
		evaluate: aString
		for: nil
		environment: nil
		logged: aBoolean!

identifierFrom: aString
	"Answer a String which is an initial suggestion for a Smalltalk identifier based on aString.
	The answer is not guaranteed to be a valid identifier as it could be an empty String.

	Invalid characters are removed, the letter following a removed character is made uppercase
	unless it forms the first character of the identifier when it is made lowercase, all other
	letters are made lowercase."

	| identifier startNewWord first |
	identifier := String smalltalkWriteStream: aString size.
	startNewWord := false.
	first := true.
	aString do: 
			[:c |
			((first and: [self isAValidInitialIdentifierChar: c]) or: [self isAValidIdentifierChar: c])
				ifFalse: [startNewWord := first not]
				ifTrue: 
					[identifier nextPut: (startNewWord ifTrue: [c asUppercase] ifFalse: [c asLowercase]).
					startNewWord := false.
					first := false]].
	^identifier contents!

initialize
	"Private - Initialize the class variables of the receiver.

		Compiler initialize
	"

	DefaultFlags := 0.
	DisabledWarnings := Set new!

isAReservedWord: aString
	"Private - Answer whether aString is a reserved word."

	^self reservedWords includes: aString!

isAValidIdentifierChar: aCharacter
	"Private - Answer whether aCharacter is valid as the non-initial character in an identifier. ANSI Smalltalk allows only the English alphabet, digits, and underscore as characters in identifiers."

	^'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz' includes: aCharacter!

isAValidInitialIdentifierChar: aCharacter
	"Private - Answer whether aCharacter is valid as the initial character in an identifier. ANSI Smalltalk allows only the English alphabet, and underscore as the initial character of an identifiers."

	^'ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz' includes: aCharacter!

isAValidLocalIdentifier: aString
	"Private - Answer whether aString is a valid local identifier."

	^(aString allSatisfy: [:c | self isAValidIdentifierChar: c]) and: [
		(self isAValidInitialIdentifierChar: aString first) and: [
			(self isAReservedWord: aString) not]]!

isValidSelector: aSymbol
	"Answer whether the <Symbol> argument is a valid selector (unary, binary or keyword)."

	^(Symbol isLiteralSymbol: aSymbol) and: [(self isAReservedWord: aSymbol asString) not]!

isWarningDisabled: anInteger 
	^anInteger >= CWarnFirst and: [DisabledWarnings includes: anInteger]!

notificationClass
	^CompilerNotification!

reservedWords
	"Private - Answer the Set of reserved words."

	^##(Set withAll: #('self' 'super' 'nil' 'true' 'false' 'thisContext'))!

warningClass
	^CompilerWarningNotification! !
!Kernel.Compiler class categoriesForMethods!
compile:in:!compiling!public! !
compile:in:environment:!compiling!public! !
compile:in:environment:flags:!compiling!public! !
compileDebugExpression:in:environment:evaluationPools:!compiling!public! !
compileDebugMethod:in:environment:!compiling!public! !
compileExpression:in:!compiling!public! !
compileExpression:in:environment:!compiling!public! !
compileExpression:in:environment:evaluationPools:flags:!compiling!public! !
compileExpression:in:environment:flags:!compiling!public! !
compileForEvaluation:in:environment:evaluationPools:flags:!compiling!private! !
compileForMethod:in:environment:flags:!compiling!private! !
compilerImplementation!accessing!public! !
compilerImplementation:!accessing!public! !
compilerNotification:!exceptions!private! !
debugInfoFlags:!development!public! !
debugInfoFor:in:environment:debug:!development!public! !
debugInfoForExpression:in:environment:evaluationPools:debug:!development!public! !
defaultFlags!constants!public! !
defaultFlags:!accessing!public! !
disableWarning:!helpers!public! !
enableWarning:!helpers!public! !
errorClass!public! !
evaluate:!evaluating!public! !
evaluate:for:!evaluating!public! !
evaluate:for:environment:!evaluating!public! !
evaluate:for:environment:evaluationPools:logged:!evaluating!public! !
evaluate:for:environment:evaluationPools:logged:ifFail:!evaluating!public! !
evaluate:for:environment:logged:!evaluating!public! !
evaluate:logged:!evaluating!public! !
identifierFrom:!parsing!public! !
initialize!development!initializing!private! !
isAReservedWord:!parsing!private! !
isAValidIdentifierChar:!parsing!private! !
isAValidInitialIdentifierChar:!parsing!private! !
isAValidLocalIdentifier:!parsing!private! !
isValidSelector:!public!testing! !
isWarningDisabled:!exceptions!private! !
notificationClass!public! !
reservedWords!constants!private! !
warningClass!public! !
!

Kernel.Compiler class methodProtocol: #'Compiler class' attributes: #() selectors: #(#compile:in: #compile:in:environment: #compile:in:environment:flags: #compileExpression:in: #compileExpression:in:environment: #compileExpression:in:environment:flags:)!

