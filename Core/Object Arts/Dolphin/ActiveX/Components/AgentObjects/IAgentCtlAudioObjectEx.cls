"Filed out from Dolphin Smalltalk 7"!

IAgentCtlAudioObject subclass: #IAgentCtlAudioObjectEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlAudioObjectEx guid: (IID fromString: '{F5BE8BF0-7DE6-11D0-91FE-00C04FD701A5}')!
IAgentCtlAudioObjectEx comment: '<IAgentCtlAudioObjectEx> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlAudioObjectEx'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlAudioObjectEx Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlAudioObjectEx categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlAudioObjectEx methodsFor!

get_Status: available
	"Private - Get the value of the 'Status' property of the receiver.
				HRESULT __stdcall Status(
			[out, retval] short* Available);"

	<virtual stdcall: hresult 10 sword*>
	^self invalidCall
!

status
	"Answer the <sword> value of the 'Status' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Status: answer.
	^answer asObject
! !
!IAgentCtlAudioObjectEx categoriesFor: #get_Status:!**auto generated**!COM Interfaces-IAgentCtlAudioObjectEx!private! !
!IAgentCtlAudioObjectEx categoriesFor: #status!**auto generated**!properties!public! !

!IAgentCtlAudioObjectEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlAudioObjectEx'
		IAgentCtlAudioObjectEx defineTemplate"

	self
		defineFunction: #get_Status:
			argumentTypes: 'sword*'
! !
!IAgentCtlAudioObjectEx class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

