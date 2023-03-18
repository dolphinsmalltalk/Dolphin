"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'Graphics.Gdiplus.Tests.GdiplusTest'
	instanceVariableNames: 'model'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GdiplusTest guid: (Core.GUID fromString: '{ea227fda-3570-490b-b8cf-4973dc534043}')!
Graphics.Gdiplus.Tests.GdiplusTest isNonInstantiable: true!
Graphics.Gdiplus.Tests.GdiplusTest comment: ''!
!Graphics.Gdiplus.Tests.GdiplusTest methodsFor!

createCanonicalSubject
	^self subjectClass new!

fileResource
	^FileResource current!

getSampleBrush
	^Brush color: (Color red alpha: 100)!

getSampleSolidBrush
	^Brush color: (Color red alpha: 100)!

newCanonicalModel
	model := self createCanonicalSubject!

subjectClass
	^self subclassResponsibility! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesForMethods!
createCanonicalSubject!private!running! !
fileResource!accessing!public! !
getSampleBrush!accessing!public! !
getSampleSolidBrush!accessing!public! !
newCanonicalModel!public!running! !
subjectClass!constants!private! !
!

!Graphics.Gdiplus.Tests.GdiplusTest class methodsFor!

resources
	^{FileResource}! !
!Graphics.Gdiplus.Tests.GdiplusTest class categoriesForMethods!
resources!accessing!public! !
!

