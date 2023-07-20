"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.MonthCalendarViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.MonthCalendarViewTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!
UI.Tests.MonthCalendarViewTest comment: ''!
!UI.Tests.MonthCalendarViewTest methodsFor!

classToTest
	^MonthCalendarView!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view typeconverter isNullConverter.
	self assert: view hasToday.
	self assert: view hasTodayCircle.
	self deny: view hasWeekNumbers.
	self assertIsNil: view maximum.
	self assertIsNil: view minimum.
	self assert: view firstDayOfWeek equals: 1.
	self assert: view value
		equals: (Date
				year: 2003
				month: 3
				day: 14)! !
!UI.Tests.MonthCalendarViewTest categoriesForMethods!
classToTest!helpers!private! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.MonthCalendarViewTest class methodsFor!

resource_Month_calendar_view_D7
	"Answer the literal data from which the 'Month calendar view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Month_calendar_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.MonthCalendarView) 34 15 nil nil 34 2 8 1409351680 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 262406 ##(Smalltalk.Date) 74655 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 395 307 5 nil nil nil 416 nil 8 1904635520 852486 ##(Smalltalk.NullConverter) nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 610 3839 21 610 395 307 416 754 #range: 34 1 8 #(nil nil) 416 754 #mcmSetFirstDayOfWeek: 8 #(0) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 68 8 0 0 163 0 0 0] 8 #() 610 193 193 nil 27 )! !
!UI.Tests.MonthCalendarViewTest class categoriesForMethods!
resource_Month_calendar_view_D7!public!resources-views! !
!

