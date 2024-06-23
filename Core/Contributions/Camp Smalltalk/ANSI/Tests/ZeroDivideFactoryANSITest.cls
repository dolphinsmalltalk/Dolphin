"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ZeroDivideFactoryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ZeroDivideFactoryANSITest guid: (GUID fromString: '{3e4c31cd-6705-42d7-a54d-d85824942cf4}')!

ZeroDivideFactoryANSITest comment: ''!

!ZeroDivideFactoryANSITest categoriesForClass!Unclassified! !

!ZeroDivideFactoryANSITest methodsFor!

canonicalObject
	^ZeroDivide!

protocol
	^#'ZeroDivide factory'!

testXconcatenateOp
	" <exceptionSelector>#, "
	#'Exception'.!

testXdividendX
	" <ZeroDivide factory>#dividend: "
	| dividendTmp msgResult |
	#'Exception'.
	self value: [	[(msgResult := ZeroDivide dividend: 1) signal
				] on: ZeroDivide do: [ :aZeroDivide |
					dividendTmp := aZeroDivide dividend.
					aZeroDivide return: msgResult ] ]
		should: [:r | dividendTmp = 1]
		conformTo: #'ZeroDivide factory' selector: #'dividend:'.!

testXhandlesX
	" <exceptionSelector>#handles: "
	#'Exception'.!

testXnew
	" <exceptionInstantiator>#new "
	#'Exception'.!

testXsignal
	" <ZeroDivide factory>#signal "
	| msgResult |
	#'Exception'.
	self value: [	[msgResult := (ZeroDivide dividend: 1) signal
				] on: ZeroDivide do: [ :aZeroDivide |
					aZeroDivide return: msgResult ] ]
		should: [:r | true "unspecified"]
		conformTo: #'ZeroDivide factory' selector: #'signal'.!

testXsignalX
	" <exceptionSignaler>#signal: "
	#'Exception'.! !

!ZeroDivideFactoryANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
testXconcatenateOp!public! !
testXdividendX!public! !
testXhandlesX!public! !
testXnew!public! !
testXsignal!public! !
testXsignalX!public! !
!

