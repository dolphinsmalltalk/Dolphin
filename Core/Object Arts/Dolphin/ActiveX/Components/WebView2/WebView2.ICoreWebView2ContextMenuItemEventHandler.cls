"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2ContextMenuItemEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ContextMenuItemEventHandler guid: (OS.COM.IID fromString: '{a8ff2237-fd49-4ed1-b0d0-86bc92bbba44}')!

WebView2.ICoreWebView2ContextMenuItemEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2ContextMenuItemEventHandler comment: 'Abstract class of event handler COM interfaces for events from a WebView2 context menu item object.'!

!WebView2.ICoreWebView2ContextMenuItemEventHandler methodsFor!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2ContextMenuItem* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2ContextMenuItem* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ContextMenuItemEventHandler categoriesForMethods!
Invoke:args:!event handling!public! !
!

