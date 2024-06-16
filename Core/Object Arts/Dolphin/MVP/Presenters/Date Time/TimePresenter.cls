"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #TimePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TimePresenter guid: (GUID fromString: '{87b4c6d3-026e-11d3-9fd7-00a0cc3e4a32}')!

TimePresenter comment: 'TimePresenter is a <valuePresenter> that displays a <valueModel> onto <Time> value. A TimePresenter can be connected to any <valueView> capable of displaying <Time> values. When the ''Dolphin DateTimePicker Control'' package is installed this will be a <DateTimePicker>, but alternative views may be chosen with the installation of an appropriate <typeConverter>.'!

!TimePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Time fields! !

!TimePresenter class methodsFor!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TextEdit) 34 16 nil nil 34 2 8 1140916224 1025 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1759000288 656134 ##(Smalltalk.TimeToText) nil nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[127 7 0 0 10 0 0 0 1 8 0 0 29 0 0 0] 193 448 nil 416 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )! !

!TimePresenter class categoriesForMethods!
defaultView!constants!public!views! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

