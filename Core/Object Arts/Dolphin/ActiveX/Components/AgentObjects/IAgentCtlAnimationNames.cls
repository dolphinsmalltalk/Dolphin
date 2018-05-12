"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IAgentCtlAnimationNames
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlAnimationNames guid: (IID fromString: '{8B77181C-D3EF-11D1-8500-00C04FA34A14}')!
IAgentCtlAnimationNames comment: '<IAgentCtlAnimationNames> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlAnimationNames'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlCharacterAnimations Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlAnimationNames categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlAnimationNames methodsFor!

enum
	"Answer the <IUnknown> value of the 'Enum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_Enum: answer.
	^answer asObject
!

get_Enum: ppunkEnum
	"Private - Get the value of the 'Enum' property of the receiver.
				HRESULT __stdcall Enum(
			[out, retval] IUnknown** ppunkEnum);"

	<virtual stdcall: hresult 8 IUnknown**>
	^self invalidCall
! !
!IAgentCtlAnimationNames categoriesFor: #enum!**auto generated**!properties!public! !
!IAgentCtlAnimationNames categoriesFor: #get_Enum:!**auto generated**!COM Interfaces-IAgentCtlAnimationNames!private! !

!IAgentCtlAnimationNames class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlAnimationNames'
		IAgentCtlAnimationNames defineTemplate"

	self
		defineFunction: #get_Enum:
			argumentTypes: 'IUnknown**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlAnimationNames initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlAnimationNames class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlAnimationNames class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

