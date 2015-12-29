"Filed out from Dolphin Smalltalk X6"!

IAgentCtlCharacter subclass: #IAgentCtlCharacterEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlCharacterEx guid: (IID fromString: '{DE8EF600-2F82-11D1-ACAC-00C04FD97575}')!
IAgentCtlCharacterEx comment: '<IAgentCtlCharacterEx> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlCharacterEx'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlCharacterEx Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlCharacterEx categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlCharacterEx methodsFor!

active
	"Answer the <sword> value of the 'Active' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Active: answer.
	^answer asObject
!

animationNames
	"Answer the <IAgentCtlAnimationNames> value of the 'AnimationNames' property of the receiver."

	| answer |
	answer := IAgentCtlAnimationNames newPointer.
	self get_AnimationNames: answer.
	^answer asObject
!

autoPopupMenu
	"Answer the <varbool> value of the 'AutoPopupMenu' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_AutoPopupMenu: answer.
	^answer asObject
!

autoPopupMenu: on
	"Set the 'AutoPopupMenu' property of the receiver to the <varbool> value of the argument."

	self put_AutoPopupMenu: on
!

get_Active: state
	"Private - Get the value of the 'Active' property of the receiver.
				HRESULT __stdcall Active(
			[out, retval] short* State);"

	<virtual stdcall: hresult 52 sword*>
	^self invalidCall
!

get_AnimationNames: names
	"Private - Get the value of the 'AnimationNames' property of the receiver.
				HRESULT __stdcall AnimationNames(
			[out, retval] IAgentCtlAnimationNames** Names);"

	<virtual stdcall: hresult 67 IAgentCtlAnimationNames**>
	^self invalidCall
!

get_AutoPopupMenu: on
	"Private - Get the value of the 'AutoPopupMenu' property of the receiver.
				HRESULT __stdcall AutoPopupMenu(
			[out, retval] VARIANT_BOOL* On);"

	<virtual stdcall: hresult 47 varbool*>
	^self invalidCall
!

get_GUID: guid
	"Private - Get the value of the 'GUID' property of the receiver.
				HRESULT __stdcall GUID(
			[out, retval] BSTR* GUID);"

	<virtual stdcall: hresult 62 bstr*>
	^self invalidCall
!

get_HelpContextID: id
	"Private - Get the value of the 'HelpContextID' property of the receiver.
				HRESULT __stdcall HelpContextID(
			[out, retval] long* ID);"

	<virtual stdcall: hresult 51 sdword*>
	^self invalidCall
!

get_HelpFile: file
	"Private - Get the value of the 'HelpFile' property of the receiver.
				HRESULT __stdcall HelpFile(
			[out, retval] BSTR* File);"

	<virtual stdcall: hresult 60 bstr*>
	^self invalidCall
!

get_HelpModeOn: on
	"Private - Get the value of the 'HelpModeOn' property of the receiver.
				HRESULT __stdcall HelpModeOn(
			[out, retval] VARIANT_BOOL* On);"

	<virtual stdcall: hresult 49 varbool*>
	^self invalidCall
!

get_LanguageID: languageID
	"Private - Get the value of the 'LanguageID' property of the receiver.
				HRESULT __stdcall LanguageID(
			[out, retval] long* LanguageID);"

	<virtual stdcall: hresult 55 sdword*>
	^self invalidCall
!

get_OriginalHeight: height
	"Private - Get the value of the 'OriginalHeight' property of the receiver.
				HRESULT __stdcall OriginalHeight(
			[out, retval] short* Height);"

	<virtual stdcall: hresult 63 sword*>
	^self invalidCall
!

get_OriginalWidth: width
	"Private - Get the value of the 'OriginalWidth' property of the receiver.
				HRESULT __stdcall OriginalWidth(
			[out, retval] short* Width);"

	<virtual stdcall: hresult 64 sword*>
	^self invalidCall
!

get_SRModeID: engineModeId
	"Private - Get the value of the 'SRModeID' property of the receiver.
				HRESULT __stdcall SRModeID(
			[out, retval] BSTR* EngineModeId);"

	<virtual stdcall: hresult 56 bstr*>
	^self invalidCall
!

get_SRStatus: status
	"Private - Get the value of the 'SRStatus' property of the receiver.
				HRESULT __stdcall SRStatus(
			[out, retval] long* Status);"

	<virtual stdcall: hresult 68 sdword*>
	^self invalidCall
!

get_TTSModeID: engineModeId
	"Private - Get the value of the 'TTSModeID' property of the receiver.
				HRESULT __stdcall TTSModeID(
			[out, retval] BSTR* EngineModeId);"

	<virtual stdcall: hresult 58 bstr*>
	^self invalidCall
!

get_Version: version
	"Private - Get the value of the 'Version' property of the receiver.
				HRESULT __stdcall Version(
			[out, retval] BSTR* Version);"

	<virtual stdcall: hresult 66 bstr*>
	^self invalidCall
!

