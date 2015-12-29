"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IAgentCtlCharacters
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlCharacters guid: (IID fromString: '{F5BE8BE8-7DE6-11D0-91FE-00C04FD701A5}')!
IAgentCtlCharacters comment: '<IAgentCtlCharacters> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlCharacters'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlCharacters Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlCharacters categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlCharacters methodsFor!

character: characterID
	"Answer the <IAgentCtlCharacterEx> result of invoking the Character() method of the COM object."

	| answer |
	answer := IAgentCtlCharacterEx newPointer.
	self
		Character: characterID
		ppidItem: answer.
	^answer asObject
!

Character: characterID ppidItem: ppidItem
	"Private - Invoke the Character() method of the COM object.

		HRESULT __stdcall Character(
			[in] BSTR CharacterID,
			[out, retval] IAgentCtlCharacterEx** ppidItem);"

	<virtual stdcall: hresult 9 bstr IAgentCtlCharacterEx**>
	^self invalidCall
!

enum
	"Answer the <IUnknown> value of the 'Enum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_Enum: answer.
	^answer asObject
!

get_Enum: ppunkEnum
	"Private - Get the value of the 'Enum' property of the receiver.
				HRESULT __stdcall Enum(
			[out, retval] IUnknown** ppunkEnum);"

	<virtual stdcall: hresult 10 IUnknown**>
	^self invalidCall
!

get_Item: characterID ppidItem: ppidItem
	"Private - Get the value of the 'Item' property of the receiver.
				HRESULT __stdcall Item(
			[in] BSTR CharacterID,
			[out, retval] IAgentCtlCharacterEx** ppidItem);"

	<virtual stdcall: hresult 8 bstr IAgentCtlCharacterEx**>
	^self invalidCall
!

item: characterID
	"Answer the <IAgentCtlCharacterEx> value of the 'Item' property of the receiver."

	| answer |
	answer := IAgentCtlCharacterEx newPointer.
	self
		get_Item: characterID
		ppidItem: answer.
	^answer asObject
!

load: characterID
	"Answer the <IAgentCtlRequest> result of invoking the Load() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 load: characterID
		 loadKey: VARIANT unspecified!

load: characterID loadKey: loadKey
	"Answer the <IAgentCtlRequest> result of invoking the Load() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		Load: characterID
		LoadKey: loadKey asVariant
		ppidRequest: answer.
	^answer asObject
!

Load: characterID LoadKey: loadKey ppidRequest: ppidRequest
	"Private - Invoke the Load() method of the COM object.

		HRESULT __stdcall Load(
			[in] BSTR CharacterID,
			[in, optional] VARIANT LoadKey,
			[out, retval] IAgentCtlRequest** ppidRequest);"

	<virtual stdcall: hresult 12 bstr variant IAgentCtlRequest**>
	^self invalidCall
!

unload: characterID
	"Invoke the Unload() method of the COM object."

	^self Unload: characterID
!

Unload: characterID
	"Private - Invoke the Unload() method of the COM object.

		HRESULT __stdcall Unload(
			[in] BSTR CharacterID);"

	<virtual stdcall: hresult 11 bstr>
	^self invalidCall
! !
!IAgentCtlCharacters categoriesFor: #character:!**auto generated**!methods!public! !
!IAgentCtlCharacters categoriesFor: #Character:ppidItem:!**auto generated**!COM Interfaces-IAgentCtlCharacters!private! !
!IAgentCtlCharacters categoriesFor: #enum!**auto generated**!properties!public! !
!IAgentCtlCharacters categoriesFor: #get_Enum:!**auto generated**!COM Interfaces-IAgentCtlCharacters!private! !
!IAgentCtlCharacters categoriesFor: #get_Item:ppidItem:!**auto generated**!COM Interfaces-IAgentCtlCharacters!private! !
!IAgentCtlCharacters categoriesFor: #item:!**auto generated**!properties!public! !
!IAgentCtlCharacters categoriesFor: #load:!**auto generated**!methods!public! !
!IAgentCtlCharacters categoriesFor: #load:loadKey:!**auto generated**!methods!public! !
!IAgentCtlCharacters categoriesFor: #Load:LoadKey:ppidRequest:!**auto generated**!COM Interfaces-IAgentCtlCharacters!private! !
!IAgentCtlCharacters categoriesFor: #unload:!**auto generated**!methods!public! !
!IAgentCtlCharacters categoriesFor: #Unload:!**auto generated**!COM Interfaces-IAgentCtlCharacters!private! !

!IAgentCtlCharacters class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlCharacters'
		IAgentCtlCharacters defineTemplate"

	self
		defineFunction: #get_Item:ppidItem:
			argumentTypes: 'bstr IAgentCtlCharacterEx**';
		defineFunction: #Character:ppidItem:
			argumentTypes: 'bstr IAgentCtlCharacterEx**';
		defineFunction: #get_Enum:
			argumentTypes: 'IUnknown**';
		defineFunction: #Unload:
			argumentTypes: 'bstr';
		defineFunction: #Load:LoadKey:ppidRequest:
			argumentTypes: 'bstr variant IAgentCtlRequest**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlCharacters initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlCharacters class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlCharacters class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

