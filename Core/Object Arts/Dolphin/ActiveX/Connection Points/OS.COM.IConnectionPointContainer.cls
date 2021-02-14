"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.IConnectionPointContainer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IConnectionPointContainer guid: (OS.COM.IID fromString: '{b196b284-bab4-101a-b69c-00aa00341d07}')!
OS.COM.IConnectionPointContainer comment: '<IConnectionPointContainer> is a wrapper class for the custom interface ''OBJIDL.IConnectionPointContainer'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.IConnectionPointContainer categoriesForClass!No category! !
!OS.COM.IConnectionPointContainer methodsFor!

connectionIIDs
	"Answer a collection of the IIDs of the outgoing interfaces which can be registered with
	each of the connection points in the receiver, i.e. these are not the IIDs of the connection
	points themselves, but of the interfaces which should be passed to 
	IConnectionPoint>>advise:, through which the client will receive notifications."

	^self connectionPoints collect: [:c | c connectionIID]!

connectionPoints
	"Answer an <OLEEnumerator> on the <IConnectionPoint>s hosted by  
	the receiver."

	^Enumerable onIEnum: self enumConnectionPoints!

enumConnectionPoints
	"Answer the <IEnumConnectionPoints> result of invoking the COM Object's EnumConnectionPoints() method."

	| answer |
	answer := IEnumConnectionPoints newPointer.
	self EnumConnectionPoints: answer.
	^answer asObject!

EnumConnectionPoints: ppenum
	"Private - Invoke the EnumConnectionPoints() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumConnectionPoints(
			[out] IEnumConnectionPoints** ppenum);
	"

	<virtual stdcall: hresult 4 IEnumConnectionPoints**>
	^self invalidCall: _failureCode!

findConnectionPoint: interfaceClass
	"Answer the connection point for the specified <COMInterface> subclass, interfaceClass."

	| answer |
	answer := IConnectionPoint newPointer.
	self FindConnectionPoint: interfaceClass iid ppCP: answer.
	^answer!

FindConnectionPoint: riid ppCP: ppCP
	"Private - Invoke the FindConnectionPoint() method of the COM object wrapped by the receiver.

		HRESULT __stdcall FindConnectionPoint(
			[in] GUID* riid,
			[out] IConnectionPoint** ppCP);
	"

	<virtual stdcall: hresult 5 guid* IConnectionPoint**>
	^self invalidCall: _failureCode! !
!OS.COM.IConnectionPointContainer categoriesFor: #connectionIIDs!enumerating!public! !
!OS.COM.IConnectionPointContainer categoriesFor: #connectionPoints!enumerating!public! !
!OS.COM.IConnectionPointContainer categoriesFor: #enumConnectionPoints!**auto generated**!methods!public! !
!OS.COM.IConnectionPointContainer categoriesFor: #EnumConnectionPoints:!**auto generated**!COM Interfaces-IConnectionPointContainer!private! !
!OS.COM.IConnectionPointContainer categoriesFor: #findConnectionPoint:!accessing!public! !
!OS.COM.IConnectionPointContainer categoriesFor: #FindConnectionPoint:ppCP:!**auto generated**!COM Interfaces-IConnectionPointContainer!private! !

!OS.COM.IConnectionPointContainer class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IConnectionPointContainer'
		IConnectionPointContainer defineTemplate
	"

	self
		defineFunction: #EnumConnectionPoints:
			argumentTypes: 'IEnumConnectionPoints**';
		defineFunction: #FindConnectionPoint:ppCP:
			argumentTypes: 'GUID* IConnectionPoint**'
! !
!OS.COM.IConnectionPointContainer class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

