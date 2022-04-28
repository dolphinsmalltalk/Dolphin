﻿"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2Frame
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
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

Add_ContentLoading: eventHandler token: token
	"Private - Invoke the add_ContentLoading() method of the COM object.

		HRESULT __stdcall add_ContentLoading(
			[in]ICoreWebView2FrameContentLoadingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	^E_NOTIMPL!

Add_Destroyed: eventHandler token: token
	"Private - Invoke the add_Destroyed() method of the COM object.

		HRESULT __stdcall add_Destroyed(
			[in]ICoreWebView2FrameDestroyedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 9 ICoreWebView2FrameDestroyedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_DOMContentLoaded: eventHandler token: token
	"Private - Invoke the add_DOMContentLoaded() method of the COM object.

		HRESULT __stdcall add_DOMContentLoaded(
			[in]ICoreWebView2FrameDOMContentLoadedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	^E_NOTIMPL!

Add_NameChanged: eventHandler token: token
	"Private - Invoke the add_NameChanged() method of the COM object.

		HRESULT __stdcall add_NameChanged(
			[in]ICoreWebView2FrameNameChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 5 ICoreWebView2FrameNameChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_NavigationCompleted: eventHandler token: token
	"Private - Invoke the add_NavigationCompleted() method of the COM object.

		HRESULT __stdcall add_NavigationCompleted(
			[in]ICoreWebView2FrameNavigationCompletedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	^E_NOTIMPL!

Add_NavigationStarting: eventHandler token: token
	"Private - Invoke the add_NavigationStarting() method of the COM object.

		HRESULT __stdcall add_NavigationStarting(
			[in]ICoreWebView2FrameNavigationStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	^E_NOTIMPL!

Add_WebMessageReceived: handler token: token
	"Private - Invoke the add_WebMessageReceived() method of the COM object.

		HRESULT __stdcall add_WebMessageReceived(
			[in]ICoreWebView2FrameWebMessageReceivedEventHandler* handler,
			[out]EventRegistrationToken* token);"

	^E_NOTIMPL!

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

ExecuteScript: javaScript handler: handler
	"Private - Invoke the ExecuteScript() method of the COM object.

		HRESULT __stdcall ExecuteScript(
			[in]LPWSTR javaScript,
			[in]ICoreWebView2ExecuteScriptCompletedHandler* handler);"

	^E_NOTIMPL!

executeScript: aString thenDo: aDyadicValuable
	"See the same method of ICoreWebView2"

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2ExecuteScriptCompletedHandler.
	self ExecuteScript: aString asUtf16String handler: handler.
	handler free!

get_name: name
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]LPWSTR* name);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

isDestroyed
	"Answer the <Boolean> result of invoking the IsDestroyed() method of the COM object."

	| answer |
	answer := BOOL newBuffer.
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

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_name: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

postWebMessageAsJson: webMessageAsJson
	"Invoke the PostWebMessageAsJson() method of the COM object."

	^self PostWebMessageAsJson: webMessageAsJson asUtf16String!

PostWebMessageAsJson: webMessageAsJson
	"Private - Invoke the PostWebMessageAsJson() method of the COM object.

		HRESULT __stdcall PostWebMessageAsJson(
			[in]LPWSTR webMessageAsJson);"

	^E_NOTIMPL!

postWebMessageAsString: webMessageAsString
	"Invoke the PostWebMessageAsString() method of the COM object."

	^self PostWebMessageAsString: webMessageAsString asUtf16String!

PostWebMessageAsString: webMessageAsString
	"Private - Invoke the PostWebMessageAsString() method of the COM object.

		HRESULT __stdcall PostWebMessageAsString(
			[in]LPWSTR webMessageAsString);"

	^E_NOTIMPL!

printableProperties
	^#(#name #isDestroyed)!

Remove_ContentLoading: token
	"Private - Invoke the remove_ContentLoading() method of the COM object.

		HRESULT __stdcall remove_ContentLoading(
			[in]EventRegistrationToken token);"

	^E_NOTIMPL!

Remove_Destroyed: token
	"Private - Invoke the remove_Destroyed() method of the COM object.

		HRESULT __stdcall remove_Destroyed(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 10 sqword>
	^self invalidCall: _failureCode!

Remove_DOMContentLoaded: token
	"Private - Invoke the remove_DOMContentLoaded() method of the COM object.

		HRESULT __stdcall remove_DOMContentLoaded(
			[in]EventRegistrationToken token);"

	^E_NOTIMPL!

Remove_NameChanged: token
	"Private - Invoke the remove_NameChanged() method of the COM object.

		HRESULT __stdcall remove_NameChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 6 sqword>
	^self invalidCall: _failureCode!

Remove_NavigationCompleted: token
	"Private - Invoke the remove_NavigationCompleted() method of the COM object.

		HRESULT __stdcall remove_NavigationCompleted(
			[in]EventRegistrationToken token);"

	^E_NOTIMPL!

Remove_NavigationStarting: token
	"Private - Invoke the remove_NavigationStarting() method of the COM object.

		HRESULT __stdcall remove_NavigationStarting(
			[in]EventRegistrationToken token);"

	^E_NOTIMPL!

Remove_WebMessageReceived: token
	"Private - Invoke the remove_WebMessageReceived() method of the COM object.

		HRESULT __stdcall remove_WebMessageReceived(
			[in]EventRegistrationToken token);"

	^E_NOTIMPL!

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
Add_ContentLoading:token:!COM Interfaces-ICoreWebView2Frame2!events!private! !
Add_Destroyed:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame!events!private! !
Add_DOMContentLoaded:token:!COM Interfaces-ICoreWebView2Frame2!events!private! !
Add_NameChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame!events!private! !
Add_NavigationCompleted:token:!COM Interfaces-ICoreWebView2Frame2!events!private! !
Add_NavigationStarting:token:!COM Interfaces-ICoreWebView2Frame2!events!private! !
Add_WebMessageReceived:token:!COM Interfaces-ICoreWebView2Frame2!events!private! !
addHostObjectToScriptWithOrigins:object:originsCount:origins:!**auto generated**!methods!public! !
AddHostObjectToScriptWithOrigins:object:originsCount:origins:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private! !
ExecuteScript:handler:!COM Interfaces-ICoreWebView2Frame2!methods!private! !
executeScript:thenDo:!methods!public! !
get_name:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private!properties! !
isDestroyed!methods!public! !
IsDestroyed:!**auto generated**!COM Interfaces-ICoreWebView2Frame!methods!private! !
name!properties!public! !
postWebMessageAsJson:!**auto generated**!methods!public! !
PostWebMessageAsJson:!COM Interfaces-ICoreWebView2Frame2!methods!private! !
postWebMessageAsString:!**auto generated**!methods!public! !
PostWebMessageAsString:!COM Interfaces-ICoreWebView2Frame2!methods!private! !
printableProperties!printing!private! !
Remove_ContentLoading:!COM Interfaces-ICoreWebView2Frame2!events!private! !
Remove_Destroyed:!**auto generated**!COM Interfaces-ICoreWebView2Frame!events!private! !
Remove_DOMContentLoaded:!COM Interfaces-ICoreWebView2Frame2!events!private! !
Remove_NameChanged:!**auto generated**!COM Interfaces-ICoreWebView2Frame!events!private! !
Remove_NavigationCompleted:!COM Interfaces-ICoreWebView2Frame2!events!private! !
Remove_NavigationStarting:!COM Interfaces-ICoreWebView2Frame2!events!private! !
Remove_WebMessageReceived:!COM Interfaces-ICoreWebView2Frame2!events!private! !
removeHostObjectFromScript:!**auto generated**!methods!public! !
RemoveHostObjectFromScript:!**auto generated**!COM Interfaces-ICoreWebView2Frame!private! !
!

ICoreWebView2Frame methodProtocol: #ICoreWebView2Frame attributes: #(#readOnly) selectors: #(#Add_Destroyed:token: #Add_NameChanged:token: #AddHostObjectToScriptWithOrigins:object:originsCount:origins: #get_name: #IsDestroyed: #Remove_Destroyed: #Remove_NameChanged: #RemoveHostObjectFromScript:)!
ICoreWebView2Frame methodProtocol: #ICoreWebView2Frame2 attributes: #(#readOnly) selectors: #(#Add_ContentLoading:token: #Add_Destroyed:token: #Add_DOMContentLoaded:token: #Add_NameChanged:token: #Add_NavigationCompleted:token: #Add_NavigationStarting:token: #Add_WebMessageReceived:token: #AddHostObjectToScriptWithOrigins:object:originsCount:origins: #ExecuteScript:handler: #get_name: #IsDestroyed: #PostWebMessageAsJson: #PostWebMessageAsString: #Remove_ContentLoading: #Remove_Destroyed: #Remove_DOMContentLoaded: #Remove_NameChanged: #Remove_NavigationCompleted: #Remove_NavigationStarting: #Remove_WebMessageReceived: #RemoveHostObjectFromScript:)!

!ICoreWebView2Frame class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Frame'
		ICoreWebView2Frame defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'lpwstr*';
		defineFunction: #Add_NameChanged:token:
			argumentTypes: 'ICoreWebView2FrameNameChangedEventHandler* sqword*';
		defineFunction: #Remove_NameChanged:
			argumentTypes: 'sqword';
		defineFunction: #AddHostObjectToScriptWithOrigins:object:originsCount:origins:
			argumentTypes: 'lpwstr variant* dword lpwstr*';
		defineFunction: #RemoveHostObjectFromScript:
			argumentTypes: 'lpwstr';
		defineFunction: #Add_Destroyed:token:
			argumentTypes: 'ICoreWebView2FrameDestroyedEventHandler* sqword*';
		defineFunction: #Remove_Destroyed:
			argumentTypes: 'sqword';
		defineFunction: #IsDestroyed:
			argumentTypes: 'bool*'
! !
!ICoreWebView2Frame class categoriesForMethods!
defineFunctions!initializing!public! !
!
