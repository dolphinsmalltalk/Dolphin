"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #INPStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'NPDolphinConstants'
	classInstanceVariableNames: ''!
INPStream guid: (IID fromString: '{56922240-71A0-11D3-97BC-0080C8D59432}')!
INPStream comment: '<INPStream> is a wrapper class for the COM interface ''NPDolphin.INPStream'' generated from type information in the ''Dolphin Internet Browser Plugin 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Dolphin Plugin Wrapper for a Netscape stream"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!INPStream categoriesForClass!Plugin-Interfaces! !
!INPStream methodsFor!

Destroy: reason
	"Invoke the Destroy() method of the COM object wrapped by the receiver.
	Helpstring: 'Ask Netscape to destroy the receiver for the specified reason'

		HRESULT __stdcall Destroy(
			[in] short reason);
	"

	<virtual stdcall: hresult 11 sword>
	^self invalidCall
!

end
	"Answer the <sdword> value of the 'End' property of the receiver.
	Helpstring: 'property End'"

	| pVal |
	pVal := SDWORD new.
	self get_End: pVal.
	^pVal asObject
!

get_End: pVal
	"Private - Get the value of the 'End' property of the receiver.
	Helpstring: 'property End'

		HRESULT __stdcall End(
			[out, retval] long* pVal);
	"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_MIMEType: pVal
	"Private - Get the value of the 'MIMEType' property of the receiver.
	Helpstring: 'MIME type of data in the stream'

		HRESULT __stdcall MIMEType(
			[out, retval] LPSTR* pVal);
	"

	<virtual stdcall: hresult 5 lpstr*>
	^self invalidCall
!

get_PluginInstance: ppiNPP
	"Private - Get the value of the 'PluginInstance' property of the receiver.
	Helpstring: 'The plug-in instance with which this stream is associated'

		HRESULT __stdcall PluginInstance(
			[out, retval] INPApplet** ppiNPP);
	"

	<virtual stdcall: hresult 4 INPApplet**>
	^self invalidCall
!

get_Seekable: pVal
	"Private - Get the value of the 'Seekable' property of the receiver.
	Helpstring: 'Whether or not the stream supports random access'

		HRESULT __stdcall Seekable(
			[out, retval] long* pVal);
	"

	<virtual stdcall: hresult 6 sdword*>
	^self invalidCall
!

get_URL: pVal
	"Private - Get the value of the 'URL' property of the receiver.
	Helpstring: 'URL from which the stream''s contents originated'

		HRESULT __stdcall URL(
			[out, retval] LPSTR* pVal);
	"

	<virtual stdcall: hresult 7 lpstr*>
	^self invalidCall
!

mimeType
	"Answer the <lpstr> value of the 'MIMEType' property of the receiver.
	Helpstring: 'MIME type of data in the stream'"

	| pVal answer |
	pVal := COMTaskMemory new.
	self get_MIMEType: pVal.
	answer := String fromAddress: pVal.
	pVal free.
	^answer!

pluginInstance
	"Answer the <INPApplet> value of the 'PluginInstance' property of the receiver.
	Helpstring: 'The plug-in instance with which this stream is associated'"

	| ppiNPP |
	ppiNPP := INPApplet newPointer.
	self get_PluginInstance: ppiNPP.
	^ppiNPP asObject
!

RequestRead: offset Length: length
	"Invoke the RequestRead() method of the COM object wrapped by the receiver.
	Helpstring: 'Request a range of bytes (delivered asynchronously) from a seekable stream'

		HRESULT __stdcall RequestRead(
			[in] long Offset,
			[in] unsigned long Length);
	"

	<virtual stdcall: hresult 9 sdword dword>
	^self invalidCall
!

seekable
	"Answer the <sdword> value of the 'Seekable' property of the receiver.
	Helpstring: 'Whether or not the stream supports random access'"

	| pVal |
	pVal := SDWORD new.
	self get_Seekable: pVal.
	^pVal asObject
!

url
	"Answer the <lpstr> value of the 'URL' property of the receiver.
	Helpstring: 'URL from which the stream''s contents originated'"

	| pVal url |
	pVal := COMTaskMemory new.
	self get_URL: pVal.
	url := String fromAddress: pVal.
	pVal free.
	^url
!

write: bufLen buf: buf 
	"Answer the <SDWORD> result of invoking the COM Object's Write() method.
	Helpstring: 'Write a block of bytes to the stream (only possible if created by plug-in for posting)'"

	| plWritten |
	plWritten := SDWORD new.
	self Write: bufLen Buf: buf plWritten: plWritten.
	^plWritten asObject
!

Write: bufLen Buf: buf plWritten: plWritten
	"Private - Invoke the Write() method of the COM object wrapped by the receiver.
	Helpstring: 'Write a block of bytes to the stream (only possible if created by plug-in for posting)'

		HRESULT __stdcall Write(
			[in] long BufLen,
			[in] char* Buf,
			[out, retval] long* plWritten);
	"

	<virtual stdcall: hresult 10 sdword byte* sdword*>
	^self invalidCall
! !
!INPStream categoriesFor: #Destroy:!**auto generated**!public! !
!INPStream categoriesFor: #end!**auto generated**!public! !
!INPStream categoriesFor: #get_End:!**auto generated**!private! !
!INPStream categoriesFor: #get_MIMEType:!**auto generated**!private! !
!INPStream categoriesFor: #get_PluginInstance:!**auto generated**!private! !
!INPStream categoriesFor: #get_Seekable:!**auto generated**!private! !
!INPStream categoriesFor: #get_URL:!**auto generated**!private! !
!INPStream categoriesFor: #mimeType!accessing!public! !
!INPStream categoriesFor: #pluginInstance!**auto generated**!public! !
!INPStream categoriesFor: #RequestRead:Length:!**auto generated**!public! !
!INPStream categoriesFor: #seekable!**auto generated**!public! !
!INPStream categoriesFor: #url!accessing!public! !
!INPStream categoriesFor: #write:buf:!**auto generated**!public! !
!INPStream categoriesFor: #Write:Buf:plWritten:!**auto generated**!private! !

!INPStream class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'NPDolphin.INPStream'
		INPStream defineTemplate
	"

	self
		defineFunction: #get_PluginInstance:
			argumentTypes: 'INPApplet**';
		defineFunction: #get_MIMEType:
			argumentTypes: 'lpstr*';
		defineFunction: #get_Seekable:
			argumentTypes: 'sdword*';
		defineFunction: #get_URL:
			argumentTypes: 'lpstr*';
		defineFunction: #get_End:
			argumentTypes: 'sdword*';
		defineFunction: #RequestRead:Length:
			argumentTypes: 'sdword dword';
		defineFunction: #Write:Buf:plWritten:
			argumentTypes: 'sdword byte* sdword*';
		defineFunction: #Destroy:
			argumentTypes: 'sword'
! !
!INPStream class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

