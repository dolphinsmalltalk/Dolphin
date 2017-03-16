"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IAgentCtl
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtl guid: (IID fromString: '{F5BE8BD1-7DE6-11D0-91FE-00C04FD701A5}')!
IAgentCtl comment: '<IAgentCtl> is a wrapper class for the COM interface ''AgentObjects.IAgentCtl'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtl Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtl categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtl methodsFor!

audioOutput
	"Answer the <IAgentCtlAudioObjectEx> value of the 'AudioOutput' property of the receiver."

	| answer |
	answer := IAgentCtlAudioObjectEx newPointer.
	self get_AudioOutput: answer.
	^answer asObject
!

characters
	"Answer the <IAgentCtlCharacters> value of the 'Characters' property of the receiver."

	| answer |
	answer := IAgentCtlCharacters newPointer.
	self get_Characters: answer.
	^answer asObject
!

commandsWindow
	"Answer the <IAgentCtlCommandsWindow> value of the 'CommandsWindow' property of the receiver."

	| answer |
	answer := IAgentCtlCommandsWindow newPointer.
	self get_CommandsWindow: answer.
	^answer asObject
!

connected
	"Answer the <varbool> value of the 'Connected' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Connected: answer.
	^answer asObject
!

connected: connected
	"Set the 'Connected' property of the receiver to the <varbool> value of the argument."

	self put_Connected: connected
!

get_AudioOutput: audioOutput
	"Private - Get the value of the 'AudioOutput' property of the receiver.
				HRESULT __stdcall AudioOutput(
			[out, retval] IAgentCtlAudioObjectEx** AudioOutput);"

	<virtual stdcall: hresult 9 IAgentCtlAudioObjectEx**>
	^self invalidCall
!

get_Characters: characters
	"Private - Get the value of the 'Characters' property of the receiver.
				HRESULT __stdcall Characters(
			[out, retval] IAgentCtlCharacters** Characters);"

	<virtual stdcall: hresult 8 IAgentCtlCharacters**>
	^self invalidCall
!

get_CommandsWindow: commandsWindow
	"Private - Get the value of the 'CommandsWindow' property of the receiver.
				HRESULT __stdcall CommandsWindow(
			[out, retval] IAgentCtlCommandsWindow** CommandsWindow);"

	<virtual stdcall: hresult 12 IAgentCtlCommandsWindow**>
	^self invalidCall
!

get_Connected: connected
	"Private - Get the value of the 'Connected' property of the receiver.
				HRESULT __stdcall Connected(
			[out, retval] VARIANT_BOOL* Connected);"

	<virtual stdcall: hresult 13 varbool*>
	^self invalidCall
!

get_PropertySheet: propSheet
	"Private - Get the value of the 'PropertySheet' property of the receiver.
				HRESULT __stdcall PropertySheet(
			[out, retval] IAgentCtlPropertySheet** PropSheet);"

	<virtual stdcall: hresult 11 IAgentCtlPropertySheet**>
	^self invalidCall
!

get_SpeechInput: speechInput
	"Private - Get the value of the 'SpeechInput' property of the receiver.
				HRESULT __stdcall SpeechInput(
			[out, retval] IAgentCtlSpeechInput** SpeechInput);"

	<virtual stdcall: hresult 10 IAgentCtlSpeechInput**>
	^self invalidCall
!

get_Suspended: suspended
	"Private - Get the value of the 'Suspended' property of the receiver.
				HRESULT __stdcall Suspended(
			[out, retval] VARIANT_BOOL* Suspended);"

	<virtual stdcall: hresult 15 varbool*>
	^self invalidCall
!

propertySheet
	"Answer the <IAgentCtlPropertySheet> value of the 'PropertySheet' property of the receiver."

	| answer |
	answer := IAgentCtlPropertySheet newPointer.
	self get_PropertySheet: answer.
	^answer asObject
!

put_Connected: connected
	"Private - Set the value of the 'Connected' property of the object wrapped by the 
	 receiver to the <varbool> argument, connected.
				HRESULT __stdcall Connected(
			[in] VARIANT_BOOL Connected);"

	<virtual stdcall: hresult 14 varbool>
	^self invalidCall
!

speechInput
	"Answer the <IAgentCtlSpeechInput> value of the 'SpeechInput' property of the receiver."

	| answer |
	answer := IAgentCtlSpeechInput newPointer.
	self get_SpeechInput: answer.
	^answer asObject
!

suspended
	"Answer the <varbool> value of the 'Suspended' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Suspended: answer.
	^answer asObject
! !
!IAgentCtl categoriesFor: #audioOutput!**auto generated**!properties!public! !
!IAgentCtl categoriesFor: #characters!**auto generated**!properties!public! !
!IAgentCtl categoriesFor: #commandsWindow!**auto generated**!properties!public! !
!IAgentCtl categoriesFor: #connected!**auto generated**!properties!public! !
!IAgentCtl categoriesFor: #connected:!**auto generated**!properties!public! !
!IAgentCtl categoriesFor: #get_AudioOutput:!**auto generated**!COM Interfaces-IAgentCtl!private! !
!IAgentCtl categoriesFor: #get_Characters:!**auto generated**!COM Interfaces-IAgentCtl!private! !
!IAgentCtl categoriesFor: #get_CommandsWindow:!**auto generated**!COM Interfaces-IAgentCtl!private! !
!IAgentCtl categoriesFor: #get_Connected:!**auto generated**!COM Interfaces-IAgentCtl!private! !
!IAgentCtl categoriesFor: #get_PropertySheet:!**auto generated**!COM Interfaces-IAgentCtl!private! !
!IAgentCtl categoriesFor: #get_SpeechInput:!**auto generated**!COM Interfaces-IAgentCtl!private! !
!IAgentCtl categoriesFor: #get_Suspended:!**auto generated**!COM Interfaces-IAgentCtl!private! !
!IAgentCtl categoriesFor: #propertySheet!**auto generated**!properties!public! !
!IAgentCtl categoriesFor: #put_Connected:!**auto generated**!COM Interfaces-IAgentCtl!private! !
!IAgentCtl categoriesFor: #speechInput!**auto generated**!properties!public! !
!IAgentCtl categoriesFor: #suspended!**auto generated**!properties!public! !

!IAgentCtl class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtl'
		IAgentCtl defineTemplate"

	self
		defineFunction: #get_Characters:
			argumentTypes: 'IAgentCtlCharacters**';
		defineFunction: #get_AudioOutput:
			argumentTypes: 'IAgentCtlAudioObjectEx**';
		defineFunction: #get_SpeechInput:
			argumentTypes: 'IAgentCtlSpeechInput**';
		defineFunction: #get_PropertySheet:
			argumentTypes: 'IAgentCtlPropertySheet**';
		defineFunction: #get_CommandsWindow:
			argumentTypes: 'IAgentCtlCommandsWindow**';
		defineFunction: #get_Connected:
			argumentTypes: 'varbool*';
		defineFunction: #put_Connected:
			argumentTypes: 'varbool';
		defineFunction: #get_Suspended:
			argumentTypes: 'varbool*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtl initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtl class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtl class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

