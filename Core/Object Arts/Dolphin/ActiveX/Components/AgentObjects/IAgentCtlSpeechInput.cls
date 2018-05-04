"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IAgentCtlSpeechInput
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlSpeechInput guid: (IID fromString: '{F5BE8BDD-7DE6-11D0-91FE-00C04FD701A5}')!
IAgentCtlSpeechInput comment: '<IAgentCtlSpeechInput> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlSpeechInput'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlSpeechInput Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlSpeechInput categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlSpeechInput methodsFor!

enabled
	"Answer the <varbool> value of the 'Enabled' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Enabled: answer.
	^answer asObject
!

engine
	"Answer the <bstr> value of the 'Engine' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Engine: answer.
	^answer asObject
!

engine: engine
	"Set the 'Engine' property of the receiver to the <bstr> value of the argument."

	self put_Engine: engine
!

get_Enabled: voiceEnabled
	"Private - Get the value of the 'Enabled' property of the receiver.
				HRESULT __stdcall Enabled(
			[out, retval] VARIANT_BOOL* VoiceEnabled);"

	<virtual stdcall: hresult 8 varbool*>
	^self invalidCall
!

get_Engine: engine
	"Private - Get the value of the 'Engine' property of the receiver.
				HRESULT __stdcall Engine(
			[out, retval] BSTR* Engine);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall
!

get_HotKey: hotKey
	"Private - Get the value of the 'HotKey' property of the receiver.
				HRESULT __stdcall HotKey(
			[out, retval] BSTR* HotKey);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_Installed: voiceInstalled
	"Private - Get the value of the 'Installed' property of the receiver.
				HRESULT __stdcall Installed(
			[out, retval] VARIANT_BOOL* VoiceInstalled);"

	<virtual stdcall: hresult 11 varbool*>
	^self invalidCall
!

get_Language: language
	"Private - Get the value of the 'Language' property of the receiver.
				HRESULT __stdcall Language(
			[out, retval] BSTR* Language);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall
!

get_ListeningTip: listeningTip
	"Private - Get the value of the 'ListeningTip' property of the receiver.
				HRESULT __stdcall ListeningTip(
			[out, retval] VARIANT_BOOL* ListeningTip);"

	<virtual stdcall: hresult 14 varbool*>
	^self invalidCall
!

hotKey
	"Answer the <bstr> value of the 'HotKey' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_HotKey: answer.
	^answer asObject
!

installed
	"Answer the <varbool> value of the 'Installed' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Installed: answer.
	^answer asObject
!

language
	"Answer the <bstr> value of the 'Language' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Language: answer.
	^answer asObject
!

listeningTip
	"Answer the <varbool> value of the 'ListeningTip' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_ListeningTip: answer.
	^answer asObject
!

put_Engine: engine
	"Private - Set the value of the 'Engine' property of the object wrapped by the 
	 receiver to the <bstr> argument, engine.
				HRESULT __stdcall Engine(
			[in] BSTR Engine);"

	<virtual stdcall: hresult 13 bstr>
	^self invalidCall
! !
!IAgentCtlSpeechInput categoriesFor: #enabled!**auto generated**!properties!public! !
!IAgentCtlSpeechInput categoriesFor: #engine!**auto generated**!properties!public! !
!IAgentCtlSpeechInput categoriesFor: #engine:!**auto generated**!properties!public! !
!IAgentCtlSpeechInput categoriesFor: #get_Enabled:!**auto generated**!COM Interfaces-IAgentCtlSpeechInput!private! !
!IAgentCtlSpeechInput categoriesFor: #get_Engine:!**auto generated**!COM Interfaces-IAgentCtlSpeechInput!private! !
!IAgentCtlSpeechInput categoriesFor: #get_HotKey:!**auto generated**!COM Interfaces-IAgentCtlSpeechInput!private! !
!IAgentCtlSpeechInput categoriesFor: #get_Installed:!**auto generated**!COM Interfaces-IAgentCtlSpeechInput!private! !
!IAgentCtlSpeechInput categoriesFor: #get_Language:!**auto generated**!COM Interfaces-IAgentCtlSpeechInput!private! !
!IAgentCtlSpeechInput categoriesFor: #get_ListeningTip:!**auto generated**!COM Interfaces-IAgentCtlSpeechInput!private! !
!IAgentCtlSpeechInput categoriesFor: #hotKey!**auto generated**!properties!public! !
!IAgentCtlSpeechInput categoriesFor: #installed!**auto generated**!properties!public! !
!IAgentCtlSpeechInput categoriesFor: #language!**auto generated**!properties!public! !
!IAgentCtlSpeechInput categoriesFor: #listeningTip!**auto generated**!properties!public! !
!IAgentCtlSpeechInput categoriesFor: #put_Engine:!**auto generated**!COM Interfaces-IAgentCtlSpeechInput!private! !

!IAgentCtlSpeechInput class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlSpeechInput'
		IAgentCtlSpeechInput defineTemplate"

	self
		defineFunction: #get_Enabled:
			argumentTypes: 'varbool*';
		defineFunction: #get_Language:
			argumentTypes: 'bstr*';
		defineFunction: #get_HotKey:
			argumentTypes: 'bstr*';
		defineFunction: #get_Installed:
			argumentTypes: 'varbool*';
		defineFunction: #get_Engine:
			argumentTypes: 'bstr*';
		defineFunction: #put_Engine:
			argumentTypes: 'bstr';
		defineFunction: #get_ListeningTip:
			argumentTypes: 'varbool*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlSpeechInput initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlSpeechInput class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlSpeechInput class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

