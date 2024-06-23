"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'CDO.IMessages'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

CDO.IMessages guid: (OS.COM.IID fromString: '{cd000025-8b95-11d1-82db-00c04fb1625d}')!

CDO.IMessages comment: '<CDO.IMessages> is a wrapper class for the COM interface ''CDO.IMessages'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to manage a collection of Message objects on the file system. Returned by IDropDirectory.GetMessages"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!

!CDO.IMessages categoriesForClass!CDO-Interfaces!COM-Interfaces! !

!CDO.IMessages methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get__NewEnum: answer.
	^answer asObject!

count
	"Answer the <sdword> value of the 'Count' property of the receiver.
	Helpstring: The number of message objects in the collection."

	| answer |
	answer := Int32 new.
	self get_Count: answer.
	^answer asObject!

Delete: index
	"Invoke the Delete() method of the COM object.
	Helpstring: Deletes the specified message object in the collection.

		HRESULT __stdcall Delete(
			[in]long Index);"

	<virtual stdcall: hresult 10 int32>
	^self invalidCall: _failureCode!

DeleteAll
	"Invoke the DeleteAll() method of the COM object.
	Helpstring: Deletes all message objects in the collection.

		HRESULT __stdcall DeleteAll();"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode!

fileName: var
	"Answer the <bstr> value of the 'FileName' property of the receiver.
	Helpstring: Returns the name of the file containing the specified message in the file system."

	| answer |
	answer := BSTR new.
	self get_FileName: var asVariant FileName: answer.
	^answer asObject!

get__NewEnum: retval
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval]IUnknown** retval);"

	<virtual stdcall: hresult 12 IUnknown**>
	^self invalidCall: _failureCode!

get_Count: varCount
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval]long* varCount);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

get_FileName: var FileName: fileName
	"Private - Get the value of the 'FileName' property of the receiver.

		HRESULT __stdcall FileName(
			VARIANT var,
			[out, retval]BSTR* FileName);"

	<virtual stdcall: hresult 13 variant bstr*>
	^self invalidCall: _failureCode!

get_Item: index ppMessage: ppMessage
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			long Index,
			[out, retval]IMessage** ppMessage);"

	<virtual stdcall: hresult 8 int32 IMessage**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <IMessage> value of the 'Item' property of the receiver.
	Helpstring: Returns the message specified by index from the collection."

	| answer |
	answer := IMessage newPointer.
	self get_Item: index ppMessage: answer.
	^answer asObject! !

!CDO.IMessages categoriesForMethods!
_newEnum!**auto generated**!properties!public! !
count!**auto generated**!properties!public! !
Delete:!**auto generated**!COM Interfaces-IMessages!public! !
DeleteAll!**auto generated**!COM Interfaces-IMessages!public! !
fileName:!**auto generated**!properties!public! !
get__NewEnum:!**auto generated**!COM Interfaces-IMessages!private! !
get_Count:!**auto generated**!COM Interfaces-IMessages!private! !
get_FileName:FileName:!**auto generated**!COM Interfaces-IMessages!private! !
get_Item:ppMessage:!**auto generated**!COM Interfaces-IMessages!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
item:!**auto generated**!properties!public! !
!

!CDO.IMessages class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IMessages'
		IMessages defineTemplate"

	self
		defineFunction: #get_Item:ppMessage:
			argumentTypes: 'sdword IMessage**';
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Delete:
			argumentTypes: 'sdword';
		defineFunction: #DeleteAll;
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**';
		defineFunction: #get_FileName:FileName:
			argumentTypes: 'variant bstr*'
! !

!CDO.IMessages class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

