"Filed out from Dolphin Smalltalk 7"!

MSXML.ISAXXMLReader subclass: #'MSXML.ISAXXMLFilter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISAXXMLFilter guid: (OS.COM.IID fromString: '{70409222-ca09-4475-acb8-40312fe8d145}')!
MSXML.ISAXXMLFilter comment: '`ISAXXMLFilter` is a wrapper class for the COM interface ''MSXML2.ISAXXMLFilter'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISAXXMLFilter interface"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(70409222-ca09-4475-acb8-40312fe8d145), 
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
```
'!
!MSXML.ISAXXMLFilter categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISAXXMLFilter methodsFor!

getParent
	"Answer the <ISAXXMLReader> result of invoking the getParent() method of the COM object."

	| answer |
	answer := ISAXXMLReader newPointer.
	self GetParent: answer.
	^answer asObject!

GetParent: ppReader
	"Private - Invoke the getParent() method of the COM object.

		HRESULT __stdcall getParent(
			[out, retval]ISAXXMLReader** ppReader);"

	<virtual stdcall: hresult 22 ISAXXMLReader**>
	^self invalidCall: _failureCode!

PutParent: pReader
	"Invoke the putParent() method of the COM object.

		HRESULT __stdcall putParent(
			[in]ISAXXMLReader* pReader);"

	<virtual stdcall: hresult 23 ISAXXMLReader*>
	^self invalidCall: _failureCode! !
!MSXML.ISAXXMLFilter categoriesFor: #getParent!**auto generated**!methods!public! !
!MSXML.ISAXXMLFilter categoriesFor: #GetParent:!**auto generated**!COM Interfaces-ISAXXMLFilter!private! !
!MSXML.ISAXXMLFilter categoriesFor: #PutParent:!**auto generated**!COM Interfaces-ISAXXMLFilter!public! !

!MSXML.ISAXXMLFilter class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISAXXMLFilter'
		ISAXXMLFilter defineTemplate"

	self
		defineFunction: #GetParent:
			argumentTypes: 'ISAXXMLReader**';
		defineFunction: #PutParent:
			argumentTypes: 'ISAXXMLReader*'
! !
!MSXML.ISAXXMLFilter class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

