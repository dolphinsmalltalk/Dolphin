"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #INPStreamEvents
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'NPDolphinConstants'
	classInstanceVariableNames: ''!
INPStreamEvents guid: (IID fromString: '{C475170C-7361-11D3-97BC-0080C8D59432}')!
INPStreamEvents comment: '<INPStreamEvents> is a wrapper class for the COM interface ''NPDolphin.INPStreamEvents'' generated from type information in the ''Dolphin Internet Browser Plugin 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Dolphin Plugin callback events for a Netscape stream"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!INPStreamEvents categoriesForClass!Plugin-Interfaces! !
!INPStreamEvents methodsFor!

OnDestroy: npReason
	"Invoke the OnDestroy() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnDestroy(
			[in] short npReason);
	"

	<virtual stdcall: hresult 7 sword>
	^self invalidCall
!

OnStreamAsFile: szPath
	"Invoke the OnStreamAsFile() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnStreamAsFile(
			[in] LPSTR szPath);
	"

	<virtual stdcall: hresult 6 lpstr>
	^self invalidCall
!

OnWrite: offset cBuf: cBuf pbBuf: pbBuf plRet: plRet
	"Invoke the OnWrite() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnWrite(
			[in] long Offset,
			[in] long cBuf,
			[in] char* pbBuf,
			[out, retval] long* plRet);
	"

	<virtual stdcall: hresult 5 sdword sdword byte* sdword*>
	^self invalidCall
!

OnWriteReady: pcBytes
	"Invoke the OnWriteReady() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnWriteReady(
			[out, retval] long* pcBytes);
	"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall
! !
!INPStreamEvents categoriesFor: #OnDestroy:!**auto generated**!COM Interfaces-INPStreamEvents!public! !
!INPStreamEvents categoriesFor: #OnStreamAsFile:!**auto generated**!COM Interfaces-INPStreamEvents!public! !
!INPStreamEvents categoriesFor: #OnWrite:cBuf:pbBuf:plRet:!**auto generated**!COM Interfaces-INPStreamEvents!public! !
!INPStreamEvents categoriesFor: #OnWriteReady:!**auto generated**!COM Interfaces-INPStreamEvents!public! !

INPStreamEvents methodProtocol: #'NPDolphin.INPStreamEvents' attributes: #() selectors: #(#OnDestroy: #OnStreamAsFile: #OnWrite:cBuf:pbBuf:plRet: #OnWriteReady:)!

!INPStreamEvents class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'NPDolphin.INPStreamEvents'
		INPStreamEvents defineTemplate
	"

	self
		defineFunction: #OnWriteReady:
			argumentTypes: 'sdword*';
		defineFunction: #OnWrite:cBuf:pbBuf:plRet:
			argumentTypes: 'sdword sdword byte* sdword*';
		defineFunction: #OnStreamAsFile:
			argumentTypes: 'lpstr';
		defineFunction: #OnDestroy:
			argumentTypes: 'sword'
! !
!INPStreamEvents class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

