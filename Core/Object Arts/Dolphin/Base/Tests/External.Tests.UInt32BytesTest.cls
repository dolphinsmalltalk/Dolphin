"Filed out from Dolphin Smalltalk"!

External.Tests.IntegerBytesTest
	subclass: #'External.Tests.UInt32BytesTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.UInt32BytesTest guid: (Core.GUID fromString: '{df15ebf5-f6c2-4cd6-8d5a-59836c85f726}')!
External.Tests.UInt32BytesTest comment: ''!
!External.Tests.UInt32BytesTest methodsFor!

canonicalValue
	^16rDEADBEEF!

stlVersion4
	^{ #'!!STL'. 4. 655414. Smalltalk.DWORDBytes. 4. 239. 190. 173. 222 }!

stlVersion6
	^{ #'!!STL'. 6. 54. External.UInt32Bytes. 4. #[239 190 173 222] }!

subjectClass
	^UInt32Bytes! !
!External.Tests.UInt32BytesTest categoriesForMethods!
canonicalValue!constants!private! !
stlVersion4!constants!private! !
stlVersion6!constants!private! !
subjectClass!constants!private! !
!

