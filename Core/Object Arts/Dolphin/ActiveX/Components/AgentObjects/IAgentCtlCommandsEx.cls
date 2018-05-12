"Filed out from Dolphin Smalltalk 7"!

IAgentCtlCommands subclass: #IAgentCtlCommandsEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlCommandsEx guid: (IID fromString: '{6BA90C01-3910-11D1-ACB3-00C04FD97575}')!
IAgentCtlCommandsEx comment: '<IAgentCtlCommandsEx> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlCommandsEx'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlCommandsEx Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlCommandsEx categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlCommandsEx methodsFor!

defaultCommand
	"Answer the <bstr> value of the 'DefaultCommand' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_DefaultCommand: answer.
	^answer asObject
!

defaultCommand: name
	"Set the 'DefaultCommand' property of the receiver to the <bstr> value of the argument."

	self put_DefaultCommand: name
!

fontName
	"Answer the <bstr> value of the 'FontName' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_FontName: answer.
	^answer asObject
!

fontName: fontName
	"Set the 'FontName' property of the receiver to the <bstr> value of the argument."

	self put_FontName: fontName
!

fontSize
	"Answer the <sdword> value of the 'FontSize' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_FontSize: answer.
	^answer asObject
!

fontSize: fontSize
	"Set the 'FontSize' property of the receiver to the <sdword> value of the argument."

	self put_FontSize: fontSize
!

get_DefaultCommand: name
	"Private - Get the value of the 'DefaultCommand' property of the receiver.
				HRESULT __stdcall DefaultCommand(
			[out, retval] BSTR* Name);"

	<virtual stdcall: hresult 23 bstr*>
	^self invalidCall
!

get_FontName: fontName
	"Private - Get the value of the 'FontName' property of the receiver.
				HRESULT __stdcall FontName(
			[out, retval] BSTR* FontName);"

	<virtual stdcall: hresult 27 bstr*>
	^self invalidCall
!

get_FontSize: fontSize
	"Private - Get the value of the 'FontSize' property of the receiver.
				HRESULT __stdcall FontSize(
			[out, retval] long* FontSize);"

	<virtual stdcall: hresult 28 sdword*>
	^self invalidCall
!

get_GlobalVoiceCommandsEnabled: enable
	"Private - Get the value of the 'GlobalVoiceCommandsEnabled' property of the receiver.
				HRESULT __stdcall GlobalVoiceCommandsEnabled(
			[out, retval] VARIANT_BOOL* Enable);"

	<virtual stdcall: hresult 33 varbool*>
	^self invalidCall
!

get_HelpContextID: id
	"Private - Get the value of the 'HelpContextID' property of the receiver.
				HRESULT __stdcall HelpContextID(
			[out, retval] long* ID);"

	<virtual stdcall: hresult 25 sdword*>
	^self invalidCall
!

get_VoiceCaption: voiceCaption
	"Private - Get the value of the 'VoiceCaption' property of the receiver.
				HRESULT __stdcall VoiceCaption(
			[out, retval] BSTR* VoiceCaption);"

	<virtual stdcall: hresult 31 bstr*>
	^self invalidCall
!

globalVoiceCommandsEnabled
	"Answer the <varbool> value of the 'GlobalVoiceCommandsEnabled' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_GlobalVoiceCommandsEnabled: answer.
	^answer asObject
!

globalVoiceCommandsEnabled: enable
	"Set the 'GlobalVoiceCommandsEnabled' property of the receiver to the <varbool> value of the argument."

	self put_GlobalVoiceCommandsEnabled: enable
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

put_DefaultCommand: name
	"Private - Set the value of the 'DefaultCommand' property of the object wrapped by the 
	 receiver to the <bstr> argument, name.
				HRESULT __stdcall DefaultCommand(
			[in] BSTR Name);"

	<virtual stdcall: hresult 22 bstr>
	^self invalidCall
!

put_FontName: fontName
	"Private - Set the value of the 'FontName' property of the object wrapped by the 
	 receiver to the <bstr> argument, fontName.
				HRESULT __stdcall FontName(
			[in] BSTR FontName);"

	<virtual stdcall: hresult 26 bstr>
	^self invalidCall
