"Filed out from Dolphin Smalltalk X6"!

IAgentCtlCommand subclass: #IAgentCtlCommandEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlCommandEx guid: (IID fromString: '{B0913410-3B44-11D1-ACBA-00C04FD97575}')!
IAgentCtlCommandEx comment: '<IAgentCtlCommandEx> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlCommandEx'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlCommandEx Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlCommandEx categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlCommandEx methodsFor!

get_HelpContextID: id
	"Private - Get the value of the 'HelpContextID' property of the receiver.
				HRESULT __stdcall HelpContextID(
			[out, retval] long* ID);"

	<virtual stdcall: hresult 21 sdword*>
	^self invalidCall
!

get_VoiceCaption: voiceCaption
	"Private - Get the value of the 'VoiceCaption' property of the receiver.
				HRESULT __stdcall VoiceCaption(
			[out, retval] BSTR* VoiceCaption);"

	<virtual stdcall: hresult 23 bstr*>
	^self invalidCall
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

put_HelpContextID: id
	"Private - Set the value of the 'HelpContextID' property of the object wrapped by the 
	 receiver to the <sdword> argument, id.
				HRESULT __stdcall HelpContextID(
			[in] long ID);"

	<virtual stdcall: hresult 20 sdword>
	^self invalidCall
!

put_VoiceCaption: voiceCaption
	"Private - Set the value of the 'VoiceCaption' property of the object wrapped by the 
	 receiver to the <bstr> argument, voiceCaption.
				HRESULT __stdcall VoiceCaption(
			[in] BSTR VoiceCaption);"

	<virtual stdcall: hresult 22 bstr>
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
!IAgentCtlCommandEx categoriesFor: #get_HelpContextID:!**auto generated**!COM Interfaces-IAgentCtlCommandEx!private! !
!IAgentCtlCommandEx categoriesFor: #get_VoiceCaption:!**auto generated**!COM Interfaces-IAgentCtlCommandEx!private! !
!IAgentCtlCommandEx categoriesFor: #helpContextID!**auto generated**!properties!public! !
!IAgentCtlCommandEx categoriesFor: #helpContextID:!**auto generated**!properties!public! !
!IAgentCtlCommandEx categoriesFor: #put_HelpContextID:!**auto generated**!COM Interfaces-IAgentCtlCommandEx!private! !
!IAgentCtlCommandEx categoriesFor: #put_VoiceCaption:!**auto generated**!COM Interfaces-IAgentCtlCommandEx!private! !
!IAgentCtlCommandEx categoriesFor: #voiceCaption!**auto generated**!properties!public! !
!IAgentCtlCommandEx categoriesFor: #voiceCaption:!**auto generated**!properties!public! !

!IAgentCtlCommandEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlCommandEx'
		IAgentCtlCommandEx defineTemplate"

	self
		defineFunction: #put_HelpContextID:
			argumentTypes: 'sdword';
		defineFunction: #get_HelpContextID:
			argumentTypes: 'sdword*';
		defineFunction: #put_VoiceCaption:
			argumentTypes: 'bstr';
		defineFunction: #get_VoiceCaption:
			argumentTypes: 'bstr*'
! !
!IAgentCtlCommandEx class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

