"Filed out from Dolphin Smalltalk"!

Core.Notification
	subclass: #'Kernel.MethodCompileFailed'
	instanceVariableNames: 'compilerErrorNotification environment'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.MethodCompileFailed guid: (Core.GUID fromString: '{87b4c56f-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.MethodCompileFailed comment: 'A MethodCompileFailed notification is signalled when a method compilation fails. Handlers can trap this if they wish to replace the original failed compilation with a stub method. This is useful so that the failed method source can be seen in the browsers or to retain category information. To install a stub method the handler should call #resumeWithStubMethod.'!

!Kernel.MethodCompileFailed categoriesForClass!System-Compiler! !

!Kernel.MethodCompileFailed methodsFor!

defaultAction
	"The receiver is an unhandled notification, perform the default action
	which is nothing but to answer a nil method"

	^nil!

environment
	^environment!

error: aCompilerErrorNotification environment: aNamespace
	compilerErrorNotification := aCompilerErrorNotification.
	environment := aNamespace!

errorCode
	^compilerErrorNotification errorCode!

resumeWithStubMethod
	"Private - Create a stub method which causes an error if evaluated but has the source of the proposed method that did not compile. Answer the <CompilationResult> for the stub method as the result of resuming the notification."

	| selector methodClass result |
	selector := compilerErrorNotification selector asSymbol.
	selector isEmpty ifTrue: [^nil].
	methodClass := compilerErrorNotification methodClass.
	result := methodClass compilerClass
				compileForMethod: (CompileFailedMethod buildSourceForSelector: selector class: methodClass)
				in: methodClass
				environment: self environment
				flags: methodClass defaultCompilationFlags.
	result method becomeA: CompileFailedMethod.

	"Resume with this stub"
	self resume: result! !

!Kernel.MethodCompileFailed categoriesForMethods!
defaultAction!handling!public! !
environment!accessing!public! !
error:environment:!initializing!private! !
errorCode!accessing!public! !
resumeWithStubMethod!handler responses!operations!private! !
!

!Kernel.MethodCompileFailed class methodsFor!

error: aCompilerErrorNotification environment: aNamespace
	"Answer an instance of the receiver that indicates that a method compilation failed
	due to aCompilerErrorNotification"

	^super new error: aCompilerErrorNotification environment: aNamespace!

new
	"Private - Use #error:environment:"

	self shouldNotImplement! !

!Kernel.MethodCompileFailed class categoriesForMethods!
error:environment:!instance creation!public! !
new!instance creation!private! !
!

