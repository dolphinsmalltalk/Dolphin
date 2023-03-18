"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'CDO.IConfiguration'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
CDO.IConfiguration guid: (OS.COM.IID fromString: '{cd000022-8b95-11d1-82db-00c04fb1625d}')!
CDO.IConfiguration comment: '<CDO.IConfiguration> is a wrapper class for the COM interface ''CDO.IConfiguration'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to manage configuration information for CDO objects"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDO.IConfiguration categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDO.IConfiguration methodsFor!

fields
	"Answer the <ADODB.Fields> value of the 'Fields' property of the receiver.
	Helpstring: 'Returns the Fields collection for the object'
	Implementation Note: Originally auto-generated from the ADO type library,
	this method has been modified to answer a Smalltalk <sequencedReadableCollection>."

	| answer |
	answer := ADODB.Fields newPointer.
	self get_Fields: answer.
	^ADODB.ADOCollection on: answer

!

get_Fields: varFields
	"Private - Get the value of the 'Fields' property of the receiver.

		HRESULT __stdcall Fields(
			[out, retval]Fields** varFields);"

	<virtual stdcall: hresult 8 ADODB.Fields**>
	^self invalidCall: _failureCode!

getInterface: interface
	"Answer the <IDispatch> result of invoking the GetInterface() method of the COM object.
	Helpstring: Returns a specified interface on this object; provided for script languages."

	| answer |
	answer := IDispatch newPointer.
	self GetInterface: interface ppUnknown: answer.
	^answer asObject!

GetInterface: interface ppUnknown: ppUnknown
	"Private - Invoke the GetInterface() method of the COM object.
	Helpstring: Returns a specified interface on this object; provided for script languages.

		HRESULT __stdcall GetInterface(
			[in]BSTR Interface,
			[out, retval]IDispatch** ppUnknown);"

	<virtual stdcall: hresult 10 bstr IDispatch**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

load: loadFrom
	"Invoke the Load() method of the COM object.
	Default values are passed for all optional parameters."

	^self Load: loadFrom URL: nil!

Load: loadFrom URL: url
	"Invoke the Load() method of the COM object.
	Helpstring: Loads the specified configuration.

		HRESULT __stdcall Load(
			[in]CdoConfigSource LoadFrom,
			[in, optional]BSTR URL);"

	<virtual stdcall: hresult 9 int32 bstr>
	^self invalidCall: _failureCode!

value
	"Answer the <ADODB.Fields> value of the 'Fields' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self fields! !
!CDO.IConfiguration categoriesForMethods!
fields!properties!public! !
get_Fields:!**auto generated**!COM Interfaces-IConfiguration!private! !
getInterface:!**auto generated**!methods!public! !
GetInterface:ppUnknown:!**auto generated**!COM Interfaces-IConfiguration!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
load:!**auto generated**!methods!public! !
Load:URL:!**auto generated**!COM Interfaces-IConfiguration!public! !
value!**auto generated**!properties!public! !
!

!CDO.IConfiguration class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Configuration) for which the receiver is the default interface."

	^CLSID fromString: '{cd000002-8b95-11d1-82db-00c04fb1625d}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IConfiguration'
		IConfiguration defineTemplate"

	self
		defineFunction: #get_Fields:
			argumentTypes: 'ADODB.Fields**';
		defineFunction: #Load:URL:
			argumentTypes: 'sdword bstr';
		defineFunction: #GetInterface:ppUnknown:
			argumentTypes: 'bstr IDispatch**'
! !
!CDO.IConfiguration class categoriesForMethods!
clsid!**auto generated**!constants!private! !
defineFunctions!**auto generated**!initializing!private! !
!

