﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IPersistStream
	subclass: #'OS.COM.IPersistStreamInit'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IPersistStreamInit guid: (OS.COM.IID fromString: '{7fd52380-4e07-101b-ae2d-08002b2ec713}')!

OS.COM.IPersistStreamInit comment: ''!

!OS.COM.IPersistStreamInit categoriesForClass!COM-Interfaces! !

!OS.COM.IPersistStreamInit methodsFor!

initNew
	"Inform a newly instantiated object that it has been newly instantiated for the purpose of
	receiving persistent state.
	The following results are possible:
		E_OUTOFMEMORY
		E_UNEXPECTED		(e.g. the object has already been intialized with IPersistStream::Load())
		E_NOTIMPL			The object does not require initialization (i.e. this is NOT an error)
		S_OK.

	Because E_NOTIMPL is permitted as a return value which is not really an error, we suppress the
	auto-exception raising for HRESULTs by defining InitNew() as returning an SDWORD."

	| hresult |
	hresult := self InitNew.
	(hresult < 0 and: [hresult ~= E_NOTIMPL]) ifTrue: [self hresultError: hresult]!

InitNew
	"Callout for the IPersistStreamInit::InitNew() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IPersistStreamInit>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: int32 9>
	^self invalidCall: _failureCode! !

!OS.COM.IPersistStreamInit categoriesForMethods!
initNew!initializing!public! !
InitNew!COM Interfaces-IPersistStreamInit!public! !
!

OS.COM.IPersistStreamInit methodProtocol: #IPersistStreamInit attributes: #(#readOnly) selectors: #(#GetClassID: #GetSizeMax: #InitNew #IsDirty #Load: #Save:fClearDirty:)!

!OS.COM.IPersistStreamInit class methodsFor!

defineFunctions
	"Define the vtable for the IPersistStreamInit interface.
		IPersistStreamInit compileFunctions
	"

	self
		defineFunction: #InitNew returnType: 'int32'! !

!OS.COM.IPersistStreamInit class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

