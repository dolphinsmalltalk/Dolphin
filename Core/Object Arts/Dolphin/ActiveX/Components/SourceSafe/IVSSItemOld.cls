"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IVSSItemOld
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSItemOld guid: (IID fromString: '{783CD4E1-9D54-11CF-B8EE-00608CC9A71F}')!
IVSSItemOld comment: '<IVSSItemOld> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSItemOld'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe item interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSItemOld categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSItemOld methodsFor!

add: local comment: comment iFlags: iFlags 
	"Answer the <IVSSItem> result of invoking the COM Object's Add() method."

	| answer |
	answer := IVSSItem newPointer.
	self
		Add: local
		Comment: comment
		iFlags: iFlags
		ppIItem: answer.
	^answer asObject
!

Add: local Comment: comment iFlags: iFlags ppIItem: ppIItem
	"Private - Invoke the Add() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Add(
			[in] BSTR Local,
			[in, optional, defaultvalue()] BSTR Comment,
			[in, optional, defaultvalue(0)] long iFlags,
			[out, retval] IVSSItem** ppIItem);
	"

	<virtual stdcall: hresult 28 bstr bstr sdword IVSSItem**>
	^self invalidCall
!

binary
	"Answer the <varbool> value of the 'Binary' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		get_Binary: answer.
	^answer asObject
!

binary: pbBinary 
	"Set the 'Binary' property of the receiver to the <varbool> value of the argument."

	self
		put_Binary: pbBinary
!

Checkin: comment Local: local iFlags: iFlags
	"Invoke the Checkin() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Checkin(
			[in, optional, defaultvalue()] BSTR Comment,
			[in, optional, defaultvalue()] BSTR Local,
			[in, optional, defaultvalue(0)] long iFlags);
	"

	<virtual stdcall: hresult 23 bstr bstr sdword>
	^self invalidCall
!

Checkout: comment Local: local iFlags: iFlags
	"Invoke the Checkout() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Checkout(
			[in, optional, defaultvalue()] BSTR Comment,
			[in, optional, defaultvalue()] BSTR Local,
			[in, optional, defaultvalue(0)] long iFlags);
	"

	<virtual stdcall: hresult 22 bstr bstr sdword>
	^self invalidCall
!

checkouts
	"Answer the <IVSSCheckouts> value of the 'Checkouts' property of the receiver."

	| answer |
	answer := IVSSCheckouts newPointer.
	self
		get_Checkouts: answer.
	^answer asObject
!

deleted
	"Answer the <varbool> value of the 'Deleted' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		get_Deleted: answer.
	^answer asObject
!

deleted: pbDeleted 
	"Set the 'Deleted' property of the receiver to the <varbool> value of the argument."

	self
		put_Deleted: pbDeleted
!

Destroy 
	"Invoke the Destroy() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Destroy();
	"

	<virtual stdcall: hresult 31>
	^self invalidCall
!

get: local iFlags: iFlags 
	"Answer the <BSTR> result of invoking the COM Object's Get() method."

	| answer |
	answer := local asBSTR.
	self
		Get: answer
		iFlags: iFlags.
	^answer asObject
!

Get: local iFlags: iFlags
	"Private - Invoke the Get() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Get(
			[in, out, optional, defaultvalue()] BSTR* Local,
			[in, optional, defaultvalue(0)] long iFlags);
	"

	<virtual stdcall: hresult 21 bstr* sdword>
	^self invalidCall
!

get_Binary: pbBinary
	"Private - Get the value of the 'Binary' property of the receiver.

		HRESULT __stdcall Binary(
			[out, retval] VARIANT_BOOL* pbBinary);
	"

	<virtual stdcall: hresult 9 varbool*>
	^self invalidCall
!

get_Checkouts: ppICheckouts
	"Private - Get the value of the 'Checkouts' property of the receiver.

		HRESULT __stdcall Checkouts(
			[out, retval] IVSSCheckouts** ppICheckouts);
	"

	<virtual stdcall: hresult 26 IVSSCheckouts**>
	^self invalidCall
!

get_Deleted: pbDeleted
	"Private - Get the value of the 'Deleted' property of the receiver.

		HRESULT __stdcall Deleted(
			[out, retval] VARIANT_BOOL* pbDeleted);
	"

	<virtual stdcall: hresult 11 varbool*>
	^self invalidCall
!

get_IsCheckedOut: piStatus
	"Private - Get the value of the 'IsCheckedOut' property of the receiver.

		HRESULT __stdcall IsCheckedOut(
			[out, retval] long* piStatus);
	"

	<virtual stdcall: hresult 25 sdword*>
	^self invalidCall
!

get_IsDifferent: local pbDifferent: pbDifferent
	"Private - Get the value of the 'IsDifferent' property of the receiver.

		HRESULT __stdcall IsDifferent(
			[in, optional, defaultvalue()] BSTR Local,
			[out, retval] VARIANT_BOOL* pbDifferent);
	"

	<virtual stdcall: hresult 27 bstr varbool*>
	^self invalidCall
