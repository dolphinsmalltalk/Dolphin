"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IPerPropertyBrowsing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IPerPropertyBrowsing guid: (IID fromString: '{376BD3AA-3845-101B-84ED-08002B2EC713}')!
IPerPropertyBrowsing comment: '<IPerPropertyBrowsing> is a wrapper class for the COM interface ''OCIDL.IPerPropertyBrowsing'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IPerPropertyBrowsing categoriesForClass!ActiveX Automation! !
!IPerPropertyBrowsing methodsFor!

getDisplayString: dispID 
	"Answer <readableString> describing the property identified with dispID in the caller's user interface. 
	If no information is available, answer nil."

	| answer |
	answer := BSTR new.
	self
		GetDisplayString: dispID
		pBstr: answer.
	^answer isNull ifFalse: [answer asString]!

GetDisplayString: dispID pBstr: pBstr
	"Private - Invoke the GetDisplayString() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetDisplayString(
			[in] long dispID,
			[out] BSTR* pBstr);
	"

	<virtual stdcall: sdword 4 sdword bstr*>
	^self invalidCall
!

getPredefinedStrings: dispID 
	"Invoke the GetPredefinedStrings() method of the COM Object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (CALPOLESTR new);
				basicAt: 2 put: (CADWORD new);
				yourself.
	self
		GetPredefinedStrings: dispID
		pCaStringsOut: (answer basicAt: 1)
		pCaCookiesOut: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetPredefinedStrings: dispID pCaStringsOut: pCaStringsOut pCaCookiesOut: pCaCookiesOut
	"Private - Invoke the GetPredefinedStrings() method of the COM object wrapped by the receiver.
	Implementation Note: Manually modify to ignore the error return code.

		HRESULT __stdcall GetPredefinedStrings(
			[in] long dispID,
			[out] CALPOLESTR* pCaStringsOut,
			[out] CADWORD* pCaCookiesOut);
	"

	<virtual stdcall: sdword  6 sdword CALPOLESTR* CADWORD*>
	^self invalidCall
!

getPredefinedValue: dispID dwCookie: dwCookie 
	"Answer the <VARIANT> result of invoking the COM Object's GetPredefinedValue() method."

	| answer |
	answer := VARIANT new.
	self
		GetPredefinedValue: dispID
		dwCookie: dwCookie
		pVarOut: answer.
	^answer asObject
!

GetPredefinedValue: dispID dwCookie: dwCookie pVarOut: pVarOut
	"Private - Invoke the GetPredefinedValue() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetPredefinedValue(
			[in] long dispID,
			[in] unsigned long dwCookie,
			[out] VARIANT* pVarOut);
	"

	<virtual stdcall: hresult 7 sdword dword VARIANT*>
	^self invalidCall
!

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
	"Answer the <GUID> result of invoking the COM Object's MapPropertyToPage() method."

	| answer |
	answer := GUID new.
	self
		MapPropertyToPage: dispID
		pClsid: answer.
	^answer asObject
!

MapPropertyToPage: dispID pClsid: pClsid
	"Private - Invoke the MapPropertyToPage() method of the COM object wrapped by the receiver.

		HRESULT __stdcall MapPropertyToPage(
			[in] long dispID,
			[out] GUID* pClsid);
	"

	<virtual stdcall: hresult 5 sdword GUID*>
	^self invalidCall
!

stringsToValues: dispid
	"Answer an <LookupTable> mapping between <readableString> value display names 
	and the <VARIANT> values associated with those display names for the property with 
	<integer> dispatch id, dispid."

	^Dictionary withAll: (self getStringsAndValues: dispid)
! !
!IPerPropertyBrowsing categoriesFor: #getDisplayString:!methods!public! !
!IPerPropertyBrowsing categoriesFor: #GetDisplayString:pBstr:!COM Interfaces-IPerPropertyBrowsing!private! !
!IPerPropertyBrowsing categoriesFor: #getPredefinedStrings:!**auto generated**!methods!public! !
!IPerPropertyBrowsing categoriesFor: #GetPredefinedStrings:pCaStringsOut:pCaCookiesOut:!COM Interfaces-IPerPropertyBrowsing!private! !
!IPerPropertyBrowsing categoriesFor: #getPredefinedValue:dwCookie:!**auto generated**!methods!public! !
!IPerPropertyBrowsing categoriesFor: #GetPredefinedValue:dwCookie:pVarOut:!**auto generated**!COM Interfaces-IPerPropertyBrowsing!private! !
!IPerPropertyBrowsing categoriesFor: #getStringsAndValues:!accessing!private! !
!IPerPropertyBrowsing categoriesFor: #mapPropertyToPage:!**auto generated**!methods!public! !
!IPerPropertyBrowsing categoriesFor: #MapPropertyToPage:pClsid:!**auto generated**!COM Interfaces-IPerPropertyBrowsing!private! !
!IPerPropertyBrowsing categoriesFor: #stringsToValues:!accessing!public! !

IPerPropertyBrowsing methodProtocol: #IPerPropertyBrowsing attributes: #() selectors: #(#GetDisplayString:pBstr: #GetPredefinedStrings:pCaStringsOut:pCaCookiesOut: #GetPredefinedValue:dwCookie:pVarOut: #MapPropertyToPage:pClsid:)!

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

