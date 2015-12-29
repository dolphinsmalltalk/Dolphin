"Filed out from Dolphin Smalltalk X6"!

IXMLDOMNode subclass: #IXTLRuntime
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXTLRuntime guid: (IID fromString: '{3EFAA425-272F-11D2-836F-0000F87A7782}')!
IXTLRuntime comment: '<IXTLRuntime> is a wrapper class for the COM interface ''MSXML.IXTLRuntime'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XTL runtime object"

IXTLRuntime implements methods that can be called from XSL style sheets.'!
!IXTLRuntime categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!IXTLRuntime methodsFor!

absoluteChildNumber: pNode
	"Answer the <SDWORD> result of invoking the absoluteChildNumber() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		AbsoluteChildNumber: pNode
		pNumber: answer.
	^answer asObject
!

AbsoluteChildNumber: pNode pNumber: pNumber
	"Private - Invoke the absoluteChildNumber() method of the COM object.

		HRESULT __stdcall absoluteChildNumber(
			[in]IXMLDOMNode* pNode,
			[out, retval]long* pNumber);"

	<virtual stdcall: hresult 48 IXMLDOMNode* sdword*>
	^self invalidCall!

ancestorChildNumber: bstrNodeName pNode: pNode
	"Answer the <SDWORD> result of invoking the ancestorChildNumber() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		AncestorChildNumber: bstrNodeName
		pNode: pNode
		pNumber: answer.
	^answer asObject
!

AncestorChildNumber: bstrNodeName pNode: pNode pNumber: pNumber
	"Private - Invoke the ancestorChildNumber() method of the COM object.

		HRESULT __stdcall ancestorChildNumber(
			[in]BSTR bstrNodeName,
			[in]IXMLDOMNode* pNode,
			[out, retval]long* pNumber);"

	<virtual stdcall: hresult 47 bstr IXMLDOMNode* sdword*>
	^self invalidCall!

childNumber: pNode
	"Answer the <SDWORD> result of invoking the childNumber() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		ChildNumber: pNode
		pNumber: answer.
	^answer asObject
!

ChildNumber: pNode pNumber: pNumber
	"Private - Invoke the childNumber() method of the COM object.

		HRESULT __stdcall childNumber(
			[in]IXMLDOMNode* pNode,
			[out, retval]long* pNumber);"

	<virtual stdcall: hresult 46 IXMLDOMNode* sdword*>
	^self invalidCall!

depth: pNode
	"Answer the <SDWORD> result of invoking the depth() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		Depth: pNode
		pDepth: answer.
	^answer asObject
!

Depth: pNode pDepth: pDepth
	"Private - Invoke the depth() method of the COM object.

		HRESULT __stdcall depth(
			[in]IXMLDOMNode* pNode,
			[out, retval]long* pDepth);"

	<virtual stdcall: hresult 45 IXMLDOMNode* sdword*>
	^self invalidCall!

formatDate: varDate bstrFormat: bstrFormat
	"Answer the <BSTR> result of invoking the formatDate() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 formatDate: varDate
		 bstrFormat: bstrFormat
		 varDestLocale: VARIANT unspecified!

formatDate: varDate bstrFormat: bstrFormat varDestLocale: varDestLocale
	"Answer the <BSTR> result of invoking the formatDate() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		FormatDate: varDate asVariant
		bstrFormat: bstrFormat
		varDestLocale: varDestLocale asVariant
		pbstrFormattedString: answer.
	^answer asObject
!

FormatDate: varDate bstrFormat: bstrFormat varDestLocale: varDestLocale pbstrFormattedString: pbstrFormattedString
	"Private - Invoke the formatDate() method of the COM object.

		HRESULT __stdcall formatDate(
			[in]VARIANT varDate,
			[in]BSTR bstrFormat,
			[in, optional]VARIANT varDestLocale,
			[out, retval]BSTR* pbstrFormattedString);"

	<virtual stdcall: hresult 51 variant bstr variant bstr*>
	^self invalidCall!

formatIndex: lIndex bstrFormat: bstrFormat
	"Answer the <BSTR> result of invoking the formatIndex() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		FormatIndex: lIndex
		bstrFormat: bstrFormat
		pbstrFormattedString: answer.
	^answer asObject
!

FormatIndex: lIndex bstrFormat: bstrFormat pbstrFormattedString: pbstrFormattedString
	"Private - Invoke the formatIndex() method of the COM object.

		HRESULT __stdcall formatIndex(
			[in]long lIndex,
			[in]BSTR bstrFormat,
			[out, retval]BSTR* pbstrFormattedString);"

	<virtual stdcall: hresult 49 sdword bstr bstr*>
	^self invalidCall!

formatNumber: dblNumber bstrFormat: bstrFormat
	"Answer the <BSTR> result of invoking the formatNumber() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		FormatNumber: dblNumber
		bstrFormat: bstrFormat
		pbstrFormattedString: answer.
	^answer asObject
!

