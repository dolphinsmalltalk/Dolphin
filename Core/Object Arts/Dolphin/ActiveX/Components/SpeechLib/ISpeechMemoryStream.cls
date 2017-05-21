"Filed out from Dolphin Smalltalk 7"!

ISpeechBaseStream subclass: #ISpeechMemoryStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechMemoryStream guid: (IID fromString: '{EEB14B68-808B-4ABE-A5EA-B51DA7588008}')!
ISpeechMemoryStream comment: '<ISpeechMemoryStream> is a wrapper class for the COM interface ''SpeechLib.ISpeechMemoryStream'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechMemoryStream Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(EEB14B68-808B-4ABE-A5EA-B51DA7588008), 
	helpstring("ISpeechMemoryStream Interface"), 
	dual
]
interface ISpeechMemoryStream : ISpeechBaseStream {
	[id(0x00000064), helpstring("SetData")]
	HRESULT __stdcall SetData(
		[in] VARIANT Data);
	[id(0x00000065), helpstring("GetData")]
	HRESULT __stdcall GetData(
		[out, retval] VARIANT* pData);
};
'!
!ISpeechMemoryStream categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechMemoryStream methodsFor!

getData
	"Answer the <VARIANT> result of invoking the GetData() method of the COM object.
	Helpstring: 'GetData'"

	| answer |
	answer := VARIANT new.
	self GetData: answer.
	^answer asObject
!

GetData: pData
	"Private - Invoke the GetData() method of the COM object.
	Helpstring: 'GetData'

		HRESULT __stdcall GetData(
			[out, retval] VARIANT* pData);"

	<virtual stdcall: hresult 14 variant*>
	^self invalidCall
!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^true!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the
	type library, and must perform a run-time check for the _NewEnum property."

	^self has_NewEnum!

setData: data
	"Invoke the SetData() method of the COM object.
	Helpstring: 'SetData'"

	^self SetData: data asVariant
!

SetData: data
	"Private - Invoke the SetData() method of the COM object.
	Helpstring: 'SetData'

		HRESULT __stdcall SetData(
			[in] VARIANT Data);"

	<virtual stdcall: hresult 13 variant>
	^self invalidCall
! !
!ISpeechMemoryStream categoriesFor: #getData!**auto generated**!methods!public! !
!ISpeechMemoryStream categoriesFor: #GetData:!**auto generated**!COM Interfaces-ISpeechMemoryStream!private! !
!ISpeechMemoryStream categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ISpeechMemoryStream categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechMemoryStream categoriesFor: #setData:!**auto generated**!methods!public! !
!ISpeechMemoryStream categoriesFor: #SetData:!**auto generated**!COM Interfaces-ISpeechMemoryStream!private! !

!ISpeechMemoryStream class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpMemoryStream) for which the receiver is the default interface."

	^CLSID fromString: '{5FB7EF7D-DFF4-468A-B6B7-2FCBD188F994}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechMemoryStream'
		ISpeechMemoryStream defineTemplate"

	self
		defineFunction: #SetData:
			argumentTypes: 'variant';
		defineFunction: #GetData:
			argumentTypes: 'variant*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechMemoryStream initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechMemoryStream class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechMemoryStream class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechMemoryStream class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

