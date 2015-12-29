"Filed out from Dolphin Smalltalk 2002 release 5.00"!

COMInterfaceImp subclass: #CA
	instanceVariableNames: 'm_pUnknownInner m_pIY'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CA guid: (GUID fromString: '{F1496402-92F4-49F6-AF1F-B4955CA6A8FC}')!
CA comment: 'Implementation of aggregating (outer) component from Chapter 8, example 2, of Dale Rogerson''s "Inside COM"

First create a dynamic registration of Dolphin as the server for this class:
	COMClassFactory on: CA

Now instantiate an instance via CoCreateInstance:
	piX := IX onCLSID: CA clsid'!
!CA categoriesForClass!No category! !
!CA methodsFor!

aggregatee
	"Answer the IUnknown (which must be a non-delegating unknown implementation)
	of any aggregatee of the receiver, or nil if there is none."

	^m_pUnknownInner!

Fx
	"Implement the IX::Fx() interface function."

	^Transcript show: 'Aggregating (outer) component Fx()'; cr!

initialize
	"Initialize the component by creating the contained component.
	You will note that no HRESULT error handling code is required like that in 'Inside COM'
	which makes this much clearer and simpler. Also we deal exclusively in terms of classes
	rather than GUIDs."

	| pUnknownOuter |
	pUnknownOuter := self queryInterface: IUnknown.
	Notification signal: 'Create inner component'.
	m_pUnknownInner := IUnknown onCLSID: CB clsid outerIUnknown: pUnknownOuter.
	m_pIY := m_pUnknownInner queryInterface: IY.
	"Tricky: Remove ref. to self created by above QI (contained object adds ref. to self
	for the queried interface with AddRef(), which it delegates back to this object!!)."
	pUnknownOuter Release.
	"m_pIY does not need Releasing"
	m_pIY beUnfinalizable!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver.
	N.B. By the rules of COM, this set must remain constant. All
	interfaces also support IUnknown."

	^Array with: IX! !
!CA categoriesFor: #aggregatee!accessing!private! !
!CA categoriesFor: #Fx!COM Interfaces-IX!private! !
!CA categoriesFor: #initialize!initializing!private! !
!CA categoriesFor: #supportedInterfaces!constants!private! !

!CA class methodsFor!

clsid
	"Answer the receiver's CLSID."

	^CLSID fromString: '{E0E7B194-F8BD-11D1-AA69-7CCD00000000}'! !
!CA class categoriesFor: #clsid!constants!private! !

