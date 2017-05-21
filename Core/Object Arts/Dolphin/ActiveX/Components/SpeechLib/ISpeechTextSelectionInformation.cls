"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechTextSelectionInformation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechTextSelectionInformation guid: (IID fromString: '{3B9C7E7A-6EEE-4DED-9092-11657279ADBE}')!
ISpeechTextSelectionInformation comment: '<ISpeechTextSelectionInformation> is a wrapper class for the COM interface ''SpeechLib.ISpeechTextSelectionInformation'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechTextSelectionInformation Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(3B9C7E7A-6EEE-4DED-9092-11657279ADBE), 
	helpstring("ISpeechTextSelectionInformation Interface"), 
	dual
]
interface ISpeechTextSelectionInformation : IDispatch {
	[id(0x00000001), propput, helpstring("ActiveOffset")]
	HRESULT __stdcall ActiveOffset(
		[in] long ActiveOffset);
	[id(0x00000001), propget, helpstring("ActiveOffset")]
	HRESULT __stdcall ActiveOffset(
		[out, retval] long* ActiveOffset);
	[id(0x00000002), propput, helpstring("ActiveLength")]
	HRESULT __stdcall ActiveLength(
		[in] long ActiveLength);
	[id(0x00000002), propget, helpstring("ActiveLength")]
	HRESULT __stdcall ActiveLength(
		[out, retval] long* ActiveLength);
	[id(0x00000003), propput, helpstring("SelectionOffset")]
	HRESULT __stdcall SelectionOffset(
		[in] long SelectionOffset);
	[id(0x00000003), propget, helpstring("SelectionOffset")]
	HRESULT __stdcall SelectionOffset(
		[out, retval] long* SelectionOffset);
	[id(0x00000004), propput, helpstring("SelectionLength")]
	HRESULT __stdcall SelectionLength(
		[in] long SelectionLength);
	[id(0x00000004), propget, helpstring("SelectionLength")]
	HRESULT __stdcall SelectionLength(
		[out, retval] long* SelectionLength);
};
'!
!ISpeechTextSelectionInformation categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechTextSelectionInformation methodsFor!

activeLength
	"Answer the <sdword> value of the 'ActiveLength' property of the receiver.
	Helpstring: 'ActiveLength'"

	| answer |
	answer := (SDWORD new).
	self get_ActiveLength: answer.
	^answer asObject
!

activeLength: activeLength
	"Set the 'ActiveLength' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'ActiveLength'"

	self put_ActiveLength: activeLength
!

activeOffset
	"Answer the <sdword> value of the 'ActiveOffset' property of the receiver.
	Helpstring: 'ActiveOffset'"

	| answer |
	answer := (SDWORD new).
	self get_ActiveOffset: answer.
	^answer asObject
!

activeOffset: activeOffset
	"Set the 'ActiveOffset' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'ActiveOffset'"

	self put_ActiveOffset: activeOffset
!

get_ActiveLength: activeLength
	"Private - Get the value of the 'ActiveLength' property of the receiver.

		HRESULT __stdcall ActiveLength(
			[out, retval] long* ActiveLength);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall
!

get_ActiveOffset: activeOffset
	"Private - Get the value of the 'ActiveOffset' property of the receiver.

		HRESULT __stdcall ActiveOffset(
			[out, retval] long* ActiveOffset);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

get_SelectionLength: selectionLength
	"Private - Get the value of the 'SelectionLength' property of the receiver.

		HRESULT __stdcall SelectionLength(
			[out, retval] long* SelectionLength);"

	<virtual stdcall: hresult 15 sdword*>
	^self invalidCall
!

get_SelectionOffset: selectionOffset
	"Private - Get the value of the 'SelectionOffset' property of the receiver.

		HRESULT __stdcall SelectionOffset(
			[out, retval] long* SelectionOffset);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall
!

put_ActiveLength: activeLength
	"Private - Set the value of the 'ActiveLength' property of the object wrapped by the 
	 receiver to the <sdword> argument, activeLength.

		HRESULT __stdcall ActiveLength(
			[in] long ActiveLength);"

	<virtual stdcall: hresult 10 sdword>
	^self invalidCall
!

put_ActiveOffset: activeOffset
	"Private - Set the value of the 'ActiveOffset' property of the object wrapped by the 
	 receiver to the <sdword> argument, activeOffset.

		HRESULT __stdcall ActiveOffset(
			[in] long ActiveOffset);"

	<virtual stdcall: hresult 8 sdword>
	^self invalidCall
!

