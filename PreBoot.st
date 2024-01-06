Kernel.Compiler addClassVariable: 'CompilerImplementation' value: nil!

!Kernel.CompilerLibrary class methodsFor!

compileForEvaluation: aString in: aBehaviorOrNil environment: aNamespaceOrNil evaluationPools: anArray flags: anInteger
	| results expression source |
	source := aString asUtf8String.
	results := self default
				compileForEvaluation: self
				source: source
				length: source size
				in: aBehaviorOrNil
				environment: aNamespaceOrNil
				evaluationPools: anArray
				flags: anInteger
				notifying: self.
	expression := results first.
	results := CompilationResult
				method: expression
				rawTextMap: results second
				rawTempsMap: results third
				flags: anInteger.
	expression notNil
		ifTrue: 
			[aBehaviorOrNil ifNotNil: [expression methodClass: aBehaviorOrNil].
			expression
				storeSourceString: source evaluationPools: anArray;
				beImmutableObject].
	^results!

compileForMethod: aString in: aClass environment: aNamespaceOrNil flags: anInteger
	| results source |
	source := aString asUtf8String.
	results := self default
				compile: self
				source: source
				length: source size
				in: aClass
				environment: aNamespaceOrNil
				flags: anInteger
				notifying: self.
	^CompilationResult
		method: results first
		rawTextMap: results second
		rawTempsMap: results third
		flags: anInteger! !

!Kernel.Compiler class methodsFor!

compilerImplementation
	^CompilerImplementation ?? CompilerLibrary!

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
		flags: anInteger! !
