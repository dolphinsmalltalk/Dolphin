"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface subclass: #'WebView2.ICoreWebView2CompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2CompletedHandler guid: (OS.COM.IID fromString: '{27d65498-b891-4319-88fb-fcd3c81271f3}')!
WebView2.ICoreWebView2CompletedHandler isNonInstantiable: true!
WebView2.ICoreWebView2CompletedHandler comment: '`ICoreWebView2EventHandler` is not defined in the WebView2 IDL, but is defined here for economy of mechanism.

The concrete subclasses represent COM interfaces used to provide the callback object that is notified when an asynchronous request completes.

There are 10 or more completion handler interfaces defined that are all similar callback interfaces (i.e. implemented by the host application, not WebView2). The presence and type of the 2nd argument does vary, but we map all of these onto blocks/valuables via the common indirection, `WebView2CompletionHandler`. The first argument is always an HRESULT code indicating success (0) or failure (<0). The 2nd argument, where present, is usually an interface onto some object result, or a (json) string, or in one case an integer value.


'!
!WebView2.ICoreWebView2CompletedHandler categoriesForClass!COM-Interfaces! !
