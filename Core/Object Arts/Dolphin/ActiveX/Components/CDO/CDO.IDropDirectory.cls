"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOIDropDirectory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOIDropDirectory guid: (IID fromString: '{cd000024-8b95-11d1-82db-00c04fb1625d}')!
CDOIDropDirectory comment: '<CDOIDropDirectory> is a wrapper class for the COM interface ''CDO.IDropDirectory'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to manage a collection of messages on the file system"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOIDropDirectory categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOIDropDirectory methodsFor!

getMessages: dirName
	"Answer the <CDOIMessages> result of invoking the COM Object's GetMessages() method.
	Helpstring: 'Returns a collection of messages contained in the specified directory on the file system. The default location is the SMTP drop directory.'"

	| answer |
	answer := CDOIMessages newPointer.
	self
		GetMessages: dirName
		Msgs: answer.
	^answer asObject
!

GetMessages: dirName Msgs: msgs
	"Private - Invoke the GetMessages() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns a collection of messages contained in the specified directory on the file system. The default location is the SMTP drop directory.'

		HRESULT __stdcall GetMessages(
			[in, optional] BSTR DirName,
			[out, retval] IMessages** Msgs);
	"

	<virtual stdcall: hresult 8 bstr CDOIMessages**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!CDOIDropDirectory categoriesFor: #getMessages:!**auto generated**!methods!public! !
!CDOIDropDirectory categoriesFor: #GetMessages:Msgs:!**auto generated**!COM Interfaces-IDropDirectory!private! !
!CDOIDropDirectory categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOIDropDirectory categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!CDOIDropDirectory class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (DropDirectory) for which the receiver is the default interface.
	"

	^CLSID fromString: '{CD000004-8B95-11D1-82DB-00C04FB1625D}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IDropDirectory'
		CDOIDropDirectory defineTemplate
	"

	self
		defineFunction: #GetMessages:Msgs:
			argumentTypes: 'bstr CDOIMessages**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOIDropDirectory initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOIDropDirectory class categoriesFor: #clsid!**auto generated**!constants!private! !
!CDOIDropDirectory class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDOIDropDirectory class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

