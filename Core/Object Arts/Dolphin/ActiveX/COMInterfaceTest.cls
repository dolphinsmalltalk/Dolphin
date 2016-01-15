"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #COMInterfaceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COMInterfaceTest guid: (GUID fromString: '{3CBD4156-925E-437D-B6B6-E862481E60C6}')!
COMInterfaceTest comment: ''!
!COMInterfaceTest categoriesForClass!Unclassified! !
!COMInterfaceTest methodsFor!

testGetObject
	| factory font |
	self should: [IUnknown getObject: 'bad'] raise: HRESULTError.
	"clsid monikers are quite interesting, as they allow one to bind to the class"
	factory := IClassFactory getObject: 'clsid:' , IFont clsid asString.
	font := factory createInstance: nil iid: IFont iid.! !
!COMInterfaceTest categoriesFor: #testGetObject!public!unit tests! !

