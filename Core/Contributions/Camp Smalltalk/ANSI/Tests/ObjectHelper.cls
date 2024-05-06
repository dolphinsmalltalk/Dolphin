"Filed out from Dolphin Smalltalk"!

TestCaseHelper subclass: #ObjectHelper
	instanceVariableNames: 'object'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ObjectHelper guid: (GUID fromString: '{6b634eea-466c-4a57-9256-1e3d3c87879a}')!

ObjectHelper comment: ''!

!ObjectHelper categoriesForClass!Unclassified! !

!ObjectHelper methodsFor!

canonicalObject
	^object!

object: anObject
	object := anObject!

protocol
	^testCase protocol!

testXclass
	" <Object>#class "
	#'Fundamental'.
	self value: [self canonicalObject class]
		should: [:r | true]
		conformTo: self protocol selector: #'class'.

	self value: [self canonicalObject class class]
		should: [:r | true "unspecified"]
		conformTo: self protocol selector: #'class'.!

testXcopy
	" <Object>#copy (Return Values: <RECEIVER>) "
	#'Fundamental'.
	self assertSend: #copy!

testXdoesNotUnderstandX
	" <Object>#doesNotUnderstand: "
	#'Fundamental'.

	self value: [self canonicalObject fooXzzYZ] shouldRaise: MessageNotUnderstood.!

testXequalityOp
	" <Object>#= "
	| newObject object1 |
	#'Fundamental'.
"	The value of receiver = comparand is true if and only if the value of comparand = receiver would also be true. If the value of receiver = comparand is true then the receiver and comparand must have equivalent hash values.  Or more formally:

	receiver = comparand	=>
	receiver hash = comparand hash
"	
	object1 := self canonicalObject.
	self value: [object1 = object1]
		should: [:r | r and: [object1 hash = object1 hash] ]
		conformTo: #'Object' selector: #'='.

	newObject := Object new.
	self should: [(object1 ~= newObject) and: [object1 hash ~= newObject hash] ].!

testXerrorX
	" <Object>#error: "
	#'Fundamental'.
	self value: [	[self canonicalObject error: 'dummy'
				]	on: Error
					do: [ :error |  error return: true ].
				]
		should: [:r | r]
		conformTo: self protocol selector: #'error:'.

	self value: [self canonicalObject error: 'dummy'] shouldRaise: Error.!

testXhash
	" <Object>#hash "
	| |
	#'Fundamental'.
"	Any two objects that are considered equivalent using the #= message must have the same hash value.  More formally:

	receiver = comparand	=>
	receiver hash = comparand hash
"

	self assertSend: #hash!

testXidentityHash
	" <Object>#identityHash "
	#'Fundamental'.
	self assertSend: #identityHash!

testXidentityOp
	" <Object>#== "
	| newObject object1 |
	#'Fundamental'.
"	The value of receiver == comparand is true if and only if the value of comparand == receiver would also be true. If the value of receiver == comparand is true then the receiver and comparand must have equivalent identity hash values.  Or more formally:

	receiver == comparand =>
	receiver identityHash = comparand identityHash
"
	object1 := self canonicalObject.
	self value: [object1 == object1]
		should: [:r | r and: [object1 identityHash = object1 identityHash] ]
		conformTo: #'Object' selector: #'=='.

	newObject := Object new.
	self should: [(object1 ~~ newObject) and: [object1 identityHash ~~ newObject identityHash] ].!

testXisKindOfX
	" <Object>#isKindOf:"
	#Fundamental.
	"	The return value is unspecified if the receiver is a class object or 
	candidateClass is not a class object.
	"
	#todo.
	"Fix find a test for unspecified rule above ???"
	self
		value: [self canonicalObject isKindOf: Object]
		should: [:r | r]
		conformTo: self protocol
		selector: #isKindOf:.
	"Metaclass tests:"
	self
		value: [self canonicalObject class isKindOf: Object class]
		should: [:r | "unspecified"
			true]
		conformTo: self protocol
		selector: #isKindOf:.
	self
		shouldnt: [self canonicalObject == nil
				ifTrue: [false]
				ifFalse: [self canonicalObject isKindOf: UndefinedObject]]!

