"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2Frame
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2Frame guid: (IID fromString: '{f1131a5e-9ba9-11eb-a8b3-0242ac130003}')!
ICoreWebView2Frame comment: '`ICoreWebView2Frame` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Frame'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f1131a5e-9ba9-11eb-a8b3-0242ac130003)
]
interface ICoreWebView2Frame : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall name(
		[out, retval]LPWSTR* name);
	[id(0x60010001)]
	HRESULT __stdcall add_NameChanged(
		[in]ICoreWebView2FrameNameChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010002)]
	HRESULT __stdcall remove_NameChanged(
		[in]EventRegistrationToken token);
	[id(0x60010003)]
	HRESULT __stdcall AddHostObjectToScriptWithOrigins(
		[in]LPWSTR name,
		[in]VARIANT* object,
		[in]unsigned int originsCount,
		[in]LPWSTR* origins);
	[id(0x60010004)]
	HRESULT __stdcall RemoveHostObjectFromScript(
		[in]LPWSTR name);
	[id(0x60010005)]
	HRESULT __stdcall add_Destroyed(
		[in]ICoreWebView2FrameDestroyedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010006)]
	HRESULT __stdcall remove_Destroyed(
		[in]EventRegistrationToken token);
	[id(0x60010007)]
	HRESULT __stdcall IsDestroyed(
		[out, retval]long* destroyed);
};
```
'!
!ICoreWebView2Frame categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Frame methodsFor!

add_Destroyed: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_Destroyed() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_Destroyed: eventHandler token: answer.
	^answer asObject!

Add_Destroyed: eventHandler token: token
	"Private - Invoke the add_Destroyed() method of the COM object.

		HRESULT __stdcall add_Destroyed(
			[in]ICoreWebView2FrameDestroyedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 9 ICoreWebView2FrameDestroyedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_NameChanged: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_NameChanged() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_NameChanged: eventHandler token: answer.
	^answer asObject!

Add_NameChanged: eventHandler token: token
	"Private - Invoke the add_NameChanged() method of the COM object.

		HRESULT __stdcall add_NameChanged(
			[in]ICoreWebView2FrameNameChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 5 ICoreWebView2FrameNameChangedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

addHostObjectToScriptWithOrigins: name object: object originsCount: originsCount origins: origins
	"Invoke the AddHostObjectToScriptWithOrigins() method of the COM object."

	^self
		AddHostObjectToScriptWithOrigins: name asUtf16String
		object: object asVariant
		originsCount: originsCount
		origins: origins asUtf16String!

AddHostObjectToScriptWithOrigins: name object: object originsCount: originsCount origins: origins
	"Private - Invoke the AddHostObjectToScriptWithOrigins() method of the COM object.

		HRESULT __stdcall AddHostObjectToScriptWithOrigins(
			[in]LPWSTR name,
			[in]VARIANT* object,
			[in]unsigned int originsCount,
			[in]LPWSTR* origins);"

	<virtual stdcall: hresult 7 lpwstr variant* dword lpwstr*>
	^self invalidCall: _failureCode!

get_name: name
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]LPWSTR* name);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

isDestroyed
	"Answer the <SDWORD> result of invoking the IsDestroyed() method of the COM object."

	| answer |
	answer := SDWORD new.
	self IsDestroyed: answer.
	^answer asObject!

IsDestroyed: destroyed
	"Private - Invoke the IsDestroyed() method of the COM object.

		HRESULT __stdcall IsDestroyed(
			[out, retval]long* destroyed);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

name
	"Answer the <lpwstr> value of the 'name' property of the receiver."

	| answer |
	answer := StructurePointer newNull: COMTaskMemory elementClass: Utf16String.
	self get_name: answer.
	^answer asObject!

remove_Destroyed: token
	"Invoke the remove_Destroyed() method of the COM object."

	^self Remove_Destroyed: token!

Remove_Destroyed: token
	"Private - Invoke the remove_Destroyed() method of the COM object.

		HRESULT __stdcall remove_Destroyed(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 10 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_NameChanged: token
	"Invoke the remove_NameChanged() method of the COM object."

	^self Remove_NameChanged: token!

Remove_NameChanged: token
	"Private - Invoke the remove_NameChanged() method of the COM object.

		HRESULT __stdcall remove_NameChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 6 EventRegistrationToken>
	^self invalidCall: _failureCode!

removeHostObjectFromScript: name
	"Invoke the RemoveHostObjectFromScript() method of the COM object."

	^self RemoveHostObjectFromScript: name asUtf16String!

RemoveHostObjectFromScript: name
	"Private - Invoke the RemoveHostObjectFromScript() method of the COM object.

		HRESULT __stdcall RemoveHostObjectFromScript(
			[in]LPWSTR name);"

	<virtual stdcall: hresult 8 lpwstr>
	^self invalidCall: _failureCode! !
!ICoreWebView2Frame categoriesForMethods!
add_Destroyed:!**auto generated**!methods!public! !
Add_Destroyed:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private! !
add_NameChanged:!**auto generated**!methods!public! !
Add_NameChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private! !
addHostObjectToScriptWithOrigins:object:originsCount:origins:!**auto generated**!methods!public! !
AddHostObjectToScriptWithOrigins:object:originsCount:origins:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private! !
get_name:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private! !
isDestroyed!**auto generated**!methods!public! !
IsDestroyed:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private! !
name!**auto generated**!properties!public! !
remove_Destroyed:!**auto generated**!methods!public! !
Remove_Destroyed:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private! !
remove_NameChanged:!**auto generated**!methods!public! !
Remove_NameChanged:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private! !
removeHostObjectFromScript:!**auto generated**!methods!public! !
RemoveHostObjectFromScript:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private! !
!

!ICoreWebView2Frame class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Frame'
		ICoreWebView2Frame defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'lpwstr*';
		defineFunction: #Add_NameChanged:token:
			argumentTypes: 'ICoreWebView2FrameNameChangedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_NameChanged:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #AddHostObjectToScriptWithOrigins:object:originsCount:origins:
			argumentTypes: 'lpwstr variant* dword lpwstr*';
		defineFunction: #RemoveHostObjectFromScript:
			argumentTypes: 'lpwstr';
		defineFunction: #Add_Destroyed:token:
			argumentTypes: 'ICoreWebView2FrameDestroyedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_Destroyed:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #IsDestroyed:
			argumentTypes: 'sdword*'
! !
!ICoreWebView2Frame class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

