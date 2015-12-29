"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IAgentCtlCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlCommand guid: (IID fromString: '{F5BE8BE3-7DE6-11D0-91FE-00C04FD701A5}')!
IAgentCtlCommand comment: '<IAgentCtlCommand> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlCommand'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlCommand Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlCommand categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlCommand methodsFor!

caption
	"Answer the <bstr> value of the 'Caption' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Caption: answer.
	^answer asObject
!

caption: caption
	"Set the 'Caption' property of the receiver to the <bstr> value of the argument."

	self put_Caption: caption
!

confidence
	"Answer the <sdword> value of the 'Confidence' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Confidence: answer.
	^answer asObject
!

confidence: confidence
	"Set the 'Confidence' property of the receiver to the <sdword> value of the argument."

	self put_Confidence: confidence
!

confidenceText
	"Answer the <bstr> value of the 'ConfidenceText' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_ConfidenceText: answer.
	^answer asObject
!

confidenceText: text
	"Set the 'ConfidenceText' property of the receiver to the <bstr> value of the argument."

	self put_ConfidenceText: text
!

enabled
	"Answer the <varbool> value of the 'Enabled' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Enabled: answer.
	^answer asObject
!

enabled: enabled
	"Set the 'Enabled' property of the receiver to the <varbool> value of the argument."

	self put_Enabled: enabled
!

get_Caption: caption
	"Private - Get the value of the 'Caption' property of the receiver.
				HRESULT __stdcall Caption(
			[out, retval] BSTR* Caption);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_Confidence: confidence
	"Private - Get the value of the 'Confidence' property of the receiver.
				HRESULT __stdcall Confidence(
			[out, retval] long* Confidence);"

	<virtual stdcall: hresult 16 sdword*>
	^self invalidCall
!

get_ConfidenceText: text
	"Private - Get the value of the 'ConfidenceText' property of the receiver.
				HRESULT __stdcall ConfidenceText(
			[out, retval] BSTR* Text);"

	<virtual stdcall: hresult 18 bstr*>
	^self invalidCall
!

get_Enabled: enabled
	"Private - Get the value of the 'Enabled' property of the receiver.
				HRESULT __stdcall Enabled(
			[out, retval] VARIANT_BOOL* Enabled);"

	<virtual stdcall: hresult 12 varbool*>
	^self invalidCall
!

get_Visible: visible
	"Private - Get the value of the 'Visible' property of the receiver.
				HRESULT __stdcall Visible(
			[out, retval] VARIANT_BOOL* Visible);"

	<virtual stdcall: hresult 14 varbool*>
	^self invalidCall
!

get_Voice: voice
	"Private - Get the value of the 'Voice' property of the receiver.
				HRESULT __stdcall Voice(
			[out, retval] BSTR* Voice);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall
!

put_Caption: caption
	"Private - Set the value of the 'Caption' property of the object wrapped by the 
	 receiver to the <bstr> argument, caption.
				HRESULT __stdcall Caption(
			[in] BSTR Caption);"

	<virtual stdcall: hresult 11 bstr>
	^self invalidCall
!

put_Confidence: confidence
	"Private - Set the value of the 'Confidence' property of the object wrapped by the 
	 receiver to the <sdword> argument, confidence.
				HRESULT __stdcall Confidence(
			[in] long Confidence);"

	<virtual stdcall: hresult 17 sdword>
	^self invalidCall
!

put_ConfidenceText: text
	"Private - Set the value of the 'ConfidenceText' property of the object wrapped by the 
	 receiver to the <bstr> argument, text.
				HRESULT __stdcall ConfidenceText(
			[in] BSTR Text);"

	<virtual stdcall: hresult 19 bstr>
	^self invalidCall
!

put_Enabled: enabled
	"Private - Set the value of the 'Enabled' property of the object wrapped by the 
	 receiver to the <varbool> argument, enabled.
				HRESULT __stdcall Enabled(
			[in] VARIANT_BOOL Enabled);"

	<virtual stdcall: hresult 13 varbool>
	^self invalidCall
!

put_Visible: visible
	"Private - Set the value of the 'Visible' property of the object wrapped by the 
	 receiver to the <varbool> argument, visible.
				HRESULT __stdcall Visible(
			[in] VARIANT_BOOL Visible);"

	<virtual stdcall: hresult 15 varbool>
	^self invalidCall
!

put_Voice: voice
	"Private - Set the value of the 'Voice' property of the object wrapped by the 
	 receiver to the <bstr> argument, voice.
				HRESULT __stdcall Voice(
			[in] BSTR Voice);"

	<virtual stdcall: hresult 9 bstr>
	^self invalidCall
!

visible
	"Answer the <varbool> value of the 'Visible' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Visible: answer.
	^answer asObject
!

visible: visible
	"Set the 'Visible' property of the receiver to the <varbool> value of the argument."

	self put_Visible: visible
!

voice
	"Answer the <bstr> value of the 'Voice' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Voice: answer.
	^answer asObject
!

voice: voice
	"Set the 'Voice' property of the receiver to the <bstr> value of the argument."

	self put_Voice: voice
! !
!IAgentCtlCommand categoriesFor: #caption!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #caption:!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #confidence!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #confidence:!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #confidenceText!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #confidenceText:!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #enabled!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #enabled:!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #get_Caption:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #get_Confidence:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #get_ConfidenceText:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #get_Enabled:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #get_Visible:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #get_Voice:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #put_Caption:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #put_Confidence:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #put_ConfidenceText:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #put_Enabled:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #put_Visible:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #put_Voice:!**auto generated**!COM Interfaces-IAgentCtlCommand!private! !
!IAgentCtlCommand categoriesFor: #visible!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #visible:!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #voice!**auto generated**!properties!public! !
!IAgentCtlCommand categoriesFor: #voice:!**auto generated**!properties!public! !

!IAgentCtlCommand class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlCommand'
		IAgentCtlCommand defineTemplate"

	self
		defineFunction: #get_Voice:
			argumentTypes: 'bstr*';
		defineFunction: #put_Voice:
			argumentTypes: 'bstr';
		defineFunction: #get_Caption:
			argumentTypes: 'bstr*';
		defineFunction: #put_Caption:
			argumentTypes: 'bstr';
		defineFunction: #get_Enabled:
			argumentTypes: 'varbool*';
		defineFunction: #put_Enabled:
			argumentTypes: 'varbool';
		defineFunction: #get_Visible:
			argumentTypes: 'varbool*';
		defineFunction: #put_Visible:
			argumentTypes: 'varbool';
		defineFunction: #get_Confidence:
			argumentTypes: 'sdword*';
		defineFunction: #put_Confidence:
			argumentTypes: 'sdword';
		defineFunction: #get_ConfidenceText:
			argumentTypes: 'bstr*';
		defineFunction: #put_ConfidenceText:
			argumentTypes: 'bstr'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlCommand initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlCommand class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlCommand class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

