"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2ProfileEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ProfileEventHandler guid: (OS.COM.IID fromString: '{ec94b6f4-f98e-4621-be9d-1b4666ab981b}')!

WebView2.ICoreWebView2ProfileEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2ProfileEventHandler comment: 'Abstract class of event handler COM interfaces for events from a WebView2 profile object.'!

!WebView2.ICoreWebView2ProfileEventHandler methodsFor!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Profile* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Profile* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ProfileEventHandler categoriesForMethods!
Invoke:args:!public! !
!

