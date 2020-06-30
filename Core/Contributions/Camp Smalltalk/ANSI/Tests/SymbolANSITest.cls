"Filed out from Dolphin Smalltalk 7"!

SequencedReadableCollectionTest subclass: #SymbolANSITest
	instanceVariableNames: 'smalltalkSymbol'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SymbolANSITest guid: (GUID fromString: '{df4dc58e-5825-423b-a9bd-af325267aa8f}')!
SymbolANSITest comment: ''!
!SymbolANSITest categoriesForClass!Unclassified! !
!SymbolANSITest methodsFor!

canonicalElement

	^self canonicalObject at: 2!

canonicalObject
	^#abcd!

emptyCollection

	^#''!

limitedElementTypes

	^1!

protocol
	^#symbol!

returnTypeHasLimitedElementTypes

	^true!

setUp
	super setUp.
	smalltalkSymbol := #'Smalltalk'.!

testXasLowercase
	" <readableString>#asLowercase "
	#'Collection'.!

testXasString
	" <symbol>#asString "
	#'Collection'.!

testXasSymbol
	" <symbol>#asSymbol (Return Values: <RECEIVER>) "
	#'Collection'.!

testXasUppercase
	" <readableString>#asUppercase "
	#'Collection'.!

testXbetweenXandX
	" <magnitude>#between:and: "
	#'Collection'.!

testXcopy
	" <Object>#copy (Return Values: <RECEIVER>) "
	#'Collection'.

#todo. "??? add change-side-effect test ???"
	
"
If the receiver is an identity object, return the receiver.
"
	self value: [smalltalkSymbol copy]
		should: [:r | (r = smalltalkSymbol) & (r == smalltalkSymbol)]
		conformTo: #'Object' selector: #'copy' opRECEIVER: smalltalkSymbol.!

testXequalityOp
	" <sequencedReadableCollection>#= "
	#'Collection'.
"	The value of receiver = comparand is true if and only if the value of comparand = receiver would also be true. If the value of receiver = comparand is true then the receiver and comparand must have equivalent hash values.  Or more formally:

	receiver = comparand	=>
	receiver hash = comparand hash
Refinement: <sequenceReadableCollection>
Unless specifically refined, the receiver and operand are equivalent if all of the following are true:
1. The receiver and operand are instances of the same class.
2. They answer the same value for the #size message.
3. For all indices of the receiver, the element in the receiver at a given index is equivalent to the element in operand at the same index.
Element lookup is defined by the #at: message for the receiver and operand.
"
#todo. "??? add Refinement: test ???"
	self value: [smalltalkSymbol = smalltalkSymbol]
		should: [:r | r and: [smalltalkSymbol hash = smalltalkSymbol hash] ]
		conformTo: #'sequencedReadableCollection' selector: #'='.!

testXgreaterThanOp
	" <readableString>#> "
	#'Collection'.!

testXgreaterThanOrEqualToOp
	" <readableString>#>= "
	#'Collection'.!

testXhash
	" <Object>#hash "
	#'Collection'.
"	Any two objects that are considered equivalent using the #= message must have the same hash value.  More formally:

	receiver = comparand	=>
	receiver hash = comparand hash
