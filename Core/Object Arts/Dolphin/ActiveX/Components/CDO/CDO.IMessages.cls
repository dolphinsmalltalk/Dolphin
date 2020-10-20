"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOIMessages
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOIMessages guid: (IID fromString: '{cd000025-8b95-11d1-82db-00c04fb1625d}')!
CDOIMessages comment: '<CDOIMessages> is a wrapper class for the COM interface ''CDO.IMessages'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to manage a collection of Message objects on the file system. Returned by IDropDirectory.GetMessages"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOIMessages categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOIMessages methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self
		get__NewEnum: answer.
	^answer asObject
!

count
	"Answer the <sdword> value of the 'Count' property of the receiver.
	Helpstring: 'The number of message objects in the collection.'"

	| answer |
	answer := (SDWORD new).
	self
		get_Count: answer.
	^answer asObject
!

Delete: index
	"Invoke the Delete() method of the COM object wrapped by the receiver.
	Helpstring: 'Deletes the specified message object in the collection.'

		HRESULT __stdcall Delete(
			[in] long Index);
	"

	<virtual stdcall: hresult 10 sdword>
	^self invalidCall: _failureCode!

DeleteAll
	"Invoke the DeleteAll() method of the COM object wrapped by the receiver.
	Helpstring: 'Deletes all message objects in the collection.'

		HRESULT __stdcall DeleteAll();
	"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode!

fileName: var
	"Answer the <bstr> value of the 'FileName' property of the receiver.
	Helpstring: 'Returns the name of the file containing the specified message in the file system.'"

	| answer |
	answer := BSTR new.
	self
		get_FileName: var asVariant
		FileName: answer.
	^answer asObject
!

get__NewEnum: retval
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval] IUnknown** retval);
	"

	<virtual stdcall: hresult 12 IUnknown**>
	^self invalidCall: _failureCode!

get_Count: varCount
	"Private - Get the value of the 'Count' property of the receiver.
	Helpstring: 'The number of message objects in the collection.'

		HRESULT __stdcall Count(
			[out, retval] long* varCount);
	"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall: _failureCode!

get_FileName: var FileName: fileName
	"Private - Get the value of the 'FileName' property of the receiver.
	Helpstring: 'Returns the name of the file containing the specified message in the file system.'

		HRESULT __stdcall FileName(
			VARIANT var,
			[out, retval] BSTR* FileName);
	"

	<virtual stdcall: hresult 13 variant bstr*>
	^self invalidCall: _failureCode!

get_Item: index ppMessage: ppMessage
	"Private - Get the value of the 'Item' property of the receiver.
	Helpstring: 'Returns the message specified by index from the collection.'

		HRESULT __stdcall Item(
			long Index,
			[out, retval] IMessage** ppMessage);
	"

	<virtual stdcall: hresult 8 sdword CDOIMessage**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <CDOIMessage> value of the 'Item' property of the receiver.
	Helpstring: 'Returns the message specified by index from the collection.'"

	| answer |
	answer := CDOIMessage newPointer.
	self
		get_Item: index
		ppMessage: answer.
	^answer asObject
! !
!CDOIMessages categoriesFor: #_newEnum!**auto generated**!properties!public! !
!CDOIMessages categoriesFor: #count!**auto generated**!properties!public! !
!CDOIMessages categoriesFor: #Delete:!**auto generated**!COM Interfaces-IMessages!public! !
!CDOIMessages categoriesFor: #DeleteAll!**auto generated**!COM Interfaces-IMessages!public! !
!CDOIMessages categoriesFor: #fileName:!**auto generated**!properties!public! !
!CDOIMessages categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-IMessages!private! !
!CDOIMessages categoriesFor: #get_Count:!**auto generated**!COM Interfaces-IMessages!private! !
!CDOIMessages categoriesFor: #get_FileName:FileName:!**auto generated**!COM Interfaces-IMessages!private! !
!CDOIMessages categoriesFor: #get_Item:ppMessage:!**auto generated**!COM Interfaces-IMessages!private! !
!CDOIMessages categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOIMessages categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!CDOIMessages categoriesFor: #item:!**auto generated**!properties!public! !

!CDOIMessages class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IMessages'
		CDOIMessages defineTemplate
	"

	self
		defineFunction: #get_Item:ppMessage:
			argumentTypes: 'sdword CDOIMessage**';
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Delete:
			argumentTypes: 'sdword';
		defineFunction: #DeleteAll;
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**';
		defineFunction: #get_FileName:FileName:
			argumentTypes: 'variant bstr*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOIMessages initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOIMessages class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDOIMessages class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

