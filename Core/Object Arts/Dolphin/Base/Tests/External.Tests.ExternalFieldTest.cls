﻿"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'External.Tests.ExternalFieldTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.ExternalFieldTest guid: (Core.GUID fromString: '{d0a2c7ae-43c2-4b76-ad72-7d2df32edbc6}')!

External.Tests.ExternalFieldTest isNonInstantiable: true!

External.Tests.ExternalFieldTest comment: ''!

!External.Tests.ExternalFieldTest methodsFor!

makeStructUncompiled: structClass
	structClass
		methodDictionary: nil;
		flushMethodCache;
		hasUncompiledFields: true.
	structClass template do: [:each | each beUncompiled]! !

!External.Tests.ExternalFieldTest categoriesForMethods!
makeStructUncompiled:!helpers!private! !
!

