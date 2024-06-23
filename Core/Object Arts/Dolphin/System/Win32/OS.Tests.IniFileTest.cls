"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.IniFileTest'
	instanceVariableNames: 'iniFile'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.IniFileTest guid: (Core.GUID fromString: '{5fc93855-8e32-4463-9906-50705ecb9acc}')!

OS.Tests.IniFileTest comment: ''!

!OS.Tests.IniFileTest methodsFor!

fileResource
	^IniFileTestResource current!

makeEmptyIniFile
	^IniFile open: self fileResource emptyFile!

makeIniFile
	^IniFile open: self fileResource iniFile1!

makeModifiableIniFile
	iniFile := self fileResource fileLocator localFileSpecFor: self selector , '.ini'.
	File copy: self fileResource iniFile1 to: iniFile.
	^IniFile open: iniFile!

stlVersion4
	^{ #'!!STL'. 4. 655414. Smalltalk.DWORDBytes. 4. 239. 190. 173. 222 }!

tearDown
	(iniFile notNil and: [File exists: iniFile]) ifTrue: [File delete: iniFile].
	^super tearDown!

testAdd
	| subject section newValues assoc |
	subject := self makeModifiableIniFile.
	"Sanity check"
	newValues := LookupTable new
				at: 'Key1' put: 'Value1';
				at: '' put: 'Value2';
				at: 'Key3' put: '';
				yourself.
	assoc := 'Section1' -> newValues.
	self assert: (subject add: assoc) equals: assoc.
	section := subject at: 'Section1'.
	self assert: (section keys noDifference: newValues keys).
	self assert: (section values noDifference: newValues values).
	assoc := 'Key1' -> 'Modified1'.
	self assert: (section add: assoc) identicalTo: assoc.
	self assert: (section associationAt: assoc key) equals: assoc.
	section add: '' -> 'Modified2'.
	section add: 'Key4' -> 'Added'.
	self assert: (section keys noDifference: (newValues keys
						add: 'Key4';
						yourself)).
	self assert: (section values noDifference: #('Modified1' 'Modified2' '' 'Added'))!

testAsByteArray
	| subject |
	subject := self makeIniFile.
	self should: [subject asByteArray] raise: Error!

testAt
	| subject anonymousSection values |
	subject := self makeIniFile.
	self assert: subject keys equals: #('Section1' 'S2' '3' '').
	values := subject values.
	self assert: (subject at: 'section1') equals: values first.
	self should: [subject at: 'section'] raise: NotFoundError.
	anonymousSection := subject at: ''.
	self assert: anonymousSection equals: values last.
	self assert: (anonymousSection at: '') equals: 'NoSectionNoKeyValue'.
	subject := self makeEmptyIniFile.
	self should: [subject at: ''] raise: NotFoundError!

testAtIfAbsentPut
	| subject section newValues |
	subject := self makeModifiableIniFile.
	"Sanity check"
	newValues := LookupTable new
				at: 'Key1' put: 'Value1';
				at: '' put: 'Value2';
				at: 'Key3' put: '';
				yourself.
	section := subject at: 'Section1'.
	self assert: (subject at: 'Section1' ifAbsentPut: [newValues]) equals: section.
	self assert: (subject at: 'S5' ifAbsentPut: [newValues]) identicalTo: newValues.
	self assert: (subject at: 'S5') associations equals: newValues associations asArray!

testAtPut
	| subject section newValues |
	subject := self makeModifiableIniFile.
	"We can write a whole section at once"
	self deny: (subject includesKey: 'Section5').
	newValues := LookupTable new
				at: 'Key1' put: 'Value1';
				at: '' put: 'Value2';
				at: 'Key3' put: '';
				yourself.
	self assert: (subject at: 'Section5' put: newValues) equals: newValues.
	section := subject at: 'Section5'.
	self assert: (section keys noDifference: newValues keys).
	self assert: (section values noDifference: newValues values).
	section at: 'Key1' put: 'Modified1'.
	section at: '' put: 'Modified2'.
	section at: 'Key4' put: 'Added'.
	self assert: (section keys noDifference: (newValues keys
						add: 'Key4';
						yourself)).
	self assert: (section values noDifference: #('Modified1' 'Modified2' '' 'Added')).
	"If we write a whole section that exists, only the replaced/added values should remain."
	newValues at: 'Key5' put: 'Added5'.
	newValues removeKey: 'Key1'.
	self assert: (subject at: 'Section5') keys asSortedCollection asArray
		equals: #('' 'Key1' 'Key3' 'Key4').
	subject at: 'Section1' put: newValues.
	self assert: (subject at: 'Section1' put: newValues) equals: newValues.
	self assert: (subject at: 'Section1') equals: newValues!

testCollect
	| subject section collected |
	subject := self makeIniFile.
	collected := subject collect: [:each | each keys].
	self assert: collected isKindOf: LookupTable.
	self assert: (subject keys noDifference: collected keys).
	self assert: ((subject values collect: [:each | each keys]) noDifference: collected values).
	section := subject values first.
	collected := section collect: [:each | each].
	self assert: (section keys noDifference: collected keys).
	self assert: (section values noDifference: collected values)!

testIncludesKey
	| subject section1 anonymousSection |
	subject := self makeIniFile.
	#('Section1' 'S2' '3' '') do: [:each | self assert: (subject includesKey: each)].
	self deny: (subject includesKey: 'Section4').
	self deny: (subject includesKey: nil).
	section1 := subject at: 'Section1'.
	self assert: (section1 includesKey: 'S1Key1').
	self deny: (section1 includesKey: '').
	self deny: (section1 includesKey: 'S2Key1').
	self should: [section1 includesKey: nil] raise: Error.
	anonymousSection := subject at: ''.
	self assert: (anonymousSection includesKey: '')!

testIsEmpty
	| subject section |
	subject := self makeIniFile.
	self deny: subject isEmpty.
	section := subject values first.
	self deny: section isEmpty.
	section := subject values second.
	self assert: section isEmpty.
	subject := self makeEmptyIniFile.
	self assert: subject isEmpty!

testKeys
	| subject anonymousSection |
	subject := self makeIniFile.
	self assert: subject keys equals: #('Section1' 'S2' '3' '').
	anonymousSection := subject at: ''.
	self assert: anonymousSection keys equals: #('').
	subject := self makeEmptyIniFile.
	self assert: subject keys isEmpty!

testLookup
	| subject absent values |
	subject := self makeModifiableIniFile.
	values := subject values.
	self assert: (subject lookup: 'section1') equals: values first.
	self assert: (subject lookup: '') equals: values last.
	absent := subject lookup: 'section'.
	self assert: subject keys equals: #('Section1' 'S2' '3' '').
	absent at: 'x' put: 1.
	self assert: subject keys equals: #('Section1' 'S2' '3' '' 'section').
	"Reopen"
	subject := IniFile open: subject filename.
	absent := subject lookup: 'section'.
	self assert: absent associations equals: {'x' -> '1'}!

testRemove
	| subject |
	subject := self makeModifiableIniFile.
	self should: [subject remove: 'Blah'] raise: Error matching: [:ex | ex description = 'IniFile should not implement #remove:ifAbsent:']!

testRemoveAllKeys
	| subject sections absent |
	subject := self makeModifiableIniFile.
	"Sanity check"
	sections := subject values.
	self should: [sections first removeAllKeys: #('x')] raise: NotFoundError.
	sections first removeAllKeys: #('S1key2' 's1Key1').
	self assert: sections first keys equals: #('S1Key3').
	sections first removeAllKeys: #('s1Key3').
	self assert: (subject at: 'section1') keys equals: #().
	self assert: subject keys equals: #('Section1' 'S2' '3' '').
	self should: [subject removeAllKeys: #('x')] raise: NotFoundError.
	subject removeAllKeys: #('Section1' '3').
	self assert: subject keys equals: #('S2' '').
	self assert: subject values equals: {sections second. sections fourth}.
	absent := OrderedCollection new.
	subject removeAllKeys: #('Section1' 'S2' '3' '') ifAbsent: [:k | absent add: k].
	self assert: absent asArray equals: #('Section1' '3').
	self assert: subject isEmpty!

testRemoveKey
	| subject section removed |
	subject := self makeModifiableIniFile.
	"Sanity check"
	self assert: subject keys equals: #('Section1' 'S2' '3' '').
	section := subject values first.
	removed := subject removeKey: 'Section1'.
	self assert: removed equals: section.
	self assert: subject keys equals: #('S2' '3' '').
	section := subject values last.
	removed := subject removeKey: ''.
	self assert: removed equals: section.
	self assert: subject keys equals: #('S2' '3').
	subject removeKey: 'S2'.
	subject removeKey: '3'.
	self assert: subject keys equals: #()!

testValues
	| subject sections keys |
	subject := self makeIniFile.
	sections := subject values.
	keys := sections collect: [:each | each name].
	self assert: keys equals: subject keys.
	self assert: keys equals: #('Section1' 'S2' '3' '').
	self assert: sections first values equals: #('S1Value1' 'S1Value2' '').
	self assert: sections second values isEmpty.
	self assert: sections third values equals: #('123').
	self assert: sections fourth values equals: #('NoSectionNoKeyValue').
	subject := self makeEmptyIniFile.
	self assert: subject values isEmpty! !

!OS.Tests.IniFileTest categoriesForMethods!
fileResource!accessing!private! !
makeEmptyIniFile!helpers!private! !
makeIniFile!helpers!private! !
makeModifiableIniFile!helpers!private! !
stlVersion4!constants!private! !
tearDown!private!running! !
testAdd!public!unit tests! !
testAsByteArray!public!unit tests! !
testAt!public!unit tests! !
testAtIfAbsentPut!public!unit tests! !
testAtPut!public!unit tests! !
testCollect!public!unit tests! !
testIncludesKey!public!unit tests! !
testIsEmpty!public!unit tests! !
testKeys!public!unit tests! !
testLookup!public!unit tests! !
testRemove!public! !
testRemoveAllKeys!public!unit tests! !
testRemoveKey!public!unit tests! !
testValues!public!unit tests! !
!

!OS.Tests.IniFileTest class methodsFor!

resources
	^{IniFileTestResource}! !

!OS.Tests.IniFileTest class categoriesForMethods!
resources!accessing!public! !
!

