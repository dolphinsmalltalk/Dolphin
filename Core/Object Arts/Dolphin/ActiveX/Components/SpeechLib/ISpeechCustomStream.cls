"Filed out from Dolphin Smalltalk 7"!

ISpeechBaseStream subclass: #ISpeechCustomStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechCustomStream guid: (IID fromString: '{1A9E9F4F-104F-4DB8-A115-EFD7FD0C97AE}')!
ISpeechCustomStream comment: '<ISpeechCustomStream> is a wrapper class for the COM interface ''SpeechLib.ISpeechCustomStream'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechCustomStream Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(1A9E9F4F-104F-4DB8-A115-EFD7FD0C97AE), 
	helpstring("ISpeechCustomStream Interface"), 
	dual
]
interface ISpeechCustomStream : ISpeechBaseStream {
	[id(0x00000064), propget, helpstring("BaseStream")]
	HRESULT __stdcall BaseStream(
		[out, retval] IUnknown** ppUnkStream);
	[id(0x00000064), propputref, helpstring("BaseStream")]
	HRESULT __stdcall BaseStream(
		[in] IUnknown* ppUnkStream);
};
'!
!ISpeechCustomStream categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechCustomStream methodsFor!

baseStream
	"Answer the <IUnknown> value of the 'BaseStream' property of the receiver.
	Helpstring: 'BaseStream'"

	| answer |
	answer := IUnknown newPointer.
	self get_BaseStream: answer.
	^answer asObject
!

get_BaseStream: ppUnkStream
	"Private - Get the value of the 'BaseStream' property of the receiver.

		HRESULT __stdcall BaseStream(
			[out, retval] IUnknown** ppUnkStream);"

	<virtual stdcall: hresult 13 IUnknown**>
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

putref_BaseStream: ppUnkStream
	"Private - Set the value of the 'BaseStream' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppUnkStream.

		HRESULT __stdcall BaseStream(
			[in] IUnknown* ppUnkStream);"

	<virtual stdcall: hresult 14 IUnknown*>
	^self invalidCall
!

setBaseStream: ppUnkStream
	"Set the 'BaseStream' property of the receiver to the <IUnknown*> value of the argument.
	Helpstring: 'BaseStream'"

	self putref_BaseStream: ppUnkStream
! !
!ISpeechCustomStream categoriesFor: #baseStream!**auto generated**!properties!public! !
!ISpeechCustomStream categoriesFor: #get_BaseStream:!**auto generated**!COM Interfaces-ISpeechCustomStream!private! !
!ISpeechCustomStream categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ISpeechCustomStream categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechCustomStream categoriesFor: #putref_BaseStream:!**auto generated**!COM Interfaces-ISpeechCustomStream!private! !
!ISpeechCustomStream categoriesFor: #setBaseStream:!**auto generated**!properties!public! !

!ISpeechCustomStream class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpCustomStream) for which the receiver is the default interface."

	^CLSID fromString: '{8DBEF13F-1948-4AA8-8CF0-048EEBED95D8}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechCustomStream'
		ISpeechCustomStream defineTemplate"

	self
		defineFunction: #get_BaseStream:
			argumentTypes: 'IUnknown**';
		defineFunction: #putref_BaseStream:
			argumentTypes: 'IUnknown*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechCustomStream initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechCustomStream class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechCustomStream class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechCustomStream class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

