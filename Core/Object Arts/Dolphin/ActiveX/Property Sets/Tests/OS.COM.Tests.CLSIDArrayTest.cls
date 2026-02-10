"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.COM.Tests.CLSIDArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CLSIDArrayTest guid: (Core.GUID fromString: '{db6ea3d9-9895-4dc6-a4ed-b8a2216b8081}')!

OS.COM.Tests.CLSIDArrayTest comment: ''!

!OS.COM.Tests.CLSIDArrayTest class methodsFor!

arrayClass
	^CLSIDArray!

elementFromIndex: anInteger
	^##({
		CLSID null.
		CLSID fromString: '{1df7c823-b2d4-4b54-975a-f2ac5d7cf8b8}'.
		CLSID fromString: '{3f4daca4-160d-11d2-a8e9-00104b365c9f}'.
		CLSID fromString: '{a1d42f35-e6c0-11d2-833b-0020afab8efe}'.
		CLSID fromString: '{333c7bc4-460f-11d0-bc04-0080c7055a83}'.
		CLSID fromString: '{35053a22-8589-11d1-b16a-00c0f0283628}'
	}) at: anInteger! !

!OS.COM.Tests.CLSIDArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!private!unit tests! !
!

