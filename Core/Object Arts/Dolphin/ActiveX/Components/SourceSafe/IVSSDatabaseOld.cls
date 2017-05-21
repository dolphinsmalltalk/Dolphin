"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IVSSDatabaseOld
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSDatabaseOld guid: (IID fromString: '{783CD4E2-9D54-11CF-B8EE-00608CC9A71F}')!
IVSSDatabaseOld comment: '<IVSSDatabaseOld> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSDatabaseOld'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe database object interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSDatabaseOld categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSDatabaseOld methodsFor!

currentProject
	"Answer the <bstr> value of the 'CurrentProject' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_CurrentProject: answer.
	^answer asObject
!

currentProject: pPrj 
	"Set the 'CurrentProject' property of the receiver to the <bstr> value of the argument."

	self
		put_CurrentProject: pPrj
!

databaseName
	"Answer the <bstr> value of the 'DatabaseName' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_DatabaseName: answer.
	^answer asObject
!

get_CurrentProject: pPrj
	"Private - Get the value of the 'CurrentProject' property of the receiver.

		HRESULT __stdcall CurrentProject(
			[out, retval] BSTR* pPrj);
	"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall
!

get_DatabaseName: pDatabaseName
	"Private - Get the value of the 'DatabaseName' property of the receiver.

		HRESULT __stdcall DatabaseName(
			[out, retval] BSTR* pDatabaseName);
	"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_SrcSafeIni: pSrcSafeIni
	"Private - Get the value of the 'SrcSafeIni' property of the receiver.

		HRESULT __stdcall SrcSafeIni(
			[out, retval] BSTR* pSrcSafeIni);
	"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall
!

get_Username: pUsername
	"Private - Get the value of the 'Username' property of the receiver.

		HRESULT __stdcall Username(
			[out, retval] BSTR* pUsername);
	"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall
!

get_VSSItem: spec Deleted: deleted ppIVSSItem: ppIVSSItem
	"Private - Get the value of the 'VSSItem' property of the receiver.

		HRESULT __stdcall VSSItem(
			[in] BSTR Spec,
			[in, optional, defaultvalue(false)] VARIANT_BOOL Deleted,
			[out, retval] IVSSItem** ppIVSSItem);
	"

	<virtual stdcall: hresult 14 bstr varbool IVSSItem**>
	^self invalidCall
!

Open: srcSafeIni Username: username Password: password
	"Invoke the Open() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Open(
			[in, optional, defaultvalue()] BSTR SrcSafeIni,
			[in, optional, defaultvalue()] BSTR Username,
			[in, optional, defaultvalue()] BSTR Password);
	"

	<virtual stdcall: hresult 8 bstr bstr bstr>
	^self invalidCall
!

put_CurrentProject: pPrj
	"Private - Set the value of the 'CurrentProject' property of the object wrapped by the 
	 receiver to the <bstr> argument, pPrj.

		HRESULT __stdcall CurrentProject(
			[in] BSTR pPrj);
	"

	<virtual stdcall: hresult 13 bstr>
	^self invalidCall
!

srcSafeIni
	"Answer the <bstr> value of the 'SrcSafeIni' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_SrcSafeIni: answer.
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

vssItem: spec deleted: deleted 
	"Answer the <IVSSItem> value of the 'VSSItem' property of the receiver."

	| answer |
	answer := IVSSItem newPointer.
	self
		get_VSSItem: spec
		Deleted: deleted
		ppIVSSItem: answer.
	^answer asObject
! !
!IVSSDatabaseOld categoriesFor: #currentProject!**auto generated**!properties!public! !
!IVSSDatabaseOld categoriesFor: #currentProject:!**auto generated**!properties!public! !
!IVSSDatabaseOld categoriesFor: #databaseName!**auto generated**!properties!public! !
!IVSSDatabaseOld categoriesFor: #get_CurrentProject:!COM Interfaces-IVSSDatabaseOld!private! !
!IVSSDatabaseOld categoriesFor: #get_DatabaseName:!COM Interfaces-IVSSDatabaseOld!private! !
!IVSSDatabaseOld categoriesFor: #get_SrcSafeIni:!COM Interfaces-IVSSDatabaseOld!private! !
!IVSSDatabaseOld categoriesFor: #get_Username:!COM Interfaces-IVSSDatabaseOld!private! !
!IVSSDatabaseOld categoriesFor: #get_VSSItem:Deleted:ppIVSSItem:!COM Interfaces-IVSSDatabaseOld!private! !
!IVSSDatabaseOld categoriesFor: #Open:Username:Password:!**auto generated**!COM Interfaces-IVSSDatabaseOld!public! !
!IVSSDatabaseOld categoriesFor: #put_CurrentProject:!COM Interfaces-IVSSDatabaseOld!private! !
!IVSSDatabaseOld categoriesFor: #srcSafeIni!**auto generated**!properties!public! !
!IVSSDatabaseOld categoriesFor: #username!**auto generated**!properties!public! !
!IVSSDatabaseOld categoriesFor: #vssItem:deleted:!**auto generated**!properties!public! !