put_SelectionLength: selectionLength
	"Private - Set the value of the 'SelectionLength' property of the object wrapped by the 
	 receiver to the <sdword> argument, selectionLength.

		HRESULT __stdcall SelectionLength(
			[in] long SelectionLength);"

	<virtual stdcall: hresult 14 sdword>
	^self invalidCall
!

put_SelectionOffset: selectionOffset
	"Private - Set the value of the 'SelectionOffset' property of the object wrapped by the 
	 receiver to the <sdword> argument, selectionOffset.

		HRESULT __stdcall SelectionOffset(
			[in] long SelectionOffset);"

	<virtual stdcall: hresult 12 sdword>
	^self invalidCall
!

selectionLength
	"Answer the <sdword> value of the 'SelectionLength' property of the receiver.
	Helpstring: 'SelectionLength'"

	| answer |
	answer := (SDWORD new).
	self get_SelectionLength: answer.
	^answer asObject
!

selectionLength: selectionLength
	"Set the 'SelectionLength' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'SelectionLength'"

	self put_SelectionLength: selectionLength
!

selectionOffset
	"Answer the <sdword> value of the 'SelectionOffset' property of the receiver.
	Helpstring: 'SelectionOffset'"

	| answer |
	answer := (SDWORD new).
	self get_SelectionOffset: answer.
	^answer asObject
!

selectionOffset: selectionOffset
	"Set the 'SelectionOffset' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'SelectionOffset'"

	self put_SelectionOffset: selectionOffset
! !
!ISpeechTextSelectionInformation categoriesFor: #activeLength!**auto generated**!properties!public! !
!ISpeechTextSelectionInformation categoriesFor: #activeLength:!**auto generated**!properties!public! !
!ISpeechTextSelectionInformation categoriesFor: #activeOffset!**auto generated**!properties!public! !
!ISpeechTextSelectionInformation categoriesFor: #activeOffset:!**auto generated**!properties!public! !
!ISpeechTextSelectionInformation categoriesFor: #get_ActiveLength:!**auto generated**!COM Interfaces-ISpeechTextSelectionInformation!private! !
!ISpeechTextSelectionInformation categoriesFor: #get_ActiveOffset:!**auto generated**!COM Interfaces-ISpeechTextSelectionInformation!private! !
!ISpeechTextSelectionInformation categoriesFor: #get_SelectionLength:!**auto generated**!COM Interfaces-ISpeechTextSelectionInformation!private! !
!ISpeechTextSelectionInformation categoriesFor: #get_SelectionOffset:!**auto generated**!COM Interfaces-ISpeechTextSelectionInformation!private! !
!ISpeechTextSelectionInformation categoriesFor: #put_ActiveLength:!**auto generated**!COM Interfaces-ISpeechTextSelectionInformation!private! !
!ISpeechTextSelectionInformation categoriesFor: #put_ActiveOffset:!**auto generated**!COM Interfaces-ISpeechTextSelectionInformation!private! !
!ISpeechTextSelectionInformation categoriesFor: #put_SelectionLength:!**auto generated**!COM Interfaces-ISpeechTextSelectionInformation!private! !
!ISpeechTextSelectionInformation categoriesFor: #put_SelectionOffset:!**auto generated**!COM Interfaces-ISpeechTextSelectionInformation!private! !
!ISpeechTextSelectionInformation categoriesFor: #selectionLength!**auto generated**!properties!public! !
!ISpeechTextSelectionInformation categoriesFor: #selectionLength:!**auto generated**!properties!public! !
!ISpeechTextSelectionInformation categoriesFor: #selectionOffset!**auto generated**!properties!public! !
!ISpeechTextSelectionInformation categoriesFor: #selectionOffset:!**auto generated**!properties!public! !

!ISpeechTextSelectionInformation class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpTextSelectionInformation) for which the receiver is the default interface."

	^CLSID fromString: '{0F92030A-CBFD-4AB8-A164-FF5985547FF6}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechTextSelectionInformation'
		ISpeechTextSelectionInformation defineTemplate"

	self
		defineFunction: #put_ActiveOffset:
			argumentTypes: 'sdword';
		defineFunction: #get_ActiveOffset:
			argumentTypes: 'sdword*';
		defineFunction: #put_ActiveLength:
			argumentTypes: 'sdword';
		defineFunction: #get_ActiveLength:
			argumentTypes: 'sdword*';
		defineFunction: #put_SelectionOffset:
			argumentTypes: 'sdword';
		defineFunction: #get_SelectionOffset:
			argumentTypes: 'sdword*';
		defineFunction: #put_SelectionLength:
			argumentTypes: 'sdword';
		defineFunction: #get_SelectionLength:
			argumentTypes: 'sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechTextSelectionInformation initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechTextSelectionInformation class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechTextSelectionInformation class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechTextSelectionInformation class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

