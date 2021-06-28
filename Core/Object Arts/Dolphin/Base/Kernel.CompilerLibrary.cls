"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary subclass: #'Kernel.CompilerLibrary'
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

compile: aCompiler source: aString in: aClass environment: aNamespaceOrNil flags: anInteger notifying: notifier
	"Private - Compiler the method source, aString, in the context of the class, aClass, on behalf of the compiler, aCompiler, parameterized by the flags, anInteger, notifying, notifier, of any errors or warnings which are detected.
	If the <Namespace> argument is specified, it is used as the default binding context for static variables (and BindingReferences). This can be used when compiling extension methods so that the code is compiled in an environment supplied by the package, rather than the environment of the class. If aNamespaceOrNil is nil, then the method is compiled in aClass' normal context (i.e. variables of its own environment are bindable)."

	<stdcall: oop CompileForClass ote lpvoid ote ote sdword oop>
	^self invalidCall: _failureCode!

compileForEvaluation: aCompiler source: aString in: aClass environment: aNamespaceOrNil evaluationPools: anArray flags: anInteger notifying: notifier
	"Private - Compiler the expression source, aString, in the context of the class, aClass, on behalf of the compiler, aCompiler, parameterized by the flags, anInteger, notifying, notifier, of any errors or warnings which are detected.
	If the <Namespace> argument is specified, it is used as the default binding context for static variables (and BindingReferences). This can be used when compiling expressions so that the code is compiled in an alternate environment, rather than the environment of the class. If aNamespaceOrNil is nil, then the expression is compiled in aClass' normal context (i.e. variables of its own environment are bindable)."

	<stdcall: oop CompileForEval oop lpvoid ote ote ote sdword oop>
	^self invalidCall: _failureCode! !
!Kernel.CompilerLibrary categoriesFor: #compile:source:in:environment:flags:notifying:!compiling!private! !
!Kernel.CompilerLibrary categoriesFor: #compileForEvaluation:source:in:environment:evaluationPools:flags:notifying:!compiling!private! !

!Kernel.CompilerLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which
	the receiver represents."

	^VMLibrary default compilerFileName! !
!Kernel.CompilerLibrary class categoriesFor: #fileName!constants!public! !