guid
	"Answer the <bstr> value of the 'GUID' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_GUID: answer.
	^answer asObject
!

helpContextID
	"Answer the <sdword> value of the 'HelpContextID' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_HelpContextID: answer.
	^answer asObject
!

helpContextID: id
	"Set the 'HelpContextID' property of the receiver to the <sdword> value of the argument."

	self put_HelpContextID: id
!

helpFile
	"Answer the <bstr> value of the 'HelpFile' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_HelpFile: answer.
	^answer asObject
!

helpFile: file
	"Set the 'HelpFile' property of the receiver to the <bstr> value of the argument."

	self put_HelpFile: file
!

helpModeOn
	"Answer the <varbool> value of the 'HelpModeOn' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_HelpModeOn: answer.
	^answer asObject
!

helpModeOn: on
	"Set the 'HelpModeOn' property of the receiver to the <varbool> value of the argument."

	self put_HelpModeOn: on
!

languageID
	"Answer the <sdword> value of the 'LanguageID' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_LanguageID: answer.
	^answer asObject
!

languageID: languageID
	"Set the 'LanguageID' property of the receiver to the <sdword> value of the argument."

	self put_LanguageID: languageID
!

listen: listen
	"Answer the <VARIANT_BOOL> result of invoking the Listen() method of the COM object."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		Listen: listen
		StartedListening: answer.
	^answer asObject
!

Listen: listen StartedListening: startedListening
	"Private - Invoke the Listen() method of the COM object.

		HRESULT __stdcall Listen(
			[in] VARIANT_BOOL Listen,
			[out, retval] VARIANT_BOOL* StartedListening);"

	<virtual stdcall: hresult 53 varbool varbool*>
	^self invalidCall
!

originalHeight
	"Answer the <sword> value of the 'OriginalHeight' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_OriginalHeight: answer.
	^answer asObject
!

originalWidth
	"Answer the <sword> value of the 'OriginalWidth' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_OriginalWidth: answer.
	^answer asObject
!

put_AutoPopupMenu: on
	"Private - Set the value of the 'AutoPopupMenu' property of the object wrapped by the 
	 receiver to the <varbool> argument, on.
				HRESULT __stdcall AutoPopupMenu(
			[in] VARIANT_BOOL On);"

	<virtual stdcall: hresult 46 varbool>
	^self invalidCall
!

put_HelpContextID: id
	"Private - Set the value of the 'HelpContextID' property of the object wrapped by the 
	 receiver to the <sdword> argument, id.
				HRESULT __stdcall HelpContextID(
			[in] long ID);"

	<virtual stdcall: hresult 50 sdword>
	^self invalidCall
!

put_HelpFile: file
	"Private - Set the value of the 'HelpFile' property of the object wrapped by the 
	 receiver to the <bstr> argument, file.
				HRESULT __stdcall HelpFile(
			[in] BSTR File);"

	<virtual stdcall: hresult 61 bstr>
	^self invalidCall
!

put_HelpModeOn: on
	"Private - Set the value of the 'HelpModeOn' property of the object wrapped by the 
	 receiver to the <varbool> argument, on.
				HRESULT __stdcall HelpModeOn(
			[in] VARIANT_BOOL On);"

	<virtual stdcall: hresult 48 varbool>
	^self invalidCall
!

put_LanguageID: languageID
	"Private - Set the value of the 'LanguageID' property of the object wrapped by the 
	 receiver to the <sdword> argument, languageID.
				HRESULT __stdcall LanguageID(
			[in] long LanguageID);"

	<virtual stdcall: hresult 54 sdword>
	^self invalidCall
!

put_SRModeID: engineModeId
	"Private - Set the value of the 'SRModeID' property of the object wrapped by the 
	 receiver to the <bstr> argument, engineModeId.
				HRESULT __stdcall SRModeID(
			[in] BSTR EngineModeId);"

	<virtual stdcall: hresult 57 bstr>
	^self invalidCall
!

put_TTSModeID: engineModeId
	"Private - Set the value of the 'TTSModeID' property of the object wrapped by the 
	 receiver to the <bstr> argument, engineModeId.
				HRESULT __stdcall TTSModeID(
			[in] BSTR EngineModeId);"

	<virtual stdcall: hresult 59 bstr>
	^self invalidCall
!

showPopupMenu: x y: y
	"Answer the <VARIANT_BOOL> result of invoking the ShowPopupMenu() method of the COM object."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		ShowPopupMenu: x
		y: y
		Showed: answer.
	^answer asObject
!

ShowPopupMenu: x y: y Showed: showed
	"Private - Invoke the ShowPopupMenu() method of the COM object.

		HRESULT __stdcall ShowPopupMenu(
			[in] short x,
			[in] short y,
			[out, retval] VARIANT_BOOL* Showed);"

	<virtual stdcall: hresult 45 sword sword varbool*>
	^self invalidCall
!

srModeID
	"Answer the <bstr> value of the 'SRModeID' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_SRModeID: answer.
	^answer asObject
!

