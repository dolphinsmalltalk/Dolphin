"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IVSSCheckout
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSCheckout guid: (IID fromString: '{783CD4E6-9D54-11CF-B8EE-00608CC9A71F}')!
IVSSCheckout comment: '<IVSSCheckout> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSCheckout'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe checkouts interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSCheckout categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSCheckout methodsFor!

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

get_Comment: pComment
	"Private - Get the value of the 'Comment' property of the receiver.

		HRESULT __stdcall Comment(
			[out, retval] BSTR* pComment);
	"

	<virtual stdcall: hresult 13 bstr*>
	^self invalidCall
!

get_Date: pDate
	"Private - Get the value of the 'Date' property of the receiver.

		HRESULT __stdcall Date(
			[out, retval] DATE* pDate);
	"

	<virtual stdcall: hresult 9 double*>
	^self invalidCall
!

get_LocalSpec: pLocal
	"Private - Get the value of the 'LocalSpec' property of the receiver.

		HRESULT __stdcall LocalSpec(
			[out, retval] BSTR* pLocal);
	"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_Machine: pMachine
	"Private - Get the value of the 'Machine' property of the receiver.

		HRESULT __stdcall Machine(
			[out, retval] BSTR* pMachine);
	"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall
!

get_Project: pProject
	"Private - Get the value of the 'Project' property of the receiver.

		HRESULT __stdcall Project(
			[out, retval] BSTR* pProject);
	"

	<virtual stdcall: hresult 12 bstr*>
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

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall
!

localSpec
	"Answer the <bstr> value of the 'LocalSpec' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_LocalSpec: answer.
	^answer asObject
!

machine
	"Answer the <bstr> value of the 'Machine' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_Machine: answer.
	^answer asObject
!

project
	"Answer the <bstr> value of the 'Project' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_Project: answer.
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
! !
!IVSSCheckout categoriesFor: #comment!**auto generated**!properties!public! !
!IVSSCheckout categoriesFor: #date!**auto generated**!properties!public! !
!IVSSCheckout categoriesFor: #get_Comment:!COM Interfaces-IVSSCheckout!private! !
!IVSSCheckout categoriesFor: #get_Date:!COM Interfaces-IVSSCheckout!private! !
!IVSSCheckout categoriesFor: #get_LocalSpec:!COM Interfaces-IVSSCheckout!private! !
!IVSSCheckout categoriesFor: #get_Machine:!COM Interfaces-IVSSCheckout!private! !
!IVSSCheckout categoriesFor: #get_Project:!COM Interfaces-IVSSCheckout!private! !
!IVSSCheckout categoriesFor: #get_Username:!COM Interfaces-IVSSCheckout!private! !
!IVSSCheckout categoriesFor: #get_VersionNumber:!COM Interfaces-IVSSCheckout!private! !
!IVSSCheckout categoriesFor: #localSpec!**auto generated**!properties!public! !
!IVSSCheckout categoriesFor: #machine!**auto generated**!properties!public! !
!IVSSCheckout categoriesFor: #project!**auto generated**!properties!public! !
!IVSSCheckout categoriesFor: #username!**auto generated**!properties!public! !
!IVSSCheckout categoriesFor: #versionNumber!**auto generated**!properties!public! !

