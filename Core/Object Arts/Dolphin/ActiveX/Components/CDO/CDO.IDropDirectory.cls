"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'CDO.IDropDirectory'
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

getMessages: dirName
	"Answer the <CDO.IMessages> result of invoking the COM Object's GetMessages() method.
	Helpstring: 'Returns a collection of messages contained in the specified directory on the file system. The default location is the SMTP drop directory.'"

	| answer |
	answer := IMessages newPointer.
	self GetMessages: dirName Msgs: answer.
	^answer asObject!

GetMessages: dirName Msgs: msgs
	"Private - Invoke the GetMessages() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns a collection of messages contained in the specified directory on the file system. The default location is the SMTP drop directory.'

		HRESULT __stdcall GetMessages(
			[in, optional] BSTR DirName,
			[out, retval] IMessages** Msgs);
	"

	<virtual stdcall: hresult 8 bstr IMessages**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!CDO.IDropDirectory categoriesFor: #getMessages:!**auto generated**!methods!public! !
!CDO.IDropDirectory categoriesFor: #GetMessages:Msgs:!**auto generated**!COM Interfaces-IDropDirectory!private! !
!CDO.IDropDirectory categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDO.IDropDirectory categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!CDO.IDropDirectory class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (DropDirectory) for which the receiver is the default interface.
	"

	^CLSID fromString: '{CD000004-8B95-11D1-82DB-00C04FB1625D}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IDropDirectory'
		CDO.IDropDirectory defineTemplate
	"

	self
		defineFunction: #GetMessages:Msgs:
			argumentTypes: 'bstr IMessages**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDO.IDropDirectory initializeTypeLib
	"

	typeLib := CDOLib! !
!CDO.IDropDirectory class categoriesFor: #clsid!**auto generated**!constants!private! !
!CDO.IDropDirectory class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDO.IDropDirectory class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

