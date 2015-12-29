"Filed out from Dolphin Smalltalk X6"!

IVSSDatabaseOld subclass: #IVSSDatabase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSDatabase guid: (IID fromString: '{2A0DE0E2-2E9F-11D0-9236-00AA00A1EB95}')!
IVSSDatabase comment: '<IVSSDatabase> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSDatabase'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe database object interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSDatabase categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSDatabase methodsFor!

addUser: user password: password readOnly: readOnly 
	"Answer the <IVSSUser> result of invoking the COM Object's AddUser() method."

	| answer |
	answer := IVSSUser newPointer.
	self
		AddUser: user
		Password: password
		ReadOnly: readOnly
		ppIUser: answer.
	^answer asObject
!

AddUser: user Password: password ReadOnly: readOnly ppIUser: ppIUser
	"Private - Invoke the AddUser() method of the COM object wrapped by the receiver.

		HRESULT __stdcall AddUser(
			[in] BSTR User,
			[in] BSTR Password,
			[in] VARIANT_BOOL ReadOnly,
			[out, retval] IVSSUser** ppIUser);
	"

	<virtual stdcall: hresult 15 bstr bstr varbool IVSSUser**>
	^self invalidCall
!

defaultProjectRights
	"Answer the <sdword> value of the 'DefaultProjectRights' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self
		get_DefaultProjectRights: answer.
	^answer asObject
!

defaultProjectRights: pRights 
	"Set the 'DefaultProjectRights' property of the receiver to the <sdword> value of the argument."

	self
		put_DefaultProjectRights: pRights
!

get_DefaultProjectRights: pRights
	"Private - Get the value of the 'DefaultProjectRights' property of the receiver.

		HRESULT __stdcall DefaultProjectRights(
			[out, retval] long* pRights);
	"

	<virtual stdcall: hresult 20 sdword*>
	^self invalidCall
!

get_ProjectRightsEnabled: pEnabled
	"Private - Get the value of the 'ProjectRightsEnabled' property of the receiver.

		HRESULT __stdcall ProjectRightsEnabled(
			[out, retval] VARIANT_BOOL* pEnabled);
	"

	<virtual stdcall: hresult 18 varbool*>
	^self invalidCall
!

get_User: name ppIUser: ppIUser
	"Private - Get the value of the 'User' property of the receiver.

		HRESULT __stdcall User(
			[in] BSTR Name,
			[out, retval] IVSSUser** ppIUser);
	"

	<virtual stdcall: hresult 16 bstr IVSSUser**>
	^self invalidCall
!

get_Users: ppIUsers
	"Private - Get the value of the 'Users' property of the receiver.

		HRESULT __stdcall Users(
			[out, retval] IVSSUsers** ppIUsers);
	"

	<virtual stdcall: hresult 17 IVSSUsers**>
	^self invalidCall
!

projectRightsEnabled
	"Answer the <varbool> value of the 'ProjectRightsEnabled' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		get_ProjectRightsEnabled: answer.
	^answer asObject
!

projectRightsEnabled: pEnabled 
	"Set the 'ProjectRightsEnabled' property of the receiver to the <varbool> value of the argument."

	self
		put_ProjectRightsEnabled: pEnabled
!

put_DefaultProjectRights: pRights
	"Private - Set the value of the 'DefaultProjectRights' property of the object wrapped by the 
	 receiver to the <sdword> argument, pRights.

		HRESULT __stdcall DefaultProjectRights(
			[in] long pRights);
	"

	<virtual stdcall: hresult 21 sdword>
	^self invalidCall
!

put_ProjectRightsEnabled: pEnabled
	"Private - Set the value of the 'ProjectRightsEnabled' property of the object wrapped by the 
	 receiver to the <varbool> argument, pEnabled.

		HRESULT __stdcall ProjectRightsEnabled(
			[in] VARIANT_BOOL pEnabled);
	"

	<virtual stdcall: hresult 19 varbool>
	^self invalidCall
!

user: name 
	"Answer the <IVSSUser> value of the 'User' property of the receiver."

	| answer |
	answer := IVSSUser newPointer.
	self
		get_User: name
		ppIUser: answer.
	^answer asObject
!

users
	"Answer the <IVSSUsers> value of the 'Users' property of the receiver."

	| answer |
	answer := IVSSUsers newPointer.
	self
		get_Users: answer.
	^answer asObject
! !
!IVSSDatabase categoriesFor: #addUser:password:readOnly:!**auto generated**!methods!public! !
!IVSSDatabase categoriesFor: #AddUser:Password:ReadOnly:ppIUser:!**auto generated**!COM Interfaces-IVSSDatabase!private! !
!IVSSDatabase categoriesFor: #defaultProjectRights!**auto generated**!properties!public! !
!IVSSDatabase categoriesFor: #defaultProjectRights:!**auto generated**!properties!public! !
!IVSSDatabase categoriesFor: #get_DefaultProjectRights:!COM Interfaces-IVSSDatabase!private! !
!IVSSDatabase categoriesFor: #get_ProjectRightsEnabled:!COM Interfaces-IVSSDatabase!private! !
!IVSSDatabase categoriesFor: #get_User:ppIUser:!COM Interfaces-IVSSDatabase!private! !
!IVSSDatabase categoriesFor: #get_Users:!COM Interfaces-IVSSDatabase!private! !
!IVSSDatabase categoriesFor: #projectRightsEnabled!**auto generated**!properties!public! !
!IVSSDatabase categoriesFor: #projectRightsEnabled:!**auto generated**!properties!public! !
!IVSSDatabase categoriesFor: #put_DefaultProjectRights:!COM Interfaces-IVSSDatabase!private! !
!IVSSDatabase categoriesFor: #put_ProjectRightsEnabled:!COM Interfaces-IVSSDatabase!private! !
!IVSSDatabase categoriesFor: #user:!**auto generated**!properties!public! !
!IVSSDatabase categoriesFor: #users!**auto generated**!properties!public! !

!IVSSDatabase class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (VSSDatabase) for which the receiver is the default interface.
	"

	^CLSID fromString: '{783CD4E4-9D54-11CF-B8EE-00608CC9A71F}'
! !
!IVSSDatabase class categoriesFor: #clsid!**auto generated**!constants!private! !