!

get_Items: includeDeleted ppIItems: ppIItems
	"Private - Get the value of the 'Items' property of the receiver.

		HRESULT __stdcall Items(
			[in, optional, defaultvalue(false)] VARIANT_BOOL IncludeDeleted,
			[out, retval] IVSSItems** ppIItems);
	"

	<virtual stdcall: hresult 20 varbool IVSSItems**>
	^self invalidCall
!

get_LocalSpec: pLocal
	"Private - Get the value of the 'LocalSpec' property of the receiver.

		HRESULT __stdcall LocalSpec(
			[out, retval] BSTR* pLocal);
	"

	<virtual stdcall: hresult 14 bstr*>
	^self invalidCall
!

get_Name: pName
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval] BSTR* pName);
	"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall
!

get_Parent: ppIParent
	"Private - Get the value of the 'Parent' property of the receiver.

		HRESULT __stdcall Parent(
			[out, retval] IVSSItem** ppIParent);
	"

	<virtual stdcall: hresult 18 IVSSItem**>
	^self invalidCall
!

get_Spec: pSpec
	"Private - Get the value of the 'Spec' property of the receiver.

		HRESULT __stdcall Spec(
			[out, retval] BSTR* pSpec);
	"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall
!

get_Type: piType
	"Private - Get the value of the 'Type' property of the receiver.

		HRESULT __stdcall Type(
			[out, retval] int* piType);
	"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall
!

get_Version: version ppIItem: ppIItem
	"Private - Get the value of the 'Version' property of the receiver.

		HRESULT __stdcall Version(
			[in, optional] VARIANT Version,
			[out, retval] IVSSItem** ppIItem);
	"

	<virtual stdcall: hresult 35 VARIANT IVSSItem**>
	^self invalidCall
!

get_VersionNumber: piVersion
	"Private - Get the value of the 'VersionNumber' property of the receiver.

		HRESULT __stdcall VersionNumber(
			[out, retval] long* piVersion);
	"

	<virtual stdcall: hresult 19 sdword*>
	^self invalidCall
!

get_Versions: iFlags pIVersions: pIVersions
	"Private - Get the value of the 'Versions' property of the receiver.

		HRESULT __stdcall Versions(
			[in, optional, defaultvalue(0)] long iFlags,
			[out, retval] IVSSVersions** pIVersions);
	"

	<virtual stdcall: hresult 34 sdword IVSSVersions**>
	^self invalidCall
!

isCheckedOut
	"Answer the <sdword> value of the 'IsCheckedOut' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self
		get_IsCheckedOut: answer.
	^answer asObject
!

isDifferent: local 
	"Answer the <varbool> value of the 'IsDifferent' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		get_IsDifferent: local
		pbDifferent: answer.
	^answer asObject
!

items: includeDeleted 
	"Answer the <IVSSItems> value of the 'Items' property of the receiver."

	| answer |
	answer := IVSSItems newPointer.
	self
		get_Items: includeDeleted
		ppIItems: answer.
	^answer asObject
!

Label: label Comment: comment
	"Invoke the Label() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Label(
			[in] BSTR Label,
			[in, optional, defaultvalue()] BSTR Comment);
	"

	<virtual stdcall: hresult 33 bstr bstr>
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

localSpec: pLocal 
	"Set the 'LocalSpec' property of the receiver to the <bstr> value of the argument."

	self
		put_LocalSpec: pLocal
!

Move: pINewParent
	"Invoke the Move() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Move(
			[in] IVSSItem* pINewParent);
	"

	<virtual stdcall: hresult 32 IVSSItem*>
	^self invalidCall
!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_Name: answer.
	^answer asObject
!

name: pName 
	"Set the 'Name' property of the receiver to the <bstr> value of the argument."

	self
		put_Name: pName
!

newSubproject: name comment: comment 
	"Answer the <IVSSItem> result of invoking the COM Object's NewSubproject() method."

	| answer |
	answer := IVSSItem newPointer.
	self
		NewSubproject: name
		Comment: comment
		ppIItem: answer.
	^answer asObject
!

NewSubproject: name Comment: comment ppIItem: ppIItem
	"Private - Invoke the NewSubproject() method of the COM object wrapped by the receiver.

		HRESULT __stdcall NewSubproject(
			[in] BSTR Name,
			[in, optional, defaultvalue()] BSTR Comment,
			[out, retval] IVSSItem** ppIItem);
	"

	<virtual stdcall: hresult 29 bstr bstr IVSSItem**>
	^self invalidCall
!

parent
	"Answer the <IVSSItem> value of the 'Parent' property of the receiver."

	| answer |
	answer := IVSSItem newPointer.
	self
		get_Parent: answer.
	^answer asObject
!

