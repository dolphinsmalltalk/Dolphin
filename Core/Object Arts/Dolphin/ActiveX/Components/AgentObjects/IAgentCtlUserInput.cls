"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IAgentCtlUserInput
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlUserInput guid: (IID fromString: '{C4ABF875-8100-11D0-AC63-00C04FD97575}')!
IAgentCtlUserInput comment: '<IAgentCtlUserInput> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlUserInput'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlUserInput categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlUserInput methodsFor!

alt1Confidence
	"Answer the <sdword> value of the 'Alt1Confidence' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Alt1Confidence: answer.
	^answer asObject
!

alt1Name
	"Answer the <bstr> value of the 'Alt1Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Alt1Name: answer.
	^answer asObject
!

alt1Voice
	"Answer the <bstr> value of the 'Alt1Voice' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Alt1Voice: answer.
	^answer asObject
!

alt2Confidence
	"Answer the <sdword> value of the 'Alt2Confidence' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Alt2Confidence: answer.
	^answer asObject
!

alt2Name
	"Answer the <bstr> value of the 'Alt2Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Alt2Name: answer.
	^answer asObject
!

alt2Voice
	"Answer the <bstr> value of the 'Alt2Voice' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Alt2Voice: answer.
	^answer asObject
!

characterID
	"Answer the <bstr> value of the 'CharacterID' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_CharacterID: answer.
	^answer asObject
!

confidence
	"Answer the <sdword> value of the 'Confidence' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Confidence: answer.
	^answer asObject
!

count
	"Answer the <sword> value of the 'Count' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Count: answer.
	^answer asObject
!

get_Alt1Confidence: pAlt1Confidence
	"Private - Get the value of the 'Alt1Confidence' property of the receiver.
				HRESULT __stdcall Alt1Confidence(
			[out, retval] long* pAlt1Confidence);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall
!

get_Alt1Name: pAlt1Name
	"Private - Get the value of the 'Alt1Name' property of the receiver.
				HRESULT __stdcall Alt1Name(
			[out, retval] BSTR* pAlt1Name);"

	<virtual stdcall: hresult 13 bstr*>
	^self invalidCall
!

get_Alt1Voice: pAlt1Voice
	"Private - Get the value of the 'Alt1Voice' property of the receiver.
				HRESULT __stdcall Alt1Voice(
			[out, retval] BSTR* pAlt1Voice);"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall
!

get_Alt2Confidence: pAlt2Confidence
	"Private - Get the value of the 'Alt2Confidence' property of the receiver.
				HRESULT __stdcall Alt2Confidence(
			[out, retval] long* pAlt2Confidence);"

	<virtual stdcall: hresult 17 sdword*>
	^self invalidCall
!

get_Alt2Name: pAlt2Name
	"Private - Get the value of the 'Alt2Name' property of the receiver.
				HRESULT __stdcall Alt2Name(
			[out, retval] BSTR* pAlt2Name);"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall
!

get_Alt2Voice: pAlt2Voice
	"Private - Get the value of the 'Alt2Voice' property of the receiver.
				HRESULT __stdcall Alt2Voice(
			[out, retval] BSTR* pAlt2Voice);"

	<virtual stdcall: hresult 18 bstr*>
	^self invalidCall
!

get_CharacterID: pCharacterID
	"Private - Get the value of the 'CharacterID' property of the receiver.
				HRESULT __stdcall CharacterID(
			[out, retval] BSTR* pCharacterID);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_Confidence: pConfidence
	"Private - Get the value of the 'Confidence' property of the receiver.
				HRESULT __stdcall Confidence(
			[out, retval] long* pConfidence);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall
!

get_Count: pCount
	"Private - Get the value of the 'Count' property of the receiver.
				HRESULT __stdcall Count(
			[out, retval] short* pCount);"

	<virtual stdcall: hresult 8 sword*>
	^self invalidCall
!

get_Name: pName
	"Private - Get the value of the 'Name' property of the receiver.
				HRESULT __stdcall Name(
			[out, retval] BSTR* pName);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall
!

get_Voice: pVoice
	"Private - Get the value of the 'Voice' property of the receiver.
				HRESULT __stdcall Voice(
			[out, retval] BSTR* pVoice);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall
!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject
!

voice
	"Answer the <bstr> value of the 'Voice' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Voice: answer.
	^answer asObject
! !
!IAgentCtlUserInput categoriesFor: #alt1Confidence!**auto generated**!properties!public! !
!IAgentCtlUserInput categoriesFor: #alt1Name!**auto generated**!properties!public! !
!IAgentCtlUserInput categoriesFor: #alt1Voice!**auto generated**!properties!public! !
!IAgentCtlUserInput categoriesFor: #alt2Confidence!**auto generated**!properties!public! !
!IAgentCtlUserInput categoriesFor: #alt2Name!**auto generated**!properties!public! !
!IAgentCtlUserInput categoriesFor: #alt2Voice!**auto generated**!properties!public! !
!IAgentCtlUserInput categoriesFor: #characterID!**auto generated**!properties!public! !
!IAgentCtlUserInput categoriesFor: #confidence!**auto generated**!properties!public! !
!IAgentCtlUserInput categoriesFor: #count!**auto generated**!properties!public! !
!IAgentCtlUserInput categoriesFor: #get_Alt1Confidence:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #get_Alt1Name:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #get_Alt1Voice:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #get_Alt2Confidence:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #get_Alt2Name:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #get_Alt2Voice:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #get_CharacterID:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #get_Confidence:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #get_Count:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #get_Name:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #get_Voice:!**auto generated**!COM Interfaces-IAgentCtlUserInput!private! !
!IAgentCtlUserInput categoriesFor: #name!**auto generated**!properties!public! !
!IAgentCtlUserInput categoriesFor: #voice!**auto generated**!properties!public! !

!IAgentCtlUserInput class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlUserInput'
		IAgentCtlUserInput defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sword*';
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_CharacterID:
			argumentTypes: 'bstr*';
		defineFunction: #get_Confidence:
			argumentTypes: 'sdword*';
		defineFunction: #get_Voice:
			argumentTypes: 'bstr*';
		defineFunction: #get_Alt1Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_Alt1Confidence:
			argumentTypes: 'sdword*';
		defineFunction: #get_Alt1Voice:
			argumentTypes: 'bstr*';
		defineFunction: #get_Alt2Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_Alt2Confidence:
			argumentTypes: 'sdword*';
		defineFunction: #get_Alt2Voice:
			argumentTypes: 'bstr*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlUserInput initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlUserInput class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlUserInput class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

