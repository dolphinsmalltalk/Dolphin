"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IAgentCtlCommands
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlCommands guid: (IID fromString: '{F5BE8BE1-7DE6-11D0-91FE-00C04FD701A5}')!
IAgentCtlCommands comment: '<IAgentCtlCommands> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlCommands'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlCommands Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlCommands categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlCommands methodsFor!

add: name
	"Answer the <IAgentCtlCommand> result of invoking the Add() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 add: name
		 caption: VARIANT unspecified
		 voice: VARIANT unspecified
		 enabled: VARIANT unspecified
		 visible: VARIANT unspecified!

add: name caption: caption voice: voice enabled: enabled visible: visible
	"Answer the <IAgentCtlCommand> result of invoking the Add() method of the COM object."

	| answer |
	answer := IAgentCtlCommand newPointer.
	self
		Add: name
		Caption: caption asVariant
		Voice: voice asVariant
		Enabled: enabled asVariant
		Visible: visible asVariant
		Command: answer.
	^answer asObject
!

Add: name Caption: caption Voice: voice Enabled: enabled Visible: visible Command: command
	"Private - Invoke the Add() method of the COM object.

		HRESULT __stdcall Add(
			[in] BSTR Name,
			[in, optional] VARIANT Caption,
			[in, optional] VARIANT Voice,
			[in, optional] VARIANT Enabled,
			[in, optional] VARIANT Visible,
			[out, retval] IAgentCtlCommand** Command);"

	<virtual stdcall: hresult 18 bstr variant variant variant variant IAgentCtlCommand**>
	^self invalidCall
!

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

command: name
	"Answer the <IAgentCtlCommandEx> result of invoking the Command() method of the COM object."

	| answer |
	answer := IAgentCtlCommandEx newPointer.
	self
		Command: name
		Item: answer.
	^answer asObject
!

Command: name Item: item
	"Private - Invoke the Command() method of the COM object.

		HRESULT __stdcall Command(
			[in] BSTR Name,
			[out, retval] IAgentCtlCommandEx** Item);"

	<virtual stdcall: hresult 9 bstr IAgentCtlCommandEx**>
	^self invalidCall
!

count
	"Answer the <sdword> value of the 'Count' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Count: answer.
	^answer asObject
!

enum
	"Answer the <IUnknown> value of the 'Enum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_Enum: answer.
	^answer asObject
!

get_Caption: caption
	"Private - Get the value of the 'Caption' property of the receiver.
				HRESULT __stdcall Caption(
			[out, retval] BSTR* Caption);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall
!

get_Count: count
	"Private - Get the value of the 'Count' property of the receiver.
				HRESULT __stdcall Count(
			[out, retval] long* Count);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

get_Enum: ppunkEnum
	"Private - Get the value of the 'Enum' property of the receiver.
				HRESULT __stdcall Enum(
			[out, retval] IUnknown** ppunkEnum);"

	<virtual stdcall: hresult 17 IUnknown**>
	^self invalidCall
!

get_Item: name Item: item
	"Private - Get the value of the 'Item' property of the receiver.
				HRESULT __stdcall Item(
			[in] BSTR Name,
			[out, retval] IAgentCtlCommandEx** Item);"

	<virtual stdcall: hresult 8 bstr IAgentCtlCommandEx**>
	^self invalidCall
!

get_Visible: visible
	"Private - Get the value of the 'Visible' property of the receiver.
				HRESULT __stdcall Visible(
			[out, retval] VARIANT_BOOL* Visible);"

	<virtual stdcall: hresult 15 varbool*>
	^self invalidCall
!

get_Voice: voice
	"Private - Get the value of the 'Voice' property of the receiver.
				HRESULT __stdcall Voice(
			[out, retval] BSTR* Voice);"

	<virtual stdcall: hresult 13 bstr*>
	^self invalidCall
!

insert: name refName: refName
	"Answer the <IAgentCtlCommand> result of invoking the Insert() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 insert: name
		 refName: refName
		 before: VARIANT unspecified
		 caption: VARIANT unspecified
		 voice: VARIANT unspecified
		 enabled: VARIANT unspecified
		 visible: VARIANT unspecified!

insert: name refName: refName before: before caption: caption voice: voice enabled: enabled visible: visible
	"Answer the <IAgentCtlCommand> result of invoking the Insert() method of the COM object."

	| answer |
	answer := IAgentCtlCommand newPointer.
	self
		Insert: name
		RefName: refName
		Before: before asVariant
		Caption: caption asVariant
		Voice: voice asVariant
		Enabled: enabled asVariant
		Visible: visible asVariant
		Command: answer.
	^answer asObject
!

Insert: name RefName: refName Before: before Caption: caption Voice: voice Enabled: enabled Visible: visible Command: command
	"Private - Invoke the Insert() method of the COM object.

		HRESULT __stdcall Insert(
			[in] BSTR Name,
			[in] BSTR RefName,
			[in, optional] VARIANT Before,
			[in, optional] VARIANT Caption,
			[in, optional] VARIANT Voice,
			[in, optional] VARIANT Enabled,
			[in, optional] VARIANT Visible,
			[out, retval] IAgentCtlCommand** Command);"

	<virtual stdcall: hresult 19 bstr bstr variant variant variant variant variant IAgentCtlCommand**>
	^self invalidCall
