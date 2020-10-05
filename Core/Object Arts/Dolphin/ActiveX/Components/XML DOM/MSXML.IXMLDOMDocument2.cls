"Filed out from Dolphin Smalltalk 7"!

IXMLDOMDocument subclass: #IXMLDOMDocument2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IXMLDOMDocument2 guid: (IID fromString: '{2933bf95-7b36-11d2-b20e-00c04f983e60}')!
IXMLDOMDocument2 comment: '<IXMLDOMDocument2> is a wrapper class for the COM interface ''MSXML2.IXMLDOMDocument2'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

IDL definition follows:

[
	object, 
	uuid(2933BF95-7B36-11D2-B20E-00C04F983E60), 
	dual, 
	nonextensible
]
interface IXMLDOMDocument2 : IXMLDOMDocument
 {
	[id(0x000000c9), propget, helpstring("A collection of all namespaces for this document")]
	HRESULT __stdcall namespaces(
		[out, retval]IXMLDOMSchemaCollection** namespaceCollection);
	[id(0x000000ca), propget, helpstring("The associated schema cache")]
	HRESULT __stdcall schemas(
		[out, retval]VARIANT* otherCollection);
	[id(0x000000ca), propputref, helpstring("The associated schema cache")]
	HRESULT __stdcall schemas(
		[in]VARIANT otherCollection);
	[id(0x000000cb), helpstring("perform runtime validation on the currently loaded XML document")]
	HRESULT __stdcall validate(
		[out, retval]IXMLDOMParseError** errorObj);
	[id(0x000000cc), helpstring("set the value of the named property")]
	HRESULT __stdcall setProperty(
		[in]BSTR name,
		[in]VARIANT value);
	[id(0x000000cd), helpstring("get the value of the named property")]
	HRESULT __stdcall getProperty(
		[in]BSTR name,
		[out, retval]VARIANT* value);
};
'!
!IXMLDOMDocument2 categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLDOMDocument2 methodsFor!

get_namespaces: namespaceCollection
	"Private - Get the value of the 'namespaces' property of the receiver.

		HRESULT __stdcall namespaces(
			[out, retval]IXMLDOMSchemaCollection** namespaceCollection);"

	<virtual stdcall: hresult 77 IXMLDOMSchemaCollection**>
	^self invalidCall: _failureCode!

get_schemas: otherCollection
	"Private - Get the value of the 'schemas' property of the receiver.

		HRESULT __stdcall schemas(
			[out, retval]VARIANT* otherCollection);"

	<virtual stdcall: hresult 78 variant*>
	^self invalidCall: _failureCode!

GetProperty: name value: value
	"Private - Invoke the getProperty() method of the COM object.
	Helpstring: get the value of the named property

		HRESULT __stdcall getProperty(
			[in]BSTR name,
			[out, retval]VARIANT* value);"

	<virtual stdcall: hresult 82 bstr variant*>
	^self invalidCall: _failureCode!

getProperty_: name
	"Answer the <VARIANT> result of invoking the getProperty() method of the COM object.
	Helpstring: get the value of the named property"

	| answer |
	answer := VARIANT new.
	self
		GetProperty: name
		value: answer.
	^answer asObject
!

namespaces
	"Answer the <IXMLDOMSchemaCollection> value of the 'namespaces' property of the receiver.
	Helpstring: A collection of all namespaces for this document"

	| answer |
	answer := IXMLDOMSchemaCollection newPointer.
	self get_namespaces: answer.
	^answer asObject
!

putref_schemas: otherCollection
	"Private - Set the value of the 'schemas' property of the object wrapped by the 
	 receiver to the <variant> argument, otherCollection.

		HRESULT __stdcall schemas(
			[in]VARIANT otherCollection);"

	<virtual stdcall: hresult 79 variant>
	^self invalidCall: _failureCode!

schemas
	"Answer the <variant> value of the 'schemas' property of the receiver.
	Helpstring: The associated schema cache"

	| answer |
	answer := VARIANT new.
	self get_schemas: answer.
	^answer asObject
!

SetProperty: name value: value
	"Private - Invoke the setProperty() method of the COM object.
	Helpstring: set the value of the named property

		HRESULT __stdcall setProperty(
			[in]BSTR name,
			[in]VARIANT value);"

	<virtual stdcall: hresult 81 bstr variant>
	^self invalidCall: _failureCode!

setProperty_: name value: value
	"Invoke the setProperty() method of the COM object.
	Helpstring: set the value of the named property"

	^self
		SetProperty: name
		value: value asVariant
!

setSchemas: otherCollection
	"Set the 'schemas' property of the receiver to the <variant> value of the argument.
	Helpstring: The associated schema cache"

	self putref_schemas: otherCollection asVariant
!

validate
	"Answer the <IXMLDOMParseError> result of invoking the validate() method of the COM object.
	Helpstring: perform runtime validation on the currently loaded XML document"

	| answer |
	answer := IXMLDOMParseError newPointer.
	self Validate: answer.
	^answer asObject
!

Validate: errorObj
	"Private - Invoke the validate() method of the COM object.
	Helpstring: perform runtime validation on the currently loaded XML document

		HRESULT __stdcall validate(
			[out, retval]IXMLDOMParseError** errorObj);"

	<virtual stdcall: hresult 80 IXMLDOMParseError**>
	^self invalidCall: _failureCode! !
