"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer
	subclass: #'Graphics.Gdiplus.PenInitializer'
	instanceVariableNames: 'ink width alignment lineJoin endCap startCap dashCap dashStyle dashPattern transform compoundArray'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'AlignmentNames' -> #('PenAlignmentCenter' 'PenAlignmentInset').
			'DashStyleNames'
				-> #('DashStyleSolid' 'DashStyleDash' 'DashStyleDot' 'DashStyleDashDot' 'DashStyleDashDotDot' 'DashStyleCustom')
		}!
Graphics.Gdiplus.PenInitializer guid: (Core.GUID fromString: '{b5a5d186-b0ef-421c-befb-c5628a17fee9}')!
Graphics.Gdiplus.PenInitializer comment: ''!
!Graphics.Gdiplus.PenInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: 
			[self species == anObject species and: 
					[width = anObject width and: 
							[ink = anObject ink and: 
									[alignment = anObject alignment and: 
											[endCap = anObject endCap and: 
													[startCap = anObject startCap and: 
															[dashCap = anObject dashCap
																and: [dashStyle = anObject dashStyle and: [dashPattern = anObject dashPattern]]]]]]]]]!

alignment
	^alignment!

alignmentOf: aGdiplusPen set: aPenAlignmentConstant
	alignment := aPenAlignmentConstant.
	aGdiplusPen basicHandle ifNotNil: [:handle | self setPenAlignment: handle]!

applyAdditionalAttributes: aHandle
	alignment == PenAlignmentCenter ifFalse: [self setPenAlignment: aHandle].
	endCap == LineCapFlat
		ifFalse: 
			[endCap isInteger
				ifTrue: [Gdip gdipSetPenEndCap: aHandle endCap: endCap]
				ifFalse: [Gdip gdipSetPenCustomEndCap: aHandle customCap: endCap asParameter]].
	startCap == LineCapFlat
		ifFalse: 
			[startCap isInteger
				ifTrue: [Gdip gdipSetPenStartCap: aHandle startCap: startCap]
				ifFalse: [Gdip gdipSetPenCustomStartCap: aHandle customCap: startCap asParameter]].
	lineJoin == LineJoinMiter ifFalse: [Gdip gdipSetPenLineJoin: aHandle lineJoin: lineJoin].
	dashCap == DashCapFlat ifFalse: [Gdip gdipSetPenDashCap197819: aHandle dashCap: dashCap].
	dashStyle == DashStyleSolid ifFalse: [Gdip gdipSetPenDashStyle: aHandle dashStyle: dashStyle].
	dashPattern ifNotNil: [Gdip gdipSetPenDashArray: aHandle dashes: dashPattern].
	compoundArray ifNotNil: [self setPenCompoundArray: aHandle].
	transform ifNotNil: [Gdip gdipSetPenTransform: aHandle matrix: transform asParameter]!

basicCreateHandle
	| handle |
	handle := ink createGpPen: width asFloat.
	self applyAdditionalAttributes: handle.
	^handle!

brushOf: aGdiplusPen
	(ink isKindOf: Brush) ifTrue: [^ink].
	^self queryBrushOf: aGdiplusPen!

brushOf: aGdiplusPen set: aGdiplusBrush
	ink := aGdiplusBrush.
	aGdiplusPen basicHandle
		ifNotNil: [:handle | Gdip gdipSetPenBrushFill: handle brush: ink asParameter]!

cacheTransform: aGpPenHandle
	| matrix |
	matrix := Matrix new.
	Gdip gdipGetPenTransform: aGpPenHandle matrix: matrix handle.
	self transform: matrix.
	^matrix!

capsOf: aGdiplusPen setLineCap: startLineCapConstant endCap: endLineCapConstant dashCap: aDashCapConstant
	startCap := startLineCapConstant.
	endCap := endLineCapConstant.
	dashCap := aDashCapConstant.
	aGdiplusPen basicHandle
		ifNotNil: 
			[:handle |
			Gdip
				gdipSetPenLineCap197819: handle
				startCap: startLineCapConstant
				endCap: endLineCapConstant
				dashCap: aDashCapConstant]!

