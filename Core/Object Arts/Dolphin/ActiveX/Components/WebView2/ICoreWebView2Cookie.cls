"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2Cookie
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2Cookie guid: (IID fromString: '{ad26d6be-1486-43e6-bf87-a2034006ca21}')!
ICoreWebView2Cookie comment: '`ICoreWebView2Cookie` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Cookie'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ad26d6be-1486-43e6-bf87-a2034006ca21)
]
interface ICoreWebView2Cookie : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall name(
		[out, retval]LPWSTR* name);
	[id(0x60010001), propget]
	HRESULT __stdcall value(
		[out, retval]LPWSTR* value);
	[id(0x60010001), propput]
	HRESULT __stdcall value(
		[in]LPWSTR value);
	[id(0x60010003), propget]
	HRESULT __stdcall Domain(
		[out, retval]LPWSTR* Domain);
	[id(0x60010004), propget]
	HRESULT __stdcall Path(
		[out, retval]LPWSTR* Path);
	[id(0x60010005), propget]
	HRESULT __stdcall Expires(
		[out, retval]double* Expires);
	[id(0x60010005), propput]
	HRESULT __stdcall Expires(
		[in]double Expires);
	[id(0x60010007), propget]
	HRESULT __stdcall IsHttpOnly(
		[out, retval]long* IsHttpOnly);
	[id(0x60010007), propput]
	HRESULT __stdcall IsHttpOnly(
		[in]long IsHttpOnly);
	[id(0x60010009), propget]
	HRESULT __stdcall SameSite(
		[out, retval]COREWEBVIEW2_COOKIE_SAME_SITE_KIND* SameSite);
	[id(0x60010009), propput]
	HRESULT __stdcall SameSite(
		[in]COREWEBVIEW2_COOKIE_SAME_SITE_KIND SameSite);
	[id(0x6001000b), propget]
	HRESULT __stdcall IsSecure(
		[out, retval]long* IsSecure);
	[id(0x6001000b), propput]
	HRESULT __stdcall IsSecure(
		[in]long IsSecure);
	[id(0x6001000d), propget]
	HRESULT __stdcall IsSession(
		[out, retval]long* IsSession);
};
```
'!
!ICoreWebView2Cookie categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Cookie methodsFor!

domain
	"Answer the <lpwstr> value of the 'Domain' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_Domain: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

expires
	"Answer the <double> value of the 'Expires' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_Expires: answer.
	^DateAndTime fromUnixTime: answer value asInteger!

expires: aDateAndTime
	"Set the 'Expires' property of the receiver to the <double> value of the argument."

	self put_Expires: aDateAndTime asUnixTime!

get_Domain: domain
	"Private - Get the value of the 'Domain' property of the receiver.

		HRESULT __stdcall Domain(
			[out, retval]LPWSTR* Domain);"

	<virtual stdcall: hresult 7 lpwstr*>
	^self invalidCall: _failureCode!

get_Expires: expires
	"Private - Get the value of the 'Expires' property of the receiver.

		HRESULT __stdcall Expires(
			[out, retval]double* Expires);"

	<virtual stdcall: hresult 9 double*>
	^self invalidCall: _failureCode!

get_IsHttpOnly: isHttpOnly
	"Private - Get the value of the 'IsHttpOnly' property of the receiver.

		HRESULT __stdcall IsHttpOnly(
			[out, retval]long* IsHttpOnly);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

get_IsSecure: isSecure
	"Private - Get the value of the 'IsSecure' property of the receiver.

		HRESULT __stdcall IsSecure(
			[out, retval]long* IsSecure);"

	<virtual stdcall: hresult 15 sdword*>
	^self invalidCall: _failureCode!

get_IsSession: isSession
	"Private - Get the value of the 'IsSession' property of the receiver.

		HRESULT __stdcall IsSession(
			[out, retval]long* IsSession);"

	<virtual stdcall: hresult 17 sdword*>
	^self invalidCall: _failureCode!

get_name: name
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]LPWSTR* name);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_Path: path
	"Private - Get the value of the 'Path' property of the receiver.

		HRESULT __stdcall Path(
			[out, retval]LPWSTR* Path);"

	<virtual stdcall: hresult 8 lpwstr*>
	^self invalidCall: _failureCode!

get_SameSite: sameSite
	"Private - Get the value of the 'SameSite' property of the receiver.

		HRESULT __stdcall SameSite(
			[out, retval]COREWEBVIEW2_COOKIE_SAME_SITE_KIND* SameSite);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall: _failureCode!

get_value: value
	"Private - Get the value of the 'value' property of the receiver.

		HRESULT __stdcall value(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

isHttpOnly
	"Answer the <Boolean> value of the 'IsHttpOnly' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsHttpOnly: answer.
	^answer asObject!

isHttpOnly: isHttpOnly
	"Set the 'IsHttpOnly' property of the receiver to the <sdword> value of the argument."

	self put_IsHttpOnly: isHttpOnly asParameter!

isSecure
	"Answer the <Boolean> value of the 'IsSecure' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsSecure: answer.
	^answer asObject!

isSecure: isSecure
	"Set the 'IsSecure' property of the receiver to the <sdword> value of the argument."

	self put_IsSecure: isSecure asParameter!

isSession
	"Answer the <Boolean> value of the 'IsSession' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsSession: answer.
	^answer asObject!

name
	"Answer the <lpwstr> value of the 'name' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_name: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

path
	"Answer the <lpwstr> value of the 'Path' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_Path: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

printableProperties
	| propertyNames |
	propertyNames := OrderedCollection withAll: #(#domain #name).
	self isSession ifFalse: [propertyNames add: #expires].
	self isHttpOnly ifTrue: [propertyNames add: #isHttpOnly].
	self isSecure ifTrue: [propertyNames add: #isSecure].
	self sameSite ifFalse: [propertyNames add: #sameSite].
	self path = '/' ifFalse: [propertyNames add: #path].
	^propertyNames!

put_Expires: expires
	"Private - Set the value of the 'Expires' property of the object wrapped by the 
	 receiver to the <double> argument, expires.

		HRESULT __stdcall Expires(
			[in]double Expires);"

	<virtual stdcall: hresult 10 double>
	^self invalidCall: _failureCode!

put_IsHttpOnly: isHttpOnly
	"Private - Set the value of the 'IsHttpOnly' property of the object wrapped by the 
	 receiver to the <sdword> argument, isHttpOnly.

		HRESULT __stdcall IsHttpOnly(
			[in]long IsHttpOnly);"

	<virtual stdcall: hresult 12 sdword>
	^self invalidCall: _failureCode!

put_IsSecure: isSecure
	"Private - Set the value of the 'IsSecure' property of the object wrapped by the 
	 receiver to the <sdword> argument, isSecure.

		HRESULT __stdcall IsSecure(
			[in]long IsSecure);"

	<virtual stdcall: hresult 16 sdword>
	^self invalidCall: _failureCode!

put_SameSite: sameSite
	"Private - Set the value of the 'SameSite' property of the object wrapped by the 
	 receiver to the <sdword> argument, sameSite.

		HRESULT __stdcall SameSite(
			[in]COREWEBVIEW2_COOKIE_SAME_SITE_KIND SameSite);"

	<virtual stdcall: hresult 14 sdword>
	^self invalidCall: _failureCode!

put_value: value
	"Private - Set the value of the 'value' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall value(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 6 lpwstr>
	^self invalidCall: _failureCode!

sameSite
	"Answer the <Boolean> value of the 'SameSite' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_SameSite: answer.
	^answer asObject!

sameSite: sameSite
	"Set the 'SameSite' property of the receiver to the <sdword> value of the argument."

	self put_SameSite: sameSite asParameter!

value
	"Answer the <lpwstr> value of the 'value' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_value: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

value: value
	"Set the 'value' property of the receiver to the <lpwstr> value of the argument."

	self put_value: value asUtf16String! !
!ICoreWebView2Cookie categoriesForMethods!
domain!properties!public! !
expires!properties!public! !
expires:!properties!public! !
get_Domain:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
get_Expires:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
get_IsHttpOnly:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
get_IsSecure:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
get_IsSession:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
get_name:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
get_Path:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
get_SameSite:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
get_value:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
isHttpOnly!properties!public! !
isHttpOnly:!properties!public! !
isSecure!properties!public! !
isSecure:!properties!public! !
isSession!properties!public! !
name!properties!public! !
path!properties!public! !
printableProperties!printing!private! !
put_Expires:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
put_IsHttpOnly:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
put_IsSecure:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
put_SameSite:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
put_value:!**auto generated**!COM Interfaces-ICoreWebView2Cookie!private! !
sameSite!properties!public! !
sameSite:!properties!public! !
value!properties!public! !
value:!**auto generated**!properties!public! !
!

!ICoreWebView2Cookie class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Cookie'
		ICoreWebView2Cookie defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_value:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_value:
			argumentTypes: 'lpwstr';
		defineFunction: #get_Domain:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Path:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Expires:
			argumentTypes: 'double*';
		defineFunction: #put_Expires:
			argumentTypes: 'double';
		defineFunction: #get_IsHttpOnly:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsHttpOnly:
			argumentTypes: 'sdword';
		defineFunction: #get_SameSite:
			argumentTypes: 'sdword*';
		defineFunction: #put_SameSite:
			argumentTypes: 'sdword';
		defineFunction: #get_IsSecure:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsSecure:
			argumentTypes: 'sdword';
		defineFunction: #get_IsSession:
			argumentTypes: 'sdword*'
! !
!ICoreWebView2Cookie class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

