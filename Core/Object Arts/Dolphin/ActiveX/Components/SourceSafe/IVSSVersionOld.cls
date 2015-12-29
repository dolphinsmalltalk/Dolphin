"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IVSSVersionOld
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSVersionOld guid: (IID fromString: '{783CD4E8-9D54-11CF-B8EE-00608CC9A71F}')!
IVSSVersionOld comment: '<IVSSVersionOld> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSVersionOld'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe version information"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSVersionOld categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSVersionOld methodsFor!

action
	"Answer the <bstr> value of the 'Action' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_Action: answer.
	^answer asObject
!

comment
	"Answer the <bstr> value of the 'Comment' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_Comment: answer.
	^answer asObject
!

date
	"Answer the <double> value of the 'Date' property of the receiver."

	| answer |
	answer := (DATE new).
	self
		get_Date: answer.
	^answer asObject
!

get_Action: pAction
	"Private - Get the value of the 'Action' property of the receiver.

		HRESULT __stdcall Action(
			[out, retval] BSTR* pAction);
	"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_Comment: pComment
	"Private - Get the value of the 'Comment' property of the receiver.

		HRESULT __stdcall Comment(
			[out, retval] BSTR* pComment);
	"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall
!

get_Date: pDate
	"Private - Get the value of the 'Date' property of the receiver.

		HRESULT __stdcall Date(
			[out, retval] DATE* pDate);
	"

	<virtual stdcall: hresult 11 double*>
	^self invalidCall
!

get_Label: pLabel
	"Private - Get the value of the 'Label' property of the receiver.

		HRESULT __stdcall Label(
			[out, retval] BSTR* pLabel);
	"

	<virtual stdcall: hresult 13 bstr*>
	^self invalidCall
!

get_Username: pUsername
	"Private - Get the value of the 'Username' property of the receiver.

		HRESULT __stdcall Username(
			[out, retval] BSTR* pUsername);
	"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall
!

get_VersionNumber: piVersion
	"Private - Get the value of the 'VersionNumber' property of the receiver.

		HRESULT __stdcall VersionNumber(
			[out, retval] long* piVersion);
	"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

get_VSSItem: ppIItem
	"Private - Get the value of the 'VSSItem' property of the receiver.

		HRESULT __stdcall VSSItem(
			[out, retval] IVSSItem** ppIItem);
	"

	<virtual stdcall: hresult 14 IVSSItem**>
	^self invalidCall
!

label
	"Answer the <bstr> value of the 'Label' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_Label: answer.
	^answer asObject
!

username
	"Answer the <bstr> value of the 'Username' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_Username: answer.
	^answer asObject
!

versionNumber
	"Answer the <sdword> value of the 'VersionNumber' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self
		get_VersionNumber: answer.
	^answer asObject
!

vssItem
	"Answer the <IVSSItem> value of the 'VSSItem' property of the receiver."

	| answer |
	answer := IVSSItem newPointer.
	self
		get_VSSItem: answer.
	^answer asObject
! !
!IVSSVersionOld categoriesFor: #action!**auto generated**!properties!public! !
!IVSSVersionOld categoriesFor: #comment!**auto generated**!properties!public! !
!IVSSVersionOld categoriesFor: #date!**auto generated**!properties!public! !
!IVSSVersionOld categoriesFor: #get_Action:!COM Interfaces-IVSSVersionOld!private! !
!IVSSVersionOld categoriesFor: #get_Comment:!COM Interfaces-IVSSVersionOld!private! !
!IVSSVersionOld categoriesFor: #get_Date:!COM Interfaces-IVSSVersionOld!private! !
!IVSSVersionOld categoriesFor: #get_Label:!COM Interfaces-IVSSVersionOld!private! !
!IVSSVersionOld categoriesFor: #get_Username:!COM Interfaces-IVSSVersionOld!private! !
!IVSSVersionOld categoriesFor: #get_VersionNumber:!COM Interfaces-IVSSVersionOld!private! !
!IVSSVersionOld categoriesFor: #get_VSSItem:!COM Interfaces-IVSSVersionOld!private! !
!IVSSVersionOld categoriesFor: #label!**auto generated**!properties!public! !
!IVSSVersionOld categoriesFor: #username!**auto generated**!properties!public! !
!IVSSVersionOld categoriesFor: #versionNumber!**auto generated**!properties!public! !
!IVSSVersionOld categoriesFor: #vssItem!**auto generated**!properties!public! !

