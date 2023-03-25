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

	| actualText shell subject textWidth |
	"Use a non-proportional font to make calculating the expected result predictable"

	"The check button should mean that the actual extent is always larger than the text extent, even given minor variations in the calculated text size"
	subject := self view.
	subject usePreferredExtent: true.
	shell := subject parentView.
	shell
		extent: 500 @ 75;
		layoutManager: FlowLayout new.
	actualText := '	The quick brown 狐狸 jumped over the lazy Лиса'.
	subject text: actualText.
	textWidth := (self getTextExtent: actualText) x.
	self assert: (subject extent x between: textWidth and: textWidth + 25).
	subject text: 'abc'.
	textWidth := (self getTextExtent: 'abc') x.
	self assert: (subject extent x between: textWidth and: textWidth + 25)! !
!CheckButtonTest categoriesForMethods!
getTextExtent:!helpers!private! !
testCalculateExtent!public!unit tests! !
!

