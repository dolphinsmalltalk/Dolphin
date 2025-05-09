﻿"Filed out from Dolphin Smalltalk"!

UI.CheckButton
	subclass: #'UI.RadioButton'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.RadioButton guid: (Core.GUID fromString: '{87b4c73b-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.RadioButton comment: 'RadioButton is a <valueView> implementing the Windows "BUTTON" class in a BS_AUTORADIOBUTTON style. The <valueModel> associated with a RadioButton must always yield a <boolean> value once mapped through the installed type converter. RadioButtons will normally be used in a group in conjunction with a <RadioButtonSetPresenter>.

Windows'' standard behaviour for radio buttons is that among a group of such buttons under the same parent only a single button may be selected at any time (hence the ''radio'' button designation, a reference to old-fashioned radios that used such controls for selection between the different frequency bands, etc). RadioButton itself does not implement this behaviour; although Windows will ensure that only one radio button (with the style BS_AUTORADIOBUTTON) within a parent is selected at any one time, the deselected radio button receives no event to notify it of the change. Therefore we rely on a ''grouping'' presenter to ensure that the models of a group of radio buttons are consistent. <RadioButtonSetPresenter> is one such presenter that performs this task and implements the standard behaviour.
'!

!UI.RadioButton categoriesForClass!MVP-Views! !

!UI.RadioButton methodsFor!

basicWindowStyle
	^BS_AUTORADIOBUTTON! !

!UI.RadioButton categoriesForMethods!
basicWindowStyle!constants!private! !
!

