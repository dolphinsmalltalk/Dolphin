"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2EventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2EventArgs guid: (OS.COM.IID fromString: '{18b842e9-59bb-446b-a0bf-1cdcc14230b1}')!
WebView2.ICoreWebView2EventArgs isNonInstantiable: true!
WebView2.ICoreWebView2EventArgs comment: '`ICoreWebView2EventArgs` is not defined in the WebView2 IDL, but is defined here to group all the event argument interfaces in an attempt to make the large API easier to navigate and understand. In other words, there is no real is-a relationship, rather this is just a convenient grouping.
'!
!WebView2.ICoreWebView2EventArgs categoriesForClass!COM-Interfaces! !
!WebView2.ICoreWebView2EventArgs methodsFor!

defer
	"Defer this event, answering an <ICoreWebView2Deferral> that can be used to complete it later, or nil if the event is not of a deferrable type."

	| answer |
	answer := ICoreWebView2Deferral newPointer.
	self GetDeferral: answer.
	^answer asObject!

GetDeferral: anICoreWebView2Deferral
	^E_NOTIMPL! !
!WebView2.ICoreWebView2EventArgs categoriesForMethods!
defer!methods!public! !
GetDeferral:!methods!private! !
!

