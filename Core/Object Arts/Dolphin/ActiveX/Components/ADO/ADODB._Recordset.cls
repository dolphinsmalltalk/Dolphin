"Filed out from Dolphin Smalltalk 7"!

ADODB.Recordset21 subclass: #'ADODB._Recordset'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB._Recordset guid: (OS.COM.IID fromString: '{00001556-0000-0010-8000-00aa006d2ea4}')!
ADODB._Recordset comment: '`ADODB_Recordset` is a wrapper class for the COM interface ''ADODB._Recordset'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001556-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c903), 
	hidden, 
	nonextensible, 
	dual
]
interface _Recordset : Recordset21
 {
	[id(0x00000421), helpcontext(0x0012c8df)]
	HRESULT __stdcall Save(
		[in, optional]VARIANT Destination,
		[in, defaultvalue(0)]PersistFormatEnum PersistFormat);
};
```
'!
!ADODB._Recordset categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB._Recordset methodsFor!

save
	"Invoke the Save() method of the COM object.
	Default values are passed for all optional parameters."

	^self save: VARIANT unspecified persistFormat: 0!

save: destination persistFormat: persistFormat
	"Invoke the Save() method of the COM object."

	^self Save: destination asVariant PersistFormat: persistFormat!

Save: destination PersistFormat: persistFormat
	"Private - Invoke the Save() method of the COM object.

		HRESULT __stdcall Save(
			[in, optional]VARIANT Destination,
			[in, defaultvalue(0)]PersistFormatEnum PersistFormat);"

	<virtual stdcall: hresult 85 variant sdword>
	^self invalidCall: _failureCode! !
!ADODB._Recordset categoriesFor: #save!**auto generated**!methods!public! !
!ADODB._Recordset categoriesFor: #save:persistFormat:!**auto generated**!methods!public! !
!ADODB._Recordset categoriesFor: #Save:PersistFormat:!**auto generated**!COM Interfaces-_Recordset!private! !

!ADODB._Recordset class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Recordset) for which the receiver is the default interface."

	^CLSID fromString: '{00000535-0000-0010-8000-00aa006d2ea4}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Recordset'
		_Recordset defineTemplate"

	self
		defineFunction: #Save:PersistFormat:
			argumentTypes: 'variant sdword'
!

example1
	| rs |
	rs := _Recordset new.
	"Assumes an ODBC DSN is defined for the Microsoft Northwind sample database"
	rs open: 'Employees' activeConnection: 'DSN=Northwind'.
	"Get the employees names"
	rs collect: [:each | (each item: 'LastName') value]! !
!ADODB._Recordset class categoriesFor: #clsid!**auto generated**!constants!private! !
!ADODB._Recordset class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ADODB._Recordset class categoriesFor: #example1!examples!public! !

