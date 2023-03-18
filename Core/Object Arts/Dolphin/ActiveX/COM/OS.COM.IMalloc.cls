"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IMalloc'
	instanceVariableNames: ''
	classVariableNames: 'Shared Task'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IMalloc guid: (OS.COM.IID fromString: '{00000002-0000-0000-c000-000000000046}')!
OS.COM.IMalloc comment: '`OS.COM.IMalloc` is a wrapper class for the custom interface ''OBJIDL.IMalloc'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.IMalloc categoriesForClass!COM-Interfaces! !
!OS.COM.IMalloc methodsFor!

Alloc: cb
	"Invoke the Alloc() method of the object wrapped by the receiver.
	
		void* __stdcall Alloc(
			[in] unsigned long cb);
	"

	<virtual stdcall: void* 4 uint32>
	^self invalidCall: _failureCode!

DidAlloc: pv
	"Invoke the DidAlloc() method of the object wrapped by the receiver.
	
		int __stdcall DidAlloc(
			void* pv);

	"

	<virtual stdcall: int32 8 void*>
	^self invalidCall: _failureCode!

Free: pv
	"Invoke the Free() method of the object wrapped by the receiver.
	
		void __stdcall Free(
			[in] void* pv);

	"

	<virtual stdcall: void 6 void*>
	^self invalidCall: _failureCode!

GetSize: pv
	"Invoke the GetSize() method of the object wrapped by the receiver.
	
		unsigned long __stdcall GetSize(
			[in] void* pv);

	"

	<virtual stdcall: uint32 7 void*>
	^self invalidCall: _failureCode!

HeapMinimize
	"Invoke the HeapMinimize() method of the object wrapped by the receiver.
	
		void __stdcall HeapMinimize();

	"

	<virtual stdcall: void 9>
	^self invalidCall: _failureCode!

Realloc: pv cb: cb
	"Invoke the Realloc() method of the object wrapped by the receiver.
	
		void* __stdcall Realloc(
			[in] void* pv,
			[in] unsigned long cb);

	"

	<virtual stdcall: void* 5 void* uint32>
	^self invalidCall: _failureCode! !
!OS.COM.IMalloc categoriesForMethods!
Alloc:!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
DidAlloc:!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
Free:!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
GetSize:!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
HeapMinimize!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
Realloc:cb:!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
!

OS.COM.IMalloc methodProtocol: #IMalloc attributes: #(#readOnly) selectors: #(#Alloc: #DidAlloc: #GetSize: #HeapMinimize #Realloc:cb:)!

!OS.COM.IMalloc class methodsFor!

clear
	"Private - Clear down the standard task/shared allocators (e.g. on startup)."

	Task := Shared := nil!

default
	"Answer the default IMalloc (task allocator)."

	^self task!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IMalloc'
		IMalloc defineTemplate
	"

	self
		defineFunction: #Alloc:
			returnType: 'void*'
			argumentTypes: 'dword';
		defineFunction: #Realloc:cb:
			returnType: 'void*'
			argumentTypes: 'void* dword';
		defineFunction: #Free:
			returnType: 'void'
			argumentTypes: 'void*';
		defineFunction: #GetSize:
			returnType: 'dword'
			argumentTypes: 'void*';
		defineFunction: #DidAlloc:
			returnType: 'sdword'
			argumentTypes: 'void*';
		defineFunction: #HeapMinimize
			returnType: 'void'
!

free
	"Private - Free the standard task/shared allocators."

	self freeTask.
	self freeShared!

freeShared
	"Private - Release the default IMalloc (task allocator)."

	Shared free.
	Shared := nil!

freeTask
	"Private - Release the default IMalloc (task allocator)."

	Task isNil ifFalse: [
		Task free.
		Task := nil]
!

task
	"Answer the IMalloc task allocator.
	N.B. The task allocator must always be used to allocate [Out] and [In/Out]
	parameters."

	Task isNull
		ifTrue: 
			[| pMalloc |
			pMalloc := self newPointer.
			Ole32 coGetMalloc: MEMCTX_TASK ppMalloc: pMalloc.	"may throw HRESULTError"
			Task := pMalloc].
	^Task!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self clear! !
!OS.COM.IMalloc class categoriesForMethods!
clear!initializing!private! !
default!accessing!public! !
defineFunctions!**auto generated**!initializing!public! !
free!private!realizing/unrealizing! !
freeShared!private!realizing/unrealizing! !
freeTask!private!realizing/unrealizing! !
task!accessing!public! !
uninitialize!accessing!class hierarchy-removing!private! !
!

