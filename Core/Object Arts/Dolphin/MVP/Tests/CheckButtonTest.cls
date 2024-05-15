"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #CheckButtonTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CheckButtonTest guid: (GUID fromString: '{e0bdffe5-2de1-45be-9686-3c62aed4734f}')!

CheckButtonTest isAbstract: true!

CheckButtonTest comment: ''!

!CheckButtonTest categoriesForClass!Unclassified! !

!CheckButtonTest methodsFor!

testCalculateExtent
	"Test that checkboxes are able to resize to fit their text (and button). We really don't need to verify this precisely as we aren't testing the control's behaviour, rather that it does size to fit."

	| actualText shell subject textWidth buttonAndPadding |
	"The check button should mean that the actual extent is always larger than the text extent, even given minor variations in the calculated text size"
	subject := self view.
	subject usePreferredExtent: true.
	shell := subject parentView.
	shell
		designExtent: 500 @ 75;
		layoutManager: FlowLayout new.
	actualText := '	The quick brown 狐狸 jumped over the lazy Лиса'.
	subject text: actualText.
	textWidth := (self getTextExtent: actualText) x.
	"To keep the test simple, we use a guess at the size of the checkbox plus padding that ought to be large enough. We don't care about precise accuracy."
	buttonAndPadding := 20 * subject dpi // 96.
	self assert: (subject width between: textWidth and: textWidth + buttonAndPadding).
	subject text: 'abc'.
	textWidth := (self getTextExtent: 'abc') x.
	self assert: (subject width between: textWidth and: textWidth + buttonAndPadding)! !

!CheckButtonTest categoriesForMethods!
testCalculateExtent!public!unit tests! !
!

