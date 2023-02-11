"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch subclass: #'CDO.IBodyParts'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
CDO.IBodyParts guid: (OS.COM.IID fromString: '{cd000023-8b95-11d1-82db-00c04fb1625d}')!
CDO.IBodyParts comment: '<CDO.IBodyParts> is a wrapper class for the COM interface ''CDO.IBodyParts'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to manage a collection of BodyPart objects"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDO.IBodyParts categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDO.IBodyParts methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get__NewEnum: answer.
	^answer asObject!

add
	"Answer the <IBodyPart> result of invoking the Add() method of the COM object.
	Default values are passed for all optional parameters."

	^self add: -1!

add: index
	"Answer the <IBodyPart> result of invoking the Add() method of the COM object.
	Helpstring: Adds a BodyPart object to the collection at the specified index, and returns the newly added object."

	| answer |
	answer := IBodyPart newPointer.
	self Add: index ppPart: answer.
	^answer asObject!

Add: index ppPart: ppPart
	"Private - Invoke the Add() method of the COM object.
	Helpstring: Adds a BodyPart object to the collection at the specified index, and returns the newly added object.

		HRESULT __stdcall Add(
			[in, defaultvalue(-1)]long Index,
			[out, retval]IBodyPart** ppPart);"

	<virtual stdcall: hresult 13 int32 IBodyPart**>
	^self invalidCall: _failureCode!

count
	"Answer the <sdword> value of the 'Count' property of the receiver.
	Helpstring: Returns the number of BodyPart objects in the collection."

	| answer |
	answer := Int32 new.
	self get_Count: answer.
	^answer asObject!

delete: varBP
	"Invoke the Delete() method of the COM object.
	Helpstring: Deletes the specified BodyPart object from the collection. Can use the index or a reference to the object."

	^self Delete: varBP asVariant!

Delete: varBP
	"Private - Invoke the Delete() method of the COM object.
	Helpstring: Deletes the specified BodyPart object from the collection. Can use the index or a reference to the object.

		HRESULT __stdcall Delete(
			[in]VARIANT varBP);"

	<virtual stdcall: hresult 11 variant>
	^self invalidCall: _failureCode!

DeleteAll
	"Invoke the DeleteAll() method of the COM object.
	Helpstring: Deletes all BodyPart objects in the collection.

		HRESULT __stdcall DeleteAll();"

	<virtual stdcall: hresult 12>
	^self invalidCall: _failureCode!

get__NewEnum: retval
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval]IUnknown** retval);"

	<virtual stdcall: hresult 10 IUnknown**>
	^self invalidCall: _failureCode!

get_Count: varCount
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval]long* varCount);"

	<virtual stdcall: hresult 8 int32*>
	^self invalidCall: _failureCode!

get_Item: index ppBody: ppBody
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]long Index,
			[out, retval]IBodyPart** ppBody);"

	<virtual stdcall: hresult 9 int32 IBodyPart**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <IBodyPart> value of the 'Item' property of the receiver.
	Helpstring: The specified BodyPart object in the collection."

	| answer |
	answer := IBodyPart newPointer.
	self get_Item: index ppBody: answer.
	^answer asObject! !
!CDO.IBodyParts categoriesForMethods!
_newEnum!**auto generated**!properties!public! !
add!**auto generated**!methods!public! !
add:!**auto generated**!methods!public! !
Add:ppPart:!**auto generated**!COM Interfaces-IBodyParts!private! !
count!**auto generated**!properties!public! !
delete:!**auto generated**!methods!public! !
Delete:!**auto generated**!COM Interfaces-IBodyParts!private! !
DeleteAll!**auto generated**!COM Interfaces-IBodyParts!public! !
get__NewEnum:!**auto generated**!COM Interfaces-IBodyParts!private! !
get_Count:!**auto generated**!COM Interfaces-IBodyParts!private! !
get_Item:ppBody:!**auto generated**!COM Interfaces-IBodyParts!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
item:!**auto generated**!properties!public! !
!

!CDO.IBodyParts class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IBodyParts'
		IBodyParts defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #get_Item:ppBody:
			argumentTypes: 'sdword IBodyPart**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**';
		defineFunction: #Delete:
			argumentTypes: 'variant';
		defineFunction: #DeleteAll;
		defineFunction: #Add:ppPart:
			argumentTypes: 'sdword IBodyPart**'
! !
!CDO.IBodyParts class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

