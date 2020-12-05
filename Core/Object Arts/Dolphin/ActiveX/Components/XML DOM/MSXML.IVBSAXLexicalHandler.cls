"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IVBSAXLexicalHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IVBSAXLexicalHandler guid: (OS.COM.IID fromString: '{032aac35-8c0e-4d9d-979f-e3b702935576}')!
MSXML.IVBSAXLexicalHandler comment: '<IVBSAXLexicalHandler> is a wrapper class for the COM interface ''MSXML2.IVBSAXLexicalHandler'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXLexicalHandler interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(032AAC35-8C0E-4D9D-979F-E3B702935576), 
	helpstring("IVBSAXLexicalHandler interface"), 
	dual, 
	nonextensible
]
interface IVBSAXLexicalHandler : IDispatch
 {
	[id(0x0000054e), helpstring("Report the start of DTD declarations, if any.")]
	HRESULT __stdcall startDTD(
		[in, out]BSTR* strName,
		[in, out]BSTR* strPublicId,
		[in, out]BSTR* strSystemId);
	[id(0x0000054f), helpstring("Report the end of DTD declarations.")]
	HRESULT __stdcall endDTD();
	[id(0x00000550), helpstring("Report the beginning of some internal and external XML entities.")]
	HRESULT __stdcall startEntity(
		[in, out]BSTR* strName);
	[id(0x00000551), helpstring("Report the end of an entity.")]
	HRESULT __stdcall endEntity(
		[in, out]BSTR* strName);
	[id(0x00000552), helpstring("Report the start of a CDATA section.")]
	HRESULT __stdcall startCDATA();
	[id(0x00000553), helpstring("Report the end of a CDATA section.")]
	HRESULT __stdcall endCDATA();
	[id(0x00000554), helpstring("Report an XML comment anywhere in the document.")]
	HRESULT __stdcall comment(
		[in, out]BSTR* strChars);
};
'!
!MSXML.IVBSAXLexicalHandler categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IVBSAXLexicalHandler methodsFor!

comment: strChars
	"Invoke the comment() method of the COM object.
	Helpstring: Report an XML comment anywhere in the document."

	^self Comment: strChars asBSTR
!

Comment: strChars
	"Private - Invoke the comment() method of the COM object.
	Helpstring: Report an XML comment anywhere in the document.

		HRESULT __stdcall comment(
			[in, out]BSTR* strChars);"

	<virtual stdcall: hresult 14 bstr*>
	^self invalidCall: _failureCode!

EndCDATA
	"Invoke the endCDATA() method of the COM object.
	Helpstring: Report the end of a CDATA section.

		HRESULT __stdcall endCDATA();"

	<virtual stdcall: hresult 13>
	^self invalidCall: _failureCode!

EndDTD
	"Invoke the endDTD() method of the COM object.
	Helpstring: Report the end of DTD declarations.

		HRESULT __stdcall endDTD();"

	<virtual stdcall: hresult 9>
	^self invalidCall: _failureCode!

endEntity: strName
	"Invoke the endEntity() method of the COM object.
	Helpstring: Report the end of an entity."

	^self EndEntity: strName asBSTR
!

EndEntity: strName
	"Private - Invoke the endEntity() method of the COM object.
	Helpstring: Report the end of an entity.

		HRESULT __stdcall endEntity(
			[in, out]BSTR* strName);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

StartCDATA
	"Invoke the startCDATA() method of the COM object.
	Helpstring: Report the start of a CDATA section.

		HRESULT __stdcall startCDATA();"

	<virtual stdcall: hresult 12>
	^self invalidCall: _failureCode!

startDTD: strName strPublicId: strPublicId strSystemId: strSystemId
	"Invoke the startDTD() method of the COM object.
	Helpstring: Report the start of DTD declarations, if any."

	| answer |
	answer := (Array new: 3)
				basicAt: 1 put: strName asBSTR;
				basicAt: 2 put: strPublicId asBSTR;
				basicAt: 3 put: strSystemId asBSTR;
				yourself.
	self
		StartDTD: (answer basicAt: 1)
		strPublicId: (answer basicAt: 2)
		strSystemId: (answer basicAt: 3).
	^answer collect: [:each | each asObject]
!

StartDTD: strName strPublicId: strPublicId strSystemId: strSystemId
	"Private - Invoke the startDTD() method of the COM object.
	Helpstring: Report the start of DTD declarations, if any.

		HRESULT __stdcall startDTD(
			[in, out]BSTR* strName,
			[in, out]BSTR* strPublicId,
			[in, out]BSTR* strSystemId);"

	<virtual stdcall: hresult 8 bstr* bstr* bstr*>
	^self invalidCall: _failureCode!

startEntity: strName
	"Invoke the startEntity() method of the COM object.
	Helpstring: Report the beginning of some internal and external XML entities."

	^self StartEntity: strName asBSTR
!

StartEntity: strName
	"Private - Invoke the startEntity() method of the COM object.
	Helpstring: Report the beginning of some internal and external XML entities.

		HRESULT __stdcall startEntity(
			[in, out]BSTR* strName);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall: _failureCode! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #comment:!**auto generated**!methods!public! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #Comment:!**auto generated**!COM Interfaces-IVBSAXLexicalHandler!private! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #EndCDATA!**auto generated**!COM Interfaces-IVBSAXLexicalHandler!public! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #EndDTD!**auto generated**!COM Interfaces-IVBSAXLexicalHandler!public! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #endEntity:!**auto generated**!methods!public! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #EndEntity:!**auto generated**!COM Interfaces-IVBSAXLexicalHandler!private! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #StartCDATA!**auto generated**!COM Interfaces-IVBSAXLexicalHandler!public! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #startDTD:strPublicId:strSystemId:!**auto generated**!methods!public! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #StartDTD:strPublicId:strSystemId:!**auto generated**!COM Interfaces-IVBSAXLexicalHandler!private! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #startEntity:!**auto generated**!methods!public! !
!MSXML.IVBSAXLexicalHandler categoriesFor: #StartEntity:!**auto generated**!COM Interfaces-IVBSAXLexicalHandler!private! !

!MSXML.IVBSAXLexicalHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXLexicalHandler'
		IVBSAXLexicalHandler defineTemplate"

	self
		defineFunction: #StartDTD:strPublicId:strSystemId:
			argumentTypes: 'bstr* bstr* bstr*';
		defineFunction: #EndDTD;
		defineFunction: #StartEntity:
			argumentTypes: 'bstr*';
		defineFunction: #EndEntity:
			argumentTypes: 'bstr*';
		defineFunction: #StartCDATA;
		defineFunction: #EndCDATA;
		defineFunction: #Comment:
			argumentTypes: 'bstr*'
! !
!MSXML.IVBSAXLexicalHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

