"Filed out from Dolphin Smallalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2EventHandlerNoArgs
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2EventHandlerNoArgs guid: (IID fromString: '{bf51adc2-2955-425e-8c7c-676127797c58}')!
ICoreWebView2EventHandlerNoArgs isAbstract: true!
ICoreWebView2EventHandlerNoArgs comment: '`ICoreWebView2EventHandlerNoArgs` is not defined in the WebView2 IDL, but is defined here to group all the similar event handler interfaces in an attempt to make the large API easier to navigate and understand.

The subclasses are always passed a null args parameter. What''s odd is that in reality they share no common superclass, so there is no reason to define their Invoke() method to take the parameter at all.'!
!ICoreWebView2EventHandlerNoArgs categoriesForClass!COM-Interfaces! !
!ICoreWebView2EventHandlerNoArgs methodsFor!

publish: aSymbol with: anIUnknown for: aPresenter
	aPresenter trigger: aSymbol! !
!ICoreWebView2EventHandlerNoArgs categoriesForMethods!
publish:with:for:!public! !
!

!ICoreWebView2EventHandlerNoArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CursorChangedEventHandler'
		ICoreWebView2CursorChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2CompositionController* IUnknown*'
! !
!ICoreWebView2EventHandlerNoArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

