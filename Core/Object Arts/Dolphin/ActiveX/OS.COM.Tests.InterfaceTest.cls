"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #COMInterfaceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COMInterfaceTest guid: (GUID fromString: '{3cbd4156-925e-437d-b6b6-e862481e60c6}')!
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

