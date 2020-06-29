"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IMXSchemaDeclHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IMXSchemaDeclHandler guid: (IID fromString: '{fa4bb38c-faf9-4cca-9302-d1dd0fe520db}')!
IMXSchemaDeclHandler comment: '<IMXSchemaDeclHandler> is a wrapper class for the COM interface ''MSXML2.IMXSchemaDeclHandler'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IMXSchemaDeclHandler interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(FA4BB38C-FAF9-4CCA-9302-D1DD0FE520DB), 
	helpstring("IMXSchemaDeclHandler interface"), 
	dual, 
	nonextensible
]
interface IMXSchemaDeclHandler : IDispatch
 {
	[id(0x0000057b), helpstring("Access schema element declaration")]
	HRESULT __stdcall schemaElementDecl(
		[in]ISchemaElement* oSchemaElement);
};
'!
!IMXSchemaDeclHandler categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IMXSchemaDeclHandler methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

SchemaElementDecl: oSchemaElement
	"Invoke the schemaElementDecl() method of the COM object.
	Helpstring: Access schema element declaration

		HRESULT __stdcall schemaElementDecl(
			[in]ISchemaElement* oSchemaElement);"

	<virtual stdcall: hresult 8 ISchemaElement*>
	^self invalidCall: _failureCode! !
!IMXSchemaDeclHandler categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IMXSchemaDeclHandler categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IMXSchemaDeclHandler categoriesFor: #SchemaElementDecl:!**auto generated**!COM Interfaces-IMXSchemaDeclHandler!public! !

!IMXSchemaDeclHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IMXSchemaDeclHandler'
		IMXSchemaDeclHandler defineTemplate"

	self
		defineFunction: #SchemaElementDecl:
			argumentTypes: 'ISchemaElement*'
! !
!IMXSchemaDeclHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

