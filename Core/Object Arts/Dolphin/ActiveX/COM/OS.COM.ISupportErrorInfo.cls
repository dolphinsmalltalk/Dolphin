"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.ISupportErrorInfo'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.ISupportErrorInfo guid: (OS.COM.IID fromString: '{df0b3d60-548f-101b-8e65-08002b2bd119}')!
OS.COM.ISupportErrorInfo comment: '`OS.COM.ISupportErrorInfo` is a wrapper class for the custom interface ''OAIDL.ISupportErrorInfo'' from type information in the ''Ole Automation Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.ISupportErrorInfo categoriesForClass!COM-Interfaces! !
!OS.COM.ISupportErrorInfo methodsFor!

InterfaceSupportsErrorInfo: riid
	"Invoke the InterfaceSupportsErrorInfo() method of the object wrapped by the receiver.
	
		HRESULT __stdcall InterfaceSupportsErrorInfo(
			[in] GUID* riid);

	"

	<virtual stdcall: hresult 4 guid*>
	^self invalidCall: _failureCode!

supportsErrorInfo: interface
	"Answer whether error information is supported for the specified interface
	or interface class."

	^(self InterfaceSupportsErrorInfo: interface iid) = S_OK! !
!OS.COM.ISupportErrorInfo categoriesFor: #InterfaceSupportsErrorInfo:!**auto generated**!COM Interfaces-OAIDL.ISupportErrorInfo!private! !
!OS.COM.ISupportErrorInfo categoriesFor: #supportsErrorInfo:!public!testing! !

OS.COM.ISupportErrorInfo methodProtocol: #ISupportErrorInfo attributes: #(#readOnly) selectors: #(#InterfaceSupportsErrorInfo:)!

!OS.COM.ISupportErrorInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OAIDL.ISupportErrorInfo'
		ISupportErrorInfo defineTemplate
	"

	self
		defineFunction: #InterfaceSupportsErrorInfo:
			argumentTypes: 'GUID*'
! !
!OS.COM.ISupportErrorInfo class categoriesFor: #defineFunctions!**auto generated**!public! !

