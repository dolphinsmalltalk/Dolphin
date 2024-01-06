"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'Kernel.CompilerLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompilerLibrary guid: (Core.GUID fromString: '{87b4c58a-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.CompilerLibrary comment: 'CompilerLibrary is the <ExternalLibrary> to represent the Dolphin Smalltalk compiler.

In versin 3.0 the compiler is actually implemented as a COM object, but to avoid the necessity of making the OLE COM package part of the base image, the VM exposes some simple wrapper functions which have the same signature as the 2.x compiler API.'!
!Kernel.CompilerLibrary categoriesForClass!External-Libraries! !
!Kernel.CompilerLibrary methodsFor!

compile: aCompiler source: aString length: lengthInteger in: aClass environment: aNamespaceOrNil flags: anInteger notifying: notifier
	"Private - Compiler the method source, aString, in the context of the class, aClass, on behalf of the compiler, aCompiler, parameterized by the flags, anInteger, notifying, notifier, of any errors or warnings which are detected.
	If the <Namespace> argument is specified, it is used as the default binding context for static variables (and BindingReferences). This can be used when compiling extension methods so that the code is compiled in an environment supplied by the package, rather than the environment of the class. If aNamespaceOrNil is nil, then the method is compiled in aClass' normal context (i.e. variables of its own environment are bindable)."

	<stdcall: oop CompileForClass ote lpvoid uint32 ote ote int32 oop>
	^self invalidCall: _failureCode!

compileForEvaluation: aCompiler source: aString length: lengthInteger in: aClass environment: aNamespaceOrNil evaluationPools: anArray flags: flagsInteger notifying: notifier
	"Private - Compiler the expression source, aString, in the context of the class, aClass, on behalf of the compiler, aCompiler, parameterized by the flags, anInteger, notifying, notifier, of any errors or warnings which are detected.
	If the <Namespace> argument is specified, it is used as the default binding context for static variables (and BindingReferences). This can be used when compiling expressions so that the code is compiled in an alternate environment, rather than the environment of the class. If aNamespaceOrNil is nil, then the expression is compiled in aClass' normal context (i.e. variables of its own environment are bindable)."

	<stdcall: oop CompileForEval oop lpvoid uint32 ote ote ote int32 oop>
	^self invalidCall: _failureCode! !
!Kernel.CompilerLibrary categoriesForMethods!
compile:source:length:in:environment:flags:notifying:!compiling!private! !
compileForEvaluation:source:length:in:environment:evaluationPools:flags:notifying:!compiling!private! !
!

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
		flags: anInteger!

compilerNotification: aCompilerNotification 
	"Private - Inform user of Compiler error/warning as detailed in the <CompilerNotification> argument."

	^aCompilerNotification signal!

fileName
	"Answer the host system file name of the external library which
	the receiver represents."

	^VM compilerFileName!

notificationCallback: anArray
	"Private - The receiver has generated an error while compiling, inform notifier of this.
	N.B. This is a callback from the Compiler DLL, and should not be removed."

	"Array layout:
		1) <integer> Error code
		2) <integer> Line number
		3) <integer> Start of erroneous interval
		4) <integer> End of erroneous interval
		5) <integer> Offset of the start of the source code in the original source (0 unless compiling a static expression)
		6) <String> Source code
		7) <string> selector
		8) <behavior> Class in the context of which the compilation is taking place.
		9) The object to be notified.
		10) <Array> of <Object> representing extra information about the error."

	| errorCode offset sourceText lineNumber errorStart errorStop selector methodClass extras notified |
	errorCode := anArray first.
	(Compiler isWarningDisabled: errorCode) ifTrue: [^true].
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
	^notified compilerNotification: ((Compiler notificationClass
				code: errorCode
				in: sourceText
				for: methodClass
				selector: selector
				position: errorStart + 1
				line: lineNumber
				range: (errorStart to: errorStop) + 1
				extras: extras)
				offset: offset;
				yourself)!

uninitialize
	"Clean up VM references that are only required if the compiler DLL is in use."

	"Uses:
		notificationCallback:		Sent with compilation errors/warnings
		allInstVarNames			To query the instance variable names of the method class
		evaluate:for:evaluationPools:	To evaluate ##(...) expressions
		bindingFor:				To lookup variables in the evaluation pools.
		fullBindingFor:environment:	Sent to a class to resolve static variables
		asNumber				Sent to parse numeric literals
		understandsArithmetic		Sent to verify the type of literals when parsing some messages with inline forms, e.g. #to:by:do:
		negative					Similarly to above, but to check for negative 'step'
		pathString:context:meta:		Sent to instantiate BindingReference objects for literal binding references
		namespace:				For implicit namespace: annotations when compiling methods with a specific environment (usually Smalltalk)"

	#(#notificationCallback: #allInstanceVariableNames #evaluate:for:evaluationPools: #bindingFor: #fullBindingFor:environment: #asNumber #understandsArithmetic #negative #pathString:scope:flags: #namespace: #setScope:)
		, { BindingReference. Smalltalk } do: [:each | VM unregisterObject: each].
	super uninitialize! !
!Kernel.CompilerLibrary class categoriesForMethods!
compileForEvaluation:in:environment:evaluationPools:flags:!compiling!private! !
compileForMethod:in:environment:flags:!compiling!private! !
compilerNotification:!compiling!exceptions!private! !
fileName!constants!public! !
notificationCallback:!compiling!exceptions!private! !
uninitialize!class hierarchy-removing!public! !
!

