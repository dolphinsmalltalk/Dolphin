"Filed out from Dolphin Smalltalk 7"!

Notification subclass: #MethodCompileFailed
	instanceVariableNames: 'compilerErrorNotification'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MethodCompileFailed guid: (GUID fromString: '{87b4c56f-026e-11d3-9fd7-00a0cc3e4a32}')!
MethodCompileFailed comment: 'A MethodCompileFailed notification is signalled when a method compilation fails. Handlers can trap this if they wish to replace the original failed compilation with a stub method. This is useful so that the failed method source can be seen in the browsers or to retain category information. To install a stub method the handler should call #resumeWithStubMethod.'!
!MethodCompileFailed categoriesForClass!System-Compiler! !
!MethodCompileFailed methodsFor!

compilerErrorNotification: aCompilerErrorNotification
	"Private - Set the value of the receiver's instance variable compilerErrorNotification to 
	aCompilerErrorNotification."

	compilerErrorNotification := aCompilerErrorNotification.!

defaultAction
	"The receiver is an unhandled notification, perform the default action
	which is nothing but to answer a nil method"

	^nil!

resumeWithStubMethod
	"Create a stub method which causes an error if evaluated but has the source of the
	proposed method that did not compile. Answer this as the result of resuming the
	notification"

	| selector methodClass result |
	selector := compilerErrorNotification selector asSymbol.
	selector isEmpty ifTrue: [^nil].
	methodClass := compilerErrorNotification methodClass.
	result := methodClass compilerClass 
				compile: (CompileFailedMethod buildSourceForSelector: selector class: methodClass)
				in: methodClass
				flags: methodClass defaultCompilationFlags.
	result method becomeA: CompileFailedMethod.

	"Resume with this stub"
	self resume: result! !
!MethodCompileFailed categoriesFor: #compilerErrorNotification:!accessing!private! !
!MethodCompileFailed categoriesFor: #defaultAction!handling!public! !
!MethodCompileFailed categoriesFor: #resumeWithStubMethod!handler responses!operations!public! !

!MethodCompileFailed class methodsFor!

new
	"Private - Use #with:"

	self shouldNotImplement!

with: aCompilerErrorNotification
	"Answer an instance of the receiver that indicates that a method compilation failed
	due to aCompilerErrorNotification"

	^super new compilerErrorNotification: aCompilerErrorNotification
! !
!MethodCompileFailed class categoriesFor: #new!instance creation!private! !
!MethodCompileFailed class categoriesFor: #with:!instance creation!public! !

