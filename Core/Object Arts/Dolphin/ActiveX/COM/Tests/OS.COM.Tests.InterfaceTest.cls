"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.InterfaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.InterfaceTest guid: (Core.GUID fromString: '{3cbd4156-925e-437d-b6b6-e862481e60c6}')!

OS.COM.Tests.InterfaceTest comment: ''!

!OS.COM.Tests.InterfaceTest methodsFor!

testAllRegistered
	| missing different iids registered |
	missing := OrderedCollection new.
	different := OrderedCollection new.
	iids := Set new.
	IUnknown withAllSubclasses do: 
			[:each |
			| iid |
			iid := each iid.
			(Interface classForIID: each iid ifNone: [])
				ifNil: [missing add: each]
				ifNotNil: 
					[:found |
					iids add: iid.
					(each isNonInstantiable or: [found == each])
						ifFalse: 
							[| base |
							base := found superclass.
							(base isNonInstantiable and: [each superclass == base and: [base iid = iid]])
								ifFalse: [different add: each]]]].
	self assert: different asArray equals: #().
	self assert: (missing allSatisfy: [:each | each isNonInstantiable]).
	"Check that only IUnknown and subclasses are registered, and only registered undo one IID"
	registered := Interface.InterfaceClasses copy.
	registered removeAllKeys: iids.
	"The collection will not be empty if any interface class has duplicate registrations, although IDispatch can have multiple registrations for dispinterfaces"
	self assert: (registered associations reject: [:each | each value name == #IDispatch]) asArray
		equals: #()!

testDowncast
	| random random2 disp |
	random := OS.COM.Examples.IRandomStream new.
	disp := random queryInterface: IDispatch.
	"This is important for the test"
	self assert: disp typeInfo name equals: 'IRandomStream'.
	self assert: random isKindOf: OS.COM.Examples.IRandomStream.
	random2 := random downCast.
	self assert: random2 isKindOf: OS.COM.Examples.IRandomStream2.
	self assert: random2 multiplier equals: RandomLinearCongruential.AnsiCMultiplier.
	self assert: random2 modulus equals: RandomLinearCongruential.AnsiCModulus.
	self assert: random2 increment equals: RandomLinearCongruential.AnsiCIncrement.
	random2 := disp downCast.
	self assert: random2 isKindOf: OS.COM.Examples.IRandomStream2!

testDowncastNotImplemented
	| factory f1 f2 pointerMonikerClsid |
	factory := ClassFactory on: Examples.RandomStream.
	f1 := factory queryInterface: IClassFactory.
	self assert: f1 class latestDerivation identicalTo: IClassFactory2.
	f2 := f1 downCast.
	"Dolphin's ClassFactory doesn't actually implement IClassFactory2."
	self assert: f2 class identicalTo: IClassFactory.
	f2 free.
	f1 free.
	"Likewise, system pointer monikers don't implement IClassFactory2 either"
	pointerMonikerClsid := CLSID fromString: '{00000306-0000-0000-C000-000000000046}'.
	f1 := IClassFactory onCLSID: pointerMonikerClsid.
	f2 := f1 downCast.
	self assert: f2 class identicalTo: IClassFactory.
	f2 free.
	f1 free!

testDowncastNull
	| f1 f2 |
	f1 := IClassFactory newPointer.
	self assert: f1 class latestDerivation identicalTo: IClassFactory2.
	f2 := f1 downCast.
	self assertIsNil: f2!

testGetObject
	| factory font |
	self should: [IUnknown getObject: 'bad'] raise: HRESULTError.
	"clsid monikers are quite interesting, as they allow one to bind to the class. Here for the OLE Font object"
	factory := IClassFactory getObject: 'clsid:' , '{0be35203-8f91-11ce-9de3-00aa004bb851}'.
	font := factory createInstance: nil iid: (IID fromString: '{bef6e002-a874-101a-8bba-00aa00300cab}').
	font name!

testIsSameCOMObject
	"There was a historic bug in Dolphin's COM infrastructure that broke the COM object identity rule (i.e. that there must be only one unique IUnknown per object). Specifically if an out parameter could return an IUnknown, the actual interface returned might be a derived interface. If the object supports more than one interface, and an alternate interface not of the same derivation as the first is queried, then comparing the IUnknowns retrieved through the two paths would yield different actual interface instances, making them appear to relate to different objects.

	We can test this using the RandomStream example, which implements its own specific interface, and IDispatch. If we create the object through the class factory requesting an IUnknown, we would actually have got an IDispatch. Although technically IDispatch is an IUnknown in that all COM interfaces derived from IUnknown, it would not be the same IUnknown that we'd get by querying an IUnknown from the object's IRandomStream interface, breaking the identity comparison."

	| unk random stream |
	unk := IUnknown onCLSID: OS.COM.Examples.RandomStream clsid.
	random := unk queryInterface: OS.COM.Examples.IRandomStream.
	"Would fail in the presence of the bug"
	self assert: (unk isSameCOMObject: random).
	self assert: (random isSameCOMObject: unk).
	"That this would have failed was the reason behind the bug"
	self deny: (unk queryInterface: IDispatch) yourAddress equals: unk yourAddress.
	"More normal path that did work anyway because the QueryInterface implementation always returned the first interface for IUnknown"
	stream := OS.COM.Examples.RandomStream new.
	self assert: ((stream queryInterface: IDispatch)
				isSameCOMObject: (stream queryInterface: OS.COM.Examples.IRandomStream)).
	self deny: ((stream queryInterface: IDispatch) isSameCOMObject: unk)!

testLatestDerivation
	self should: [IUnknown latestDerivation] raise: Error matching: [:ex | ex description = 'IUnknown class should not implement #findMostDerived'].
	self assert: IErrorInfo latestDerivation identicalTo: IErrorInfo.
	self assert: IClassFactory latestDerivation identicalTo: IClassFactory2! !

!OS.COM.Tests.InterfaceTest categoriesForMethods!
testAllRegistered!public!unit tests! !
testDowncast!public!unit tests! !
testDowncastNotImplemented!public!unit tests! !
testDowncastNull!public!unit tests! !
testGetObject!public!unit tests! !
testIsSameCOMObject!public!unit tests! !
testLatestDerivation!public!unit tests! !
!

