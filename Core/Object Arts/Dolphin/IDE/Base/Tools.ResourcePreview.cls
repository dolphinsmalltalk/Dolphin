"Filed out from Dolphin Smalltalk"!

UI.ImageView
	subclass: #'Tools.ResourcePreview'
	instanceVariableNames: ''
	classVariableNames: 'DesignDesktop'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.ResourcePreview guid: (Core.GUID fromString: '{897f61b1-f227-477b-80fd-99b714133e31}')!

Tools.ResourcePreview comment: ''!

!Tools.ResourcePreview categoriesForClass!MVP-Views! !

!Tools.ResourcePreview methodsFor!

createWindow: aCreateInDpiAwarenessContext
	aCreateInDpiAwarenessContext dpiAwareness = DesignDesktop dpiAwareness
		ifFalse: 
			["The preview option has been changed relative to the saved state. We may need to rescale, and also need to update the creation function with the new context"
			aCreateInDpiAwarenessContext
				scaleToDpi: DesignDesktop dpi;
				dpiAwareness: DesignDesktop dpiAwareness].
	^super createWindow: aCreateInDpiAwarenessContext!

creationFunction: aRectangle dpi: anInteger
	"Private - Answer a function object that encapsulates a CreateWindow API call to create or recreate a window for the receiver, with the specified position and extent, measured at the specified DPI."

	self assert: [anInteger == DesignDesktop dpi].
	^CreateInDpiAwarenessContext decorating: (super creationFunction: aRectangle dpi: anInteger)
		withDpiAwareness: DesignDesktop dpiAwareness!

dpiAwareness: aDpiAwareness
	(super dpiAwareness: aDpiAwareness) ifTrue: [self refreshContents]!

imageFromResource: aResourceIdentifier
	| resourceView |
	resourceView := [DesignDesktop loadViewResource: aResourceIdentifier resource forEdit: false]
				on: Error
				do: 
					[:x |
					| rect |
					Processor activeProcess newWindow: nil.
					backcolor := Color darkOrange.
					rect := DpiAwareness gdiScaled inContextDo: [self displayRectangle].
					viewMode := #normal.
					DesignDesktop dpiAwareness inContextDo: 
							[MultilineTextEdit new
								parentView: DesignDesktop;
								hasClientEdge: false;
								font: (Font name: 'Segoe UI' pointSize: 8);
								backcolor: backcolor;
								createAt: 0 @ 0 extent: rect extent;
								plainText: (String streamContents: [:strm | x printTraceOn: strm]);
								yourself]].
	resourceView invalidateLayoutDeeply.
	^[resourceView screenshot: backcolor brush] ensure: [resourceView destroy]!

recreationFunction
	"Private - Answer a function object that encapsulates a CreateWindow API call to recreate the receiver's window."

	^self creationFunction: self getRect dpi: DesignDesktop dpi!

refreshContents
	backcolor := Color applicationWorkspace.
	viewMode := #scaleBestFit.
	^super refreshContents!

setDpiAwareness
	self dpiAwareness: DesignDesktop dpiAwareness!

setModel: aModel
	super setModel: (ValueConverter subject: aModel
				typeConverter: ((PluggableTypeConverter
						leftToRight: [:resourceId | self imageFromResource: resourceId]
						rightToLeft: [:img | nil])
						rightNullValue: View icon;
						yourself))! !

!Tools.ResourcePreview categoriesForMethods!
createWindow:!private!realizing/unrealizing! !
creationFunction:dpi:!private!realizing/unrealizing! !
dpiAwareness:!accessing!high DPI!public! !
imageFromResource:!helpers!private! !
recreationFunction!geometry!private!realizing/unrealizing! !
refreshContents!public! !
setDpiAwareness!high DPI!private! !
setModel:!accessing!private! !
!

!Tools.ResourcePreview class methodsFor!

dpiAwareness
	"Answer the <DpiAwareness> context to be used for generating and displaying resource preview images."

	^DesignDesktop dpiAwareness!

dpiAwareness: aDpiAwareness
	aDpiAwareness = DesignDesktop dpiAwareness ifTrue: [^self].
	DesignDesktop := DesignDesktopView perform: aDpiAwareness name.
	self allSubinstances do: [:each | each isOpen ifTrue: [each setDpiAwareness]]!

initialize
	DesignDesktop := DesignDesktopView default! !

!Tools.ResourcePreview class categoriesForMethods!
dpiAwareness!public! !
dpiAwareness:!public! !
initialize!public! !
!

