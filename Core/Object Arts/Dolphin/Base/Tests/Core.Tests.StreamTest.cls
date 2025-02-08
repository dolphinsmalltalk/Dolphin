"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.StreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.StreamTest guid: (Core.GUID fromString: '{f1611eb3-2c1c-491e-a814-c62dcdce0fff}')!

Core.Tests.StreamTest isNonInstantiable: true!

Core.Tests.StreamTest comment: ''!

!Core.Tests.StreamTest methodsFor!

expectedAnsiProtocolNames
	^#(#Object)!

isReadableStreamClass
	^self streamClass conformsToProtocol: #gettableStream!

isWriteableStreamClass
	^self streamClass conformsToProtocol: #puttableStream!

streamClass
	^self class streamClass!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass on: aString!

testAnsiProtocols
	self assert: (self expectedAnsiProtocolNames difference: self streamClass allProtocolNames) equals: #()!

testIsReadable
	self assert: (self streamOn: '') isReadable equals: self isReadableStreamClass!

testIsWriteable
	self assert: (self streamOn: '') isWriteable equals: self isWriteableStreamClass! !

!Core.Tests.StreamTest categoriesForMethods!
expectedAnsiProtocolNames!constants!private! !
isReadableStreamClass!public!testing! !
isWriteableStreamClass!public!testing! !
streamClass!helpers!private! !
streamOn:!helpers!private! !
testAnsiProtocols!public!unit tests! !
testIsReadable!public!unit tests! !
testIsWriteable!public!unit tests! !
!

!Core.Tests.StreamTest class methodsFor!

allTestSelectors
	| subjectClass |
	subjectClass := self streamClass.
	^super allTestSelectors select: 
			[:each |
			| annotations |
			annotations := (self lookupMethod: each) annotations.
			annotations isNil or: 
					[((annotations withSelector: #mustNotConform:)
						anySatisfy: [:eachAnnotation | subjectClass conformsToProtocol: eachAnnotation argument]) not
						and: 
							[(annotations withSelector: #mustConform:)
								allSatisfy: [:eachAnnotation | subjectClass conformsToProtocol: eachAnnotation argument]]]]!

streamClass
	^self subclassResponsibility! !

!Core.Tests.StreamTest class categoriesForMethods!
allTestSelectors!public! !
streamClass!helpers!private! !
!

