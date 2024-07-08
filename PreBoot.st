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

!Kernel.CompilerLibrary class methodsFor!

compilerNotification: aCompilerNotification
	self error: aCompilerNotification displayString!

notificationCallback: anArray
	| errorCode offset sourceText lineNumber errorStart errorStop selector methodClass extras notified |
	errorCode := anArray first.
	lineNumber := anArray at: 2.
	errorStart := anArray at: 3.
	errorStop := anArray at: 4.
	"The offset must be added to the error range to get the actual interval in the source text"
	offset := anArray at: 5.
	sourceText := anArray at: 6.
	selector := anArray at: 7.
	methodClass := anArray at: 8.
	notified := anArray at: 9.
	extras := anArray at: 10 ifAbsent: #().
	^notified compilerNotification: ((CompilerNotification
				code: errorCode
				in: sourceText
				for: methodClass
				selector: selector
				position: errorStart + 1
				line: lineNumber
				range: (errorStart to: errorStop) + 1
				extras: extras)
				offset: offset;
				yourself)! !
