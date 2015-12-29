"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

Object subclass: #SUnitBrowserDummyUI
	instanceVariableNames: 'callbacks'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserDummyUI guid: (GUID fromString: '{3280A3A1-C71E-4080-8132-53FED896AF87}')!
SUnitBrowserDummyUI comment: ''!
!SUnitBrowserDummyUI categoriesForClass!Unclassified! !
!SUnitBrowserDummyUI methodsFor!

addCallback: anAssociation

	self callbacks add: anAssociation
			!

callbackResetList

	self addCallback: (
		Association
			key: #callbackResetList
			value: nil)
			!

callbackResetResults: results

	self addCallback: (
		Association
			key: #callbackResetResults
			value: nil)
			!

callbackResetRunningStatus

	self addCallback: (
		Association
			key: #callbackResetRunningStatus
			value: nil)
			!

callbacks

	^callbacks
			!

callbacks: aCollection

	callbacks := aCollection
			!

callbackSelectedItems: anArray

	self addCallback: (
		Association
			key: #callbackSelectedItems
			value: anArray)
			!

callbackSetRunningStatus: aString

	self addCallback: (
		Association
			key: #callbackSetRunningStatus
			value: aString)
			!

callbackSymbols

	| symbols |

	symbols := self callbacks collect: [:each | each key].

	^symbols asArray
			!

callbackUpdateTestCaseStatus: anSUnitTest withResult: aTestResult

	self addCallback: (
		Association
			key: #callbackSetRunningStatus
			value: (
				Array
					with: anSUnitTest
					with: aTestResult))
			!

initialize

	self callbacks: OrderedCollection new
			!

numberOfCallbacks

	^self callbacks size
			! !
!SUnitBrowserDummyUI categoriesFor: #addCallback:!model callbacks!private! !
!SUnitBrowserDummyUI categoriesFor: #callbackResetList!model callbacks!public! !
!SUnitBrowserDummyUI categoriesFor: #callbackResetResults:!model callbacks!public! !
!SUnitBrowserDummyUI categoriesFor: #callbackResetRunningStatus!model callbacks!public! !
!SUnitBrowserDummyUI categoriesFor: #callbacks!accessing!public! !
!SUnitBrowserDummyUI categoriesFor: #callbacks:!accessing!private! !
!SUnitBrowserDummyUI categoriesFor: #callbackSelectedItems:!model callbacks!public! !
!SUnitBrowserDummyUI categoriesFor: #callbackSetRunningStatus:!model callbacks!public! !
!SUnitBrowserDummyUI categoriesFor: #callbackSymbols!accessing!public! !
!SUnitBrowserDummyUI categoriesFor: #callbackUpdateTestCaseStatus:withResult:!model callbacks!public! !
!SUnitBrowserDummyUI categoriesFor: #initialize!initializing!private! !
!SUnitBrowserDummyUI categoriesFor: #numberOfCallbacks!accessing!public! !

!SUnitBrowserDummyUI class methodsFor!

new

	^super new
		initialize;
		yourself
			! !
!SUnitBrowserDummyUI class categoriesFor: #new!instantiating!public! !

