"Filed out from Dolphin Smalltalk 7"!

External.Library subclass: #'Kernel.CompilerLibrary'
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

compile: aCompiler source: aString in: aClass flags: anInteger notifying: notifier
	"Private - Compiler the method source, aString, in the context of the class, aClass,
	on behalf of the compiler, aCompiler, parameterized by the flags, anInteger,
	notifying, notifier, of any errors or warnings which are detected."

	<stdcall: oop CompileForClass ote lpvoid ote sdword oop>
	^self invalidCall: _failureCode!

compileForEvaluation: aCompiler source: aString in: aClass evaluationPools: anArray flags: anInteger notifying: notifier
	"Private - Compiler the expression source, aString, in the context of the class, aClass,
	on behalf of the compiler, aCompiler, parameterized by the flags, anInteger,
	notifying, notifier, of any errors or warnings which are detected."

	<stdcall: oop CompileForEval oop lpvoid ote ote sdword oop>
	^self invalidCall: _failureCode! !
!Kernel.CompilerLibrary categoriesFor: #compile:source:in:flags:notifying:!compiling!private! !
!Kernel.CompilerLibrary categoriesFor: #compileForEvaluation:source:in:evaluationPools:flags:notifying:!compiling!private! !

!Kernel.CompilerLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which
	the receiver represents."

	^VMLibrary default compilerFileName! !
!Kernel.CompilerLibrary class categoriesFor: #fileName!constants!public! !

