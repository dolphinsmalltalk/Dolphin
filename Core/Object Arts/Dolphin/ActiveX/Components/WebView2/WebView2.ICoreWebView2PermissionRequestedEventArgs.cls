﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2PermissionRequestedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'StateNames' -> #('Default' 'Allow' 'Deny') }!

WebView2.ICoreWebView2PermissionRequestedEventArgs guid: (OS.COM.IID fromString: '{973ae2ef-ff18-4894-8fb2-3c758f046810}')!

WebView2.ICoreWebView2PermissionRequestedEventArgs isEgressOnly: true!

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

isUserInitiated
	"Answer the <Boolean> value of the 'IsUserInitiated' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsUserInitiated: buf.
	^buf asBoolean!

permissionKind
	"Answer the COREWEBVIEW2_PERMISSION_KIND enumeration value of the 'PermissionKind' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_PermissionKind: buf.
	^buf asSignedInteger!

permissionName
	"Answer a <String> identifying the permission requested."

	^(ICoreWebView2PermissionSetting.PermissionNames lookup: self permissionKind) ?? 'UnknownPermission'!

permissionState
	"Answer a 3-state <boolean>|nil value (i.e. true|false|nil) that is the state of the requested permission.
		- If the permission is explicitly allowed, the answer is true.
		- If the permission is explicity denied, the answer is false.
		- If the permission has no explicit setting (i.e. it is the default) the answer is nil, indicating it is not set.

	The initial state of the permission will usually be defaulted, although permissions may be requested at frame and page level, in that order, and if the frame permission request changed the permission state then this will be the initial state when the page permission request is received."

	| state |
	state := self state.
	^state == 0 ifFalse: [(state - 1) asBoolean]!

permissionState: aBooleanOrNil
	"Set the state of the requested permission:
		- If the argument is true, the permission is explicitly allowed.
		- If the argument is false, the permission is explicity denied.
		- If the argument is nil, the permission is defaulted (not set)."

	"COREWEBVIEW2_PERMISSION_STATE_DEFAULT = 0
	COREWEBVIEW2_PERMISSION_STATE_ALLOW =	 1
	COREWEBVIEW2_PERMISSION_STATE_DENY  =	 2"

	self state: COREWEBVIEW2_PERMISSION_STATE_DENY
				- (aBooleanOrNil ?? COREWEBVIEW2_PERMISSION_STATE_DENY) asInteger!

printableProperties
	^#(#isUserInitiated #permissionName #stateName #savesInProfile #uri)!

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

savesInProfile: aBoolean
	"Set the 'SavesInProfile' property of the receiver to the <boolean> argument."

	self put_SavesInProfile: aBoolean asParameter!

state
	"Answer the COREWEBVIEW2_PERMISSION_STATE enum value of the 'State' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_State: buf.
	^buf asSignedInteger!

state: state
	"Set the 'State' property of the receiver to the COREWEBVIEW2_PERMISSION_STATE enum value of the argument."

	self put_State: state!

stateName
	"Answer the <readableString> name of the receiver's permission state."

	^(StateNames lookup: self state + 1) ?? 'Unknown'!

uri
	"Answer the <lpwstr> value of the 'uri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_uri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !

!WebView2.ICoreWebView2PermissionRequestedEventArgs categoriesForMethods!
get_IsUserInitiated:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
get_PermissionKind:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
get_SavesInProfile:!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs3!private! !
get_State:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
get_uri:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
isUserInitiated!properties!public! !
permissionKind!properties!public! !
permissionName!properties!public! !
permissionState!properties!public! !
permissionState:!properties!public! !
printableProperties!printing!private! !
put_SavesInProfile:!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs3!private! !
put_State:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs!private! !
savesInProfile!properties!public! !
savesInProfile:!properties!public! !
state!properties!public! !
state:!properties!public! !
stateName!printing!properties!public! !
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
!

latestDerivation
	^##(super latestDerivation)! !

!WebView2.ICoreWebView2PermissionRequestedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
latestDerivation!enquiries!public! !
!