!

item: name
	"Answer the <IAgentCtlCommandEx> value of the 'Item' property of the receiver."

	| answer |
	answer := IAgentCtlCommandEx newPointer.
	self
		get_Item: name
		Item: answer.
	^answer asObject
!

put_Caption: caption
	"Private - Set the value of the 'Caption' property of the object wrapped by the 
	 receiver to the <bstr> argument, caption.
				HRESULT __stdcall Caption(
			[in] BSTR Caption);"

	<virtual stdcall: hresult 12 bstr>
	^self invalidCall
!

put_Visible: visible
	"Private - Set the value of the 'Visible' property of the object wrapped by the 
	 receiver to the <varbool> argument, visible.
				HRESULT __stdcall Visible(
			[in] VARIANT_BOOL Visible);"

	<virtual stdcall: hresult 16 varbool>
	^self invalidCall
!

put_Voice: voice
	"Private - Set the value of the 'Voice' property of the object wrapped by the 
	 receiver to the <bstr> argument, voice.
				HRESULT __stdcall Voice(
			[in] BSTR Voice);"

	<virtual stdcall: hresult 14 bstr>
	^self invalidCall
!

remove: name
	"Invoke the Remove() method of the COM object."

	^self Remove: name
!

Remove: name
	"Private - Invoke the Remove() method of the COM object.

		HRESULT __stdcall Remove(
			[in] BSTR Name);"

	<virtual stdcall: hresult 20 bstr>
	^self invalidCall
!

removeAll
	"Invoke the RemoveAll() method of the COM object."

	^self RemoveAll
!

RemoveAll
	"Private - Invoke the RemoveAll() method of the COM object.

		HRESULT __stdcall RemoveAll();"

	<virtual stdcall: hresult 21>
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
!IAgentCtlCommands categoriesFor: #add:!**auto generated**!methods!public! !
!IAgentCtlCommands categoriesFor: #add:caption:voice:enabled:visible:!**auto generated**!methods!public! !
!IAgentCtlCommands categoriesFor: #Add:Caption:Voice:Enabled:Visible:Command:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #caption!**auto generated**!properties!public! !
!IAgentCtlCommands categoriesFor: #caption:!**auto generated**!properties!public! !
!IAgentCtlCommands categoriesFor: #command:!**auto generated**!methods!public! !
!IAgentCtlCommands categoriesFor: #Command:Item:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #count!**auto generated**!properties!public! !
!IAgentCtlCommands categoriesFor: #enum!**auto generated**!properties!public! !
!IAgentCtlCommands categoriesFor: #get_Caption:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #get_Count:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #get_Enum:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #get_Item:Item:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #get_Visible:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #get_Voice:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #insert:refName:!**auto generated**!methods!public! !
!IAgentCtlCommands categoriesFor: #insert:refName:before:caption:voice:enabled:visible:!**auto generated**!methods!public! !
!IAgentCtlCommands categoriesFor: #Insert:RefName:Before:Caption:Voice:Enabled:Visible:Command:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #item:!**auto generated**!properties!public! !
!IAgentCtlCommands categoriesFor: #put_Caption:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #put_Visible:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #put_Voice:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #remove:!**auto generated**!methods!public! !
!IAgentCtlCommands categoriesFor: #Remove:!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #removeAll!**auto generated**!methods!public! !
!IAgentCtlCommands categoriesFor: #RemoveAll!**auto generated**!COM Interfaces-IAgentCtlCommands!private! !
!IAgentCtlCommands categoriesFor: #visible!**auto generated**!properties!public! !
!IAgentCtlCommands categoriesFor: #visible:!**auto generated**!properties!public! !
!IAgentCtlCommands categoriesFor: #voice!**auto generated**!properties!public! !
!IAgentCtlCommands categoriesFor: #voice:!**auto generated**!properties!public! !

!IAgentCtlCommands class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlCommands'
		IAgentCtlCommands defineTemplate"

	self
		defineFunction: #get_Item:Item:
			argumentTypes: 'bstr IAgentCtlCommandEx**';
		defineFunction: #Command:Item:
			argumentTypes: 'bstr IAgentCtlCommandEx**';
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #get_Caption:
			argumentTypes: 'bstr*';
		defineFunction: #put_Caption:
			argumentTypes: 'bstr';
		defineFunction: #get_Voice:
			argumentTypes: 'bstr*';
		defineFunction: #put_Voice:
			argumentTypes: 'bstr';
		defineFunction: #get_Visible:
			argumentTypes: 'varbool*';
		defineFunction: #put_Visible:
			argumentTypes: 'varbool';
		defineFunction: #get_Enum:
			argumentTypes: 'IUnknown**';
		defineFunction: #Add:Caption:Voice:Enabled:Visible:Command:
			argumentTypes: 'bstr variant variant variant variant IAgentCtlCommand**';
		defineFunction: #Insert:RefName:Before:Caption:Voice:Enabled:Visible:Command:
			argumentTypes: 'bstr bstr variant variant variant variant variant IAgentCtlCommand**';
		defineFunction: #Remove:
			argumentTypes: 'bstr';
		defineFunction: #RemoveAll
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlCommands initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlCommands class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlCommands class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

