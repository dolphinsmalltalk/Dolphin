"Filed out from Dolphin Smalltalk 7"!

IPersistStream subclass: #IPersistStreamInit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IPersistStreamInit guid: (IID fromString: '{7fd52380-4e07-101b-ae2d-08002b2ec713}')!
IPersistStreamInit comment: ''!
!IPersistStreamInit categoriesForClass!COM-Interfaces! !
!IPersistStreamInit methodsFor!

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

	<virtual stdcall: sdword 9>
	^self invalidCall: _failureCode! !
!IPersistStreamInit categoriesFor: #initNew!initializing!public! !
!IPersistStreamInit categoriesFor: #InitNew!COM Interfaces-IPersistStreamInit!public! !

IPersistStreamInit methodProtocol: #IPersistStreamInit attributes: #(#readOnly) selectors: #(#GetClassID: #GetSizeMax: #InitNew #IsDirty #Load: #Save:fClearDirty:)!

!IPersistStreamInit class methodsFor!

defineFunctions
	"Define the vtable for the IPersistStreamInit interface.
		IPersistStreamInit compileFunctions
	"

	self
		defineFunction: #InitNew returnType: 'sdword'! !
!IPersistStreamInit class categoriesFor: #defineFunctions!initializing!public! !

