"Filed out from Dolphin Smalltalk 7"!

OS.COM.IEnumXXXX subclass: #'OS.COM.IEnumUnknown'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IEnumUnknown guid: (OS.COM.IID fromString: '{00000100-0000-0000-c000-000000000046}')!
OS.COM.IEnumUnknown comment: '`OS.COM.IEnumUnknown` is a wrapper class for the custom interface ''OBJIDL.IEnumUnknown'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

IEnumUnknown and subclasses are used for enumerating over collections of COM interface pointers.

Implementation Note: IUnknown>>fromAddress: increments the reference count of the COM object it wraps, the result is effectively a standalone pointer which is valid outside the scope of the original owner of the pointer. This means that it is not necessary to take any special action here to extend the life of the objects pulled back by nextAvailable[:] since there lifetime is independent of the buffer used to retrieve them.'!
!OS.COM.IEnumUnknown categoriesForClass!COM-Interfaces! !
!OS.COM.IEnumUnknown methodsFor!

Next: celt rgelt: rgelt pceltFetched: pceltFetched
	"Invoke the Next() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Next(
			[in] unsigned long celt,
			[out] IUnknown** rgelt,
			[out] unsigned long* pceltFetched);

	"

	<virtual stdcall: hresult 4 dword IUnknown** dword*>
	^self invalidCall: _failureCode! !
!OS.COM.IEnumUnknown categoriesFor: #Next:rgelt:pceltFetched:!**auto generated**!COM Interfaces-OBJIDL.IEnumUnknown!primitives!public! !

!OS.COM.IEnumUnknown class methodsFor!

defineFunctions
	"Declare the virtual function table for the receiver.
		self defineTemplate
	"

	"This method only present to prevent auto-generation from a type library"!

elementClass
	"Answer the class of element enumerated by the receiver."

	^IUnknown! !
!OS.COM.IEnumUnknown class categoriesFor: #defineFunctions!initializing!public! !
!OS.COM.IEnumUnknown class categoriesFor: #elementClass!constants!public! !

