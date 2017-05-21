"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechBaseStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechBaseStream guid: (IID fromString: '{6450336F-7D49-4CED-8097-49D6DEE37294}')!
ISpeechBaseStream comment: '<ISpeechBaseStream> is a wrapper class for the COM interface ''SpeechLib.ISpeechBaseStream'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechBaseStream Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(6450336F-7D49-4CED-8097-49D6DEE37294), 
	helpstring("ISpeechBaseStream Interface"), 
	dual
]
interface ISpeechBaseStream : IDispatch {
	[id(0x00000001), propget, helpstring("Format")]
	HRESULT __stdcall Format(
		[out, retval] ISpeechAudioFormat** AudioFormat);
	[id(0x00000001), propputref, helpstring("Format")]
	HRESULT __stdcall Format(
		[in] ISpeechAudioFormat* AudioFormat);
	[id(0x00000002), helpstring("Read")]
	HRESULT __stdcall Read(
		[out] VARIANT* Buffer,
		[in] long NumberOfBytes,
		[out, retval] long* BytesRead);
	[id(0x00000003), helpstring("Write")]
	HRESULT __stdcall Write(
		[in] VARIANT Buffer,
		[out, retval] long* BytesWritten);
	[id(0x00000004), helpstring("Seek")]
	HRESULT __stdcall Seek(
		[in] VARIANT Position,
		[in, defaultvalue(0)] SpeechStreamSeekPositionType Origin,
		[out, retval] VARIANT* NewPosition);
};
'!
!ISpeechBaseStream categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechBaseStream methodsFor!

format
	"Answer the <ISpeechAudioFormat> value of the 'Format' property of the receiver.
	Helpstring: 'Format'"

	| answer |
	answer := ISpeechAudioFormat newPointer.
	self get_Format: answer.
	^answer asObject
!

get_Format: audioFormat
	"Private - Get the value of the 'Format' property of the receiver.

		HRESULT __stdcall Format(
			[out, retval] ISpeechAudioFormat** AudioFormat);"

	<virtual stdcall: hresult 8 ISpeechAudioFormat**>
	^self invalidCall
!

putref_Format: audioFormat
	"Private - Set the value of the 'Format' property of the object wrapped by the 
	 receiver to the <ISpeechAudioFormat*> argument, audioFormat.

		HRESULT __stdcall Format(
			[in] ISpeechAudioFormat* AudioFormat);"

	<virtual stdcall: hresult 9 ISpeechAudioFormat*>
	^self invalidCall
!

read: numberOfBytes
	"Invoke the Read() method of the COM object.
	Helpstring: 'Read'"

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: VARIANT new;
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		Read: (answer basicAt: 1)
		NumberOfBytes: numberOfBytes
		BytesRead: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

Read: buffer NumberOfBytes: numberOfBytes BytesRead: bytesRead
	"Private - Invoke the Read() method of the COM object.
	Helpstring: 'Read'

		HRESULT __stdcall Read(
			[out] VARIANT* Buffer,
			[in] long NumberOfBytes,
			[out, retval] long* BytesRead);"

	<virtual stdcall: hresult 10 variant* sdword sdword*>
	^self invalidCall
!

reset
	self seek: 0 origin: SSSPTRelativeToStart!

seek: position
	"Answer the <VARIANT> result of invoking the Seek() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 seek: position
		 origin: 0!

seek: position origin: origin
	"Answer the <VARIANT> result of invoking the Seek() method of the COM object.
	Helpstring: 'Seek'"

	| answer |
	answer := VARIANT new.
	self
		Seek: position asVariant
		Origin: origin
		NewPosition: answer.
	^answer asObject
!

Seek: position Origin: origin NewPosition: newPosition
	"Private - Invoke the Seek() method of the COM object.
	Helpstring: 'Seek'

		HRESULT __stdcall Seek(
			[in] VARIANT Position,
			[in, defaultvalue(0)] SpeechStreamSeekPositionType Origin,
			[out, retval] VARIANT* NewPosition);"

	<virtual stdcall: hresult 12 variant sdword variant*>
	^self invalidCall
!

setFormat: audioFormat
	"Set the 'Format' property of the receiver to the <ISpeechAudioFormat*> value of the argument.
	Helpstring: 'Format'"

	self putref_Format: audioFormat
!

write: buffer
	"Answer the <SDWORD> result of invoking the Write() method of the COM object.
	Helpstring: 'Write'"

	| answer |
	answer := (SDWORD new).
	self
		Write: buffer asVariant
		BytesWritten: answer.
	^answer asObject
!

Write: buffer BytesWritten: bytesWritten
	"Private - Invoke the Write() method of the COM object.
	Helpstring: 'Write'

		HRESULT __stdcall Write(
			[in] VARIANT Buffer,
			[out, retval] long* BytesWritten);"

	<virtual stdcall: hresult 11 variant sdword*>
	^self invalidCall
! !
!ISpeechBaseStream categoriesFor: #format!**auto generated**!properties!public! !
!ISpeechBaseStream categoriesFor: #get_Format:!**auto generated**!COM Interfaces-ISpeechBaseStream!private! !
!ISpeechBaseStream categoriesFor: #putref_Format:!**auto generated**!COM Interfaces-ISpeechBaseStream!private! !
!ISpeechBaseStream categoriesFor: #read:!**auto generated**!methods!public! !
!ISpeechBaseStream categoriesFor: #Read:NumberOfBytes:BytesRead:!**auto generated**!COM Interfaces-ISpeechBaseStream!private! !
!ISpeechBaseStream categoriesFor: #reset!public! !
!ISpeechBaseStream categoriesFor: #seek:!**auto generated**!methods!public! !
!ISpeechBaseStream categoriesFor: #seek:origin:!**auto generated**!methods!public! !
!ISpeechBaseStream categoriesFor: #Seek:Origin:NewPosition:!**auto generated**!COM Interfaces-ISpeechBaseStream!private! !
!ISpeechBaseStream categoriesFor: #setFormat:!**auto generated**!properties!public! !
!ISpeechBaseStream categoriesFor: #write:!**auto generated**!methods!public! !
!ISpeechBaseStream categoriesFor: #Write:BytesWritten:!**auto generated**!COM Interfaces-ISpeechBaseStream!private! !

!ISpeechBaseStream class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechBaseStream'
		ISpeechBaseStream defineTemplate"

	self
		defineFunction: #get_Format:
			argumentTypes: 'ISpeechAudioFormat**';
		defineFunction: #putref_Format:
			argumentTypes: 'ISpeechAudioFormat*';
		defineFunction: #Read:NumberOfBytes:BytesRead:
			argumentTypes: 'variant* sdword sdword*';
		defineFunction: #Write:BytesWritten:
			argumentTypes: 'variant sdword*';
		defineFunction: #Seek:Origin:NewPosition:
			argumentTypes: 'variant sdword variant*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechBaseStream initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechBaseStream class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechBaseStream class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

