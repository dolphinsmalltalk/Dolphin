"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IAgentCtlAudioObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlAudioObject guid: (IID fromString: '{F5BE8BDB-7DE6-11D0-91FE-00C04FD701A5}')!
IAgentCtlAudioObject comment: '<IAgentCtlAudioObject> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlAudioObject'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlAudioObject Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlAudioObject categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlAudioObject methodsFor!

enabled
	"Answer the <varbool> value of the 'Enabled' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Enabled: answer.
	^answer asObject
!

get_Enabled: audioEnabled
	"Private - Get the value of the 'Enabled' property of the receiver.
				HRESULT __stdcall Enabled(
			[out, retval] VARIANT_BOOL* AudioEnabled);"

	<virtual stdcall: hresult 8 varbool*>
	^self invalidCall
!

get_SoundEffects: soundEffects
	"Private - Get the value of the 'SoundEffects' property of the receiver.
				HRESULT __stdcall SoundEffects(
			[out, retval] VARIANT_BOOL* SoundEffects);"

	<virtual stdcall: hresult 9 varbool*>
	^self invalidCall
!

soundEffects
	"Answer the <varbool> value of the 'SoundEffects' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_SoundEffects: answer.
	^answer asObject
! !
!IAgentCtlAudioObject categoriesFor: #enabled!**auto generated**!properties!public! !
!IAgentCtlAudioObject categoriesFor: #get_Enabled:!**auto generated**!COM Interfaces-IAgentCtlAudioObject!private! !
!IAgentCtlAudioObject categoriesFor: #get_SoundEffects:!**auto generated**!COM Interfaces-IAgentCtlAudioObject!private! !
!IAgentCtlAudioObject categoriesFor: #soundEffects!**auto generated**!properties!public! !

!IAgentCtlAudioObject class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlAudioObject'
		IAgentCtlAudioObject defineTemplate"

	self
		defineFunction: #get_Enabled:
			argumentTypes: 'varbool*';
		defineFunction: #get_SoundEffects:
			argumentTypes: 'varbool*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlAudioObject initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlAudioObject class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlAudioObject class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

