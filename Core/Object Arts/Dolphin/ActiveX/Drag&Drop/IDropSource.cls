"Filed out from Dolphin Smalltalk X6.1"!

IUnknown subclass: #IDropSource
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IDropSource guid: (IID fromString: '{00000121-0000-0000-C000-000000000046}')!
IDropSource comment: '<IDropSource>is a wrapper class for the standard OLE Drag & Drop interface. It was originally generated from type information in the ''OCIDL Library'' type library. It defines the function table for that interface (we only implement this interface, we never call out through it since that is always handled by the system function DoDragDrop()).'!
!IDropSource categoriesForClass!COM-Interfaces!OLEIDL-Interfaces! !
!IDropSource methodsFor!

GiveFeedback: dwEffect
	"Private - Invoke the GiveFeedback() method of the COM object.

		HRESULT __stdcall GiveFeedback(
			[in]unsigned long dwEffect);"

	<virtual stdcall: hresult 5 dword>
	^self invalidCall!

QueryContinueDrag: fEscapePressed grfKeyState: grfKeyState
	"Private - Invoke the QueryContinueDrag() method of the COM object.

		HRESULT __stdcall QueryContinueDrag(
			[in]BOOL fEscapePressed,
			[in]unsigned long grfKeyState);"

	<virtual stdcall: hresult 4 bool dword>
	^self invalidCall! !
!IDropSource categoriesFor: #GiveFeedback:!**auto generated**!COM Interfaces-IDropSource!public! !
!IDropSource categoriesFor: #QueryContinueDrag:grfKeyState:!**auto generated**!COM Interfaces-IDropSource!public! !

IDropSource methodProtocol: #IDropSource attributes: #() selectors: #(#GiveFeedback: #QueryContinueDrag:grfKeyState:)!

!IDropSource class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'Win32.IDropSource'
		IDropSource defineTemplate"

	self
		defineFunction: #QueryContinueDrag:grfKeyState:
			argumentTypes: 'bool dword';
		defineFunction: #GiveFeedback:
			argumentTypes: 'dword'
! !
!IDropSource class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