put_Binary: pbBinary
	"Private - Set the value of the 'Binary' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbBinary.

		HRESULT __stdcall Binary(
			[in] VARIANT_BOOL pbBinary);
	"

	<virtual stdcall: hresult 10 varbool>
	^self invalidCall
!

put_Deleted: pbDeleted
	"Private - Set the value of the 'Deleted' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbDeleted.

		HRESULT __stdcall Deleted(
			[in] VARIANT_BOOL pbDeleted);
	"

	<virtual stdcall: hresult 12 varbool>
	^self invalidCall
!

put_LocalSpec: pLocal
	"Private - Set the value of the 'LocalSpec' property of the object wrapped by the 
	 receiver to the <bstr> argument, pLocal.

		HRESULT __stdcall LocalSpec(
			[in] BSTR pLocal);
	"

	<virtual stdcall: hresult 15 bstr>
	^self invalidCall
!

put_Name: pName
	"Private - Set the value of the 'Name' property of the object wrapped by the 
	 receiver to the <bstr> argument, pName.

		HRESULT __stdcall Name(
			[in] BSTR pName);
	"

	<virtual stdcall: hresult 17 bstr>
	^self invalidCall
!

Share: pIItem Comment: comment iFlags: iFlags
	"Invoke the Share() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Share(
			[in] IVSSItem* pIItem,
			[in, optional, defaultvalue()] BSTR Comment,
			[in, optional, defaultvalue(0)] long iFlags);
	"

	<virtual stdcall: hresult 30 IVSSItem* bstr sdword>
	^self invalidCall
!

spec
	"Answer the <bstr> value of the 'Spec' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_Spec: answer.
	^answer asObject
!

type
	"Answer the <sdword> value of the 'Type' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self
		get_Type: answer.
	^answer asObject
!

UndoCheckout: local iFlags: iFlags
	"Invoke the UndoCheckout() method of the COM object wrapped by the receiver.

		HRESULT __stdcall UndoCheckout(
			[in, optional, defaultvalue()] BSTR Local,
			[in, optional, defaultvalue(0)] long iFlags);
	"

	<virtual stdcall: hresult 24 bstr sdword>
	^self invalidCall
!

version: version 
	"Answer the <IVSSItem> value of the 'Version' property of the receiver."

	| answer |
	answer := IVSSItem newPointer.
	self
		get_Version: version asVariant
		ppIItem: answer.
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

versions: iFlags 
	"Answer the <IVSSVersions> value of the 'Versions' property of the receiver."

	| answer |
	answer := IVSSVersions newPointer.
	self
		get_Versions: iFlags
		pIVersions: answer.
	^answer asObject
! !
!IVSSItemOld categoriesFor: #add:comment:iFlags:!**auto generated**!methods!public! !
!IVSSItemOld categoriesFor: #Add:Comment:iFlags:ppIItem:!**auto generated**!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #binary!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #binary:!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #Checkin:Local:iFlags:!**auto generated**!COM Interfaces-IVSSItemOld!public! !
!IVSSItemOld categoriesFor: #Checkout:Local:iFlags:!**auto generated**!COM Interfaces-IVSSItemOld!public! !
!IVSSItemOld categoriesFor: #checkouts!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #deleted!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #deleted:!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #Destroy!**auto generated**!COM Interfaces-IVSSItemOld!public! !
!IVSSItemOld categoriesFor: #get:iFlags:!**auto generated**!methods!public! !
!IVSSItemOld categoriesFor: #Get:iFlags:!**auto generated**!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_Binary:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_Checkouts:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_Deleted:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_IsCheckedOut:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_IsDifferent:pbDifferent:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_Items:ppIItems:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_LocalSpec:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_Name:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_Parent:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_Spec:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_Type:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_Version:ppIItem:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_VersionNumber:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #get_Versions:pIVersions:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #isCheckedOut!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #isDifferent:!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #items:!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #Label:Comment:!**auto generated**!COM Interfaces-IVSSItemOld!public! !
!IVSSItemOld categoriesFor: #localSpec!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #localSpec:!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #Move:!**auto generated**!COM Interfaces-IVSSItemOld!public! !
!IVSSItemOld categoriesFor: #name!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #name:!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #newSubproject:comment:!**auto generated**!methods!public! !
!IVSSItemOld categoriesFor: #NewSubproject:Comment:ppIItem:!**auto generated**!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #parent!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #put_Binary:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #put_Deleted:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #put_LocalSpec:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #put_Name:!COM Interfaces-IVSSItemOld!private! !
!IVSSItemOld categoriesFor: #Share:Comment:iFlags:!**auto generated**!COM Interfaces-IVSSItemOld!public! !
!IVSSItemOld categoriesFor: #spec!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #type!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #UndoCheckout:iFlags:!**auto generated**!COM Interfaces-IVSSItemOld!public! !
!IVSSItemOld categoriesFor: #version:!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #versionNumber!**auto generated**!properties!public! !
!IVSSItemOld categoriesFor: #versions:!**auto generated**!properties!public! !

