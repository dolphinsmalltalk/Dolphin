"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ExceptionClassANSITest
	instanceVariableNames: 'exceptionClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExceptionClassANSITest guid: (GUID fromString: '{72927324-67fb-4498-9a02-867e023da65d}')!

ExceptionClassANSITest comment: ''!

!ExceptionClassANSITest categoriesForClass!Unclassified! !

!ExceptionClassANSITest methodsFor!

canonicalObject
	^self exceptionClass!

exceptionClass
	"We can't use Exception itself, because it is non-instantiable. We need an instantiable Exception that is not an Error."

	^exceptionClass ifNil: [exceptionClass := Exception newAnonymousSubclass]!

protocol
	^#'Exception class'!

testXallSubclasses
	" <classDescription>#allSubclasses "
	#'Exception'.!

testXallSuperclasses
	" <classDescription>#allSuperclasses "
	#'Exception'.!

testXconcatenateOp
	" <exceptionSelector>#, "
	#'Exception'.
	self value: [ self canonicalObject , Error ]
		should: [:r | (r handles: (self canonicalObject new))
							& (r handles: (Error new)) ]
		conformTo: #'exceptionSet' selector: #','.!

testXhandlesX
	" <Exception class>#handles: "
	#'Exception'.
	self value: [ [ self canonicalObject signal ] on: self canonicalObject do: [ :except |
					except return: (Exception  handles: except) ] ]
		should: [:r | r]
		conformTo: #'Exception class' selector: #'handles:'.


	self value: [ [ self canonicalObject signal ] on: self canonicalObject do: [ :except |
					except return: (Error  handles: except) ] ]
		shouldnt: [:r | r]
		conformTo: #'Exception class' selector: #'handles:'.!

testXname
	" <classDescription>#name "
	#'Exception'.!

testXnew
	" <Exception class>#new "
	#'Exception'.
	self value: [self canonicalObject new] should: [:r | true "??? r = Exception signal ???"]
		conformTo: #'Exception class' selector: #'new'.!

testXsignal
	" <Exception class>#signal "
	#'Exception'.
	self value: [ [self exceptionClass signal] on: Exception do: [ :except | except return ] ]
		should: [:r | true "unspecified"]
		conformTo: #'Exception class' selector: #'signal'.!

testXsignalX
	" <exceptionSignaler>#signal: "
	#'Exception'.
#'todo'."??? I don't know what to test here.
	[	Exception signal
	] on: Exception do: [ :anException | anException signal: ??? ].

	self op: [xxx] should: [:r | xxx]
		conformTo: #'exceptionDescription' selector: #'signal:'.

	self should: [ [xxx] ensure: [ flag := 1 ] ]
		raise: Exception.
???"!

testXsubclasses
	" <classDescription>#subclasses "
	#'Exception'.!

testXsuperclass
	" <classDescription>#superclass "
	#'Exception'.! !

!ExceptionClassANSITest categoriesForMethods!
canonicalObject!public! !
exceptionClass!private! !
protocol!public! !
testXallSubclasses!public! !
testXallSuperclasses!public! !
testXconcatenateOp!public! !
testXhandlesX!public! !
testXname!public! !
testXnew!public! !
testXsignal!public! !
testXsignalX!public! !
testXsubclasses!public! !
testXsuperclass!public! !
!

