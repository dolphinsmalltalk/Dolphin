"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IDSOControl
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IDSOControl guid: (IID fromString: '{310AFA62-0575-11D2-9CA9-0060B0EC3D39}')!
IDSOControl comment: '<IDSOControl> is a wrapper class for the COM interface ''MSXML2.IDSOControl'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"DSO Control"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(310AFA62-0575-11D2-9CA9-0060B0EC3D39), 
	helpstring("DSO Control"), 
	hidden, 
	dual, 
	nonextensible
]
interface IDSOControl : IDispatch
 {
	[id(0x00010001), propget]
	HRESULT __stdcall XMLDocument(
		[out, retval]IXMLDOMDocument** ppDoc);
	[id(0x00010001), propput]
	HRESULT __stdcall XMLDocument(
		[in]IXMLDOMDocument* ppDoc);
	[id(0x00010002), propget]
	HRESULT __stdcall JavaDSOCompatible(
		[out, retval]long* fJavaDSOCompatible);
	[id(0x00010002), propput]
	HRESULT __stdcall JavaDSOCompatible(
		[in]long fJavaDSOCompatible);
	[id(0xfffffdf3), propget]
	HRESULT __stdcall readyState(
		[out, retval]long* state);
};
'!
!IDSOControl categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IDSOControl methodsFor!

get_JavaDSOCompatible: fJavaDSOCompatible
	"Private - Get the value of the 'JavaDSOCompatible' property of the receiver.

		HRESULT __stdcall JavaDSOCompatible(
			[out, retval]long* fJavaDSOCompatible);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall!

get_readyState: state
	"Private - Get the value of the 'readyState' property of the receiver.

		HRESULT __stdcall readyState(
			[out, retval]long* state);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall!

get_XMLDocument: ppDoc
	"Private - Get the value of the 'XMLDocument' property of the receiver.

		HRESULT __stdcall XMLDocument(
			[out, retval]IXMLDOMDocument** ppDoc);"

	<virtual stdcall: hresult 8 IXMLDOMDocument**>
	^self invalidCall!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

javaDSOCompatible
	"Answer the <sdword> value of the 'JavaDSOCompatible' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_JavaDSOCompatible: answer.
	^answer asObject
!

javaDSOCompatible: fJavaDSOCompatible
	"Set the 'JavaDSOCompatible' property of the receiver to the <sdword> value of the argument."

	self put_JavaDSOCompatible: fJavaDSOCompatible
!

put_JavaDSOCompatible: fJavaDSOCompatible
	"Private - Set the value of the 'JavaDSOCompatible' property of the object wrapped by the 
	 receiver to the <sdword> argument, fJavaDSOCompatible.

		HRESULT __stdcall JavaDSOCompatible(
			[in]long fJavaDSOCompatible);"

	<virtual stdcall: hresult 11 sdword>
	^self invalidCall!

put_XMLDocument: ppDoc
	"Private - Set the value of the 'XMLDocument' property of the object wrapped by the 
	 receiver to the <IXMLDOMDocument*> argument, ppDoc.

		HRESULT __stdcall XMLDocument(
			[in]IXMLDOMDocument* ppDoc);"

	<virtual stdcall: hresult 9 IXMLDOMDocument*>
	^self invalidCall!

readyState
	"Answer the <sdword> value of the 'readyState' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_readyState: answer.
	^answer asObject
!

xmlDocument
	"Answer the <IXMLDOMDocument> value of the 'XMLDocument' property of the receiver."

	| answer |
	answer := IXMLDOMDocument newPointer.
	self get_XMLDocument: answer.
	^answer asObject
!

xmlDocument: ppDoc
	"Set the 'XMLDocument' property of the receiver to the <IXMLDOMDocument*> value of the argument."

	self put_XMLDocument: ppDoc
! !
!IDSOControl categoriesFor: #get_JavaDSOCompatible:!**auto generated**!COM Interfaces-IDSOControl!private! !
!IDSOControl categoriesFor: #get_readyState:!**auto generated**!COM Interfaces-IDSOControl!private! !
!IDSOControl categoriesFor: #get_XMLDocument:!**auto generated**!COM Interfaces-IDSOControl!private! !
!IDSOControl categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IDSOControl categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IDSOControl categoriesFor: #javaDSOCompatible!**auto generated**!properties!public! !
!IDSOControl categoriesFor: #javaDSOCompatible:!**auto generated**!properties!public! !
!IDSOControl categoriesFor: #put_JavaDSOCompatible:!**auto generated**!COM Interfaces-IDSOControl!private! !
!IDSOControl categoriesFor: #put_XMLDocument:!**auto generated**!COM Interfaces-IDSOControl!private! !
!IDSOControl categoriesFor: #readyState!**auto generated**!properties!public! !
!IDSOControl categoriesFor: #xmlDocument!**auto generated**!properties!public! !
!IDSOControl categoriesFor: #xmlDocument:!**auto generated**!properties!public! !

!IDSOControl class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IDSOControl'
		IDSOControl defineTemplate"

	self
		defineFunction: #get_XMLDocument:
			argumentTypes: 'IXMLDOMDocument**';
		defineFunction: #put_XMLDocument:
			argumentTypes: 'IXMLDOMDocument*';
		defineFunction: #get_JavaDSOCompatible:
			argumentTypes: 'sdword*';
		defineFunction: #put_JavaDSOCompatible:
			argumentTypes: 'sdword';
		defineFunction: #get_readyState:
			argumentTypes: 'sdword*'
!

newDSOControl
	"Answer a new instance of the receiver on the DSOControl COM object"

	^self onCLSID: (CLSID fromString: '{F6D90F14-9C73-11D3-B32E-00C04F990BB4}')
!

newDSOControl26
	"Answer a new instance of the receiver on the DSOControl26 COM object"

	^self onCLSID: (CLSID fromString: '{F5078F1F-C551-11D3-89B9-0000F81FE221}')
!

newDSOControl30
	"Answer a new instance of the receiver on the DSOControl30 COM object"

	^self onCLSID: (CLSID fromString: '{F5078F39-C551-11D3-89B9-0000F81FE221}')
!

newDSOControl40
	"Answer a new instance of the receiver on the DSOControl40 COM object"

	^self onCLSID: (CLSID fromString: '{88D969C4-F192-11D4-A65F-0040963251E5}')
!

newDSOControl60
	"Answer a new instance of the receiver on the DSOControl60 COM object"

	^self onCLSID: (CLSID fromString: '{88D96A09-F192-11D4-A65F-0040963251E5}')
! !
!IDSOControl class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IDSOControl class categoriesFor: #newDSOControl!**auto generated**!instance creation!public! !
!IDSOControl class categoriesFor: #newDSOControl26!**auto generated**!instance creation!public! !
!IDSOControl class categoriesFor: #newDSOControl30!**auto generated**!instance creation!public! !
!IDSOControl class categoriesFor: #newDSOControl40!**auto generated**!instance creation!public! !
!IDSOControl class categoriesFor: #newDSOControl60!**auto generated**!instance creation!public! !

