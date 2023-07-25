"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2PermissionRequestedEventArgs'
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

get_Handled: handled
	"Private - Get the value of the 'Handled' property of the receiver.

		HRESULT __stdcall Handled(
			[out, retval]long* Handled);"

	handled value: 0.
	^S_OK!

get_IsUserInitiated: isUserInitiated
	"Private - Get the value of the 'IsUserInitiated' property of the receiver.

		HRESULT __stdcall IsUserInitiated(
			[out, retval]long* IsUserInitiated);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

get_PermissionKind: permissionKind
	"Private - Get the value of the 'PermissionKind' property of the receiver.

		HRESULT __stdcall PermissionKind(
			[out, retval]COREWEBVIEW2_PERMISSION_KIND* PermissionKind);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

get_SavesInProfile: value
	"Private - Get the value of the 'SavesInProfile' property of the receiver.

		HRESULT __stdcall SavesInProfile(
			[out, retval]long* value);"

	value value: 0.
	^S_OK!

get_State: state
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval]COREWEBVIEW2_PERMISSION_STATE* State);"

	<virtual stdcall: hresult 7 int32*>
	^self invalidCall: _failureCode!

get_uri: uri
	"Private - Get the value of the 'uri' property of the receiver.

		HRESULT __stdcall uri(
			[out, retval]LPWSTR* uri);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 9 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

handled
	"Answer whether this event is considered to have  been handled already."

	| answer |
	answer := ByteArray new: 4.
	self get_Handled: answer.
	^(answer int32AtOffset: 0) ~~ 0!

handled: aBoolean
	"Set whether this event is considered as having been handled already."

	self put_Handled: aBoolean asParameter!

isUserInitiated
	"Answer the <Boolean> value of the 'IsUserInitiated' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsUserInitiated: buf.
	^buf asBoolean!

permissionKind
	"Answer the <sdword> value of the 'PermissionKind' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_PermissionKind: answer.
	^answer asObject!

permissionName
	"Answer a <String> identifying the permission requested."

	^(ICoreWebView2PermissionSetting.PermissionNames lookup: self permissionKind) ?? 'UnknownPermission'!

printableProperties
	^#(#isUserInitiated #permissionName #savesInProfile #uri)!

put_Handled: handled
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <sdword> argument, handled.

		HRESULT __stdcall Handled(
			[in]long Handled);"

	^E_NOTIMPL!

put_SavesInProfile: value
	"Private - Set the value of the 'SavesInProfile' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall SavesInProfile(
			[in]long value);"

	^E_NOTIMPL!

put_State: state
	"Private - Set the value of the 'State' property of the object wrapped by the 
	 receiver to the <sdword> argument, state.

		HRESULT __stdcall State(
			[in]COREWEBVIEW2_PERMISSION_STATE State);"

	<virtual stdcall: hresult 8 int32>
	^self invalidCall: _failureCode!

savesInProfile
	"Answer the <boolean> value of the 'SavesInProfile' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_SavesInProfile: buf.
	^buf asBoolean!

savesInProfile: value
	"Set the 'SavesInProfile' property of the receiver to the <boolean> argument."

	self put_SavesInProfile: value asParameter!

state
	"Answer the <sdword> value of the 'State' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_State: answer.
	^answer asObject!

state: state
	"Set the 'State' property of the receiver to the <sdword> value of the argument."

	self put_State: state!

uri
	"Answer the <lpwstr> value of the 'uri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_uri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesForMethods!
get_Handled:!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs2!private! !
get_IsUserInitiated:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
get_PermissionKind:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
get_SavesInProfile:!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs3!private! !
get_State:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
get_uri:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
handled!properties!public! !
handled:!properties!public! !
isUserInitiated!properties!public! !
permissionKind!**auto generated**!properties!public! !
permissionName!properties!public! !
printableProperties!printing!private! !
put_Handled:!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs2!private! !
put_SavesInProfile:!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs3!private! !
put_State:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
savesInProfile!properties!public! !
savesInProfile:!properties!public! !
state!**auto generated**!properties!public! !
state:!**auto generated**!properties!public! !
uri!properties!public! !
!

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
!WebView2.ICoreWebView2PermissionRequestedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

