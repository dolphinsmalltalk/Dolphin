"Filed out from Dolphin Smalltalk"!

External.Tests.IntegerBytesTest
	subclass: #'External.Tests.UInt64BytesTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.UInt64BytesTest guid: (Core.GUID fromString: '{2981d5b2-1cc3-4cf5-94e9-2a0592a17688}')!

External.Tests.UInt64BytesTest comment: ''!

!External.Tests.UInt64BytesTest methodsFor!

canonicalValue
	^16rFADEDEADBEEFFEED!

stlVersion4
	"Didn't actually exist in D7"

	^{ #'!!STL'. 4. 720950. UInt64Bytes. 8. 237. 254. 239. 190. 173. 222. 222. 250 }!

stlVersion6
	^{ #'!!STL'. 6. 54. External.UInt64Bytes. 8. #[237 254 239 190 173 222 222 250] }!

subjectClass
	^UInt64Bytes! !

!External.Tests.UInt64BytesTest categoriesForMethods!
canonicalValue!constants!private! !
stlVersion4!constants!private! !
stlVersion6!constants!private! !
subjectClass!constants!private! !
!

