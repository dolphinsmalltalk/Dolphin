"Filed out from Dolphin Smallalk"!

ICoreWebView2EventArgs subclass: #ICoreWebView2SourceChangedEventArgs
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2SourceChangedEventArgs guid: (IID fromString: '{31e0e545-1dba-4266-8914-f63848a1f7d7}')!
ICoreWebView2SourceChangedEventArgs comment: '`ICoreWebView2SourceChangedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2SourceChangedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2SourceChangedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2SourceChangedEventArgs methodsFor!

get_IsNewDocument: isNewDocument
	"Private - Get the value of the 'IsNewDocument' property of the receiver.

		HRESULT __stdcall IsNewDocument(
			[out, retval]long* IsNewDocument);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

isNewDocument
	"Answer the <Boolean> value of the 'IsNewDocument' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsNewDocument: answer.
	^answer asObject!

printableProperties
	^#(#isNewDocument)! !
!ICoreWebView2SourceChangedEventArgs categoriesForMethods!
get_IsNewDocument:!**auto generated**!COM Interfaces-ICoreWebView2SourceChangedEventArgs!private! !
isNewDocument!properties!public! !
printableProperties!development!printing!private! !
!

!ICoreWebView2SourceChangedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2SourceChangedEventArgs'
		ICoreWebView2SourceChangedEventArgs defineTemplate"

	self
		defineFunction: #get_IsNewDocument:
			argumentTypes: 'sdword*'
! !
!ICoreWebView2SourceChangedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

