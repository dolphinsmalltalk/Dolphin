"Filed out from Dolphin Smalltalk"!

IDispatch subclass: #IScriptError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSScriptControlConstants'
	classInstanceVariableNames: ''!
IScriptError guid: (IID fromString: '{70841c78-067d-11d0-95d8-00a02463ab28}')!
IScriptError comment: '<IScriptError> is a wrapper class for the COM interface ''MSScriptControl.IScriptError'' generated from type information in the ''Microsoft Script Control 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Provides access to scripting error information"
'!
!IScriptError categoriesForClass!COM-Interfaces!MSScriptControl-Interfaces! !
!IScriptError methodsFor!

clear
	"Invoke the Clear() method of the COM object.
	Helpstring: Clear the script error"

	^self Clear
!

Clear
	"Private - Invoke the Clear() method of the COM object.
	Helpstring: Clear the script error

		HRESULT __stdcall Clear();"

	<virtual stdcall: hresult 16>
	^self invalidCall: _failureCode!

column
	"Answer the <sdword> value of the 'Column' property of the receiver.
	Helpstring: Source code column position where the error occurred"

	| answer |
	answer := (SDWORD new).
	self get_Column: answer.
	^answer asObject
!

description
	"Answer the <bstr> value of the 'Description' property of the receiver.
	Helpstring: Friendly description of error"

	| answer |
	answer := BSTR new.
	self get_Description: answer.
	^answer asObject
!

get_Column: plColumn
	"Private - Get the value of the 'Column' property of the receiver.

		HRESULT __stdcall Column(
			[out, retval]long* plColumn);"

	<virtual stdcall: hresult 15 sdword*>
	^self invalidCall: _failureCode!

get_Description: pbstrDescription
	"Private - Get the value of the 'Description' property of the receiver.

		HRESULT __stdcall Description(
			[out, retval]BSTR* pbstrDescription);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall: _failureCode!

get_HelpContext: plHelpContext
	"Private - Get the value of the 'HelpContext' property of the receiver.

		HRESULT __stdcall HelpContext(
			[out, retval]long* plHelpContext);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

get_HelpFile: pbstrHelpFile
	"Private - Get the value of the 'HelpFile' property of the receiver.

		HRESULT __stdcall HelpFile(
			[out, retval]BSTR* pbstrHelpFile);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall: _failureCode!

get_Line: plLine
	"Private - Get the value of the 'Line' property of the receiver.

		HRESULT __stdcall Line(
			[out, retval]long* plLine);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall: _failureCode!

get_Number: plNumber
	"Private - Get the value of the 'Number' property of the receiver.

		HRESULT __stdcall Number(
			[out, retval]long* plNumber);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

get_Source: pbstrSource
	"Private - Get the value of the 'Source' property of the receiver.

		HRESULT __stdcall Source(
			[out, retval]BSTR* pbstrSource);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall: _failureCode!

get_Text: pbstrText
	"Private - Get the value of the 'Text' property of the receiver.

		HRESULT __stdcall Text(
			[out, retval]BSTR* pbstrText);"

	<virtual stdcall: hresult 13 bstr*>
	^self invalidCall: _failureCode!

helpContext
	"Answer the <sdword> value of the 'HelpContext' property of the receiver.
	Helpstring: Context ID for the topic with information on the error"

	| answer |
	answer := (SDWORD new).
	self get_HelpContext: answer.
	^answer asObject
!

helpFile
	"Answer the <bstr> value of the 'HelpFile' property of the receiver.
	Helpstring: File in which help for the error can be found"

	| answer |
	answer := BSTR new.
	self get_HelpFile: answer.
	^answer asObject
!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

line
	"Answer the <sdword> value of the 'Line' property of the receiver.
	Helpstring: Source code line number where the error occurred"

	| answer |
	answer := (SDWORD new).
	self get_Line: answer.
	^answer asObject
!

number
	"Answer the <sdword> value of the 'Number' property of the receiver.
	Helpstring: Error number"

	| answer |
	answer := (SDWORD new).
	self get_Number: answer.
	^answer asObject
!

source
	"Answer the <bstr> value of the 'Source' property of the receiver.
	Helpstring: Source of the error"

	| answer |
	answer := BSTR new.
	self get_Source: answer.
	^answer asObject
!

text
	"Answer the <bstr> value of the 'Text' property of the receiver.
	Helpstring: Line of source code on which the error occurred"

	| answer |
	answer := BSTR new.
	self get_Text: answer.
	^answer asObject
!

value
	"Answer the special property which is the default value for the receiver."

	^self description! !
!IScriptError categoriesForMethods!
clear!**auto generated**!methods!public! !
Clear!**auto generated**!COM Interfaces-IScriptError!private! !
column!**auto generated**!properties!public! !
description!**auto generated**!properties!public! !
get_Column:!**auto generated**!COM Interfaces-IScriptError!private! !
get_Description:!**auto generated**!COM Interfaces-IScriptError!private! !
get_HelpContext:!**auto generated**!COM Interfaces-IScriptError!private! !
get_HelpFile:!**auto generated**!COM Interfaces-IScriptError!private! !
get_Line:!**auto generated**!COM Interfaces-IScriptError!private! !
get_Number:!**auto generated**!COM Interfaces-IScriptError!private! !
get_Source:!**auto generated**!COM Interfaces-IScriptError!private! !
get_Text:!**auto generated**!COM Interfaces-IScriptError!private! !
helpContext!**auto generated**!properties!public! !
helpFile!**auto generated**!properties!public! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
line!**auto generated**!properties!public! !
number!**auto generated**!properties!public! !
source!**auto generated**!properties!public! !
text!**auto generated**!properties!public! !
value!accessing!properties!public! !
!

!IScriptError class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Error) for which the receiver is the default interface."

	^CLSID fromString: '{0E59F1DE-1FBE-11D0-8FF2-00A0D10038BC}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSScriptControl.IScriptError'
		IScriptError defineTemplate"

	self
		defineFunction: #get_Number:
			argumentTypes: 'sdword*';
		defineFunction: #get_Source:
			argumentTypes: 'bstr*';
		defineFunction: #get_Description:
			argumentTypes: 'bstr*';
		defineFunction: #get_HelpFile:
			argumentTypes: 'bstr*';
		defineFunction: #get_HelpContext:
			argumentTypes: 'sdword*';
		defineFunction: #get_Text:
			argumentTypes: 'bstr*';
		defineFunction: #get_Line:
			argumentTypes: 'sdword*';
		defineFunction: #get_Column:
			argumentTypes: 'sdword*';
		defineFunction: #Clear
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IScriptError initializeTypeLib"

	typeLib := MSScriptControlLib! !
!IScriptError class categoriesForMethods!
clsid!**auto generated**!constants!private! !
defineFunctions!**auto generated**!initializing!public! !
initializeTypeLib!**auto generated**!initializing!private! !
!

