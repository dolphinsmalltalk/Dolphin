"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IVSSUser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSUser guid: (IID fromString: '{2A0DE0E3-2E9F-11D0-9236-00AA00A1EB95}')!
IVSSUser comment: '<IVSSUser> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSUser'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe user object interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSUser categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSUser methodsFor!

Delete 
	"Invoke the Delete() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Delete();
	"

	<virtual stdcall: hresult 8>
	^self invalidCall
!

get_Name: pName
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval] BSTR* pName);
	"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall
!

get_ProjectRights: project piRightsOut: piRightsOut
	"Private - Get the value of the 'ProjectRights' property of the receiver.

		HRESULT __stdcall ProjectRights(
			[in, optional, defaultvalue($/)] BSTR Project,
			[out, retval] long* piRightsOut);
	"

	<virtual stdcall: hresult 14 bstr sdword*>
	^self invalidCall
!

get_ReadOnly: pReadOnly
	"Private - Get the value of the 'ReadOnly' property of the receiver.

		HRESULT __stdcall ReadOnly(
			[out, retval] VARIANT_BOOL* pReadOnly);
	"

	<virtual stdcall: hresult 12 varbool*>
	^self invalidCall
!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_Name: answer.
	^answer asObject
!

name: pName 
	"Set the 'Name' property of the receiver to the <bstr> value of the argument."

	self
		put_Name: pName
!

password: arg1 
	"Set the 'Password' property of the receiver to the <bstr> value of the argument."

	self
		put_Password: arg1
!

projectRights: project 
	"Answer the <sdword> value of the 'ProjectRights' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self
		get_ProjectRights: project
		piRightsOut: answer.
	^answer asObject
!

projectRights: project piRightsOut: piRightsOut 
	"Set the 'ProjectRights' property of the receiver to the <sdword> value of the argument."

	self
		put_ProjectRights: project
		piRightsOut: piRightsOut
!

put_Name: pName
	"Private - Set the value of the 'Name' property of the object wrapped by the 
	 receiver to the <bstr> argument, pName.

		HRESULT __stdcall Name(
			[in] BSTR pName);
	"

	<virtual stdcall: hresult 10 bstr>
	^self invalidCall
!

put_Password: arg1
	"Private - Set the value of the 'Password' property of the object wrapped by the 
	 receiver to the <bstr> argument, arg1.

		HRESULT __stdcall Password(
			[in] BSTR arg1);
	"

	<virtual stdcall: hresult 11 bstr>
	^self invalidCall
!

put_ProjectRights: project piRightsOut: piRightsOut
	"Private - Set the value of the 'ProjectRights' property of the object wrapped by the 
	 receiver to the <sdword> argument, piRightsOut.

		HRESULT __stdcall ProjectRights(
			[in, optional, defaultvalue($/)] BSTR Project,
			[in] long piRightsOut);
	"

	<virtual stdcall: hresult 15 bstr sdword>
	^self invalidCall
!

put_ReadOnly: pReadOnly
	"Private - Set the value of the 'ReadOnly' property of the object wrapped by the 
	 receiver to the <varbool> argument, pReadOnly.

		HRESULT __stdcall ReadOnly(
			[in] VARIANT_BOOL pReadOnly);
	"

	<virtual stdcall: hresult 13 varbool>
	^self invalidCall
!

readOnly
	"Answer the <varbool> value of the 'ReadOnly' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		get_ReadOnly: answer.
	^answer asObject
!

readOnly: pReadOnly 
	"Set the 'ReadOnly' property of the receiver to the <varbool> value of the argument."

	self
		put_ReadOnly: pReadOnly
!

RemoveProjectRights: project
	"Invoke the RemoveProjectRights() method of the COM object wrapped by the receiver.

		HRESULT __stdcall RemoveProjectRights(
			[in] BSTR Project);
	"

	<virtual stdcall: hresult 16 bstr>
	^self invalidCall
! !
!IVSSUser categoriesFor: #Delete!**auto generated**!COM Interfaces-IVSSUser!public! !
!IVSSUser categoriesFor: #get_Name:!COM Interfaces-IVSSUser!private! !
!IVSSUser categoriesFor: #get_ProjectRights:piRightsOut:!COM Interfaces-IVSSUser!private! !
!IVSSUser categoriesFor: #get_ReadOnly:!COM Interfaces-IVSSUser!private! !
!IVSSUser categoriesFor: #name!**auto generated**!properties!public! !
!IVSSUser categoriesFor: #name:!**auto generated**!properties!public! !
!IVSSUser categoriesFor: #password:!**auto generated**!properties!public! !
!IVSSUser categoriesFor: #projectRights:!**auto generated**!properties!public! !
!IVSSUser categoriesFor: #projectRights:piRightsOut:!**auto generated**!properties!public! !
!IVSSUser categoriesFor: #put_Name:!COM Interfaces-IVSSUser!private! !
!IVSSUser categoriesFor: #put_Password:!COM Interfaces-IVSSUser!private! !
!IVSSUser categoriesFor: #put_ProjectRights:piRightsOut:!COM Interfaces-IVSSUser!private! !
!IVSSUser categoriesFor: #put_ReadOnly:!COM Interfaces-IVSSUser!private! !
!IVSSUser categoriesFor: #readOnly!**auto generated**!properties!public! !
!IVSSUser categoriesFor: #readOnly:!**auto generated**!properties!public! !
!IVSSUser categoriesFor: #RemoveProjectRights:!**auto generated**!COM Interfaces-IVSSUser!public! !

