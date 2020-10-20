"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOIBodyParts
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOIBodyParts guid: (IID fromString: '{cd000023-8b95-11d1-82db-00c04fb1625d}')!
CDOIBodyParts comment: '<CDOIBodyParts> is a wrapper class for the COM interface ''CDO.IBodyParts'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to manage a collection of BodyPart objects"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOIBodyParts categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOIBodyParts methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self
		get__NewEnum: answer.
	^answer asObject
!

add: index
	"Answer the <CDOIBodyPart> result of invoking the COM Object's Add() method.
	Helpstring: 'Adds a BodyPart object to the collection at the specified index, and returns the newly added object.'"

	| answer |
	answer := CDOIBodyPart newPointer.
	self
		Add: index
		ppPart: answer.
	^answer asObject
!

Add: index ppPart: ppPart
	"Private - Invoke the Add() method of the COM object wrapped by the receiver.
	Helpstring: 'Adds a BodyPart object to the collection at the specified index, and returns the newly added object.'

		HRESULT __stdcall Add(
			[in, optional, defaultvalue(-1)] long Index,
			[out, retval] IBodyPart** ppPart);
	"

	<virtual stdcall: hresult 13 sdword CDOIBodyPart**>
	^self invalidCall: _failureCode!

count
	"Answer the <sdword> value of the 'Count' property of the receiver.
	Helpstring: 'Returns the number of BodyPart objects in the collection.'"

	| answer |
	answer := (SDWORD new).
	self
		get_Count: answer.
	^answer asObject
!

delete: varBP
	"Invoke the Delete() method of the COM Object.
	Helpstring: 'Deletes the specified BodyPart object from the collection. Can use the index or a reference to the object.'"

	^self
		Delete: varBP asVariant
!

Delete: varBP
	"Private - Invoke the Delete() method of the COM object wrapped by the receiver.
	Helpstring: 'Deletes the specified BodyPart object from the collection. Can use the index or a reference to the object.'

		HRESULT __stdcall Delete(
			[in] VARIANT varBP);
	"

	<virtual stdcall: hresult 11 variant>
	^self invalidCall: _failureCode!

DeleteAll
	"Invoke the DeleteAll() method of the COM object wrapped by the receiver.
	Helpstring: 'Deletes all BodyPart objects in the collection.'

		HRESULT __stdcall DeleteAll();
	"

	<virtual stdcall: hresult 12>
	^self invalidCall: _failureCode!

get__NewEnum: retval
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval] IUnknown** retval);
	"

	<virtual stdcall: hresult 10 IUnknown**>
	^self invalidCall: _failureCode!

get_Count: varCount
	"Private - Get the value of the 'Count' property of the receiver.
	Helpstring: 'Returns the number of BodyPart objects in the collection.'

		HRESULT __stdcall Count(
			[out, retval] long* varCount);
	"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

get_Item: index ppBody: ppBody
	"Private - Get the value of the 'Item' property of the receiver.
	Helpstring: 'The specified BodyPart object in the collection.'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] IBodyPart** ppBody);
	"

	<virtual stdcall: hresult 9 sdword CDOIBodyPart**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <CDOIBodyPart> value of the 'Item' property of the receiver.
	Helpstring: 'The specified BodyPart object in the collection.'"

	| answer |
	answer := CDOIBodyPart newPointer.
	self
		get_Item: index
		ppBody: answer.
	^answer asObject
! !
!CDOIBodyParts categoriesFor: #_newEnum!**auto generated**!properties!public! !
!CDOIBodyParts categoriesFor: #add:!**auto generated**!methods!public! !
!CDOIBodyParts categoriesFor: #Add:ppPart:!**auto generated**!COM Interfaces-IBodyParts!private! !
!CDOIBodyParts categoriesFor: #count!**auto generated**!properties!public! !
!CDOIBodyParts categoriesFor: #delete:!**auto generated**!methods!public! !
!CDOIBodyParts categoriesFor: #Delete:!**auto generated**!COM Interfaces-IBodyParts!private! !
!CDOIBodyParts categoriesFor: #DeleteAll!**auto generated**!COM Interfaces-IBodyParts!public! !
!CDOIBodyParts categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-IBodyParts!private! !
!CDOIBodyParts categoriesFor: #get_Count:!**auto generated**!COM Interfaces-IBodyParts!private! !
!CDOIBodyParts categoriesFor: #get_Item:ppBody:!**auto generated**!COM Interfaces-IBodyParts!private! !
!CDOIBodyParts categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOIBodyParts categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!CDOIBodyParts categoriesFor: #item:!**auto generated**!properties!public! !

!CDOIBodyParts class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IBodyParts'
		CDOIBodyParts defineTemplate
	"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #get_Item:ppBody:
			argumentTypes: 'sdword CDOIBodyPart**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**';
		defineFunction: #Delete:
			argumentTypes: 'variant';
		defineFunction: #DeleteAll;
		defineFunction: #Add:ppPart:
			argumentTypes: 'sdword CDOIBodyPart**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOIBodyParts initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOIBodyParts class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDOIBodyParts class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