!IXMLDOMDocument2 categoriesFor: #get_namespaces:!**auto generated**!COM Interfaces-IXMLDOMDocument2!private! !
!IXMLDOMDocument2 categoriesFor: #get_schemas:!**auto generated**!COM Interfaces-IXMLDOMDocument2!private! !
!IXMLDOMDocument2 categoriesFor: #GetProperty:value:!**auto generated**!COM Interfaces-IXMLDOMDocument2!private! !
!IXMLDOMDocument2 categoriesFor: #getProperty_:!**auto generated**!methods!public! !
!IXMLDOMDocument2 categoriesFor: #namespaces!**auto generated**!properties!public! !
!IXMLDOMDocument2 categoriesFor: #putref_schemas:!**auto generated**!COM Interfaces-IXMLDOMDocument2!private! !
!IXMLDOMDocument2 categoriesFor: #schemas!**auto generated**!properties!public! !
!IXMLDOMDocument2 categoriesFor: #SetProperty:value:!**auto generated**!COM Interfaces-IXMLDOMDocument2!private! !
!IXMLDOMDocument2 categoriesFor: #setProperty_:value:!**auto generated**!methods!public! !
!IXMLDOMDocument2 categoriesFor: #setSchemas:!**auto generated**!properties!public! !
!IXMLDOMDocument2 categoriesFor: #validate!**auto generated**!methods!public! !
!IXMLDOMDocument2 categoriesFor: #Validate:!**auto generated**!COM Interfaces-IXMLDOMDocument2!private! !

!IXMLDOMDocument2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMDocument2'
		IXMLDOMDocument2 defineTemplate"

	self
		defineFunction: #get_namespaces:
			argumentTypes: 'IXMLDOMSchemaCollection**';
		defineFunction: #get_schemas:
			argumentTypes: 'variant*';
		defineFunction: #putref_schemas:
			argumentTypes: 'variant';
		defineFunction: #Validate:
			argumentTypes: 'IXMLDOMParseError**';
		defineFunction: #SetProperty:value:
			argumentTypes: 'bstr variant';
		defineFunction: #GetProperty:value:
			argumentTypes: 'bstr variant*'
!

newDOMDocument
	"Answer a new instance of the receiver on the DOMDocument COM object"

	^self onCLSID: (CLSID fromString: '{F6D90F11-9C73-11D3-B32E-00C04F990BB4}')
!

newDOMDocument26
	"Answer a new instance of the receiver on the DOMDocument26 COM object"

	^self onCLSID: (CLSID fromString: '{F5078F1B-C551-11D3-89B9-0000F81FE221}')
!

newDOMDocument30
	"Answer a new instance of the receiver on the DOMDocument30 COM object"

	^self onCLSID: (CLSID fromString: '{F5078F32-C551-11D3-89B9-0000F81FE221}')
!

newDOMDocument40
	"Answer a new instance of the receiver on the DOMDocument40 COM object"

	^self onCLSID: (CLSID fromString: '{88D969C0-F192-11D4-A65F-0040963251E5}')
!

newFreeThreadedDOMDocument
	"Answer a new instance of the receiver on the FreeThreadedDOMDocument COM object"

	^self onCLSID: (CLSID fromString: '{F6D90F12-9C73-11D3-B32E-00C04F990BB4}')
!

newFreeThreadedDOMDocument26
	"Answer a new instance of the receiver on the FreeThreadedDOMDocument26 COM object"

	^self onCLSID: (CLSID fromString: '{F5078F1C-C551-11D3-89B9-0000F81FE221}')
!

newFreeThreadedDOMDocument30
	"Answer a new instance of the receiver on the FreeThreadedDOMDocument30 COM object"

	^self onCLSID: (CLSID fromString: '{F5078F33-C551-11D3-89B9-0000F81FE221}')
!

newFreeThreadedDOMDocument40
	"Answer a new instance of the receiver on the FreeThreadedDOMDocument40 COM object"

	^self onCLSID: (CLSID fromString: '{88D969C1-F192-11D4-A65F-0040963251E5}')
! !
!IXMLDOMDocument2 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IXMLDOMDocument2 class categoriesFor: #newDOMDocument!**auto generated**!instance creation!public! !
!IXMLDOMDocument2 class categoriesFor: #newDOMDocument26!**auto generated**!instance creation!public! !
!IXMLDOMDocument2 class categoriesFor: #newDOMDocument30!**auto generated**!instance creation!public! !
!IXMLDOMDocument2 class categoriesFor: #newDOMDocument40!**auto generated**!instance creation!public! !
!IXMLDOMDocument2 class categoriesFor: #newFreeThreadedDOMDocument!**auto generated**!instance creation!public! !
!IXMLDOMDocument2 class categoriesFor: #newFreeThreadedDOMDocument26!**auto generated**!instance creation!public! !
!IXMLDOMDocument2 class categoriesFor: #newFreeThreadedDOMDocument30!**auto generated**!instance creation!public! !
!IXMLDOMDocument2 class categoriesFor: #newFreeThreadedDOMDocument40!**auto generated**!instance creation!public! !

