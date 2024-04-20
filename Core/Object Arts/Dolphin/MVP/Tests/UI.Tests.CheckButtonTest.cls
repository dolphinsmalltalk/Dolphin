"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.CheckButtonTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.CheckButtonTest guid: (Core.GUID fromString: '{e0bdffe5-2de1-45be-9686-3c62aed4734f}')!

UI.Tests.CheckButtonTest isNonInstantiable: true!

UI.Tests.CheckButtonTest comment: ''!

!UI.Tests.CheckButtonTest methodsFor!

getTextExtent: actualText
	| subject textExtent canvas |
	subject := self view.
	canvas := subject canvas.
	canvas font: subject actualFont.
	textExtent := canvas textExtent: actualText.
	canvas free.
	^textExtent!

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
	self assert: (subject extent x between: textWidth and: textWidth + buttonAndPadding).
	subject text: 'abc'.
	textWidth := (self getTextExtent: 'abc') x.
	self assert: (subject extent x between: textWidth and: textWidth + buttonAndPadding)! !

!UI.Tests.CheckButtonTest categoriesForMethods!
getTextExtent:!helpers!private! !
testCalculateExtent!public!unit tests! !
!

