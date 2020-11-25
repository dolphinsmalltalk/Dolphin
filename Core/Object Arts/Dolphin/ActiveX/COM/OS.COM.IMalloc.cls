"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IMalloc
	instanceVariableNames: ''
	classVariableNames: 'Shared Task'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IMalloc guid: (IID fromString: '{00000002-0000-0000-c000-000000000046}')!
IMalloc comment: '<IMalloc> is a wrapper class for the custom interface ''OBJIDL.IMalloc'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IMalloc categoriesForClass!COM-Interfaces! !
!IMalloc methodsFor!

Alloc: cb
	"Invoke the Alloc() method of the object wrapped by the receiver.
	
		void* __stdcall Alloc(
			[in] unsigned long cb);
	"

	<virtual stdcall: void* 4 dword>
	^self invalidCall: _failureCode!

DidAlloc: pv
	"Invoke the DidAlloc() method of the object wrapped by the receiver.
	
		int __stdcall DidAlloc(
			void* pv);

	"

	<virtual stdcall: sdword 8 void*>
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

	<virtual stdcall: dword 7 void*>
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

	<virtual stdcall: void* 5 void* dword>
	^self invalidCall: _failureCode! !
!IMalloc categoriesFor: #Alloc:!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
!IMalloc categoriesFor: #DidAlloc:!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
!IMalloc categoriesFor: #Free:!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
!IMalloc categoriesFor: #GetSize:!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
!IMalloc categoriesFor: #HeapMinimize!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !
!IMalloc categoriesFor: #Realloc:cb:!**auto generated**!COM Interfaces-OBJIDL.IMalloc!public! !

IMalloc methodProtocol: #IMalloc attributes: #(#readOnly) selectors: #(#Alloc: #DidAlloc: #GetSize: #HeapMinimize #Realloc:cb:)!

!IMalloc class methodsFor!

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

	Shared isNil ifFalse: [
		Shared free.
		Shared := nil]
!

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
			OLELibrary default coGetMalloc: MEMCTX_TASK ppMalloc: pMalloc.	"may throw HRESULTError"
			Task := pMalloc].
	^Task!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self clear! !
!IMalloc class categoriesFor: #clear!initializing!private! !
!IMalloc class categoriesFor: #default!accessing!public! !
!IMalloc class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IMalloc class categoriesFor: #free!private!realizing/unrealizing! !
!IMalloc class categoriesFor: #freeShared!private!realizing/unrealizing! !
!IMalloc class categoriesFor: #freeTask!private!realizing/unrealizing! !
!IMalloc class categoriesFor: #task!accessing!public! !
!IMalloc class categoriesFor: #uninitialize!accessing!class hierarchy-removing!private! !

