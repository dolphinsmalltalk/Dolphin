"Filed out from Dolphin Smalltalk 7"!

ADODBFields15 subclass: #ADODBFields20
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODBFields20 guid: (IID fromString: '{0000054D-0000-0010-8000-00AA006D2EA4}')!
ADODBFields20 comment: '<ADODBFields20> is a wrapper class for the COM interface ''ADODB.Fields20'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

ADODBFields20 is the ADODBFields interface as defined in version 2.0 of ADO, and has been superceded by later versions (see the subclasses).'!
!ADODBFields20 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBFields20 methodsFor!

_append: name type: type
	"Invoke the _Append() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 _Append: name
		 Type: type
		 DefinedSize: 0
		 Attrib: -1!

_Append: name Type: type DefinedSize: definedSize Attrib: attrib
	"Invoke the _Append() method of the COM object.

		HRESULT __stdcall _Append(
			[in] BSTR Name,
			[in] DataTypeEnum Type,
			[in, optional, defaultvalue(0)] long DefinedSize,
			[in, optional, defaultvalue(-1)] FieldAttributeEnum Attrib);"

	<virtual stdcall: hresult 12 bstr sdword sdword sdword>
	^self invalidCall: _failureCode!

delete: index
	"Invoke the Delete() method of the COM object."

	^self Delete: index asVariant
!

Delete: index
	"Private - Invoke the Delete() method of the COM object.

		HRESULT __stdcall Delete(
			[in] VARIANT Index);"

	<virtual stdcall: hresult 13 variant>
	^self invalidCall: _failureCode! !
!ADODBFields20 categoriesFor: #_append:type:!**auto generated**!methods!public! !
!ADODBFields20 categoriesFor: #_Append:Type:DefinedSize:Attrib:!**auto generated**!COM Interfaces-Fields20!public! !
!ADODBFields20 categoriesFor: #delete:!**auto generated**!methods!public! !
!ADODBFields20 categoriesFor: #Delete:!**auto generated**!COM Interfaces-Fields20!private! !

!ADODBFields20 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Fields20'
		ADODBFields20 defineTemplate"

	self
		defineFunction: #_Append:Type:DefinedSize:Attrib:
			argumentTypes: 'bstr sdword sdword sdword';
		defineFunction: #Delete:
			argumentTypes: 'variant'
! !
!ADODBFields20 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

