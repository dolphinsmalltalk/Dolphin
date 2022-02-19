"Filed out from Dolphin Smallalk"!

COMInterfaceImp subclass: #WebView2EventHandler
	instanceVariableNames: 'source interface publisher eventName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebView2EventHandler guid: (GUID fromString: '{91d2998a-6d4d-4c2a-93b6-fda07f00d325}')!
WebView2EventHandler comment: ''!
!WebView2EventHandler categoriesForClass!COM-Implementations! !
!WebView2EventHandler methodsFor!

free
	interface ifNotNil: [self unregister]!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]IUnknown* sender,
			[in]IUnknown* args);"

	"Transcript nextPutAll: 'trigger: '; print: eventName; nextPutAll: ' with: '; print: args; cr."
	interface
		publish: eventName
		with: args
		for: publisher!

queryInterface: anInterfaceClass ifNone: exceptionHandler
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	^(anInterfaceClass inheritsFrom: ICoreWebView2EventHandler)
		ifTrue: [anInterfaceClass on: self implementor: self]
		ifFalse: [exceptionHandler value]!

register
	interface register!

source: anICoreWebView2EventSource interfaceClass: anICoreWebView2EventHandlerClass publisher: aPresenter eventName: aSymbol
	source := anICoreWebView2EventSource.
	interface := self queryInterface: anICoreWebView2EventHandlerClass.
	interface source: anICoreWebView2EventSource.
	eventName := aSymbol.
	publisher := aPresenter!

unregister
	interface unregister.
	interface := nil! !
!WebView2EventHandler categoriesForMethods!
free!public!realizing/unrealizing! !
Invoke:args:!COM Interfaces-ICoreWebView2EventHandler!private! !
queryInterface:ifNone:!accessing!accessing-interfaces!public! !
register!initializing!public! !
source:interfaceClass:publisher:eventName:!initializing!private! !
unregister!public!realizing/unrealizing! !
!

!WebView2EventHandler class methodsFor!

source: anICoreWebView2EventSource interfaceClass: anICoreWebView2EventHandlerClass publisher: aPresenter eventName: aSymbol
	^self new
		source: anICoreWebView2EventSource
		interfaceClass: anICoreWebView2EventHandlerClass
		publisher: aPresenter
		eventName: aSymbol! !
!WebView2EventHandler class categoriesForMethods!
source:interfaceClass:publisher:eventName:!public! !
!