srModeID: engineModeId
	"Set the 'SRModeID' property of the receiver to the <bstr> value of the argument."

	self put_SRModeID: engineModeId
!

srStatus
	"Answer the <sdword> value of the 'SRStatus' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_SRStatus: answer.
	^answer asObject
!

think: text
	"Answer the <IAgentCtlRequest> result of invoking the Think() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		Think: text
		Request: answer.
	^answer asObject
!

Think: text Request: request
	"Private - Invoke the Think() method of the COM object.

		HRESULT __stdcall Think(
			[in] BSTR Text,
			[out, retval] IAgentCtlRequest** Request);"

	<virtual stdcall: hresult 65 bstr IAgentCtlRequest**>
	^self invalidCall
!

ttsModeID
	"Answer the <bstr> value of the 'TTSModeID' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_TTSModeID: answer.
	^answer asObject
!

ttsModeID: engineModeId
	"Set the 'TTSModeID' property of the receiver to the <bstr> value of the argument."

	self put_TTSModeID: engineModeId
!

version
	"Answer the <bstr> value of the 'Version' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Version: answer.
	^answer asObject
! !
!IAgentCtlCharacterEx categoriesFor: #active!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #animationNames!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #autoPopupMenu!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #autoPopupMenu:!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #get_Active:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_AnimationNames:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_AutoPopupMenu:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_GUID:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_HelpContextID:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_HelpFile:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_HelpModeOn:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_LanguageID:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_OriginalHeight:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_OriginalWidth:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_SRModeID:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_SRStatus:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_TTSModeID:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #get_Version:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #guid!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #helpContextID!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #helpContextID:!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #helpFile!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #helpFile:!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #helpModeOn!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #helpModeOn:!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #languageID!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #languageID:!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #listen:!**auto generated**!methods!public! !
!IAgentCtlCharacterEx categoriesFor: #Listen:StartedListening:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #originalHeight!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #originalWidth!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #put_AutoPopupMenu:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #put_HelpContextID:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #put_HelpFile:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #put_HelpModeOn:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #put_LanguageID:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #put_SRModeID:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #put_TTSModeID:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #showPopupMenu:y:!**auto generated**!methods!public! !
!IAgentCtlCharacterEx categoriesFor: #ShowPopupMenu:y:Showed:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #srModeID!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #srModeID:!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #srStatus!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #think:!**auto generated**!methods!public! !
!IAgentCtlCharacterEx categoriesFor: #Think:Request:!**auto generated**!COM Interfaces-IAgentCtlCharacterEx!private! !
!IAgentCtlCharacterEx categoriesFor: #ttsModeID!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #ttsModeID:!**auto generated**!properties!public! !
!IAgentCtlCharacterEx categoriesFor: #version!**auto generated**!properties!public! !

!IAgentCtlCharacterEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlCharacterEx'
		IAgentCtlCharacterEx defineTemplate"

	self
		defineFunction: #ShowPopupMenu:y:Showed:
			argumentTypes: 'sword sword varbool*';
		defineFunction: #put_AutoPopupMenu:
			argumentTypes: 'varbool';
		defineFunction: #get_AutoPopupMenu:
			argumentTypes: 'varbool*';
		defineFunction: #put_HelpModeOn:
			argumentTypes: 'varbool';
		defineFunction: #get_HelpModeOn:
			argumentTypes: 'varbool*';
		defineFunction: #put_HelpContextID:
			argumentTypes: 'sdword';
		defineFunction: #get_HelpContextID:
			argumentTypes: 'sdword*';
		defineFunction: #get_Active:
			argumentTypes: 'sword*';
		defineFunction: #Listen:StartedListening:
			argumentTypes: 'varbool varbool*';
		defineFunction: #put_LanguageID:
			argumentTypes: 'sdword';
		defineFunction: #get_LanguageID:
			argumentTypes: 'sdword*';
		defineFunction: #get_SRModeID:
			argumentTypes: 'bstr*';
		defineFunction: #put_SRModeID:
			argumentTypes: 'bstr';
		defineFunction: #get_TTSModeID:
			argumentTypes: 'bstr*';
		defineFunction: #put_TTSModeID:
			argumentTypes: 'bstr';
		defineFunction: #get_HelpFile:
			argumentTypes: 'bstr*';
		defineFunction: #put_HelpFile:
			argumentTypes: 'bstr';
		defineFunction: #get_GUID:
			argumentTypes: 'bstr*';
		defineFunction: #get_OriginalHeight:
			argumentTypes: 'sword*';
		defineFunction: #get_OriginalWidth:
			argumentTypes: 'sword*';
		defineFunction: #Think:Request:
			argumentTypes: 'bstr IAgentCtlRequest**';
		defineFunction: #get_Version:
			argumentTypes: 'bstr*';
		defineFunction: #get_AnimationNames:
			argumentTypes: 'IAgentCtlAnimationNames**';
		defineFunction: #get_SRStatus:
			argumentTypes: 'sdword*'
! !
!IAgentCtlCharacterEx class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

