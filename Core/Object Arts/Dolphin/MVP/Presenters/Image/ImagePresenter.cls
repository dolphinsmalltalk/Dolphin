"Filed out from Dolphin Smalltalk 7"!

ValuePresenter subclass: #ImagePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.AnimatedImageView)  98 14 0 0 98 2 8 1409286144 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 196934 1 ##(Smalltalk.RGB)  33489407 0 5 0 0 0 416 395334 3 ##(Smalltalk.Bitmap)  0 16 0 0 0 0 1 0 16 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 754 247 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 242 5 0 0 110 0 0 0] 98 0 754 193 193 0 27 )!

resource_Basic_image
	"Answer the literal data from which the 'Basic image' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Basic_image)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ImageView)  98 21 0 0 98 2 8 1140850944 1 416 721990 2 ##(ValueHolder)  0 0 1376774 ##(PluggableSearchPolicy)  459270 ##(Message)  8 #= 98 0 562 8 #hash 98 0 0 524550 ##(ColorRef)  8 4278190080 0 5 0 0 0 416 0 8 4294903431 852486 ##(NullConverter)  0 0 0 0 8 #scaleToFit 1 0 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 914 225 201 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 117 0 0 0 105 0 0 0] 98 0 914 193 193 0 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(StaticBitmap)  98 17 0 0 98 2 8 1149239566 1 416 721990 2 ##(ValueHolder)  0 0 1376774 ##(PluggableSearchPolicy)  459270 ##(Message)  8 #== 98 0 562 8 #hash 98 0 0 0 0 5 0 0 0 416 0 8 4294906439 852486 ##(NullConverter)  0 0 32 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 850 441 331 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 225 0 0 0 170 0 0 0] 98 0 850 193 193 0 27 )!

resource_Static_icon
	"Answer the literal data from which the 'Static icon' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Static_icon)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(StaticIcon)  98 17 0 0 98 2 8 1149239555 1 416 721990 2 ##(ValueHolder)  0 0 1376774 ##(PluggableSearchPolicy)  459270 ##(Message)  8 #== 98 0 562 8 #hash 98 0 0 0 0 7 0 0 0 416 0 8 4294906439 852486 ##(NullConverter)  0 0 32 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 850 241 221 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 125 0 0 0 115 0 0 0] 98 0 850 193 193 0 27 )! !
!ImagePresenter class categoriesFor: #icon!constants!public! !
!ImagePresenter class categoriesFor: #resource_Animated_view!public!resources-views! !
!ImagePresenter class categoriesFor: #resource_Basic_image!public!resources-views! !
!ImagePresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!ImagePresenter class categoriesFor: #resource_Static_icon!public!resources-views! !

