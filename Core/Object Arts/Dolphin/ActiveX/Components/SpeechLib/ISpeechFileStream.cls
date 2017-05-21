"Filed out from Dolphin Smalltalk 7"!

ISpeechBaseStream subclass: #ISpeechFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechFileStream guid: (IID fromString: '{AF67F125-AB39-4E93-B4A2-CC2E66E182A7}')!
ISpeechFileStream comment: '<ISpeechFileStream> is a wrapper class for the COM interface ''SpeechLib.ISpeechFileStream'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechFileStream Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(AF67F125-AB39-4E93-B4A2-CC2E66E182A7), 
	helpstring("ISpeechFileStream Interface"), 
	dual
]
interface ISpeechFileStream : ISpeechBaseStream {
	[id(0x00000064), helpstring("Open")]
	HRESULT __stdcall Open(
		[in] BSTR FileName,
		[in, defaultvalue(0)] SpeechStreamFileMode FileMode,
		[in, defaultvalue(false)] VARIANT_BOOL DoEvents);
	[id(0x00000065), helpstring("Close")]
	HRESULT __stdcall Close();
};
'!
!ISpeechFileStream categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechFileStream methodsFor!

close
	"Invoke the Close() method of the COM object.
	Helpstring: 'Close'"

	^self Close
!

Close
	"Private - Invoke the Close() method of the COM object.
	Helpstring: 'Close'

		HRESULT __stdcall Close();"

	<virtual stdcall: hresult 14>
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

open: fileName
	"Invoke the Open() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 open: fileName
		 fileMode: 0
		 doEvents: false!

open: fileName fileMode: fileMode doEvents: doEvents
	"Invoke the Open() method of the COM object.
	Helpstring: 'Open'"

	^self
		Open: fileName
		FileMode: fileMode
		DoEvents: doEvents
!

Open: fileName FileMode: fileMode DoEvents: doEvents
	"Private - Invoke the Open() method of the COM object.
	Helpstring: 'Open'

		HRESULT __stdcall Open(
			[in] BSTR FileName,
			[in, defaultvalue(0)] SpeechStreamFileMode FileMode,
			[in, defaultvalue(false)] VARIANT_BOOL DoEvents);"

	<virtual stdcall: hresult 13 bstr sdword varbool>
	^self invalidCall
! !
!ISpeechFileStream categoriesFor: #close!**auto generated**!methods!public! !
!ISpeechFileStream categoriesFor: #Close!**auto generated**!COM Interfaces-ISpeechFileStream!private! !
!ISpeechFileStream categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ISpeechFileStream categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechFileStream categoriesFor: #open:!**auto generated**!methods!public! !
!ISpeechFileStream categoriesFor: #open:fileMode:doEvents:!**auto generated**!methods!public! !
!ISpeechFileStream categoriesFor: #Open:FileMode:DoEvents:!**auto generated**!COM Interfaces-ISpeechFileStream!private! !

!ISpeechFileStream class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpFileStream) for which the receiver is the default interface."

	^CLSID fromString: '{947812B3-2AE1-4644-BA86-9E90DED7EC91}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechFileStream'
		ISpeechFileStream defineTemplate"

	self
		defineFunction: #Open:FileMode:DoEvents:
			argumentTypes: 'bstr sdword varbool';
		defineFunction: #Close
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechFileStream initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechFileStream class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechFileStream class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechFileStream class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