color
	^ink asColor!

color: anARGB
	ink := anARGB!

colorOf: aGdiplusPen set: aColor
	ink := aColor.
	aGdiplusPen basicHandle ifNotNil: [:handle | Gdip gdipSetPenColor: handle argb: ink argbCode]!

compoundArray
	^compoundArray!

compoundArrayOf: aPen set: aRealArray
	self assert: [aRealArray size >= 2].
	self assert: [aRealArray allSatisfy: [:each | each between: 0.0 and: 1.0]].
	self assert: [aRealArray first = 0.0 and: [aRealArray last = 1.0]].
	compoundArray := FLOATArray marshal: aRealArray.
	aPen basicHandle ifNotNil: [:aHandle | self setPenCompoundArray: aHandle]!

customEndCap
	^endCap isInteger ifFalse: [endCap]!

customEndCapOf: aGdiplusPen set: aGdiplusCustomLineCap
	endCap := aGdiplusCustomLineCap.
	aGdiplusPen basicHandle
		ifNotNil: [:handle | Gdip gdipSetPenCustomEndCap: handle customCap: aGdiplusCustomLineCap asParameter]!

customStartCap
	^startCap isInteger ifFalse: [startCap]!

customStartCapOf: aGdiplusPen set: aGdiplusCustomLineCap
	endCap := aGdiplusCustomLineCap.
	aGdiplusPen basicHandle
		ifNotNil: [:handle | Gdip gdipSetPenCustomStartCap: handle customCap: aGdiplusCustomLineCap asParameter]!

dashCap
	^dashCap!

dashCapOf: aGdiplusPen set: aDashCapConstant
	dashCap := aDashCapConstant.
	aGdiplusPen basicHandle
		ifNotNil: [:handle | Gdip gdipSetPenDashCap197819: handle dashCap: aDashCapConstant]!

dashPattern
	^dashPattern!

dashPatternOf: aGdiplusPen set: aSequencedReadableCollection
	dashPattern := FLOATArray marshal: aSequencedReadableCollection.
	aGdiplusPen basicHandle ifNotNil: [:handle | Gdip gdipSetPenDashArray: handle dashes: dashPattern]!

dashStyle
	^dashStyle!

dashStyleOf: aGdiplusPen set: aDashStyleConstant
	dashStyle := aDashStyleConstant.
	aGdiplusPen basicHandle
		ifNotNil: [:handle | Gdip gdipSetPenDashStyle: handle dashStyle: aDashStyleConstant]!

endCap
	^endCap!

endCapOf: aGdiplusPen set: aLineCapConstant
	endCap := aLineCapConstant.
	aGdiplusPen basicHandle
		ifNotNil: [:handle | Gdip gdipSetPenEndCap: handle endCap: aLineCapConstant]!

hash
	"Answer the <integer> hash value for the receiver."

	^((self species hash + width hash) hashMultiply + ink hash) hashMultiply!

ink
	^ink!

ink: aGdiplusBrush width: aNumber
	ink := aGdiplusBrush.
	width := aNumber ?? 1.
	alignment := PenAlignmentCenter.
	startCap := endCap := LineCapFlat.
	dashCap := DashCapFlat.
	dashStyle := DashStyleSolid.
	lineJoin := LineJoinMiter.
	^self!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the Gdiplus native object it describes exactly as it was across Smalltalk image save/restore. This is generally true."

	^ink isPersistent and: 
			[| customCap |
			customCap := self customEndCap.
			(customCap isNil or: [customCap isPersistent]) and: 
					[customCap := self customStartCap.
					customCap isNil or: [customCap isPersistent]]]!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^ink isSelfEvaluating and: 
			[alignment == PenAlignmentCenter and: 
					[endCap == LineCapFlat and: 
							[startCap == LineCapFlat
								and: [dashCap == DashCapFlat and: [dashStyle == DashStyleSolid and: [dashPattern isNil]]]]]]!

