"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2ViewEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ViewEventHandler guid: (OS.COM.IID fromString: '{00170836-6f0f-49ad-b71e-0937975105b5}')!

WebView2.ICoreWebView2ViewEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2ViewEventHandler comment: 'Abstract class of event handler COM interfaces for events from a WebView2 view (window) object.'!

!WebView2.ICoreWebView2ViewEventHandler methodsFor!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ViewEventHandler categoriesForMethods!
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2ContainsFullScreenElementChangedEventHandler!public! !
!

