"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2PermissionRequestedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2PermissionRequestedEventArgs guid: (OS.COM.IID fromString: '{973ae2ef-ff18-4894-8fb2-3c758f046810}')!
WebView2.ICoreWebView2PermissionRequestedEventArgs comment: '`ICoreWebView2PermissionRequestedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PermissionRequestedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(973ae2ef-ff18-4894-8fb2-3c758f046810)
]
interface ICoreWebView2PermissionRequestedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall uri(
		[out, retval]LPWSTR* uri);
	[id(0x60010001), propget]
	HRESULT __stdcall PermissionKind(
		[out, retval]COREWEBVIEW2_PERMISSION_KIND* PermissionKind);
	[id(0x60010002), propget]
	HRESULT __stdcall IsUserInitiated(
		[out, retval]long* IsUserInitiated);
	[id(0x60010003), propget]
	HRESULT __stdcall State(
		[out, retval]COREWEBVIEW2_PERMISSION_STATE* State);
	[id(0x60010003), propput]
	HRESULT __stdcall State(
		[in]COREWEBVIEW2_PERMISSION_STATE State);
	[id(0x60010005)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** deferral);
};
```
'!
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs methodsFor!

get_IsUserInitiated: isUserInitiated
	"Private - Get the value of the 'IsUserInitiated' property of the receiver.

		HRESULT __stdcall IsUserInitiated(
			[out, retval]long* IsUserInitiated);"

	<virtual stdcall: hresult 6 sdword*>
	^self invalidCall: _failureCode!

get_PermissionKind: permissionKind
	"Private - Get the value of the 'PermissionKind' property of the receiver.

		HRESULT __stdcall PermissionKind(
			[out, retval]COREWEBVIEW2_PERMISSION_KIND* PermissionKind);"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

get_State: state
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval]COREWEBVIEW2_PERMISSION_STATE* State);"

	<virtual stdcall: hresult 7 sdword*>
	^self invalidCall: _failureCode!

get_uri: uri
	"Private - Get the value of the 'uri' property of the receiver.

		HRESULT __stdcall uri(
			[out, retval]LPWSTR* uri);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

getDeferral
	"Answer the <ICoreWebView2Deferral> result of invoking the GetDeferral() method of the COM object."

	| answer |
	answer := ICoreWebView2Deferral newPointer.
	self GetDeferral: answer.
	^answer asObject!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 9 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

isUserInitiated
	"Answer the <sdword> value of the 'IsUserInitiated' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsUserInitiated: answer.
	^answer asObject!

permissionKind
	"Answer the <sdword> value of the 'PermissionKind' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_PermissionKind: answer.
	^answer asObject!

put_State: state
	"Private - Set the value of the 'State' property of the object wrapped by the 
	 receiver to the <sdword> argument, state.

		HRESULT __stdcall State(
			[in]COREWEBVIEW2_PERMISSION_STATE State);"

	<virtual stdcall: hresult 8 sdword>
	^self invalidCall: _failureCode!

state
	"Answer the <sdword> value of the 'State' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_State: answer.
	^answer asObject!

state: state
	"Set the 'State' property of the receiver to the <sdword> value of the argument."

	self put_State: state!

uri
	"Answer the <lpwstr> value of the 'uri' property of the receiver."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self get_uri: answer.
	^answer asObject! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #get_IsUserInitiated:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #get_PermissionKind:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #get_State:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #get_uri:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #getDeferral!**auto generated**!methods!public! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #isUserInitiated!**auto generated**!properties!public! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #permissionKind!**auto generated**!properties!public! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #put_State:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #state!**auto generated**!properties!public! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #state:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesFor: #uri!**auto generated**!properties!public! !

!WebView2.ICoreWebView2PermissionRequestedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PermissionRequestedEventArgs'
		ICoreWebView2PermissionRequestedEventArgs defineTemplate"

	self
		defineFunction: #get_uri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_PermissionKind:
			argumentTypes: 'sdword*';
		defineFunction: #get_IsUserInitiated:
			argumentTypes: 'sdword*';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #put_State:
			argumentTypes: 'sdword';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

