﻿"Filed out from Dolphin Smalltalk"!

OS.COM.InterfaceImplementation
	subclass: #'WebView2.WebView2EventSink'
	instanceVariableNames: 'source interfaceClass interface handler token'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.WebView2EventSink guid: (Core.GUID fromString: '{91d2998a-6d4d-4c2a-93b6-fda07f00d325}')!

WebView2.WebView2EventSink comment: ''!

!WebView2.WebView2EventSink categoriesForClass!COM-Implementations! !

!WebView2.WebView2EventSink methodsFor!

destroy
	"Private - Free the interface (i.e. reduce it's reference count) without unregistering. This should only be done when the browser process has exited on failure."

	interface ifNil: [^self].
	interface free.
	interface := source := nil!

free
	source ifNil: [^self].
	self unregister.
	source := nil!

interfaceClass
	^interfaceClass!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]IUnknown* sender,
			[in]IUnknown* args);"

	handler cull: sender cull: args downCast.
	^S_OK!

printOn: aPuttableStream
	self basicPrintOn: aPuttableStream.
	aPuttableStream
		nextPut: $(;
		print: token;
		space;
		print: interfaceClass eventName;
		nextPut: $)!

queryInterface: anInterfaceClass ifNone: exceptionHandler
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	^(anInterfaceClass inheritsFrom: ICoreWebView2EventHandler)
		ifTrue: [anInterfaceClass on: self implementor: self]
		ifFalse: [exceptionHandler value]!

register
	self register: source!

register: anICoreWebView2Interface
	interface := self queryInterface: interfaceClass.
	token := interface register: anICoreWebView2Interface!

source
	^source!

source: anICoreWebView2EventSource interfaceClass: anICoreWebView2EventHandlerClass handler: aDyadicValuable
	source := anICoreWebView2EventSource.
	interfaceClass := anICoreWebView2EventHandlerClass.
	handler := aDyadicValuable!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^{ IUnknown. interfaceClass }!

token
	^token!

token: anInteger
	token := anInteger!

unregister
	self unregister: source.
	source := nil!

unregister: anICoreWebView2Interface
	interface isNull ifTrue: [^self].
	interface
		unregister: token from: anICoreWebView2Interface;
		free.
	interface := token := nil! !

!WebView2.WebView2EventSink categoriesForMethods!
destroy!private!realizing/unrealizing! !
free!public!realizing/unrealizing! !
interfaceClass!accessing!public! !
Invoke:args:!COM Interfaces-ICoreWebView2EventHandler!private! !
printOn:!printing!public! !
queryInterface:ifNone:!accessing!accessing-interfaces!public! !
register!initializing!public! !
register:!initializing!public! !
source!accessing!private! !
source:interfaceClass:handler:!initializing!private! !
supportedInterfaces!constants!public! !
token!accessing!private! !
token:!accessing!private! !
unregister!public!realizing/unrealizing! !
unregister:!public!realizing/unrealizing! !
!

WebView2.WebView2EventSink methodProtocol: #ICoreWebView2EventHandler attributes: #(#readOnly) selectors: #(#Invoke:args:)!

!WebView2.WebView2EventSink class methodsFor!

icon
	^ICoreWebView2 icon!

source: anICoreWebView2EventSource interfaceClass: anICoreWebView2EventHandlerClass handler: aPresenter
	^self new
		source: anICoreWebView2EventSource
		interfaceClass: anICoreWebView2EventHandlerClass
		handler: aPresenter! !

!WebView2.WebView2EventSink class categoriesForMethods!
icon!constants!development!public! !
source:interfaceClass:handler:!instance creation!public! !
!

