"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IAgentCtlCommandsWindow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlCommandsWindow guid: (IID fromString: '{6D0ECB27-9968-11D0-AC6E-00C04FD97575}')!
IAgentCtlCommandsWindow comment: '<IAgentCtlCommandsWindow> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlCommandsWindow'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlCommandsWindow Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlCommandsWindow categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlCommandsWindow methodsFor!

get_Height: height
	"Private - Get the value of the 'Height' property of the receiver.
				HRESULT __stdcall Height(
			[out, retval] short* Height);"

	<virtual stdcall: hresult 12 sword*>
	^self invalidCall
!

get_Left: left
	"Private - Get the value of the 'Left' property of the receiver.
				HRESULT __stdcall Left(
			[out, retval] short* Left);"

	<virtual stdcall: hresult 10 sword*>
	^self invalidCall
!

get_Top: top
	"Private - Get the value of the 'Top' property of the receiver.
				HRESULT __stdcall Top(
			[out, retval] short* Top);"

	<virtual stdcall: hresult 11 sword*>
	^self invalidCall
!

get_Visible: visible
	"Private - Get the value of the 'Visible' property of the receiver.
				HRESULT __stdcall Visible(
			[out, retval] VARIANT_BOOL* Visible);"

	<virtual stdcall: hresult 8 varbool*>
	^self invalidCall
!

get_Width: width
	"Private - Get the value of the 'Width' property of the receiver.
				HRESULT __stdcall Width(
			[out, retval] short* Width);"

	<virtual stdcall: hresult 13 sword*>
	^self invalidCall
!

height
	"Answer the <sword> value of the 'Height' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Height: answer.
	^answer asObject
!

left
	"Answer the <sword> value of the 'Left' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Left: answer.
	^answer asObject
!

put_Visible: visible
	"Private - Set the value of the 'Visible' property of the object wrapped by the 
	 receiver to the <varbool> argument, visible.
				HRESULT __stdcall Visible(
			[in] VARIANT_BOOL Visible);"

	<virtual stdcall: hresult 9 varbool>
	^self invalidCall
!

top
	"Answer the <sword> value of the 'Top' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Top: answer.
	^answer asObject
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

width
	"Answer the <sword> value of the 'Width' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Width: answer.
	^answer asObject
! !
!IAgentCtlCommandsWindow categoriesFor: #get_Height:!**auto generated**!COM Interfaces-IAgentCtlCommandsWindow!private! !
!IAgentCtlCommandsWindow categoriesFor: #get_Left:!**auto generated**!COM Interfaces-IAgentCtlCommandsWindow!private! !
!IAgentCtlCommandsWindow categoriesFor: #get_Top:!**auto generated**!COM Interfaces-IAgentCtlCommandsWindow!private! !
!IAgentCtlCommandsWindow categoriesFor: #get_Visible:!**auto generated**!COM Interfaces-IAgentCtlCommandsWindow!private! !
!IAgentCtlCommandsWindow categoriesFor: #get_Width:!**auto generated**!COM Interfaces-IAgentCtlCommandsWindow!private! !
!IAgentCtlCommandsWindow categoriesFor: #height!**auto generated**!properties!public! !
!IAgentCtlCommandsWindow categoriesFor: #left!**auto generated**!properties!public! !
!IAgentCtlCommandsWindow categoriesFor: #put_Visible:!**auto generated**!COM Interfaces-IAgentCtlCommandsWindow!private! !
!IAgentCtlCommandsWindow categoriesFor: #top!**auto generated**!properties!public! !
!IAgentCtlCommandsWindow categoriesFor: #visible!**auto generated**!properties!public! !
!IAgentCtlCommandsWindow categoriesFor: #visible:!**auto generated**!properties!public! !
!IAgentCtlCommandsWindow categoriesFor: #width!**auto generated**!properties!public! !

!IAgentCtlCommandsWindow class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlCommandsWindow'
		IAgentCtlCommandsWindow defineTemplate"

	self
		defineFunction: #get_Visible:
			argumentTypes: 'varbool*';
		defineFunction: #put_Visible:
			argumentTypes: 'varbool';
		defineFunction: #get_Left:
			argumentTypes: 'sword*';
		defineFunction: #get_Top:
			argumentTypes: 'sword*';
		defineFunction: #get_Height:
			argumentTypes: 'sword*';
		defineFunction: #get_Width:
			argumentTypes: 'sword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlCommandsWindow initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlCommandsWindow class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlCommandsWindow class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

