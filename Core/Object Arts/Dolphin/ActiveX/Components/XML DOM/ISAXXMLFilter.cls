"Filed out from Dolphin Smalltalk X6"!

ISAXXMLReader subclass: #ISAXXMLFilter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
ISAXXMLFilter guid: (IID fromString: '{70409222-CA09-4475-ACB8-40312FE8D145}')!
ISAXXMLFilter comment: '<ISAXXMLFilter> is a wrapper class for the COM interface ''MSXML2.ISAXXMLFilter'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISAXXMLFilter interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(70409222-CA09-4475-ACB8-40312FE8D145), 
	helpstring("ISAXXMLFilter interface"), 
	hidden
]
interface ISAXXMLFilter : ISAXXMLReader
 {
	[id(0x60020000)]
	HRESULT __stdcall getParent(
		[out, retval]ISAXXMLReader** ppReader);
	[id(0x60020001)]
	HRESULT __stdcall putParent(
		[in]ISAXXMLReader* pReader);
};
'!
!ISAXXMLFilter categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!ISAXXMLFilter methodsFor!

getParent
	"Answer the <ISAXXMLReader> result of invoking the getParent() method of the COM object."

	| answer |
	answer := ISAXXMLReader newPointer.
	self GetParent: answer.
	^answer asObject
!

GetParent: ppReader
	"Private - Invoke the getParent() method of the COM object.

		HRESULT __stdcall getParent(
			[out, retval]ISAXXMLReader** ppReader);"

	<virtual stdcall: hresult 22 ISAXXMLReader**>
	^self invalidCall!

PutParent: pReader
	"Invoke the putParent() method of the COM object.

		HRESULT __stdcall putParent(
			[in]ISAXXMLReader* pReader);"

	<virtual stdcall: hresult 23 ISAXXMLReader*>
	^self invalidCall! !
!ISAXXMLFilter categoriesFor: #getParent!**auto generated**!methods!public! !
!ISAXXMLFilter categoriesFor: #GetParent:!**auto generated**!COM Interfaces-ISAXXMLFilter!private! !
!ISAXXMLFilter categoriesFor: #PutParent:!**auto generated**!COM Interfaces-ISAXXMLFilter!public! !

!ISAXXMLFilter class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISAXXMLFilter'
		ISAXXMLFilter defineTemplate"

	self
		defineFunction: #GetParent:
			argumentTypes: 'ISAXXMLReader**';
		defineFunction: #PutParent:
			argumentTypes: 'ISAXXMLReader*'
! !
!ISAXXMLFilter class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

