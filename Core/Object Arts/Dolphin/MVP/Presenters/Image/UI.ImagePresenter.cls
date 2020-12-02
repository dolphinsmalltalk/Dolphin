"Filed out from Dolphin Smalltalk 7"!

ValuePresenter subclass: #ImagePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ImagePresenter guid: (GUID fromString: '{87b4c6d0-026e-11d3-9fd7-00a0cc3e4a32}')!
ImagePresenter comment: 'ImagePresenter is a <valuePresenter> that displays a <valueModel> onto an <image> value. A ImagePresenter can be connected to any <valueView> capable of displaying <image> values. Normally, this will be an <ImageView> or <StaticImage>, although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!
!ImagePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Images! !
!ImagePresenter class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Animated_view
	"Answer the literal data from which the 'Animated view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Animated_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.AnimatedImageView) 34 14 nil nil 34 2 8 1409286144 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #violet nil 5 nil nil nil 416 nil true 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 690 247 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 250 7 0 0 110 0 0 0] 8 #() 690 193 193 nil 27 )!

resource_Basic_image
	"Answer the literal data from which the 'Basic image' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Basic_image)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ImageView) 34 21 nil nil 34 2 8 1140850944 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 546 #hash 8 #() nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 4294903431 852486 ##(Smalltalk.NullConverter) nil nil nil nil #scaleToFit 1 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 818 225 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 239 7 0 0 110 0 0 0] 8 #() 818 193 193 nil 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticBitmap) 34 17 nil nil 34 2 8 1149239566 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #== 8 #() 546 #hash 8 #() nil nil nil 5 nil nil nil 416 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil false nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 11 11 786 441 331 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 225 0 0 0 170 0 0 0] 8 #() 786 193 193 nil 27 )!

resource_Static_icon
	"Answer the literal data from which the 'Static icon' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Static_icon)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticIcon) 34 17 nil nil 34 2 8 1149239555 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #== 8 #() 546 #hash 8 #() nil nil nil 7 nil nil nil 416 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil false nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 11 11 786 241 221 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 125 0 0 0 115 0 0 0] 8 #() 786 193 193 nil 27 )! !
!ImagePresenter class categoriesFor: #icon!constants!public! !
!ImagePresenter class categoriesFor: #resource_Animated_view!public!resources-views! !
!ImagePresenter class categoriesFor: #resource_Basic_image!public!resources-views! !
!ImagePresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!ImagePresenter class categoriesFor: #resource_Static_icon!public!resources-views! !

