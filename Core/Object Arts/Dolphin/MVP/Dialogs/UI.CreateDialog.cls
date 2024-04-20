"Filed out from Dolphin Smalltalk"!

UI.CreateWindowApiCall
	subclass: #'UI.CreateDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CreateDialog guid: (Core.GUID fromString: '{8e83dad1-32a3-4194-8169-ce1c86fdfec7}')!

UI.CreateDialog comment: ''!

!UI.CreateDialog categoriesForClass!Kernel-Objects! !

!UI.CreateDialog methodsFor!

create: aDialogView
	| hDlg |
	hDlg := User32
				createDialogParam: aDialogView resourceLib asParameter
				lpTemplate: aDialogView templateId asResourceId
				hWndParent: View activeHandle
				lpDialogFunc: VM getDlgProc
				dwInitParam: 0.
	"Position and size the dialog as requested."
	aDialogView setInitialPosition: rectangle.
	^hDlg!

rectangle: aRectangle dpi: anInteger
	rectangle := aRectangle.
	dpi := anInteger! !

!UI.CreateDialog categoriesForMethods!
create:!operations!public! !
rectangle:dpi:!initializing!private! !
!

!UI.CreateDialog class methodsFor!

rectangle: aRectangle dpi: anInteger
	<primitive: 157>
	^self new rectangle: aRectangle dpi: anInteger! !

!UI.CreateDialog class categoriesForMethods!
rectangle:dpi:!instance creation!public! !
!

