"Filed out from Dolphin Smalltalk 7"!

IVSSVersionOld subclass: #IVSSVersion
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSVersion guid: (IID fromString: '{2A0DE0E9-2E9F-11D0-9236-00AA00A1EB95}')!
IVSSVersion comment: '<IVSSVersion> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSVersion'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe version information"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSVersion categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSVersion methodsFor!

get_LabelComment: pComment
	"Private - Get the value of the 'LabelComment' property of the receiver.

		HRESULT __stdcall LabelComment(
			[out, retval] BSTR* pComment);
	"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall
!

labelComment
	"Answer the <bstr> value of the 'LabelComment' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_LabelComment: answer.
	^answer asObject
! !
!IVSSVersion categoriesFor: #get_LabelComment:!COM Interfaces-IVSSVersion!private! !
!IVSSVersion categoriesFor: #labelComment!**auto generated**!properties!public! !

