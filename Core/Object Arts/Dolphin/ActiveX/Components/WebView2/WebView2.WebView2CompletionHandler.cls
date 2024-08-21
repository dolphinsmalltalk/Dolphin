"Filed out from Dolphin Smalltalk"!

OS.COM.InterfaceImplementation
	subclass: #'WebView2.WebView2CompletionHandler'
	instanceVariableNames: 'completionBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.WebView2CompletionHandler guid: (Core.GUID fromString: '{bc802953-baa6-43ff-94e2-d9e70d14522b}')!

WebView2.WebView2CompletionHandler comment: ''!

!WebView2.WebView2CompletionHandler categoriesForClass!COM-Implementations! !

!WebView2.WebView2CompletionHandler methodsFor!

completionBlock: aValuable
	completionBlock := aValuable!

Invoke: hresultInteger
	completionBlock value: hresultInteger.
	^S_OK!

Invoke: hresultInteger arg: anObject
	completionBlock value: hresultInteger value: anObject.
	^S_OK!

queryInterface: anInterfaceClass ifNone: exceptionHandler
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	^(anInterfaceClass inheritsFrom: ICoreWebView2CompletedHandler)
		ifTrue: [anInterfaceClass on: self]
		ifFalse: [exceptionHandler value]!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^##({ IUnknown } , ICoreWebView2CompletedHandler allSubclasses)! !

!WebView2.WebView2CompletionHandler categoriesForMethods!
completionBlock:!initializing!private! !
Invoke:!COM Interfaces-ICoreWebView2CompletedHandler!public! !
Invoke:arg:!COM Interfaces-ICoreWebView2CompletedHandler!public! !
queryInterface:ifNone:!accessing!accessing-interfaces!public! !
supportedInterfaces!constants!public! !
!

!WebView2.WebView2CompletionHandler class methodsFor!

completionBlock: aPresenter
	^self new
		completionBlock: aPresenter;
		yourself!

icon
	^ICoreWebView2 icon! !

!WebView2.WebView2CompletionHandler class categoriesForMethods!
completionBlock:!public! !
icon!constants!development!public! !
!