lineJoin
	^lineJoin!

lineJoin: anInteger 
	lineJoin := anInteger!

lineJoinOf: aGdiplusPen set: aLineJoinConstant
	lineJoin := aLineJoinConstant.
	aGdiplusPen basicHandle
		ifNotNil: [:handle | Gdip gdipSetPenLineJoin: handle lineJoin: aLineJoinConstant]!

matrixOf: aGdiplusPen set: aGdiplusMatrix
	self transform: aGdiplusMatrix.
	aGdiplusPen basicHandle
		ifNotNil: [:handle | Gdip gdipSetPenTransform: handle matrix: aGdiplusMatrix asParameter]!

printAttributesOn: aStream
	aStream
		nextPutAll: 'ink: ';
		print: ink.
	self width = 1
		ifFalse: 
			[aStream
				nextPutAll: ' width: ';
				print: width].
	alignment == PenAlignmentCenter
		ifFalse: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #alignment:;
				space.
			self
				printEnum: alignment
				names: AlignmentNames
				on: aStream].
	lineJoin == LineJoinMiter
		ifFalse: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #lineJoin:;
				space.
			self
				printEnum: lineJoin
				names: Gdiplus.LineJoinNames
				on: aStream].
	startCap == LineCapFlat
		ifFalse: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #startCap:;
				space.
			self printLineCapName: startCap on: aStream].
	endCap == LineCapFlat
		ifFalse: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #endCap:;
				space.
			self printLineCapName: endCap on: aStream].
	dashCap == DashCapFlat
		ifFalse: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #dashCap:;
				space;
				print: dashCap].
	dashStyle == DashStyleSolid
		ifFalse: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #dashStyle:;
				space.
			self
				printEnum: dashStyle
				names: DashStyleNames
				on: aStream].
	dashPattern
		ifNotNil: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #dashPattern:;
				space;
				print: dashPattern].
	transform
		ifNotNil: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #transform:;
				space;
				print: transform]!

queryBrushOf: aGdiplusPen
	| gpHandle type |
	gpHandle := Handle new.
	Gdip gdipGetPenBrushFill: aGdiplusPen handle brush: gpHandle.
	type := UInt32Bytes new.
	Gdip gdipGetBrushType: gpHandle type: type.
	^(##({SolidBrush. HatchBrush. TextureBrush. PathGradientBrush. LinearGradientBrush})
		at: type asSignedInteger + 1) fromOwnedHandle: gpHandle!

resetTransformOf: aGdiplusPen
	Gdip gdipResetPenTransform: aGdiplusPen asParameter.
	transform := nil!

setPenAlignment: aHandle
	Gdip gdipSetPenMode: aHandle penMode: alignment!

setPenCompoundArray: aHandle
	^Gdip
		gdipSetPenCompoundArray: aHandle
		dash: compoundArray
		count: compoundArray size!

startCap
	^startCap!

startCapOf: aGdiplusPen set: aLineCapConstant
	startCap := aLineCapConstant.
	aGdiplusPen basicHandle
		ifNotNil: [:handle | Gdip gdipSetPenStartCap: handle startCap: aLineCapConstant]!

transform
	^transform ifNil: [Matrix identity]!

transform: aMatrix
	transform := (aMatrix isNil or: [aMatrix isIdentity]) ifFalse: [aMatrix]!

transform: aGdiplusPen multiply: aMatrix order: aMatrixOrderConstant
	| handle |
	handle := aGdiplusPen handle.
	Gdip
		gdipMultiplyPenTransform: handle
		matrix: aMatrix asParameter
		order: aMatrixOrderConstant.
	^self cacheTransform: handle!

