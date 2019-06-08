"Filed out from Dolphin Smalltalk 7"!

ADODBRecordset21 subclass: #ADODB_Recordset
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODB_Recordset guid: (IID fromString: '{00000556-0000-0010-8000-00AA006D2EA4}')!
ADODB_Recordset comment: '<ADODB_Recordset> is a wrapper class for the COM interface ''ADODB._Recordset'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

Example:

	rs := ADODB_Recordset new.
	"Assumes an ODBC DSN is defined for the Microsoft Northwind sample database"
	rs open: ''Employees'' activeConnection: ''DSN=NWind''.
	"Get the employees names"
	rs collect: [:each | (each item: ''LastName'') value].
	
'!
!ADODB_Recordset categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB_Recordset methodsFor!

save
	"Invoke the Save() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 save: VARIANT unspecified
		 persistFormat: 0!

save: destination persistFormat: persistFormat
	"Invoke the Save() method of the COM object."

	^self
		Save: destination asVariant
		PersistFormat: persistFormat
!

Save: destination PersistFormat: persistFormat
	"Private - Invoke the Save() method of the COM object.

		HRESULT __stdcall Save(
			[in, optional] VARIANT Destination,
			[in, optional, defaultvalue(0)] PersistFormatEnum PersistFormat);"

	<virtual stdcall: hresult 85 variant sdword>
	^self invalidCall: _failureCode! !
!ADODB_Recordset categoriesFor: #save!**auto generated**!methods!public! !
!ADODB_Recordset categoriesFor: #save:persistFormat:!**auto generated**!methods!public! !
!ADODB_Recordset categoriesFor: #Save:PersistFormat:!**auto generated**!COM Interfaces-_Recordset!private! !

!ADODB_Recordset class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Recordset) for which the receiver is the default interface."

	^CLSID fromString: '{00000535-0000-0010-8000-00AA006D2EA4}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Recordset'
		ADODB_Recordset defineTemplate"

	self
		defineFunction: #Save:PersistFormat:
			argumentTypes: 'variant sdword'
! !
!ADODB_Recordset class categoriesFor: #clsid!**auto generated**!constants!private! !
!ADODB_Recordset class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

