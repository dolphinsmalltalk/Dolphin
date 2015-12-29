"Filed out from Dolphin Smalltalk 2002 release 5.00"!

COMInterfaceImp subclass: #CB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CB guid: (GUID fromString: '{A58845F0-71F3-45D3-A1DF-DEB98E3BBDFD}')!
CB comment: ''!
!CB categoriesForClass!No category! !
!CB methodsFor!

Fy
	"Implement the IY::Fy() interface function."

	^Transcript show: 'Aggregated (inner) component Fy()'; cr!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver.
	N.B. By the rules of COM, this set must remain constant. All
	interfaces also support IUnknown."

	^Array with: IY! !
!CB categoriesFor: #Fy!COM Interfaces-IY!private! !
!CB categoriesFor: #supportedInterfaces!constants!private! !

!CB class methodsFor!

clsid
	"Answer the receiver's CLSID."

	^CLSID fromString: '{E0E7B195-F8BD-11D1-AA69-7CCD00000000}'! !
!CB class categoriesFor: #clsid!constants!private! !

