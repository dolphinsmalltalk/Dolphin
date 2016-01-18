"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #RectangleTest
	instanceVariableNames: 'desktop oddDesktop unary'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RectangleTest guid: (GUID fromString: '{ACEAFC61-24F9-482C-A8E7-0AFF0E7FCC85}')!
RectangleTest comment: ''!
!RectangleTest categoriesForClass!Unclassified! !
!RectangleTest methodsFor!

setUp
	"Note that desktop is always a fixed size to make writing the tests easier"
	desktop := Rectangle origin: 0@0 corner: 1280@1024.

	oddDesktop := Rectangle origin: 0@0 corner: 1279@1023.

	unary := Rectangle origin: 0@0 extent: 1@1!

testAreasOutside
	"2"

	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (0 @ 0 corner: 180 @ 180)) asArray 
				= (Array with: (100 @ 180 corner: 200 @ 200) with: (180 @ 100 corner: 200 @ 180)).
	"3"
	self 
		assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (120 @ 0 corner: 180 @ 180)) asArray = (Array 
						with: (100 @ 180 corner: 200 @ 200)
						with: (100 @ 100 corner: 120 @ 180)
						with: (180 @ 100 corner: 200 @ 180)).
	"4"
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (120 @ 120 corner: 180 @ 180)) asArray 
				= (Array 
						with: (100 @ 100 corner: 200 @ 120)
						with: (100 @ 180 corner: 200 @ 200)
						with: (100 @ 120 corner: 120 @ 180)
						with: (180 @ 120 corner: 200 @ 180)).
	"#2132: If the rectangles do not intersect should get back the receiver whether or not they touch."
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (120 @ 200 corner: 180 @ 400)) 
				= (Array with: (100 @ 100 corner: 200 @ 200)).
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (300 @ 300 corner: 400 @ 400)) asArray 
				= (Array with: (100 @ 100 corner: 200 @ 200)).
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (200 @ 200 corner: 400 @ 400)) 
				= (Array with: (100 @ 100 corner: 200 @ 200)).
!

testCenter
	self assert: (desktop center = (640@512)).
	self assert: (oddDesktop center = (639@511)).
	self assert: (unary center = (0@0)).!

testCenterX
	self assert: (desktop centerX = 640).
	self assert: (oddDesktop centerX = 639).!

testInsetBy
	self assert: ((desktop insetBy: 1) = (1@1 corner: 1279@1023)).
	self assert: ((desktop insetBy: 2) = (2@2 corner: 1278@1022)).
	self assert: ((desktop insetBy: 1@1) = (1@1 corner: 1279@1023)).
	self assert: ((desktop insetBy: 2@2) = (2@2 corner: 1278@1022)).
	self assert: ((desktop insetBy: 1@2) = (1@2 corner: 1279@1022)).

	self assert: (((1@2) corner: 3 @ 4) insetBy: ((2 @ 0) corner: (0 @ 0))) = ( 3@2 corner: 3@4).
	#todo "Add more insetBy: <Rectangle> tests"
! !
!RectangleTest categoriesFor: #setUp!public!Running! !
!RectangleTest categoriesFor: #testAreasOutside!public!unit tests! !
!RectangleTest categoriesFor: #testCenter!public!unit tests! !
!RectangleTest categoriesFor: #testCenterX!public!unit tests! !
!RectangleTest categoriesFor: #testInsetBy!public!unit tests! !