testXisMemberOfX
	" <Object>#isMemberOf: "
	#'Fundamental'.
"	The return value is unspecified if the receiver is a class object or candidateClass is not a class object.
"
#todo. "Fix find a test for unspecified rule above ???"
	self value: [self canonicalObject isMemberOf: self canonicalObject class]
		should: [:r | r] conformTo: self protocol selector: #'isMemberOf:'.
	self shouldnt: [#'aSymbol' isMemberOf: Object].!

testXisNil
	" <Object>#isNil"
	#Fundamental.
	"	The messages #isNil and #notNil must be implemented to produce 
	consistent results.  For a given receiver if the result of #isNil is true 
	then the result of #notNil must be false.
	"
	self
		value: [self canonicalObject isNil = (self canonicalObject == nil)]
		should: [:r | r]
		conformTo: #Object
		selector: #isNil!

testXnotEqualityOp
	" <Object>#~= "
	| newObject |
	#'Fundamental'.
"	The value of receiver ~= comparand is true if and only if the value of comparand ~= receiver would also be true.
"
	newObject := Object new.
	self value: [self canonicalObject ~= newObject]
		should: [:r | r & (newObject ~= self canonicalObject)]
		conformTo: self protocol selector: #'~='.

	self value: [self canonicalObject ~= self canonicalObject] shouldnt: [:r | r]
		conformTo: self protocol selector: #'~='.!

testXnotIdentityOp
	" <Object>#== "
	| object1 |
	#'Fundamental'.
"	The value of receiver == comparand is true if and only if the value of comparand == receiver would also be true. If the value of receiver == comparand is true then the receiver and comparand must have equivalent identity hash values.  Or more formally:

	receiver == comparand =>
	receiver identityHash = comparand identityHash
"
	object1 := self canonicalObject.
	self value: [object1 ~~ Object new]
		should: [:r | r ]
		conformTo: self protocol selector: #'~~'.!

testXnotNil
	" <Object>#isNil"
	#Fundamental.
	"	The messages #isNil and #notNil must be implemented to produce 
	consistent results.  For a given receiver if the result of #isNil is true 
	then the result of #notNil must be false.
	"
	self
		value: [self canonicalObject notNil = (self canonicalObject ~~ nil)]
		should: [:r | r]
		conformTo: #Object
		selector: #notNil!

testXperformX
	" <Object>#perform: "
	#'Fundamental'.
"	If the receiver does not have a method for selector normal message-not-understood processing is performed as if the computed message hand been sent using a message send expression.
	The perform messages and #respondsTo: must be implemented to produce consistent results.  A message to perform a selector, selector, for a given receiver will result in a message-not-understood condition if and only if the value of receiver respondsTo: selector is false.
	Behavior is undefined if the number of arguments does not match that implicitly required by  the syntactic form of the selector.
"
	self value: [self canonicalObject perform: #'yourself']
		should: [:r | r == r ]
		conformTo: self protocol selector: #'perform:'.

	self value: [self canonicalObject perform: #'3+4']
		shouldRaise: MessageNotUnderstood.!

testXperformXwithArgumentsX
	" <Object>#perform:withArguments: "
	#'Fundamental'.
"	If the receiver does not have a method for the selector normal message-not-understood processing is performed as if the computed message hand been sent using a message send expression.  If this occurs, selector and arguments could be captured.
	The perform messages and #respondsTo: must be implemented to produce consistent results. A message to perform a selector, selector, for a given receiver will result in a message-not-understood condition if and only if the value of receiver respondsTo: selector is false.
	Behavior is undefined if the number of elements in arguments does not match that implicitly required by  the syntactic form of the selector.
"
	self value: [self canonicalObject perform: #'3+4' withArguments: #()]
		shouldRaise: MessageNotUnderstood.
	self value: [self canonicalObject perform: #'notNil' withArguments: #( 1 )]
		shouldRaise: Error.

	self value: [self canonicalObject perform: #'yourself' withArguments: #()]
		should: [:r | (self canonicalObject respondsTo: #'yourself')]
		conformTo: self protocol selector: #'perform:withArguments:'.!

testXperformXwithX
	" <Object>#perform:with: "
	#'Fundamental'.
"	If the receiver does not have a method for selector normal message-not-understood processing is performed as if the computed message hand been sent using a message send expression.
	The perform messages and #respondsTo: must be implemented to produce consistent results.  A message to perform a selector, selector, for a given receiver will result in a message-not-understood condition if and only if the value of receiver respondsTo: selector is false.
	Behavior is undefined if the number of arguments does not match that implicitly required by  the syntactic form of the selector.
"
	self value: [self canonicalObject perform: #'selector:' with: #()]
		shouldRaise: MessageNotUnderstood.
	self value: [self canonicalObject perform: #'isNil' with: 1]
		shouldRaise: Error.

	self value: [self canonicalObject perform: #'~~' with: 1]
		should: [:r | r & (self canonicalObject respondsTo: #'~~')]
		conformTo: self protocol selector: #'perform:with:'.!

testXperformXwithXwithX
	" <Object>#perform:with:with: "
	#'Fundamental'.
"	If the receiver does not have a method for selector normal message-not-understood processing is performed as if the computed message hand been sent using a message send expression.
	The perform messages and #respondsTo: must be implemented to produce consistent results.  A message to perform a selector, selector, for a given receiver will result in a message-not-understood condition if and only if the value of receiver respondsTo: selector is false.
	Behavior is undefined if the number of arguments does not match that implicitly required by  the syntactic form of the selector.
"
	self value: [self canonicalObject perform: #'foo:bar:' with: #() with: #()]
		shouldRaise: MessageNotUnderstood.
	self value: [self canonicalObject perform: #'isNil' with: 1 with: 1]
		shouldRaise: Error.

	self value: [self canonicalObject perform: #perform:with: with: #'~~' with: 1]
		should: [:r | r & (self canonicalObject respondsTo: #perform:with:)]
		conformTo: self protocol selector: #'perform:with:'.!

testXperformXwithXwithXwithX
	" <Object>#perform:with:with:with: "
	#'Fundamental'.

	self notDone!

testXprintOnX
	" <Object>#printOn: "
	| resultStream |
	#'Fundamental'.
"	The string of characters that would be the result of sending the message #printString to the receiver is written to target.
"
	self value: [resultStream := WriteStream on: (String new: 10).
			self canonicalObject printOn: resultStream]
		should: [:r | (resultStream contents) = self canonicalObject printString]
		conformTo: self protocol selector: #'printOn:'.!

testXprintString
	" <Object>#printString "
	#'Fundamental'.
	self value: [self canonicalObject printString]
		should: [:r | true]
		conformTo: self protocol selector: #'printString'.!

testXrespondsToX
	" <Object>#respondsTo: "
	#'Fundamental'.
	self value: [self canonicalObject respondsTo: #'isNil'] should: [:r | r]
		conformTo: self protocol selector: #'respondsTo:'.

	self value: [self canonicalObject respondsTo: #'foo'] shouldnt: [:r | r]
		conformTo: self protocol selector: #'respondsTo:'.!

testXyourself
	| anObject |
	" <Object>#yourself (Return Values: <RECEIVER>) "
	#'Fundamental'.
	anObject := self canonicalObject.
	self value: [anObject yourself] should: [:r | r == anObject]
		conformTo: self protocol selector: #'yourself'! !

!ObjectHelper categoriesForMethods!
canonicalObject!public! !
object:!public! !
protocol!public! !
testXclass!public! !
testXcopy!public! !
testXdoesNotUnderstandX!public! !
testXequalityOp!public! !
testXerrorX!public! !
testXhash!public! !
testXidentityHash!public! !
testXidentityOp!public! !
testXisKindOfX!public! !
testXisMemberOfX!public! !
testXisNil!public! !
testXnotEqualityOp!public! !
testXnotIdentityOp!public! !
testXnotNil!public! !
testXperformX!public! !
testXperformXwithArgumentsX!public! !
testXperformXwithX!public! !
testXperformXwithXwithX!public! !
testXperformXwithXwithXwithX!public! !
testXprintOnX!public! !
testXprintString!public! !
testXrespondsToX!public! !
testXyourself!public! !
!

!ObjectHelper class methodsFor!

initialize
	super initialize! !

!ObjectHelper class categoriesForMethods!
initialize!public! !
!

