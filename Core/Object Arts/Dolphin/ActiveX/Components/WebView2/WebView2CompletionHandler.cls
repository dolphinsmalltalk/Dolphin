"Filed out from Dolphin Smallalk"!

COMInterfaceImp subclass: #WebView2CompletionHandler
	instanceVariableNames: 'completionBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebView2CompletionHandler guid: (GUID fromString: '{bc802953-baa6-43ff-94e2-d9e70d14522b}')!
WebView2CompletionHandler comment: ''!
!WebView2CompletionHandler categoriesForClass!COM-Implementations! !
!WebView2CompletionHandler methodsFor!

completionBlock: aValuable
	completionBlock := aValuable!

Invoke: sender arg: args
	completionBlock value: sender value: args.
	^S_OK!

queryInterface: anInterfaceClass ifNone: exceptionHandler
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	^(anInterfaceClass inheritsFrom: ICoreWebView2CompletedHandler)
		ifTrue: [anInterfaceClass on: self implementor: completionBlock]
		ifFalse: [exceptionHandler value]!

supportedInterfaces
	^ICoreWebView2CompletedHandler subclasses! !
!WebView2CompletionHandler categoriesForMethods!
completionBlock:!initializing!private! !
Invoke:arg:!COM Interfaces-ICoreWebView2CompletedHandler!public! !
queryInterface:ifNone:!accessing!accessing-interfaces!public! !
supportedInterfaces!constants!public! !
!

!WebView2CompletionHandler class methodsFor!

completionBlock: aPresenter
	^self new
		completionBlock: aPresenter;
		yourself!

icon
	^ICoreWebView2 icon! !
!WebView2CompletionHandler class categoriesForMethods!
completionBlock:!public! !
icon!constants!development!public! !
!