transform: aGdiplusPen rotate: aNumber order: aMatrixOrderConstant
	| handle |
	handle := aGdiplusPen handle.
	Gdip
		gdipRotatePenTransform: handle
		angle: aNumber asFloat
		order: aMatrixOrderConstant.
	^self cacheTransform: handle!

transform: aGdiplusPen scale: aPoint order: aMatrixOrderConstant
	| handle |
	handle := aGdiplusPen handle.
	Gdip
		gdipScalePenTransform: handle
		sx: aPoint x asFloat
		sy: aPoint y asFloat
		order: aMatrixOrderConstant.
	^self cacheTransform: handle!

transform: aGdiplusPen translate: aPoint order: aMatrixOrderConstant
	| handle |
	handle := aGdiplusPen handle.
	Gdip
		gdipTranslatePenTransform: handle
		dx: aPoint x asFloat
		dy: aPoint y asFloat
		order: aMatrixOrderConstant.
	^self cacheTransform: handle!

width
	^width!

widthOf: aGdiplusPen set: aNumber
	width := aNumber ?? 1.
	aGdiplusPen basicHandle ifNotNil: [:handle | Gdip gdipSetPenWidth: handle width: width asFloat]! !
!Graphics.Gdiplus.PenInitializer categoriesForMethods!
=!comparing!public! !
alignment!accessing!public! !
alignmentOf:set:!attributes!private! !
applyAdditionalAttributes:!attributes!private!realizing/unrealizing! !
basicCreateHandle!private!realizing/unrealizing! !
brushOf:!attributes!private! !
brushOf:set:!attributes!private! !
cacheTransform:!private!transformations! !
capsOf:setLineCap:endCap:dashCap:!attributes!private! !
color!accessing!public! !
color:!accessing!public! !
colorOf:set:!attributes!private! !
compoundArray!accessing!private! !
compoundArrayOf:set:!attributes!private! !
customEndCap!accessing!public! !
customEndCapOf:set:!attributes!private! !
customStartCap!accessing!public! !
customStartCapOf:set:!attributes!private! !
dashCap!accessing!public! !
dashCapOf:set:!attributes!private! !
dashPattern!accessing!public! !
dashPatternOf:set:!attributes!private! !
dashStyle!accessing!public! !
dashStyleOf:set:!attributes!private! !
endCap!accessing!public! !
endCapOf:set:!attributes!private! !
hash!comparing!public! !
ink!accessing!private! !
ink:width:!initializing!private! !
isPersistent!public!testing! !
isSelfEvaluating!public!testing! !
lineJoin!accessing!public! !
lineJoin:!accessing!public! !
lineJoinOf:set:!attributes!private! !
matrixOf:set:!attributes!private! !
printAttributesOn:!attributes!printing!private! !
queryBrushOf:!attributes!private! !
resetTransformOf:!private!transformations! !
setPenAlignment:!attributes!private! !
setPenCompoundArray:!attributes!private! !
startCap!accessing!public! !
startCapOf:set:!attributes!private! !
transform!accessing!public! !
transform:!accessing!private! !
transform:multiply:order:!private!transformations! !
transform:rotate:order:!private!transformations! !
transform:scale:order:!private!transformations! !
transform:translate:order:!private!transformations! !
width!accessing!public! !
widthOf:set:!attributes!private! !
!

!Graphics.Gdiplus.PenInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipClonePen: aHandle clonepen: clone.
	^clone!

freeHandle: aHandle
	Gdip gdipDeletePen: aHandle!

ink: aGpBrushOrColor width: aFloat
	^self new ink: aGpBrushOrColor width: aFloat!

stbConvertFrom: anSTBClassFormat
	^[:data | PenInitializer ink: (data at: 2) width: (data at: 3)]!

stbVersion
	"1: Instance variables of subclasses pulled up (although this does not affect the layout), and additional inst vars added for all the additional attributes that can be set on a Pen."

	^1! !
!Graphics.Gdiplus.PenInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
ink:width:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!

