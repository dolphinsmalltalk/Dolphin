﻿"Filed out from Dolphin Smalltalk"!

OS.COM.Interface
	subclass: #'OS.COM.IUnknown'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IUnknown guid: (OS.COM.IID fromString: '{00000000-0000-0000-c000-000000000046}')!

OS.COM.IUnknown comment: '`OS.COM.IUnknown` is a wrapper class for the COM interface ''stdole.IUnknown'' generated from type information in the ''OLE Automation'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

`IUnknown` is the fundamental interface supported by all COM objects and is therefore ubiquitous for any component regardless of implementation. IUnknown includes behaviour to control object lifetime by reference counting, and for  interface negotiation using `QueryInterface()`.

Note that most of Dolphin''''s supporting behaviour wrapping IUnknown is implemented in the superclass in order not to overwhelm the fundamental simplicity of IUnknown.

IDL definition follows:
```
[
	object, 
	uuid(00000000-0000-0000-c000-000000000046), 
	hidden
]
interface IUnknown
 {
	[id(0x60000000), restricted]
	HRESULT __stdcall QueryInterface(
		[in]GUID* riid,
		[out]void** ppvObj);
	[id(0x60000001), restricted]
	unsigned long __stdcall AddRef();
	[id(0x60000002), restricted]
	unsigned long __stdcall Release();
};
```'!

!OS.COM.IUnknown categoriesForClass!COM-Interfaces! !

!OS.COM.IUnknown methodsFor!

addRef 
	"Increment the receiver's reference count.
	Raises an HRESULTError if the receiver is null."

	self isNull ifTrue: [^HRESULTError signalWith: E_POINTER].
	self AddRef
!

AddRef
	"Private - Invoke the AddRef() method of the COM object.

		unsigned long __stdcall AddRef();"

	<virtual stdcall: uint32 2>
	^self invalidCall: _failureCode!

asObject
	"Answer a suitable Smalltalk object to represent the receiver's value."

	^self notNull ifTrue: [self]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self isNull ifTrue: [aPuttableStream print: nil] ifFalse: [self printOn: aPuttableStream]!

QueryInterface: riid ppvObject: ppvObject
	"Private - Invoke the QueryInterface() method of the COM object.
	
		HRESULT __stdcall QueryInterface(
			[in]GUID* riid,
			[out]void** ppvObj);"

	"Implementation Note: Return integer hresult value rather than have exception thrown, as
	E_NOINTERFACE is not really an exceptional condition at all."

	<virtual stdcall: int32 1 guid* void**>
	^self invalidCall: _failureCode!

Release
	"Private - Invoke the Release() method of the COM object.

		unsigned long __stdcall Release();"

	<virtual stdcall: uint32 3>
	^self invalidCall: _failureCode! !

!OS.COM.IUnknown categoriesForMethods!
addRef!methods!public! !
AddRef!**auto generated**!COM Interfaces-IUnknown!private! !
asObject!converting!public! !
displayOn:!printing!public! !
QueryInterface:ppvObject:!methods!public! !
Release!**auto generated**!COM Interfaces-IUnknown!private! !
!

!OS.COM.IUnknown class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'stdole.IUnknown'

	Implementation Note: These functions are the core of COM and are crucial to good performance,
	therefore they are implemented as special classes of function which don't need to use the 
	generic Object>>perform:withArgumentsAt:descriptor: primitive."

	functions 
		add: QueryInterfaceFunction new;
		add: AddRefFunction new;
		add: ReleaseFunction new!

on: server outerUnknown: pUnkOuter
	"Private - Answer a pointer to a new instance of the receiver acting as a non-delegating
	unknown for the object, server, and whose outer unknown is referenced by the
	argument, pUnkOuter.
	Implementation Note: As IUnknown is implemented entirely by the COM object stub
	we have no need of a pointer to the implementor."

	| stub if |
	stub := self comObjectClass on: server.
	if := self newInternal.
	stub 
		outerUnknown: pUnkOuter;
		addInterface: if.
	^self fromAddress: if yourAddress!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil! !

!OS.COM.IUnknown class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
on:outerUnknown:!instance creation!private! !
uninitialize!class hierarchy-removing!private! !
!

