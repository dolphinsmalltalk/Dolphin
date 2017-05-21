"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IDropTarget
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IDropTarget guid: (IID fromString: '{00000122-0000-0000-C000-000000000046}')!
IDropTarget comment: '<IDropTarget> is a wrapper class for the standard OLE Drag & Drop interface IDropTarget. It was originally generated from type information in the ''OCIDL Library'' type library. It defines the function table for that interface (we only implement this interface, we never call out through it since that is always handled by the system function DoDragDrop()).'!
!IDropTarget categoriesForClass!COM-Interfaces! !
!IDropTarget methodsFor!

DragEnter: pDataObj grfKeyState: grfKeyState pt: pt pdwEffect: pdwEffect
	"Invoke the DragEnter() method of the COM object.

		HRESULT __stdcall DragEnter(
			[in]IDataObject* pDataObj,
			[in]unsigned long grfKeyState,
			[in]POINTL pt,
			[in, out]unsigned long* pdwEffect);"

	<virtual stdcall: hresult 4 IDataObject* dword POINTL dword*>
	^self invalidCall!

DragLeave
	"Invoke the DragLeave() method of the COM object.

		HRESULT __stdcall DragLeave();"

	<virtual stdcall: hresult 6>
	^self invalidCall!

DragOver: grfKeyState pt: pt pdwEffect: pdwEffect
	"Invoke the DragOver() method of the COM object.

		HRESULT __stdcall DragOver(
			[in]unsigned long grfKeyState,
			[in]POINTL pt,
			[in, out]unsigned long* pdwEffect);"

	<virtual stdcall: hresult 5 dword POINTL dword*>
	^self invalidCall!

Drop: pDataObj grfKeyState: grfKeyState pt: pt pdwEffect: pdwEffect
	"Invoke the Drop() method of the COM object.

		HRESULT __stdcall Drop(
			[in]IDataObject* pDataObj,
			[in]unsigned long grfKeyState,
			[in]POINTL pt,
			[in, out]unsigned long* pdwEffect);"

	<virtual stdcall: hresult 7 IDataObject* dword POINTL dword*>
	^self invalidCall! !
!IDropTarget categoriesFor: #DragEnter:grfKeyState:pt:pdwEffect:!**auto generated**!COM Interfaces-IDropTarget!public! !
!IDropTarget categoriesFor: #DragLeave!**auto generated**!COM Interfaces-IDropTarget!public! !
!IDropTarget categoriesFor: #DragOver:pt:pdwEffect:!**auto generated**!COM Interfaces-IDropTarget!public! !
!IDropTarget categoriesFor: #Drop:grfKeyState:pt:pdwEffect:!**auto generated**!COM Interfaces-IDropTarget!public! !

IDropTarget methodProtocol: #IDropTarget attributes: #() selectors: #(#DragEnter:grfKeyState:pt:pdwEffect: #DragLeave #DragOver:pt:pdwEffect: #Drop:grfKeyState:pt:pdwEffect:)!

!IDropTarget class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'Win32.IDropTarget'
		IDropTarget defineTemplate"

	self
		defineFunction: #DragEnter:grfKeyState:pt:pdwEffect:
			argumentTypes: 'IDataObject* dword POINTL dword*';
		defineFunction: #DragOver:pt:pdwEffect:
			argumentTypes: 'dword POINTL dword*';
		defineFunction: #DragLeave;
		defineFunction: #Drop:grfKeyState:pt:pdwEffect:
			argumentTypes: 'IDataObject* dword POINTL dword*'
! !
!IDropTarget class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