"
		#'Fundamental'.
	"The original interpretation here was that Strings and Symbols were never equal, but the standard is ambiguous on this. 
	There is some further discussion in https://github.com/dolphinsmalltalk/Dolphin/issues/518, the conclusion of which is that Strings and Symbols should be equal."
	"self shouldnt: [smalltalkSymbol = 'Smalltalk'].
	self shouldnt: [smalltalkSymbol hash = 'Smalltalk' hash]."
	self assert: smalltalkSymbol equals: 'Smalltalk'.
	self assert: smalltalkSymbol hash equals: 'Smalltalk' hash.

	self value: [smalltalkSymbol hash]
		should: [:r | r = smalltalkSymbol hash]
		conformTo: #'Object' selector: #'hash'.
	self value: [smalltalkSymbol hash]
		shouldnt: [:r | r = #'smalltalk' hash]
		conformTo: #'Object' selector: #'hash'.!

testXidentityHash
	" <Object>#identityHash "
	#'Collection'.
	self value: [smalltalkSymbol identityHash]
		should: [:r | r = smalltalkSymbol identityHash]
		conformTo: #'Object' selector: #'identityHash'.

	self value: [smalltalkSymbol identityHash]
		shouldnt: [:r | r = #'smalltalk' identityHash]
		conformTo: #'Object' selector: #'identityHash'.!

testXidentityOp
	" <Object>#== "
	#'Collection'.
"	The value of receiver == comparand is true if and only if the value of comparand == receiver would also be true. If the value of receiver == comparand is true then the receiver and comparand must have equivalent identity hash values.  Or more formally:

	receiver == comparand =>
	receiver identityHash = comparand identityHash
"
	self value: [smalltalkSymbol == smalltalkSymbol]
		should: [:r | r] conformTo: #'Object' selector: #'=='.

	self value: [smalltalkSymbol == #'smalltalk']
		shouldnt: [:r | r] conformTo: #'Object' selector: #'=='.!

testXisKindOfX
	" <Object>#isKindOf: "
	#'Collection'.
"	The return value is unspecified if the receiver is a class object or candidateClass is not a class object.
"
#todo. "Fix find a test for unspecified rule above ???"
	self value: [smalltalkSymbol isKindOf: Symbol]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	"Metaclass tests:"
	self value: [smalltalkSymbol class isKindOf: (Symbol class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	"Inherit tests:"
	self value: [smalltalkSymbol class isKindOf: (Object class)]
		should: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.

	self value: [smalltalkSymbol isKindOf: Number]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'isKindOf:'.!

testXisMemberOfX
	" <Object>#isMemberOf: "
	#'Collection'.
"	The return value is unspecified if the receiver is a class object or candidateClass is not a class object.
"
#todo. "Fix find a test for unspecified rule above ???"
	self value: [smalltalkSymbol isMemberOf: Symbol]
		should: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.

	"Metaclass tests:"
	self value: [smalltalkSymbol class isMemberOf: (Symbol class)]
		should: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.

	"Fail inherit tests:"
	self value: [smalltalkSymbol class isMemberOf: (Object class)]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.

	self value: [smalltalkSymbol isMemberOf: Number]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'isMemberOf:'.!

testXkeysAndValuesDoX
	" <sequencedReadableCollection>#keysAndValuesDo: "
	#'Collection'.!

testXlast
	" <sequencedReadableCollection>#last "
	#'Collection'.!

testXlessThanOp
	" <readableString>#< "
	#'Collection'.!

testXlessThanOrEqualToOp
	" <readableString>#<= "
	#'Collection'.!

testXmaxX
	" <magnitude>#max: "
	#'Collection'.!

testXminX
	" <magnitude>#min: "
	#'Collection'.!

testXnotEqualityOp
	" <Object>#~= "
	#'Collection'.
"	The value of receiver ~= comparand is true if and only if the value of
comparand ~= receiver would also be true.
"
	self value: [smalltalkSymbol ~= #'smalltalk']
		should: [:r | r] conformTo: #'Object' selector: #'~='.

	self value: [smalltalkSymbol ~= smalltalkSymbol]
		shouldnt: [:r | r] conformTo: #'Object' selector: #'~='.!

testXnotIdentityOp
	" <Object>#~~ "
	#'Collection'.
"	The value of receiver ~~ comparand is true if and only if the value of comparand ~~ receiver would also be true.
"
	self value: [smalltalkSymbol ~~ #'smalltalk'] should: [:r | r]
		conformTo: #'Object' selector: #'~~'.

	self value: [smalltalkSymbol ~~ smalltalkSymbol] shouldnt: [:r | r]
		conformTo: #'Object' selector: #'~~'.!

testXsameAsX
	" <readableString>#sameAs: "
	#'Collection'.!

testXsubStringsX
	" <readableString>#subStrings: "
	#'Collection'.! !
!SymbolANSITest categoriesFor: #canonicalElement!constants!public! !
!SymbolANSITest categoriesFor: #canonicalObject!constants!public! !
!SymbolANSITest categoriesFor: #emptyCollection!constants!public! !
!SymbolANSITest categoriesFor: #limitedElementTypes!constants!public! !
!SymbolANSITest categoriesFor: #protocol!constants!public! !
!SymbolANSITest categoriesFor: #returnTypeHasLimitedElementTypes!public!testing! !
!SymbolANSITest categoriesFor: #setUp!public! !
!SymbolANSITest categoriesFor: #testXasLowercase!public!unit tests! !
!SymbolANSITest categoriesFor: #testXasString!public!unit tests! !
!SymbolANSITest categoriesFor: #testXasSymbol!public!unit tests! !
!SymbolANSITest categoriesFor: #testXasUppercase!public!unit tests! !
!SymbolANSITest categoriesFor: #testXbetweenXandX!public!unit tests! !
!SymbolANSITest categoriesFor: #testXcopy!public!unit tests! !
!SymbolANSITest categoriesFor: #testXequalityOp!public!unit tests! !
!SymbolANSITest categoriesFor: #testXgreaterThanOp!public!unit tests! !
!SymbolANSITest categoriesFor: #testXgreaterThanOrEqualToOp!public!unit tests! !
!SymbolANSITest categoriesFor: #testXhash!public!unit tests! !
!SymbolANSITest categoriesFor: #testXidentityHash!public!unit tests! !
!SymbolANSITest categoriesFor: #testXidentityOp!public!unit tests! !
!SymbolANSITest categoriesFor: #testXisKindOfX!public!unit tests! !
!SymbolANSITest categoriesFor: #testXisMemberOfX!public!unit tests! !
!SymbolANSITest categoriesFor: #testXkeysAndValuesDoX!public!unit tests! !
!SymbolANSITest categoriesFor: #testXlast!public!unit tests! !
!SymbolANSITest categoriesFor: #testXlessThanOp!public!unit tests! !
!SymbolANSITest categoriesFor: #testXlessThanOrEqualToOp!public!unit tests! !
!SymbolANSITest categoriesFor: #testXmaxX!public!unit tests! !
!SymbolANSITest categoriesFor: #testXminX!public!unit tests! !
!SymbolANSITest categoriesFor: #testXnotEqualityOp!public!unit tests! !
!SymbolANSITest categoriesFor: #testXnotIdentityOp!public!unit tests! !
!SymbolANSITest categoriesFor: #testXsameAsX!public!unit tests! !
!SymbolANSITest categoriesFor: #testXsubStringsX!public!unit tests! !

!SymbolANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: SequencedReadableCollectionHelper! !
!SymbolANSITest class categoriesFor: #helperClassesDo:!public! !

