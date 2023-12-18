"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Profile7
	subclass: #'WebView2.ICoreWebView2Profile8'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Profile8 guid: (OS.COM.IID fromString: '{fbf70c2f-eb1f-4383-85a0-163e92044011}')!
WebView2.ICoreWebView2Profile8 isEgressOnly: true!
WebView2.ICoreWebView2Profile8 comment: '`ICoreWebView2Profile8` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Profile8'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(fbf70c2f-eb1f-4383-85a0-163e92044011)
]
interface ICoreWebView2Profile8 : ICoreWebView2Profile7
 {
	[id(0x60080000)]
	HRESULT __stdcall Delete();
	[id(0x60080001)]
	HRESULT __stdcall add_Deleted(
		[in]ICoreWebView2ProfileDeletedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60080002)]
	HRESULT __stdcall remove_Deleted(
		[in]EventRegistrationToken token);
};
```
'!
!WebView2.ICoreWebView2Profile8 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Profile8 methodsFor!

Add_Deleted: eventHandler token: token
	"Private - Invoke the add_Deleted() method of the COM object.

		HRESULT __stdcall add_Deleted(
			[in]ICoreWebView2ProfileDeletedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 26 ICoreWebView2ProfileDeletedEventHandler* int64*>
	^self invalidCall: _failureCode!

Delete
	"Invoke the Delete() method of the COM object.

		HRESULT __stdcall Delete();"

	<virtual stdcall: hresult 25>
	^self invalidCall: _failureCode!

Remove_Deleted: token
	"Invoke the remove_Deleted() method of the COM object.

		HRESULT __stdcall remove_Deleted(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 27 int64>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Profile8 categoriesForMethods!
Add_Deleted:token:!**auto generated**!COM Interfaces-ICoreWebView2Profile8!private! !
Delete!**auto generated**!COM Interfaces-ICoreWebView2Profile8!public! !
Remove_Deleted:!**auto generated**!COM Interfaces-ICoreWebView2Profile8!public! !
!

!WebView2.ICoreWebView2Profile8 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Profile8'
		ICoreWebView2Profile8 defineTemplate"

	self
		defineFunction: #Delete;
		defineFunction: #Add_Deleted:token:
			argumentTypes: 'ICoreWebView2ProfileDeletedEventHandler* int64*';
		defineFunction: #Remove_Deleted:
			argumentTypes: 'int64'
! !
!WebView2.ICoreWebView2Profile8 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

