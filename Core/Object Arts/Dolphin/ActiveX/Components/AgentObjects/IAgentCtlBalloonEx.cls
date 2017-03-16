"Filed out from Dolphin Smalltalk 7"!

IAgentCtlBalloon subclass: #IAgentCtlBalloonEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlBalloonEx guid: (IID fromString: '{822DB1C0-8879-11D1-9EC6-00C04FD7081F}')!
IAgentCtlBalloonEx comment: '<IAgentCtlBalloonEx> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlBalloonEx'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlBalloonEx Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlBalloonEx categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlBalloonEx methodsFor!

get_Style: style
	"Private - Get the value of the 'Style' property of the receiver.
				HRESULT __stdcall Style(
			[out, retval] long* Style);"

	<virtual stdcall: hresult 27 sdword*>
	^self invalidCall
!

put_Style: style
	"Private - Set the value of the 'Style' property of the object wrapped by the 
	 receiver to the <sdword> argument, style.
				HRESULT __stdcall Style(
			[in] long Style);"

	<virtual stdcall: hresult 26 sdword>
	^self invalidCall
!

style
	"Answer the <sdword> value of the 'Style' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Style: answer.
	^answer asObject
!

style: style
	"Set the 'Style' property of the receiver to the <sdword> value of the argument."

	self put_Style: style
! !
!IAgentCtlBalloonEx categoriesFor: #get_Style:!**auto generated**!COM Interfaces-IAgentCtlBalloonEx!private! !
!IAgentCtlBalloonEx categoriesFor: #put_Style:!**auto generated**!COM Interfaces-IAgentCtlBalloonEx!private! !
!IAgentCtlBalloonEx categoriesFor: #style!**auto generated**!properties!public! !
!IAgentCtlBalloonEx categoriesFor: #style:!**auto generated**!properties!public! !

!IAgentCtlBalloonEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlBalloonEx'
		IAgentCtlBalloonEx defineTemplate"

	self
		defineFunction: #put_Style:
			argumentTypes: 'sdword';
		defineFunction: #get_Style:
			argumentTypes: 'sdword*'
! !
!IAgentCtlBalloonEx class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

