"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IPrintDialogServices'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IPrintDialogServices guid: (OS.COM.IID fromString: '{509aaeda-5639-11d1-b6a1-0000f8757bf9}')!
OS.COM.IPrintDialogServices comment: '`IPrintDialogServices` is a wrapper class for the COM interface ''Win32.IPrintDialogServices'' generated from type information in the ''Win32 API'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Provides methods that enable an application using the PrintDlgEx function to retrieve information about the currently selected printer."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(509aaeda-5639-11d1-b6a1-0000f8757bf9), 
	helpstring("Provides methods that enable an application using the PrintDlgEx function to retrieve information about the currently selected printer.")
]
interface IPrintDialogServices : IUnknown
 {
	[id(0x60010000), helpstring("Fills a DEVMODE structure with information about the currently selected printer for use with PrintDlgEx.")]
	HRESULT __stdcall GetCurrentDevMode(
		DEVMODEW* pDevMode,
		unsigned int* pcbSize);
	[id(0x60010001), helpstring("Retrieves the name of the currently selected printer, for use with PrintDlgEx.")]
	HRESULT __stdcall GetCurrentPrinterName(
		LPWSTR pPrinterName,
		unsigned int* pcchSize);
	[id(0x60010002), helpstring("Retrieves the name of the current port for use with PrintDlgEx.")]
	HRESULT __stdcall GetCurrentPortName(
		LPWSTR pPortName,
		unsigned int* pcchSize);
};
```
'!
!OS.COM.IPrintDialogServices categoriesForClass!COM-Interfaces!Win32-Interfaces! !
!OS.COM.IPrintDialogServices methodsFor!

GetCurrentDevMode: pDevMode pcbSize: pcbSize
	"Invoke the GetCurrentDevMode() method of the COM object.
	Helpstring: Fills a DEVMODE structure with information about the currently selected printer for use with PrintDlgEx.

		HRESULT __stdcall GetCurrentDevMode(
			DEVMODEW* pDevMode,
			unsigned int* pcbSize);"

	<virtual stdcall: hresult 4 DEVMODEW* uint32*>
	^self invalidCall: _failureCode!

GetCurrentPortName: pPortName pcchSize: pcchSize
	"Invoke the GetCurrentPortName() method of the COM object.
	Helpstring: Retrieves the name of the current port for use with PrintDlgEx.

		HRESULT __stdcall GetCurrentPortName(
			LPWSTR pPortName,
			unsigned int* pcchSize);"

	<virtual stdcall: hresult 6 lpwstr uint32*>
	^self invalidCall: _failureCode!

GetCurrentPrinterName: pPrinterName pcchSize: pcchSize
	"Invoke the GetCurrentPrinterName() method of the COM object.
	Helpstring: Retrieves the name of the currently selected printer, for use with PrintDlgEx.

		HRESULT __stdcall GetCurrentPrinterName(
			LPWSTR pPrinterName,
			unsigned int* pcchSize);"

	<virtual stdcall: hresult 5 lpwstr uint32*>
	^self invalidCall: _failureCode! !
!OS.COM.IPrintDialogServices categoriesForMethods!
GetCurrentDevMode:pcbSize:!**auto generated**!COM Interfaces-IPrintDialogServices!public! !
GetCurrentPortName:pcchSize:!**auto generated**!COM Interfaces-IPrintDialogServices!public! !
GetCurrentPrinterName:pcchSize:!**auto generated**!COM Interfaces-IPrintDialogServices!public! !
!

!OS.COM.IPrintDialogServices class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'Win32.IPrintDialogServices'
		IPrintDialogServices defineTemplate"

	self
		defineFunction: #GetCurrentDevMode:pcbSize:
			argumentTypes: 'DEVMODEW* uint32*';
		defineFunction: #GetCurrentPrinterName:pcchSize:
			argumentTypes: 'lpwstr uint32*';
		defineFunction: #GetCurrentPortName:pcchSize:
			argumentTypes: 'lpwstr uint32*'
! !
!OS.COM.IPrintDialogServices class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

