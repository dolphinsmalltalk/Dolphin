"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Graphics.FontSeries'
	instanceVariableNames: 'canonical instances'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.FontSeries guid: (Core.GUID fromString: '{3ae24a05-acea-48b2-8f8e-df4161415a3e}')!

Graphics.FontSeries comment: 'A `FontSeries` represents a group of `Font`s of the same characteristics (i.e. font family, point size, weight, style, etc), but at different DPI scales. It allows for continued sharing of `Font`s in conjunction with per-monitor DPI awareness. For example when a view is moved between monitors with different DPIs it needs to be rescaled. Part of the rescaling is adjusting the physical pixel heights of the `Font`s appropriately to represent the point size at the correct magnification for the DPI. In Dolphin views very often share the same `Font` instances, e.g in the development system the same individual `Font` object is inherited by most views across the development tools. Rescaling a font requires destroying the existing `Font` handle and recreating it with a new pixel height. Where a `Font` is shared, this might result in a font handle that is still in use being deleted - a visual symptom of this is that the view starts to draw using the system font. Where a `Font` is shared between views with differing DPIs, this would result in some of them having the wrong scale of font. Rather than deleting the handle for an existing font, what we need to do is replace it with a new `Font` instance that is scaled appropriately, but which still maintains the sharing relationship. This is the role of `FontSeries`. Now when a change of font resolution/dpi is required, the `Font` is effectively replaced by another of the same series. The existing font is left unchanged, although internally it may lazily instantiate a `FontSeries` if not a member of one already. Whenever font handle is passed to a `ControlView`, or set into a `Canvas`, the handle of the `Font` from the series at the correct DPI is used.

## Instance Variables:
  `canonical`		The original `Font` instance that created the series. Typically this would the 96-dpi `Font` created on loading a view resource, or it might be a `Font` at the primary monitor DPI.
  `instances`		`LookupTable` of `Font` instances for all requested DPIs.

'!

!Graphics.FontSeries categoriesForClass!Graphics-Tools! !

!Graphics.FontSeries methodsFor!

atDpi: anInteger
	"Answer a <Font> from the series scaled for the specified DPI."

	^(instances lookup: anInteger)
		ifNil: 
			[instances at: anInteger
				put: (canonical copy
						dpi: anInteger;
						series: self;
						yourself)]!

canonical
	^canonical!

printOn: aStream
	aStream
		basicPrint: self;
		nextPut: $(;
		display: canonical;
		nextPut: $)!

setFont: aFont
	instances := LookupTable new.
	canonical := aFont.
	instances at: aFont dpi put: aFont.
	aFont series: self!

stbSaveOn: anSTBOutFiler
	self shouldNotImplement! !

!Graphics.FontSeries categoriesForMethods!
atDpi:!accessing!public! !
canonical!accessing!private! !
printOn:!printing!public! !
setFont:!initializing!private! !
stbSaveOn:!binary filing!public! !
!

!Graphics.FontSeries class methodsFor!

forFont: aFont
	^self new setFont: aFont!

icon
	"Answers an Icon that can be used to represent this class"

	^Font icon! !

!Graphics.FontSeries class categoriesForMethods!
forFont:!instance creation!public! !
icon!constants!public! !
!

