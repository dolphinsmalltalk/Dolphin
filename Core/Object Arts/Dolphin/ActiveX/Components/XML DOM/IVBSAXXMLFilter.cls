"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IVBSAXXMLFilter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IVBSAXXMLFilter guid: (IID fromString: '{1299EB1B-5B88-433E-82DE-82CA75AD4E04}')!
IVBSAXXMLFilter comment: '<IVBSAXXMLFilter> is a wrapper class for the COM interface ''MSXML2.IVBSAXXMLFilter'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXXMLFilter interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(1299EB1B-5B88-433E-82DE-82CA75AD4E04), 
	helpstring("IVBSAXXMLFilter interface"), 
	dual, 
	nonextensible
]
interface IVBSAXXMLFilter : IDispatch
 {
	[id(0x0000051d), propget, helpstring("Set or get the parent reader")]
	HRESULT __stdcall parent(
		[out, retval]IVBSAXXMLReader** oReader);
	[id(0x0000051d), propputref, helpstring("Set or get the parent reader")]
	HRESULT __stdcall parent(
		[in]IVBSAXXMLReader* oReader);
};
'!
!IVBSAXXMLFilter categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IVBSAXXMLFilter methodsFor!

get_parent: oReader
	"Private - Get the value of the 'parent' property of the receiver.

		HRESULT __stdcall parent(
			[out, retval]IVBSAXXMLReader** oReader);"

	<virtual stdcall: hresult 8 IVBSAXXMLReader**>
	^self invalidCall!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

parent
	"Answer the <IVBSAXXMLReader> value of the 'parent' property of the receiver.
	Helpstring: Set or get the parent reader"

	| answer |
	answer := IVBSAXXMLReader newPointer.
	self get_parent: answer.
	^answer asObject
!

putref_parent: oReader
	"Private - Set the value of the 'parent' property of the object wrapped by the 
	 receiver to the <IVBSAXXMLReader*> argument, oReader.

		HRESULT __stdcall parent(
			[in]IVBSAXXMLReader* oReader);"

	<virtual stdcall: hresult 9 IVBSAXXMLReader*>
	^self invalidCall!

setParent: oReader
	"Set the 'parent' property of the receiver to the <IVBSAXXMLReader*> value of the argument.
	Helpstring: Set or get the parent reader"

	self putref_parent: oReader
! !
!IVBSAXXMLFilter categoriesFor: #get_parent:!**auto generated**!COM Interfaces-IVBSAXXMLFilter!private! !
!IVBSAXXMLFilter categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IVBSAXXMLFilter categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IVBSAXXMLFilter categoriesFor: #parent!**auto generated**!properties!public! !
!IVBSAXXMLFilter categoriesFor: #putref_parent:!**auto generated**!COM Interfaces-IVBSAXXMLFilter!private! !
!IVBSAXXMLFilter categoriesFor: #setParent:!**auto generated**!properties!public! !

!IVBSAXXMLFilter class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXXMLFilter'
		IVBSAXXMLFilter defineTemplate"

	self
		defineFunction: #get_parent:
			argumentTypes: 'IVBSAXXMLReader**';
		defineFunction: #putref_parent:
			argumentTypes: 'IVBSAXXMLReader*'
! !
!IVBSAXXMLFilter class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

