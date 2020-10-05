"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IVBSAXLocator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IVBSAXLocator guid: (IID fromString: '{796e7ac5-5aa2-4eff-acad-3faaf01a3288}')!
IVBSAXLocator comment: '<IVBSAXLocator> is a wrapper class for the COM interface ''MSXML2.IVBSAXLocator'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXLocator interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(796E7AC5-5AA2-4EFF-ACAD-3FAAF01A3288), 
	helpstring("IVBSAXLocator interface"), 
	dual, 
	nonextensible
]
interface IVBSAXLocator : IDispatch
 {
	[id(0x00000521), propget, helpstring("Get the column number where the current document event ends.")]
	HRESULT __stdcall columnNumber(
		[out, retval]int* nColumn);
	[id(0x00000522), propget, helpstring("Get the line number where the current document event ends.")]
	HRESULT __stdcall lineNumber(
		[out, retval]int* nLine);
	[id(0x00000523), propget, helpstring("Get the public identifier for the current document event.")]
	HRESULT __stdcall publicId(
		[out, retval]BSTR* strPublicId);
	[id(0x00000524), propget, helpstring("Get the system identifier for the current document event.")]
	HRESULT __stdcall systemId(
		[out, retval]BSTR* strSystemId);
};
'!
!IVBSAXLocator categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IVBSAXLocator methodsFor!

columnNumber
	"Answer the <sdword> value of the 'columnNumber' property of the receiver.
	Helpstring: Get the column number where the current document event ends."

	| answer |
	answer := (SDWORD new).
	self get_columnNumber: answer.
	^answer asObject
!

get_columnNumber: nColumn
	"Private - Get the value of the 'columnNumber' property of the receiver.

		HRESULT __stdcall columnNumber(
			[out, retval]int* nColumn);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

get_lineNumber: nLine
	"Private - Get the value of the 'lineNumber' property of the receiver.

		HRESULT __stdcall lineNumber(
			[out, retval]int* nLine);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall: _failureCode!

get_publicId: strPublicId
	"Private - Get the value of the 'publicId' property of the receiver.

		HRESULT __stdcall publicId(
			[out, retval]BSTR* strPublicId);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall: _failureCode!

get_systemId: strSystemId
	"Private - Get the value of the 'systemId' property of the receiver.

		HRESULT __stdcall systemId(
			[out, retval]BSTR* strSystemId);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

lineNumber
	"Answer the <sdword> value of the 'lineNumber' property of the receiver.
	Helpstring: Get the line number where the current document event ends."

	| answer |
	answer := (SDWORD new).
	self get_lineNumber: answer.
	^answer asObject
!

publicId
	"Answer the <bstr> value of the 'publicId' property of the receiver.
	Helpstring: Get the public identifier for the current document event."

	| answer |
	answer := BSTR new.
	self get_publicId: answer.
	^answer asObject
!

systemId
	"Answer the <bstr> value of the 'systemId' property of the receiver.
	Helpstring: Get the system identifier for the current document event."

	| answer |
	answer := BSTR new.
	self get_systemId: answer.
	^answer asObject
! !
!IVBSAXLocator categoriesFor: #columnNumber!**auto generated**!properties!public! !
!IVBSAXLocator categoriesFor: #get_columnNumber:!**auto generated**!COM Interfaces-IVBSAXLocator!private! !
!IVBSAXLocator categoriesFor: #get_lineNumber:!**auto generated**!COM Interfaces-IVBSAXLocator!private! !
!IVBSAXLocator categoriesFor: #get_publicId:!**auto generated**!COM Interfaces-IVBSAXLocator!private! !
!IVBSAXLocator categoriesFor: #get_systemId:!**auto generated**!COM Interfaces-IVBSAXLocator!private! !
!IVBSAXLocator categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IVBSAXLocator categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IVBSAXLocator categoriesFor: #lineNumber!**auto generated**!properties!public! !
!IVBSAXLocator categoriesFor: #publicId!**auto generated**!properties!public! !
!IVBSAXLocator categoriesFor: #systemId!**auto generated**!properties!public! !

!IVBSAXLocator class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXLocator'
		IVBSAXLocator defineTemplate"

	self
		defineFunction: #get_columnNumber:
			argumentTypes: 'sdword*';
		defineFunction: #get_lineNumber:
			argumentTypes: 'sdword*';
		defineFunction: #get_publicId:
			argumentTypes: 'bstr*';
		defineFunction: #get_systemId:
			argumentTypes: 'bstr*'
! !
!IVBSAXLocator class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

