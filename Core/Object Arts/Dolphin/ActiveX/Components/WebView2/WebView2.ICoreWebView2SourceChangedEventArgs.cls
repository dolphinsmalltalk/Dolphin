"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs subclass: #'WebView2.ICoreWebView2SourceChangedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2SourceChangedEventArgs guid: (OS.COM.IID fromString: '{31e0e545-1dba-4266-8914-f63848a1f7d7}')!
WebView2.ICoreWebView2SourceChangedEventArgs comment: '`ICoreWebView2SourceChangedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2SourceChangedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(31e0e545-1dba-4266-8914-f63848a1f7d7)
]
interface ICoreWebView2SourceChangedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall IsNewDocument(
		[out, retval]long* IsNewDocument);
};
```
'!
!WebView2.ICoreWebView2SourceChangedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2SourceChangedEventArgs methodsFor!

get_IsNewDocument: isNewDocument
	"Private - Get the value of the 'IsNewDocument' property of the receiver.

		HRESULT __stdcall IsNewDocument(
			[out, retval]long* IsNewDocument);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

isNewDocument
	"Answer the <Boolean> value of the 'IsNewDocument' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsNewDocument: buf.
	^buf asBoolean!

printableProperties
	^#(#isNewDocument)! !
!WebView2.ICoreWebView2SourceChangedEventArgs categoriesForMethods!
get_IsNewDocument:!**auto generated**!COM Interfaces-ICoreWebView2SourceChangedEventArgs!private! !
isNewDocument!properties!public! !
printableProperties!printing!private! !
!

!WebView2.ICoreWebView2SourceChangedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2SourceChangedEventArgs'
		ICoreWebView2SourceChangedEventArgs defineTemplate"

	self
		defineFunction: #get_IsNewDocument:
			argumentTypes: 'sdword*'
! !
!WebView2.ICoreWebView2SourceChangedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

