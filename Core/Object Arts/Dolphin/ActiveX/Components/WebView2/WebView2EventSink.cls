"Filed out from Dolphin Smallalk"!

COMInterfaceImp subclass: #WebView2EventSink
	instanceVariableNames: 'source interfaceClass interface handler'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebView2EventSink guid: (GUID fromString: '{91d2998a-6d4d-4c2a-93b6-fda07f00d325}')!
WebView2EventSink comment: ''!
!WebView2EventSink categoriesForClass!COM-Implementations! !
!WebView2EventSink methodsFor!

free
	interface ifNotNil: [self unregister]!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]IUnknown* sender,
			[in]IUnknown* args);"

	handler value: sender value: (args isNull ifFalse: [args]).
	^S_OK!

queryInterface: anInterfaceClass ifNone: exceptionHandler
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	^(anInterfaceClass inheritsFrom: ICoreWebView2EventHandler)
		ifTrue: [anInterfaceClass on: self implementor: self]
		ifFalse: [exceptionHandler value]!

register
	interface := self queryInterface: interfaceClass.
	interface
		source: source;
		register!

source: anICoreWebView2EventSource interfaceClass: anICoreWebView2EventHandlerClass handler: aDyadicValuable
	source := anICoreWebView2EventSource.
	interfaceClass := anICoreWebView2EventHandlerClass.
	handler := aDyadicValuable!

unregister
	interface ifNil: [^self].
	interface unregister.
	interface := nil! !
!WebView2EventSink categoriesForMethods!
free!public!realizing/unrealizing! !
Invoke:args:!COM Interfaces-ICoreWebView2EventHandler!private! !
queryInterface:ifNone:!accessing!accessing-interfaces!public! !
register!initializing!public! !
source:interfaceClass:handler:!initializing!private! !
unregister!public!realizing/unrealizing! !
!

!WebView2EventSink class methodsFor!

icon
	^ICoreWebView2 icon!

source: anICoreWebView2EventSource interfaceClass: anICoreWebView2EventHandlerClass handler: aPresenter
	^self new
		source: anICoreWebView2EventSource
		interfaceClass: anICoreWebView2EventHandlerClass
		handler: aPresenter! !
!WebView2EventSink class categoriesForMethods!
icon!constants!development!public! !
source:interfaceClass:handler:!instance creation!public! !
!

