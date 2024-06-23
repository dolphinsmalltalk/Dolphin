"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'CDO.IDropDirectory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

CDO.IDropDirectory guid: (OS.COM.IID fromString: '{cd000024-8b95-11d1-82db-00c04fb1625d}')!

CDO.IDropDirectory comment: '<CDO.IDropDirectory> is a wrapper class for the COM interface ''CDO.IDropDirectory'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to manage a collection of messages on the file system"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!

!CDO.IDropDirectory categoriesForClass!CDO-Interfaces!COM-Interfaces! !

!CDO.IDropDirectory methodsFor!

getMessages
	"Answer the <IMessages> result of invoking the GetMessages() method of the COM object.
	Default values are passed for all optional parameters."

	^self getMessages: nil!

getMessages: dirName
	"Answer the <IMessages> result of invoking the GetMessages() method of the COM object.
	Helpstring: Returns a collection of messages contained in the specified directory on the file system. The default location is the SMTP drop directory."

	| answer |
	answer := IMessages newPointer.
	self GetMessages: dirName Msgs: answer.
	^answer asObject!

GetMessages: dirName Msgs: msgs
	"Private - Invoke the GetMessages() method of the COM object.
	Helpstring: Returns a collection of messages contained in the specified directory on the file system. The default location is the SMTP drop directory.

		HRESULT __stdcall GetMessages(
			[in, optional]BSTR DirName,
			[out, retval]IMessages** Msgs);"

	<virtual stdcall: hresult 8 bstr IMessages**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !

!CDO.IDropDirectory categoriesForMethods!
getMessages!**auto generated**!methods!public! !
getMessages:!**auto generated**!methods!public! !
GetMessages:Msgs:!**auto generated**!COM Interfaces-IDropDirectory!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
!

!CDO.IDropDirectory class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (DropDirectory) for which the receiver is the default interface."

	^CLSID fromString: '{cd000004-8b95-11d1-82db-00c04fb1625d}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IDropDirectory'
		IDropDirectory defineTemplate"

	self
		defineFunction: #GetMessages:Msgs:
			argumentTypes: 'bstr IMessages**'
! !

!CDO.IDropDirectory class categoriesForMethods!
clsid!**auto generated**!constants!private! !
defineFunctions!**auto generated**!initializing!private! !
!

