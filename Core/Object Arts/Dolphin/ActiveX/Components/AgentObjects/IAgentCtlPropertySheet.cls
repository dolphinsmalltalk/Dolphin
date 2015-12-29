"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IAgentCtlPropertySheet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlPropertySheet guid: (IID fromString: '{F5BE8BDF-7DE6-11D0-91FE-00C04FD701A5}')!
IAgentCtlPropertySheet comment: '<IAgentCtlPropertySheet> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlPropertySheet'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlPropertySheet Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlPropertySheet categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlPropertySheet methodsFor!

get_Height: height
	"Private - Get the value of the 'Height' property of the receiver.
				HRESULT __stdcall Height(
			[out, retval] short* Height);"

	<virtual stdcall: hresult 10 sword*>
	^self invalidCall
!

get_Left: left
	"Private - Get the value of the 'Left' property of the receiver.
				HRESULT __stdcall Left(
			[out, retval] short* Left);"

	<virtual stdcall: hresult 8 sword*>
	^self invalidCall
!

get_Page: page
	"Private - Get the value of the 'Page' property of the receiver.
				HRESULT __stdcall Page(
			[out, retval] BSTR* Page);"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall
!

get_Top: top
	"Private - Get the value of the 'Top' property of the receiver.
				HRESULT __stdcall Top(
			[out, retval] short* Top);"

	<virtual stdcall: hresult 9 sword*>
	^self invalidCall
!

get_Visible: visible
	"Private - Get the value of the 'Visible' property of the receiver.
				HRESULT __stdcall Visible(
			[out, retval] VARIANT_BOOL* Visible);"

	<virtual stdcall: hresult 13 varbool*>
	^self invalidCall
!

get_Width: width
	"Private - Get the value of the 'Width' property of the receiver.
				HRESULT __stdcall Width(
			[out, retval] short* Width);"

	<virtual stdcall: hresult 11 sword*>
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

page
	"Answer the <bstr> value of the 'Page' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Page: answer.
	^answer asObject
!

page: page
	"Set the 'Page' property of the receiver to the <bstr> value of the argument."

	self put_Page: page
!

put_Page: page
	"Private - Set the value of the 'Page' property of the object wrapped by the 
	 receiver to the <bstr> argument, page.
				HRESULT __stdcall Page(
			[in] BSTR Page);"

	<virtual stdcall: hresult 14 bstr>
	^self invalidCall
!

put_Visible: visible
	"Private - Set the value of the 'Visible' property of the object wrapped by the 
	 receiver to the <varbool> argument, visible.
				HRESULT __stdcall Visible(
			[in] VARIANT_BOOL Visible);"

	<virtual stdcall: hresult 12 varbool>
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
!IAgentCtlPropertySheet categoriesFor: #get_Height:!**auto generated**!COM Interfaces-IAgentCtlPropertySheet!private! !
!IAgentCtlPropertySheet categoriesFor: #get_Left:!**auto generated**!COM Interfaces-IAgentCtlPropertySheet!private! !
!IAgentCtlPropertySheet categoriesFor: #get_Page:!**auto generated**!COM Interfaces-IAgentCtlPropertySheet!private! !
!IAgentCtlPropertySheet categoriesFor: #get_Top:!**auto generated**!COM Interfaces-IAgentCtlPropertySheet!private! !
!IAgentCtlPropertySheet categoriesFor: #get_Visible:!**auto generated**!COM Interfaces-IAgentCtlPropertySheet!private! !
!IAgentCtlPropertySheet categoriesFor: #get_Width:!**auto generated**!COM Interfaces-IAgentCtlPropertySheet!private! !
!IAgentCtlPropertySheet categoriesFor: #height!**auto generated**!properties!public! !
!IAgentCtlPropertySheet categoriesFor: #left!**auto generated**!properties!public! !
!IAgentCtlPropertySheet categoriesFor: #page!**auto generated**!properties!public! !
!IAgentCtlPropertySheet categoriesFor: #page:!**auto generated**!properties!public! !
!IAgentCtlPropertySheet categoriesFor: #put_Page:!**auto generated**!COM Interfaces-IAgentCtlPropertySheet!private! !
!IAgentCtlPropertySheet categoriesFor: #put_Visible:!**auto generated**!COM Interfaces-IAgentCtlPropertySheet!private! !
!IAgentCtlPropertySheet categoriesFor: #top!**auto generated**!properties!public! !
!IAgentCtlPropertySheet categoriesFor: #visible!**auto generated**!properties!public! !
!IAgentCtlPropertySheet categoriesFor: #visible:!**auto generated**!properties!public! !
!IAgentCtlPropertySheet categoriesFor: #width!**auto generated**!properties!public! !

!IAgentCtlPropertySheet class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlPropertySheet'
		IAgentCtlPropertySheet defineTemplate"

	self
		defineFunction: #get_Left:
			argumentTypes: 'sword*';
		defineFunction: #get_Top:
			argumentTypes: 'sword*';
		defineFunction: #get_Height:
			argumentTypes: 'sword*';
		defineFunction: #get_Width:
			argumentTypes: 'sword*';
		defineFunction: #put_Visible:
			argumentTypes: 'varbool';
		defineFunction: #get_Visible:
			argumentTypes: 'varbool*';
		defineFunction: #put_Page:
			argumentTypes: 'bstr';
		defineFunction: #get_Page:
			argumentTypes: 'bstr*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlPropertySheet initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlPropertySheet class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlPropertySheet class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

