"Filed out from Dolphin Smalltalk 7"!

ValuePresenter subclass: #DatePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DatePresenter guid: (GUID fromString: '{87b4c6ce-026e-11d3-9fd7-00a0cc3e4a32}')!
DatePresenter comment: 'DatePresenter is a <valuePresenter> that displays a <valueModel> onto a <Date> value. A DatePresenter can be connected to any <valueView> capable of displaying <Date> values. When the ''Dolphin DateTimePicker Control'' package is installed this will be a <DateTimePicker>, but alternative views may be chosen with the installation of an appropriate <typeConverter>.'!
!DatePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Date fields! !
!DatePresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Date today!

defaultView
	^'Picker view'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(TextEdit)  98 16 0 0 98 2 8 1140916224 1025 416 0 524550 ##(ColorRef)  8 4278190080 0 5 0 0 0 416 0 8 4294906635 656454 1 ##(DateToText)  0 8 '' 0 0 1 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 738 251 39 416 674 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 416 674 8 #isTextModified: 98 1 32 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 130 0 0 0 24 0 0 0] 98 0 738 193 193 0 27 )! !
!DatePresenter class categoriesFor: #defaultModel!models!public! !
!DatePresenter class categoriesFor: #defaultView!constants!public!views! !
!DatePresenter class categoriesFor: #icon!constants!public! !
!DatePresenter class categoriesFor: #resource_Default_view!public!resources-views! !