FormatNumber: dblNumber bstrFormat: bstrFormat pbstrFormattedString: pbstrFormattedString
	"Private - Invoke the formatNumber() method of the COM object.

		HRESULT __stdcall formatNumber(
			[in]double dblNumber,
			[in]BSTR bstrFormat,
			[out, retval]BSTR* pbstrFormattedString);"

	<virtual stdcall: hresult 50 double bstr bstr*>
	^self invalidCall!

formatTime: varTime bstrFormat: bstrFormat
	"Answer the <BSTR> result of invoking the formatTime() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 formatTime: varTime
		 bstrFormat: bstrFormat
		 varDestLocale: VARIANT unspecified!

formatTime: varTime bstrFormat: bstrFormat varDestLocale: varDestLocale
	"Answer the <BSTR> result of invoking the formatTime() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		FormatTime: varTime asVariant
		bstrFormat: bstrFormat
		varDestLocale: varDestLocale asVariant
		pbstrFormattedString: answer.
	^answer asObject
!

FormatTime: varTime bstrFormat: bstrFormat varDestLocale: varDestLocale pbstrFormattedString: pbstrFormattedString
	"Private - Invoke the formatTime() method of the COM object.

		HRESULT __stdcall formatTime(
			[in]VARIANT varTime,
			[in]BSTR bstrFormat,
			[in, optional]VARIANT varDestLocale,
			[out, retval]BSTR* pbstrFormattedString);"

	<virtual stdcall: hresult 52 variant bstr variant bstr*>
	^self invalidCall!

uniqueID: pNode
	"Answer the <SDWORD> result of invoking the uniqueID() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		UniqueID: pNode
		pID: answer.
	^answer asObject
!

UniqueID: pNode pID: pID
	"Private - Invoke the uniqueID() method of the COM object.

		HRESULT __stdcall uniqueID(
			[in]IXMLDOMNode* pNode,
			[out, retval]long* pID);"

	<virtual stdcall: hresult 44 IXMLDOMNode* sdword*>
	^self invalidCall! !
!IXTLRuntime categoriesFor: #absoluteChildNumber:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #AbsoluteChildNumber:pNumber:!**auto generated**!COM Interfaces-IXTLRuntime!private! !
!IXTLRuntime categoriesFor: #ancestorChildNumber:pNode:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #AncestorChildNumber:pNode:pNumber:!**auto generated**!COM Interfaces-IXTLRuntime!private! !
!IXTLRuntime categoriesFor: #childNumber:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #ChildNumber:pNumber:!**auto generated**!COM Interfaces-IXTLRuntime!private! !
!IXTLRuntime categoriesFor: #depth:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #Depth:pDepth:!**auto generated**!COM Interfaces-IXTLRuntime!private! !
!IXTLRuntime categoriesFor: #formatDate:bstrFormat:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #formatDate:bstrFormat:varDestLocale:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #FormatDate:bstrFormat:varDestLocale:pbstrFormattedString:!**auto generated**!COM Interfaces-IXTLRuntime!private! !
!IXTLRuntime categoriesFor: #formatIndex:bstrFormat:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #FormatIndex:bstrFormat:pbstrFormattedString:!**auto generated**!COM Interfaces-IXTLRuntime!private! !
!IXTLRuntime categoriesFor: #formatNumber:bstrFormat:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #FormatNumber:bstrFormat:pbstrFormattedString:!**auto generated**!COM Interfaces-IXTLRuntime!private! !
!IXTLRuntime categoriesFor: #formatTime:bstrFormat:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #formatTime:bstrFormat:varDestLocale:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #FormatTime:bstrFormat:varDestLocale:pbstrFormattedString:!**auto generated**!COM Interfaces-IXTLRuntime!private! !
!IXTLRuntime categoriesFor: #uniqueID:!**auto generated**!methods!public! !
!IXTLRuntime categoriesFor: #UniqueID:pID:!**auto generated**!COM Interfaces-IXTLRuntime!private! !

!IXTLRuntime class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXTLRuntime'
		IXTLRuntime defineTemplate"

	self
		defineFunction: #UniqueID:pID:
			argumentTypes: 'IXMLDOMNode* sdword*';
		defineFunction: #Depth:pDepth:
			argumentTypes: 'IXMLDOMNode* sdword*';
		defineFunction: #ChildNumber:pNumber:
			argumentTypes: 'IXMLDOMNode* sdword*';
		defineFunction: #AncestorChildNumber:pNode:pNumber:
			argumentTypes: 'bstr IXMLDOMNode* sdword*';
		defineFunction: #AbsoluteChildNumber:pNumber:
			argumentTypes: 'IXMLDOMNode* sdword*';
		defineFunction: #FormatIndex:bstrFormat:pbstrFormattedString:
			argumentTypes: 'sdword bstr bstr*';
		defineFunction: #FormatNumber:bstrFormat:pbstrFormattedString:
			argumentTypes: 'double bstr bstr*';
		defineFunction: #FormatDate:bstrFormat:varDestLocale:pbstrFormattedString:
			argumentTypes: 'variant bstr variant bstr*';
		defineFunction: #FormatTime:bstrFormat:varDestLocale:pbstrFormattedString:
			argumentTypes: 'variant bstr variant bstr*'
! !
!IXTLRuntime class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

