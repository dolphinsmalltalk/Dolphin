"Filed out from Dolphin Smalltalk"!

CreateWindowApiCall subclass: #CreateDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CreateDialog guid: (GUID fromString: '{8e83dad1-32a3-4194-8169-ce1c86fdfec7}')!

CreateDialog comment: ''!

!CreateDialog categoriesForClass!Kernel-Objects! !

!CreateDialog methodsFor!

create: aDialogView
	| hDlg |
	hDlg := UserLibrary default
				createDialogParam: aDialogView resourceLib asParameter
				lpTemplate: aDialogView templateId asResourceId
				hWndParent: View activeHandle
				lpDialogFunc: VMLibrary default getDlgProc
				dwInitParam: 0.
	"Position and size the dialog as requested."
	aDialogView setInitialPosition: rectangle.
	^hDlg! !

!CreateDialog categoriesForMethods!
create:!operations!public! !
!

!CreateDialog class methodsFor!

rectangle: aRectangle dpi: anInteger
	<primitive: 157>
	^self new
		rectangle: aRectangle;
		dpi: anInteger;
		yourself! !

!CreateDialog class categoriesForMethods!
rectangle:dpi:!instance creation!public! !
!

