"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IPerPropertyBrowsing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IPerPropertyBrowsing guid: (IID fromString: '{376bd3aa-3845-101b-84ed-08002b2ec713}')!
IPerPropertyBrowsing comment: '`IPerPropertyBrowsing` is a wrapper class for the COM interface ''Win32.IPerPropertyBrowsing'' generated from type information in the ''Win32 API'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:
```
[
	object, 
	uuid(376bd3aa-3845-101b-84ed-08002b2ec713)
]
interface IPerPropertyBrowsing : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall GetDisplayString(
		[in]long dispID,
		[out]BSTR* pbstr);
	[id(0x60010001)]
	HRESULT __stdcall MapPropertyToPage(
		[in]long dispID,
		[out]GUID* pclsid);
	[id(0x60010002)]
	HRESULT __stdcall GetPredefinedStrings(
		[in]long dispID,
		[out]CALPOLESTR* pCaStringsOut,
		[out]CADWORD* pCaCookiesOut);
	[id(0x60010003)]
	HRESULT __stdcall GetPredefinedValue(
		[in]long dispID,
		[in]DWORD dwCookie,
		[out]VARIANT* pVarOut);
};
```
'!
!IPerPropertyBrowsing categoriesForClass!COM-Interfaces! !
!IPerPropertyBrowsing methodsFor!

getDisplayString: dispID
	"Answer the <BSTR> result of invoking the GetDisplayString() method of the COM object."

	| answer |
	answer := BSTR new.
	self GetDisplayString: dispID pbstr: answer.
	^answer asObject!

GetDisplayString: dispID pbstr: pbstr
	"Private - Invoke the GetDisplayString() method of the COM object.

		HRESULT __stdcall GetDisplayString(
			[in]long dispID,
			[out]BSTR* pbstr);"

	<virtual stdcall: hresult 4 sdword bstr*>
	^self invalidCall: _failureCode!

getPredefinedStrings: dispID
	"Invoke the GetPredefinedStrings() method of the COM object."

	| outputs |
	outputs := {CALPOLESTR new. CADWORD new}.
	self
		GetPredefinedStrings: dispID
		pCaStringsOut: (outputs basicAt: 1)
		pCaCookiesOut: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetPredefinedStrings: dispID pCaStringsOut: pCaStringsOut pCaCookiesOut: pCaCookiesOut
	"Private - Invoke the GetPredefinedStrings() method of the COM object.

		HRESULT __stdcall GetPredefinedStrings(
			[in]long dispID,
			[out]CALPOLESTR* pCaStringsOut,
			[out]CADWORD* pCaCookiesOut);"

	<virtual stdcall: hresult 6 sdword CALPOLESTR* CADWORD*>
	^self invalidCall: _failureCode!

getPredefinedValue: dispID dwCookie: dwCookie
	"Answer the <VARIANT> result of invoking the GetPredefinedValue() method of the COM object."

	| answer |
	answer := VARIANT new.
	self
		GetPredefinedValue: dispID
		dwCookie: dwCookie
		pVarOut: answer.
	^answer asObject!

GetPredefinedValue: dispID dwCookie: dwCookie pVarOut: pVarOut
	"Private - Invoke the GetPredefinedValue() method of the COM object.

		HRESULT __stdcall GetPredefinedValue(
			[in]long dispID,
			[in]DWORD dwCookie,
			[out]VARIANT* pVarOut);"

	<virtual stdcall: hresult 7 sdword dword variant*>
	^self invalidCall: _failureCode!

