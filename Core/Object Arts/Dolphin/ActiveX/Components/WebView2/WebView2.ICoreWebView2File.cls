"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2File'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2File guid: (OS.COM.IID fromString: '{f2c19559-6bc1-4583-a757-90021be9afec}')!
WebView2.ICoreWebView2File isEgressOnly: true!
WebView2.ICoreWebView2File comment: '`ICoreWebView2File` is a wrapper class for the COM interface ''WebView2.ICoreWebView2File'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f2c19559-6bc1-4583-a757-90021be9afec)
]
interface ICoreWebView2File : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Path(
		[out, retval]LPWSTR* Path);
};
```
'!
!WebView2.ICoreWebView2File categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2File methodsFor!

get_Path: path
	"Private - Get the value of the 'Path' property of the receiver.

		HRESULT __stdcall Path(
			[out, retval]LPWSTR* Path);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

path
	"Answer the <lpwstr> value of the 'Path' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Path: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

printableProperties
	^#(#path)! !
!WebView2.ICoreWebView2File categoriesForMethods!
get_Path:!**auto generated**!COM Interfaces-ICoreWebView2File!private! !
path!properties!public! !
printableProperties!printing!private! !
!

!WebView2.ICoreWebView2File class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2File'
		ICoreWebView2File defineTemplate"

	self
		defineFunction: #get_Path:
			argumentTypes: 'lpwstr*'
! !
!WebView2.ICoreWebView2File class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

