"Filed out from Dolphin Smalltalk 7"!

AbstractRectangleTest subclass: #RectangleTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RectangleTest guid: (GUID fromString: '{aceafc61-24f9-482c-a8e7-0aff0e7fcc85}')!
RectangleTest comment: ''!
!RectangleTest categoriesForClass!Unclassified! !
!RectangleTest methodsFor!

subjectClass
	^Rectangle!

testAreasOutside
	"2"

	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (0 @ 0 corner: 180 @ 180)) asArray
		equals: (Array with: (100 @ 180 corner: 200 @ 200) with: (180 @ 100 corner: 200 @ 180)).
	"3"
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (120 @ 0 corner: 180 @ 180)) asArray
		equals: (Array
				with: (100 @ 180 corner: 200 @ 200)
				with: (100 @ 100 corner: 120 @ 180)
				with: (180 @ 100 corner: 200 @ 180)).
	"4"
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (120 @ 120 corner: 180 @ 180)) asArray
		equals: (Array
				with: (100 @ 100 corner: 200 @ 120)
				with: (100 @ 180 corner: 200 @ 200)
				with: (100 @ 120 corner: 120 @ 180)
				with: (180 @ 120 corner: 200 @ 180)).
	"#2132: If the rectangles do not intersect should get back the receiver whether or not they touch."
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (120 @ 200 corner: 180 @ 400))
		equals: (Array with: (100 @ 100 corner: 200 @ 200)).
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (300 @ 300 corner: 400 @ 400)) asArray
		equals: (Array with: (100 @ 100 corner: 200 @ 200)).
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (200 @ 200 corner: 400 @ 400))
		equals: (Array with: (100 @ 100 corner: 200 @ 200))!

testInsetBy
	self assert: (desktop insetBy: 1) equals: (1 @ 1 corner: 1279 @ 1023).
	self assert: (desktop insetBy: 2) equals: (2 @ 2 corner: 1278 @ 1022).
	self assert: (desktop insetBy: 1 @ 1) equals: (1 @ 1 corner: 1279 @ 1023).
	self assert: (desktop insetBy: 2 @ 2) equals: (2 @ 2 corner: 1278 @ 1022).
	self assert: (desktop insetBy: 1 @ 2) equals: (1 @ 2 corner: 1279 @ 1022).
	self assert: ((1 @ 2 corner: 3 @ 4) insetBy: (2 @ 0 corner: 0 @ 0)) equals: (3 @ 2 corner: 3 @ 4).
	#todo	"Add more insetBy: <Rectangle> tests"! !
!RectangleTest categoriesFor: #subjectClass!constants!private! !
!RectangleTest categoriesFor: #testAreasOutside!public!unit tests! !
!RectangleTest categoriesFor: #testInsetBy!public!unit tests! !

