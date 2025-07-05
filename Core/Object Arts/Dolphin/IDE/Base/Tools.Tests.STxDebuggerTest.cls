"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Tools.Tests.STxDebuggerTest'
	instanceVariableNames: ''
	classVariableNames: 'TestVar'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.STxDebuggerTest guid: (Core.GUID fromString: '{5927e3bd-eb27-4032-a460-08beb17878b3}')!

Tools.Tests.STxDebuggerTest isNonInstantiable: true!

Tools.Tests.STxDebuggerTest comment: ''!

!Tools.Tests.STxDebuggerTest methodsFor!

dump: anArray withOffsets: aBoolean
	^((self stxDebuggerClass on: anArray readStream)
		printOffsets: aBoolean;
		dump;
		traceStream) contents!

expectedDump3
	^self subclassResponsibility!

expectedDump4
	^self subclassResponsibility!

expectedDump5
	^self subclassResponsibility!

expectedDump6
	^self subclassResponsibility!

minimumFilerVersion
	^self subclassResponsibility!

objectsToSerializeVersion0
	| stringWithNull |
	stringWithNull := #($a $\0 $b) asString.
	^{
		nil.
		true.
		false.
		#testVersion0.
		#'†Symbol'.
		stringWithNull.
		stringWithNull asUtf16String.
		$a.
		Character value: 128.
		Character value: 163.
		Character value: 255.
		$€.
		0.
		SmallInteger minimum.
		2 ** 64.
		1.25.
		Float infinity.
		Float nan.
		1.25s.
		2 / 3 asScaledDecimal: 2.
		Object.
		Object class.
		Processor.
		Transcript.
		Smalltalk.
		#[].
		#[255].
		#[1 2 3 4 5].
		{ stringWithNull. #testVersion0. $d } asOrderedCollection.
		#('a' 'B' 'b' 'B')
			asSortedCollectionUsing: (MergesortAlgorithm newSortBlock: SortedCollection defaultSortBlock).
		LookupTable with: 'origin' -> (10 @ 20) with: 2 -> (100 @ 200)
	}!

objectsToSerializeVersion1
	^self objectsToSerializeVersion0!

objectsToSerializeVersion2
	^self objectsToSerializeVersion1!

objectsToSerializeVersion3
	^self objectsToSerializeVersion2!

objectsToSerializeVersion4
	"Version 4 has UTF-encoded strings"

	| objects extraObjects |
	objects := self objectsToSerializeVersion3.
	extraObjects := { (objects at: 6) asAnsiString. '文字化け'. Character dolphin }.
	^objects , extraObjects!

objectsToSerializeVersion5
	| objects extraObjects |
	objects := self objectsToSerializeVersion4.
	extraObjects := {
				(BindingReference path: #('Core' 'Object'))
					pathString;
					value;
					yourself
			}.
	^objects , extraObjects!

objectsToSerializeVersion6
	^self objectsToSerializeVersion5!

outfilerClass
	^self subclassResponsibility!

saveStaticVariableDumpFormat
	^self subclassResponsibility!

serialize: anObject
	^self serialize: anObject version: self outfilerClass version!

serialize: anObject version: anInteger
	| filer |
	filer := self outfilerClass version: anInteger.
	filer nextPut: anObject.
	^filer stream contents!

stxDebuggerClass
	^self subclassResponsibility!

testNonExistentClass
	self subclassResponsibility!

testSaveStaticVariableReference
	"Requires BindingReferences, not available before v5"

	5 to: self outfilerClass version
		do: 
			[:ver |
			| serialised filer |
			filer := self outfilerClass version: ver.
			filer saveStatic: #{TestVar}.
			serialised := filer stream contents.
			TestVar := 'Foo'.
			self assert: (self dump: serialised withOffsets: false)
				equals: self saveStaticVariableDumpFormat << ver]!

testVersion3
	| dump dessicated |
	dessicated := self serialize: self objectsToSerializeVersion0 version: 3.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump equals: self expectedDump3!

testVersion4
	"Version 4 has UTF-encoded strings"

	| dump dessicated |
	dessicated := self serialize: self objectsToSerializeVersion4 version: 4.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump equals: self expectedDump4!

testVersion5
	"Version 5 has qualified class names, binding references, and writes all strings as UTF-8"

	| dump dessicated objects |
	objects := self objectsToSerializeVersion5.
	dessicated := self serialize: objects version: 5.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump equals: self expectedDump5!

testVersion6
	"Version 6 has proxyless collections"

	| dump dessicated |
	dessicated := self serialize: self objectsToSerializeVersion6 version: 6.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump equals: self expectedDump6! !

!Tools.Tests.STxDebuggerTest categoriesForMethods!
dump:withOffsets:!helpers!private! !
expectedDump3!constants!private! !
expectedDump4!constants!private! !
expectedDump5!constants!private! !
expectedDump6!constants!private! !
minimumFilerVersion!constants!private! !
objectsToSerializeVersion0!constants!private! !
objectsToSerializeVersion1!constants!private! !
objectsToSerializeVersion2!constants!private! !
objectsToSerializeVersion3!constants!private! !
objectsToSerializeVersion4!constants!private! !
objectsToSerializeVersion5!constants!private! !
objectsToSerializeVersion6!constants!private! !
outfilerClass!constants!public! !
saveStaticVariableDumpFormat!constants!private! !
serialize:!helpers!private! !
serialize:version:!helpers!private! !
stxDebuggerClass!constants!private! !
testNonExistentClass!public!unit tests! !
testSaveStaticVariableReference!public!unit tests! !
testVersion3!public!unit tests! !
testVersion4!public!unit tests! !
testVersion5!public!unit tests! !
testVersion6!public!unit tests! !
!

