"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #IXMLError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLError guid: (IID fromString: '{948C5AD3-C58D-11D0-9C0B-00C04FC99C8E}')!
IXMLError comment: '<IXMLError> is a wrapper class for the COM interface ''MSXML2.IXMLError'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Gets error info."

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(948C5AD3-C58D-11D0-9C0B-00C04FC99C8E), 
	helpstring("Gets error info."), 
	hidden
]
interface IXMLError : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall GetErrorInfo(
		xml_error* pErrorReturn);
};
'!
!IXMLError categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLError methodsFor!

GetErrorInfo: pErrorReturn
	"Invoke the GetErrorInfo() method of the COM object.

		HRESULT __stdcall GetErrorInfo(
			xml_error* pErrorReturn);"

	<virtual stdcall: hresult 4 Xml_error*>
	^self invalidCall! !
!IXMLError categoriesFor: #GetErrorInfo:!**auto generated**!COM Interfaces-IXMLError!public! !

!IXMLError class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLError'
		IXMLError defineTemplate"

	self
		defineFunction: #GetErrorInfo:
			argumentTypes: 'Xml_error*'
! !
!IXMLError class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