!

put_FontSize: fontSize
	"Private - Set the value of the 'FontSize' property of the object wrapped by the 
	 receiver to the <sdword> argument, fontSize.
				HRESULT __stdcall FontSize(
			[in] long FontSize);"

	<virtual stdcall: hresult 29 sdword>
	^self invalidCall
!

put_GlobalVoiceCommandsEnabled: enable
	"Private - Set the value of the 'GlobalVoiceCommandsEnabled' property of the object wrapped by the 
	 receiver to the <varbool> argument, enable.
				HRESULT __stdcall GlobalVoiceCommandsEnabled(
			[in] VARIANT_BOOL Enable);"

	<virtual stdcall: hresult 32 varbool>
	^self invalidCall
!

put_HelpContextID: id
	"Private - Set the value of the 'HelpContextID' property of the object wrapped by the 
	 receiver to the <sdword> argument, id.
				HRESULT __stdcall HelpContextID(
			[in] long ID);"

	<virtual stdcall: hresult 24 sdword>
	^self invalidCall
!

put_VoiceCaption: voiceCaption
	"Private - Set the value of the 'VoiceCaption' property of the object wrapped by the 
	 receiver to the <bstr> argument, voiceCaption.
				HRESULT __stdcall VoiceCaption(
			[in] BSTR VoiceCaption);"

	<virtual stdcall: hresult 30 bstr>
	^self invalidCall
!

voiceCaption
	"Answer the <bstr> value of the 'VoiceCaption' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_VoiceCaption: answer.
	^answer asObject
!

voiceCaption: voiceCaption
	"Set the 'VoiceCaption' property of the receiver to the <bstr> value of the argument."

	self put_VoiceCaption: voiceCaption
! !
!IAgentCtlCommandsEx categoriesFor: #defaultCommand!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #defaultCommand:!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #fontName!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #fontName:!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #fontSize!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #fontSize:!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #get_DefaultCommand:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #get_FontName:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #get_FontSize:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #get_GlobalVoiceCommandsEnabled:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #get_HelpContextID:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #get_VoiceCaption:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #globalVoiceCommandsEnabled!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #globalVoiceCommandsEnabled:!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #helpContextID!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #helpContextID:!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #put_DefaultCommand:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #put_FontName:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #put_FontSize:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #put_GlobalVoiceCommandsEnabled:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #put_HelpContextID:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #put_VoiceCaption:!**auto generated**!COM Interfaces-IAgentCtlCommandsEx!private! !
!IAgentCtlCommandsEx categoriesFor: #voiceCaption!**auto generated**!properties!public! !
!IAgentCtlCommandsEx categoriesFor: #voiceCaption:!**auto generated**!properties!public! !

!IAgentCtlCommandsEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlCommandsEx'
		IAgentCtlCommandsEx defineTemplate"

	self
		defineFunction: #put_DefaultCommand:
			argumentTypes: 'bstr';
		defineFunction: #get_DefaultCommand:
			argumentTypes: 'bstr*';
		defineFunction: #put_HelpContextID:
			argumentTypes: 'sdword';
		defineFunction: #get_HelpContextID:
			argumentTypes: 'sdword*';
		defineFunction: #put_FontName:
			argumentTypes: 'bstr';
		defineFunction: #get_FontName:
			argumentTypes: 'bstr*';
		defineFunction: #get_FontSize:
			argumentTypes: 'sdword*';
		defineFunction: #put_FontSize:
			argumentTypes: 'sdword';
		defineFunction: #put_VoiceCaption:
			argumentTypes: 'bstr';
		defineFunction: #get_VoiceCaption:
			argumentTypes: 'bstr*';
		defineFunction: #put_GlobalVoiceCommandsEnabled:
			argumentTypes: 'varbool';
		defineFunction: #get_GlobalVoiceCommandsEnabled:
			argumentTypes: 'varbool*'
! !
!IAgentCtlCommandsEx class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

