"Filed out from Dolphin Smalltalk"!

SequencedReadableCollectionTest subclass: #SymbolANSITest
	instanceVariableNames: 'smalltalkSymbol'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!SymbolANSITest categoriesForMethods!
canonicalElement!constants!public! !
canonicalObject!constants!public! !
emptyCollection!constants!public! !
limitedElementTypes!constants!public! !
protocol!constants!public! !
returnTypeHasLimitedElementTypes!public!testing! !
setUp!public! !
testXasLowercase!public!unit tests! !
testXasString!public!unit tests! !
testXasSymbol!public!unit tests! !
testXasUppercase!public!unit tests! !
testXbetweenXandX!public!unit tests! !
testXcopy!public!unit tests! !
testXequalityOp!public!unit tests! !
testXgreaterThanOp!public!unit tests! !
testXgreaterThanOrEqualToOp!public!unit tests! !
testXhash!public!unit tests! !
testXidentityHash!public!unit tests! !
testXidentityOp!public!unit tests! !
testXisKindOfX!public!unit tests! !
testXisMemberOfX!public!unit tests! !
testXkeysAndValuesDoX!public!unit tests! !
testXlast!public!unit tests! !
testXlessThanOp!public!unit tests! !
testXlessThanOrEqualToOp!public!unit tests! !
testXmaxX!public!unit tests! !
testXminX!public!unit tests! !
testXnotEqualityOp!public!unit tests! !
testXnotIdentityOp!public!unit tests! !
testXsameAsX!public!unit tests! !
testXsubStringsX!public!unit tests! !
!

!SymbolANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: SequencedReadableCollectionHelper! !
!SymbolANSITest class categoriesForMethods!
helperClassesDo:!public! !
!

