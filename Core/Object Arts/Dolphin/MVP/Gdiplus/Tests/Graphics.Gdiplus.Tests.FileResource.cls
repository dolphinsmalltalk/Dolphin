"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestResource
	subclass: #'Graphics.Gdiplus.Tests.FileResource'
	instanceVariableNames: 'tempDir tempFileLocator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.FileResource guid: (Core.GUID fromString: '{fca5bf8a-3e20-4e92-9cb5-dedf99daae36}')!

Graphics.Gdiplus.Tests.FileResource comment: 'A TestResource that writes a number of files to disk that can then be accessed by TestCases.

The motivation behind this resource is to avoid the need to maintain external files that the TestCases depend on.

=====
Example

	 - Your TestCase can access the file written out in #writeRgb0000FF_100x100bmp with:

		self fileResource pafRgb0000FF_100x100bmp

=====
ToDo

	 - Add images files as required

=====
Best Practice

	 - TestCases should  access the filename via an accessor method in the 
	resource (ie #pafRgb0000FF_100x100bmp), rather than using the filename directly.



'!

!Graphics.Gdiplus.Tests.FileResource methodsFor!

fileLocator
	tempFileLocator
		ifNil: [tempFileLocator := FileLocator folderRelative: File createTemporaryDirectory].
	^tempFileLocator!

fish32x32pngBytes
	^File readAllBytes: self pafFish32x32png!

pafEyeJpg
	^self resourceFileLocator localFileSpecFor: 'eye.jpg'!

pafFish32x32png
	^self resourceFileLocator localFileSpecFor: 'fish32x32.png'!

pafMosaic2Bmp
	^self resourceFileLocator localFileSpecFor: 'mosaic2.bmp'!

pafRgb0000FF_100x100bmp
	^self resourceFileLocator localFileSpecFor: 'rgb0000FF_100x100.bmp'!

pafSeattleNightJpg
	^self resourceFileLocator localFileSpecFor: 'seattleNight.JPG'!

pafWinXP32x32ico
	^self resourceFileLocator localFileSpecFor: 'winXP32x32.ico'!

resourceFileLocator
	^FileLocator imageFolderRelative: 'Resources\Tests\GdiplusTestImages\'!

rgb0000FF_100x100bmpBytes
	^File readAllBytes: self pafRgb0000FF_100x100bmp!

tearDown
	(tempFileLocator notNil and: [File exists: tempFileLocator basePath])
		ifTrue: 
			[[File deleteDirectory: tempFileLocator basePath] on: Error do: [:ex | ].
			tempFileLocator := nil].
	super tearDown! !

!Graphics.Gdiplus.Tests.FileResource categoriesForMethods!
fileLocator!accessing!public! !
fish32x32pngBytes!accessing-bytes!public! !
pafEyeJpg!accessing-filenames!public! !
pafFish32x32png!accessing-filenames!public! !
pafMosaic2Bmp!accessing-filenames!public! !
pafRgb0000FF_100x100bmp!accessing-filenames!public! !
pafSeattleNightJpg!accessing-filenames!public! !
pafWinXP32x32ico!accessing-filenames!public! !
resourceFileLocator!accessing!private! !
rgb0000FF_100x100bmpBytes!accessing-bytes!public! !
tearDown!public!running! !
!

!Graphics.Gdiplus.Tests.FileResource class methodsFor!

promptImageAsHex
	"Private - A helper method that prompts for an image file and constructs the string that 
	goes to make a new method.  Display the following, cut the displayed string, paste it in 
	a new method window, name the method, delete some of the single-quotes, and save.

		self promptImageAsHex
	"

	| image strm |
	image := Image prompt.
	strm := String new writeStream.
	strm
		display: '<name><type>Bytes';
		cr;
		tab;
		display: '^'.
	(image asByteArray: image mimeType) hexStoreOn: strm.
	^strm contents! !

!Graphics.Gdiplus.Tests.FileResource class categoriesForMethods!
promptImageAsHex!helpers!private! !
!

