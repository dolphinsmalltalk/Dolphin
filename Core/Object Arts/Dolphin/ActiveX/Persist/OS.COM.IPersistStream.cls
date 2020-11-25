"Filed out from Dolphin Smalltalk 7"!

IPersist subclass: #IPersistStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IPersistStream guid: (IID fromString: '{00000109-0000-0000-c000-000000000046}')!
IPersistStream comment: '<IPersistStream> is a wrapper class for the custom interface ''OBJIDL.IPersistStream'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IPersistStream categoriesForClass!COM-Interfaces! !
!IPersistStream methodsFor!

GetSizeMax: pcbSize
	"Invoke the GetSizeMax() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetSizeMax(
			[out] ULARGE_INTEGER* pcbSize);

	"

	<virtual stdcall: hresult 8 qword*>
	^self invalidCall: _failureCode!

IsDirty
	"Invoke the IsDirty() method of the object wrapped by the receiver.
	
		HRESULT __stdcall IsDirty();
	"

	<virtual stdcall: hresult 5>
	^self invalidCall: _failureCode!

Load: pstm
	"Invoke the Load() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Load(
			[in] IStream* pstm);
	"

	<virtual stdcall: hresult 6 IStream*>
	^self invalidCall: _failureCode!

maxSize
	"Answer the maximum amount of storage that the receiver may need to store itself.
	N.B. The answer should be a conservative estimate of the amount of space required, because
	the specification of IPersistStream requires that implementors of Save() work within
	the bounds of the current position, and this maximum size (the supplied IStream may not
	be growable)."

	| answer |
	answer := ULARGE_INTEGER new.
	self GetSizeMax: answer.
	^answer asInteger!

readFrom: anIStream
	"Load the receiver's persistent state with the data beginning at the current position
	in the specified stream.
	N.B. It is generally not necessary to invoke this method directly yourself (the helper
	OleLoadFromStream() should be used instead) unless a custom stream format has been
	used."

	self Load: anIStream!

Save: pstm fClearDirty: fClearDirty
	"Invoke the Save() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Save(
			[in] IStream* pstm,
			[in] BOOL fClearDirty);
	"

	<virtual stdcall: hresult 7 IStream* bool>
	^self invalidCall: _failureCode!

storeOn: anIStream clearDirty: aBoolean
	"Append the receiver's persistent state to the specified IStream.
	The clearDirty flag tells the object whether to consider itself 'saved'
	after this operation (some save requests may be for copies, so the
	receiver will not want to clear its 'modified' or 'dirty' flag).
	N.B. Generally one should use the helper function OleSaveToStream()
	rather than calling this function directly (unless you do not want
	the stream to be in the standard format)."

	self Save: anIStream fClearDirty: aBoolean! !
!IPersistStream categoriesFor: #GetSizeMax:!**auto generated**!COM Interfaces-OBJIDL.IPersistStream!primitives!public! !
!IPersistStream categoriesFor: #IsDirty!**auto generated**!COM Interfaces-OBJIDL.IPersistStream!primitives!public! !
!IPersistStream categoriesFor: #Load:!**auto generated**!COM Interfaces-OBJIDL.IPersistStream!primitives!public! !
!IPersistStream categoriesFor: #maxSize!accessing!public! !
!IPersistStream categoriesFor: #readFrom:!operations!public! !
!IPersistStream categoriesFor: #Save:fClearDirty:!COM Interfaces-OBJIDL.IPersistStream!primitives!public! !
!IPersistStream categoriesFor: #storeOn:clearDirty:!operations!public! !

IPersistStream methodProtocol: #IPersistStream attributes: #(#readOnly) selectors: #(#GetClassID: #GetSizeMax: #IsDirty #Load: #Save:fClearDirty:)!

!IPersistStream class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IPersistStream'
		IPersistStream withAllSubclasses do: [:e | e defineTemplate]
	"

	self
		defineFunction: #IsDirty
			returnType: 'sdword';
		defineFunction: #Load:
			argumentTypes: 'IStream*';
		defineFunction: #Save:fClearDirty:
			argumentTypes: 'IStream* bool';
		defineFunction: #GetSizeMax:
			argumentTypes: 'qword*'
! !
!IPersistStream class categoriesFor: #defineFunctions!initializing!public! !

