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

WebView2.ICoreWebView2EventArgs isEgressOnly: true!

WebView2.ICoreWebView2EventArgs comment: '`ICoreWebView2EventArgs` is not defined in the WebView2 IDL, but is defined here to group all the event argument interfaces in an attempt to make the large API easier to navigate and understand. In other words, there is no real is-a relationship, rather this is just a convenient grouping.
'!

!WebView2.ICoreWebView2EventArgs categoriesForClass!COM-Interfaces! !

!WebView2.ICoreWebView2EventArgs methodsFor!

cancel
	"Answer whether the operation associated with the event is to be cancelled."

	| buf |
	buf := UInt32Bytes new.
	self get_Cancel: buf.
	^buf asBoolean!

cancel: aBoolean
	"Set whether the event should be cancelled."

	self put_Cancel: aBoolean asParameter!

defer
	"Defer this event, answering an <ICoreWebView2Deferral> that can be used to complete it later, or nil if the event is not of a deferrable type."

	| answer |
	answer := ICoreWebView2Deferral newPointer.
	self GetDeferral: answer.
	^answer asObject!

get_Cancel: pBOOL
	"Private - Get the value of the 'Cancel' property of the receiver.

		HRESULT __stdcall Cancel(
			[out, retval]long* Cancel);"

	pBOOL value: 0.
	^S_OK!

get_Handled: pBOOL
	"Private - Get the value of the 'Handled' property of the receiver.

		HRESULT __stdcall Handled(
			[out, retval]long* Handled);"

	pBOOL value: 0.
	^S_OK!

getDeferral
	"Answer the <ICoreWebView2Deferral> result of invoking the GetDeferral() method of the COM object."

	| answer |
	answer := ICoreWebView2Deferral newPointer.
	self GetDeferral: answer.
	^answer asObject!

GetDeferral: anICoreWebView2Deferral
	^E_NOTIMPL!

handled
	"Answer whether this event is considered to have  been handled already."

	| answer |
	answer := ByteArray newFixed: 4.
	self get_Handled: answer.
	^(answer int32AtOffset: 0) ~~ 0!

handled: aBoolean
	"Set whether or not the event has been handled. This may suppress any further or default response."

	self put_Handled: aBoolean asParameter!

put_Cancel: cancel
	"Private - Set the value of the 'Cancel' property of the object wrapped by the 
	 receiver to the <sdword> argument, cancel.

		HRESULT __stdcall Cancel(
			[in]long Cancel);"

	^E_NOTIMPL!

put_Handled: handled
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <sdword> argument, handled.

		HRESULT __stdcall Handled(
			[in]long Handled);"

	^E_NOTIMPL! !

!WebView2.ICoreWebView2EventArgs categoriesForMethods!
cancel!properties!public! !
cancel:!properties!public! !
defer!methods!public! !
get_Cancel:!private!properties! !
get_Handled:!private!properties! !
getDeferral!methods!public! !
GetDeferral:!methods!private! !
handled!properties!public! !
handled:!properties!public! !
put_Cancel:!private!properties! !
put_Handled:!private!properties! !
!

