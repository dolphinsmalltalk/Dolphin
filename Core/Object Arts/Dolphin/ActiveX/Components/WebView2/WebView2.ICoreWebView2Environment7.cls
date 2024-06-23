"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Environment6
	subclass: #'WebView2.ICoreWebView2Environment7'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Environment7 guid: (OS.COM.IID fromString: '{43c22296-3bbd-43a4-9c00-5c0df6dd29a2}')!

WebView2.ICoreWebView2Environment7 isEgressOnly: true!

WebView2.ICoreWebView2Environment7 comment: '`ICoreWebView2Environment7` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment7'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(43c22296-3bbd-43a4-9c00-5c0df6dd29a2)
]
interface ICoreWebView2Environment7 : ICoreWebView2Environment6
 {
	[id(0x60070000), propget]
	HRESULT __stdcall UserDataFolder(
		[out, retval]LPWSTR* value);
};
```
'!

!WebView2.ICoreWebView2Environment7 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Environment7 methodsFor!

get_UserDataFolder: value
	"Private - Get the value of the 'UserDataFolder' property of the receiver.

		HRESULT __stdcall UserDataFolder(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 16 lpwstr*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Environment7 categoriesForMethods!
get_UserDataFolder:!**auto generated**!COM Interfaces-ICoreWebView2Environment7!private! !
!

!WebView2.ICoreWebView2Environment7 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment7'
		ICoreWebView2Environment7 defineTemplate"

	self
		defineFunction: #get_UserDataFolder:
			argumentTypes: 'lpwstr*'
! !

!WebView2.ICoreWebView2Environment7 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

