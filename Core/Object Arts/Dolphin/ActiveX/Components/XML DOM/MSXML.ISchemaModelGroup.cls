"Filed out from Dolphin Smalltalk 7"!

MSXML.ISchemaParticle subclass: #'MSXML.ISchemaModelGroup'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISchemaModelGroup guid: (OS.COM.IID fromString: '{50ea08bb-dd1b-4664-9a50-c2f40f4bd79a}')!
MSXML.ISchemaModelGroup comment: '<ISchemaModelGroup> is a wrapper class for the COM interface ''MSXML2.ISchemaModelGroup'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema Type"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08BB-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema Type"), 
	dual, 
	nonextensible
]
interface ISchemaModelGroup : ISchemaParticle
 {
	[id(0x000005b5), propget]
	HRESULT __stdcall particles(
		[out, retval]ISchemaItemCollection** particles);
};
'!
!MSXML.ISchemaModelGroup categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISchemaModelGroup methodsFor!

get_particles: particles
	"Private - Get the value of the 'particles' property of the receiver.

		HRESULT __stdcall particles(
			[out, retval]ISchemaItemCollection** particles);"

	<virtual stdcall: hresult 17 ISchemaItemCollection**>
	^self invalidCall: _failureCode!

particles
	"Answer the <ISchemaItemCollection> value of the 'particles' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_particles: answer.
	^answer asObject! !
!MSXML.ISchemaModelGroup categoriesFor: #get_particles:!**auto generated**!COM Interfaces-ISchemaModelGroup!private! !
!MSXML.ISchemaModelGroup categoriesFor: #particles!**auto generated**!properties!public! !

!MSXML.ISchemaModelGroup class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaModelGroup'
		ISchemaModelGroup defineTemplate"

	self
		defineFunction: #get_particles:
			argumentTypes: 'ISchemaItemCollection**'
! !
!MSXML.ISchemaModelGroup class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