getStringsAndValues: anInteger
	"Private - Answer an <Array> of <Association>'s between <readableString> value display names
	and the <VARIANT> values associated with those display names for the property with the
	specified <integer> dispatch id."

	| stringsAndCookies answer strings cookies var count |
	stringsAndCookies := self getPredefinedStrings: anInteger.
	strings := stringsAndCookies first.
	cookies := stringsAndCookies last.
	count := cookies size.
	answer := Array new: count.
	count == 0
		ifFalse: 
			[var := (VARIANT new)
						beUnfinalizable;
						yourself.
			strings keysAndValuesDo: 
					[:i :string |
					self
						GetPredefinedValue: anInteger
						dwCookie: (cookies at: i)
						pVarOut: var.
					answer at: i put: string asString -> var value.
					var basicFree]].
	strings free.
	cookies free.
	^answer!

mapPropertyToPage: dispID
	"Answer the <GUID> result of invoking the MapPropertyToPage() method of the COM object."

	| answer |
	answer := GUID new.
	self MapPropertyToPage: dispID pclsid: answer.
	^answer asObject!

MapPropertyToPage: dispID pclsid: pclsid
	"Private - Invoke the MapPropertyToPage() method of the COM object.

		HRESULT __stdcall MapPropertyToPage(
			[in]long dispID,
			[out]GUID* pclsid);"

	<virtual stdcall: hresult 5 sdword guid*>
	^self invalidCall: _failureCode!

stringsToValues: dispid
	"Answer an <LookupTable> mapping between <readableString> value display names 
	and the <VARIANT> values associated with those display names for the property with 
	<integer> dispatch id, dispid."

	^Dictionary withAll: (self getStringsAndValues: dispid)
! !
!IPerPropertyBrowsing categoriesFor: #getDisplayString:!**auto generated**!methods!public! !
!IPerPropertyBrowsing categoriesFor: #GetDisplayString:pbstr:!**auto generated**!COM Interfaces-IPerPropertyBrowsing!private! !
!IPerPropertyBrowsing categoriesFor: #getPredefinedStrings:!**auto generated**!methods!public! !
!IPerPropertyBrowsing categoriesFor: #GetPredefinedStrings:pCaStringsOut:pCaCookiesOut:!**auto generated**!COM Interfaces-IPerPropertyBrowsing!private! !
!IPerPropertyBrowsing categoriesFor: #getPredefinedValue:dwCookie:!**auto generated**!methods!public! !
!IPerPropertyBrowsing categoriesFor: #GetPredefinedValue:dwCookie:pVarOut:!**auto generated**!COM Interfaces-IPerPropertyBrowsing!private! !
!IPerPropertyBrowsing categoriesFor: #getStringsAndValues:!accessing!private! !
!IPerPropertyBrowsing categoriesFor: #mapPropertyToPage:!**auto generated**!methods!public! !
!IPerPropertyBrowsing categoriesFor: #MapPropertyToPage:pclsid:!**auto generated**!COM Interfaces-IPerPropertyBrowsing!private! !
!IPerPropertyBrowsing categoriesFor: #stringsToValues:!accessing!public! !

IPerPropertyBrowsing methodProtocol: #IPerPropertyBrowsing attributes: #(#readOnly) selectors: #(#GetDisplayString:pbstr: #GetPredefinedStrings:pCaStringsOut:pCaCookiesOut: #GetPredefinedValue:dwCookie:pVarOut: #MapPropertyToPage:pclsid:)!

!IPerPropertyBrowsing class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IPerPropertyBrowsing'
		IPerPropertyBrowsing defineTemplate
	"

	self
		defineFunction: #GetDisplayString:pBstr:
			argumentTypes: 'sdword bstr*';
		defineFunction: #MapPropertyToPage:pClsid:
			argumentTypes: 'sdword GUID*';
		defineFunction: #GetPredefinedStrings:pCaStringsOut:pCaCookiesOut:
			returnType: 'sdword'
			argumentTypes: 'sdword CALPOLESTR* CADWORD*';
		defineFunction: #GetPredefinedValue:dwCookie:pVarOut:
			argumentTypes: 'sdword dword VARIANT*'
! !
!IPerPropertyBrowsing class categoriesFor: #defineFunctions!initializing!public! !

