"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.ValidationResultPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ValidationResultPresenter guid: (Core.GUID fromString: '{9356a328-de22-4088-8350-dfcb12e76fa1}')!
UI.ValidationResultPresenter isNonInstantiable: true!
UI.ValidationResultPresenter comment: '`ValidationResultPresenter` is the abstract class of `ValuePresenter`s for displaying `ValidationResult`s.'!
!UI.ValidationResultPresenter methodsFor!

dwell
	"Answer the <Duration> for which a validation hint should be shown before fading away"

	^0 seconds

	!

dwell: aDuration
	"Set the <Duration> for which a validation hint should be shown before fading away"

	!

hintFont
	"Answer the `Font` to be used for the main text of any hint bubble. This does not affect the headline text, the font of which is not configurable."

	^Font name: 'Segoe UI' pointSize: 10!

hintFont: aFont
	! !
!UI.ValidationResultPresenter categoriesForMethods!
dwell!accessing!public! !
dwell:!accessing!public! !
hintFont!constants!public! !
hintFont:!accessing!public! !
!

!UI.ValidationResultPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ValidationResult new asValue
! !
!UI.ValidationResultPresenter class categoriesForMethods!
defaultModel!models!public! !
!

